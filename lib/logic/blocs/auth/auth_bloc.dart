import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/constants/enums.dart';
import 'package:chat_app/constants/exceptions.dart';
import 'package:chat_app/constants/values.dart';
import 'package:chat_app/data/data_providers/websocket/auth_socket.dart';
import 'package:chat_app/data/models/auth.dart';
import 'package:chat_app/data/repositories/auth_repository.dart';
import 'package:chat_app/logic/blocs/app/app_bloc.dart';
import 'package:chat_app/logic/blocs/internet_bloc.dart';
import 'package:chat_app/utils/static_data.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepo;
  final InternetBloc network;
  final AppBloc appBloc;
  final AuthSocket _socketAuth = AuthSocket();
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

  logout(event, emit) async {
    emit(AuthLoading());
    _socketAuth.logout();
    await authRepo.logout();
    StaticData.resetData();

    emit(AuthLogout());
  }

  checkAuth(event, emit) async {
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
      final auth = await authRepo
          .loginWithUsernameAndPassword(event.username, event.password)
          .timeout(kTimeout);
      _doWhenAuthSuccess(auth);
      emit(AuthSuccess());
    } on ServerException catch (e, s) {
      print(e.message);
      print(s);
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
      // ignore: avoid_print
      print(e.toString());
      emit(AuthError(
        status: AuthStatus.unknown,
      ));
    }
  }

  void _doWhenAuthSuccess(Auth auth) {
    StaticData.auth = auth;
    _socketAuth.connect(auth);
    _socketAuth.subcrNotifyUserMessage(auth);
  }

  @override
  Future<void> close() {
    _appBlocSubscription.cancel();
    return super.close();
  }
}
