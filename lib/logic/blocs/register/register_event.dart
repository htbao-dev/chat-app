part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent extends Equatable {}

class RegisterSubmited extends RegisterEvent {
  final String username;
  final String password;
  final String email;
  final String name;

  RegisterSubmited({
    required this.name,
    required this.email,
    required this.username,
    required this.password,
  });

  @override
  List<Object> get props => [username, password, email, name];
}
