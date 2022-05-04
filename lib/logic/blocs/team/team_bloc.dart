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
  final StreamController<List<User>> _teamMemberController =
      StreamController<List<User>>.broadcast();

  late final Stream<List<User>> teamMemberStream;
  late final Stream<List<User>> selectStream;
  late final Stream<List<User>> searchStream;
  late final Stream<Message> messageStream;
  late final StreamSubscription _roomChangedSub;
  late final StreamSubscription _subChangedSub;

  List<Team>? listTeams;
  Team? currentTeam;

  TeamBloc({required this.teamRepository, required this.userRepository})
      : super(TeamInitial()) {
    messageStream = _messageStreamController.stream.asBroadcastStream();
    selectStream = _selectStreamController.stream;
    searchStream = _searchStreamController.stream;
    teamMemberStream = _teamMemberController.stream;

    _roomChangedSub = socket.roomChangedStream.listen((event) {
      try {
        emit(TeamHaveMessage(teamId: event['fields']['args'][1]['teamId']));
        final message =
            Message.fromMap(event['fields']['args'][1]['lastMessage']);
        _messageStreamController.sink.add(message);
      } catch (e) {
        debugPrint(e.toString());
      }
    });
    _subChangedSub = socket.subChangedStream.listen(_onSubChanged);

    on<LoadTeam>(loadTeam);
    on<DisplayTeam>(displayTeam);
    on<SearchFinish>(listUserLoaded);
  }

  void removeMemberFromTeam({required Team team, required User user}) {
    // teamRepository.removeMemberFromTeam(currentTeam!.id, user.id);
  }

  List<User>? listTeamMember;
  void loadTeamMember(Team team) async {
    listTeamMember ??= await teamRepository.listTeamMember(team.roomId);
    await Future.delayed(
        const Duration(milliseconds: 100)); //delay for render UI
    _teamMemberController.sink.add(listTeamMember!);
  }

  void _onSubChanged(event) async {
    if (event['fields']['args'][0] == 'inserted') {
      listTeams = null;
      await Future.delayed(const Duration(seconds: 1)); //delay for server
      add(LoadTeam());
    } else if (event['fields']['args'][0] == 'removed') {
      final String removedRoomId = event['fields']['args'][1]['rid'];
      if (currentTeam?.roomId == removedRoomId) {
        currentTeam = null;
      }
      for (Team team in listTeams ?? []) {
        if (team.roomId == removedRoomId) {
          listTeams!.remove(team);
          add(LoadTeam());
          break;
        }
      }
    }
    add(DisplayTeam(team: currentTeam));
  }

  loadTeam(event, emit) async {
    try {
      listTeams ??= await teamRepository.listTeams();
      emit(TeamLoaded(teams: listTeams!));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  displayTeam(event, emit) {
    currentTeam = event.team;
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

  Timer? _debounceInvite;
  void searchInvite({required String selector}) async {
    if (_debounceInvite?.isActive ?? false) _debounceInvite!.cancel();
    _debounceInvite = Timer(const Duration(milliseconds: 500), () async {
      final usersSearch = await userRepository.getUsers(selector: selector);
      _listSearch = _hieu(usersSearch, _listSelected);
      _searchStreamController.sink.add(_listSearch);
    });
  }

  void clearSearchUser() {
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
    clearSearchUser();
  }

  @override
  Future<void> close() {
    listTeams = null;
    _roomChangedSub.cancel();
    _messageStreamController.close();
    _searchStreamController.close();
    _debounceInvite?.cancel();
    _subChangedSub.cancel();
    _teamMemberController.close();
    return super.close();
  }
}
