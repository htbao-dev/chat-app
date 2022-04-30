import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/data/data_providers/websocket/team_socket.dart';
import 'package:chat_app/data/models/message.dart';
import 'package:chat_app/data/models/team.dart';
import 'package:chat_app/data/models/user.dart';
import 'package:chat_app/data/repositories/team_repository.dart';
import 'package:chat_app/data/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

part 'team_event.dart';
part 'team_state.dart';

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  final TeamRepository teamRepository;
  final UserRepository userRepository;
  final TeamSocket socket = TeamSocket();

  final StreamController<Message> _messageStreamController =
      StreamController<Message>();
  final StreamController<List<User>> _searchStreamController =
      StreamController<List<User>>.broadcast();

  final StreamController<List<User>> _selectStreamController =
      StreamController<List<User>>.broadcast();
  late final Stream<List<User>> selectStream;
  late final Stream<List<User>> searchStream;
  late final Stream<Message> messageStream;
  late final StreamSubscription _roomChangedSub;
  TeamBloc({required this.teamRepository, required this.userRepository})
      : super(TeamInitial()) {
    messageStream = _messageStreamController.stream.asBroadcastStream();
    selectStream = _selectStreamController.stream;
    searchStream = _searchStreamController.stream;
    _roomChangedSub = socket.roomChangedStream.listen((event) {
      emit(TeamHaveMessage(teamId: event['fields']['args'][1]['teamId']));
      try {
        final message =
            Message.fromMap(event['fields']['args'][1]['lastMessage']);
        _messageStreamController.sink.add(message);
      } catch (e) {
        debugPrint(e.toString());
      }
    });

    on<LoadTeam>(loadTeam);
    on<DisplayTeam>(displayTeam);
    on<SearchFinish>(listUserLoaded);
  }

  loadTeam(event, emit) async {
    try {
      var teams = await teamRepository.listTeams();
      print(teams.length);
      emit(TeamLoaded(teams: teams));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  displayTeam(event, emit) {
    emit(TeamDisplayed(team: event.team));
  }

  createTeam({required String name}) async {
    return teamRepository.createTeam(name: name);
  }

  List<User> _listSearch = [];
  List<User> _listSelected = [];

  void selectUserInvite(User user) {
    _listSelected.add(user);
    _listSearch.remove(user);
    _searchStreamController.sink.add(_listSearch);
    _selectStreamController.sink.add(_listSelected);
  }

  Timer? _debounce;
  void searchInvite({required String selector}) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final usersSearch = await userRepository.getUsers(selector: selector);
      _listSearch = _hieu(usersSearch, _listSelected);
      _searchStreamController.sink.add(_listSearch);
    });
  }

  void clearSearch() {
    _listSearch = [];
    _listSelected = [];
  }

  void listUserLoaded(SearchFinish event, Emitter<TeamState> emit) {
    emit(ListUserLoaded(users: event.users));
  }

  List<User> _hieu(List<User> a, List<User> b) {
    return a.where((user) {
      for (var userSelected in b) {
        if (user.id == userSelected.id) return false;
      }
      return true;
    }).toList();
  }

  void removeUserInvite(User user) {
    _listSelected.remove(user);
    _listSearch.add(user);
    _searchStreamController.sink.add(_listSearch);
    _selectStreamController.sink.add(_listSelected);
  }

  Future<void> inviteUser({required String teamRoomId}) async {
    await teamRepository.inviteUsers(
        teamRoomId: teamRoomId, users: _listSelected);
    clearSearch();
  }

  @override
  Future<void> close() {
    _roomChangedSub.cancel();
    _messageStreamController.close();
    _searchStreamController.close();
    _debounce?.cancel();
    return super.close();
  }
}
