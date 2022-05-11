import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat_app/constants/enums.dart';
import 'package:chat_app/constants/exceptions.dart';
import 'package:chat_app/constants/values.dart';
import 'package:chat_app/data/data_providers/websocket/auth_socket.dart';
import 'package:chat_app/data/models/auth.dart';
import 'package:chat_app/data/models/user.dart';
import 'package:chat_app/data/repositories/auth_repository.dart';
import 'package:chat_app/data/repositories/user_repository.dart';
import 'package:chat_app/logic/blocs/app/app_bloc.dart';
import 'package:chat_app/logic/blocs/internet_bloc.dart';
import 'package:chat_app/utils/static_data.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepo;
  final UserRepository userRepository = UserRepository();
  final InternetBloc network;
  final AppBloc appBloc;
  final AuthSocket _socketAuth = AuthSocket();

  final StreamController<User?> _userController =
      StreamController<User?>.broadcast();

  Stream<User?> get userStream => _userController.stream;

  late final StreamSubscription _appBlocSubscription;
  AuthBloc(
      {required this.authRepo, required this.appBloc, required this.network})
      : super(AuthInitial()) {
    _appBlocSubscription = appBloc.stream.listen(
      (event) {
        if (event is InitDone) {
          add(CheckAuth());
        }
      },
    );
    network.stream.listen((event) {
      if (StaticData.internetStatus == InternetStatus.connected) {
        final auth = StaticData.auth;
        if (auth != null) {
          _socketAuth.connect(auth);
          _socketAuth.subcrNotifyUserMessage(auth);
        }
      }
    });
    on<LoginSubmited>(loginSubmitedLogin);
    on<CheckAuth>((checkAuth));
    on<Logout>(logout);
  }

  Future<void> getUserInfo() async {
    final auth = StaticData.auth!;
    final user = await userRepository.getUserInfo(auth: auth);
    _userController.sink.add(user);
  }

  Future<bool> updateUserInfo(
      {String? name, String? email, String? password, String? username}) async {
    final success = await userRepository.updateUserInfo(
      name: name,
      email: email,
      password: password,
      username: username,
    );
    return success;
  }

  Future<bool> openGallery() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final file = await _picker.pickImage(source: ImageSource.gallery);
      //XFile to File
      final image = File(file!.path);
      final success = await userRepository.setAvatar(image);
      return success;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  logout(event, emit) async {
    emit(AuthLoading());
    _socketAuth.logout();
    await authRepo.logout();
    StaticData.resetData();

    emit(AuthLogout());
  }

  Future<void> checkAuth(event, emit) async {
    try {
      final auth = await authRepo.checkAuth();
      _doWhenAuthSuccess(auth!);
      emit(AuthSuccess());
    } on ServerException {
      emit(AuthError(status: AuthStatus.checkAuthFailed));
    } catch (e) {
      emit(AuthError(status: AuthStatus.checkAuthFailed));
    }
  }

  loginSubmitedLogin(event, emit) async {
    emit(AuthLoading());
    try {
      final auth = await authRepo.loginWithUsernameAndPassword(
          event.username, event.password);
      _doWhenAuthSuccess(auth);
      emit(AuthSuccess());
    } on ServerException catch (e, s) {
      debugPrint(e.message);
      debugPrint(s.toString());
      if (e.statusCode == RequestStatusCode.timeout) {
        emit(AuthError(
          status: AuthStatus.timeout,
        ));
      } else {
        emit(AuthError(status: AuthStatus.unauthorirzed));
      }
    } on TimeoutException {
      emit(AuthError(
        status: AuthStatus.timeout,
      ));
    } catch (e) {
      debugPrint(e.toString());
      emit(AuthError(
        status: AuthStatus.unknown,
        errorMessage: e.toString(),
      ));
    }
  }

  void _doWhenAuthSuccess(Auth auth) {
    StaticData.auth = auth;
    if (StaticData.internetStatus == InternetStatus.connected) {
      _socketAuth.connect(auth);
      _socketAuth.subcrNotifyUserMessage(auth);
      userRepository.loadAllUsers();
    }
  }

  @override
  Future<void> close() {
    _userController.close();
    _appBlocSubscription.cancel();
    return super.close();
  }
}
