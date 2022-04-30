part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {}

class CheckAuth extends AuthEvent {
  @override
  List<Object> get props => [];
}

abstract class LoginEvent extends AuthEvent {}

class LoginSubmited extends LoginEvent {
  final String username;
  final String password;

  LoginSubmited({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}

class Logout extends AuthEvent {
  @override
  List<Object> get props => [];
}
