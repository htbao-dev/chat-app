part of 'team_bloc.dart';

@immutable
abstract class TeamState extends Equatable {}

class TeamInitial extends TeamState {
  @override
  List<Object> get props => [];
}

class TeamLoaded extends TeamState {
  final List<Team> teams;

  TeamLoaded({required this.teams});

  @override
  List<Object> get props => [teams];
}

class TeamDisplayed extends TeamState {
  final Team team;

  TeamDisplayed({required this.team});

  @override
  List<Object> get props => [team];
}

class TeamHaveMessage extends TeamState {
  final String teamId;

  TeamHaveMessage({required this.teamId});

  @override
  List<Object> get props => [teamId];
}

class ListUserLoaded extends TeamState {
  final List<User> users;

  ListUserLoaded({required this.users});

  @override
  List<Object> get props => [users];
}
