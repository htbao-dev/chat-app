part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthSuccess extends AuthState {
  AuthSuccess();

  @override
  List<Object> get props => [];
}

class AuthError extends AuthState {
  // final int statusCode;
  final AuthStatus status;

  AuthError({required this.status});

  @override
  List<Object> get props => [status];
}

class AuthLogout extends AuthState {
  @override
  List<Object> get props => [];
}
