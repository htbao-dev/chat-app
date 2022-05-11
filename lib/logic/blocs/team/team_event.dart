part of 'team_bloc.dart';

@immutable
abstract class TeamEvent extends Equatable {}

class LoadTeam extends TeamEvent {
  final bool isLoadNew;

  LoadTeam({required this.isLoadNew});
  @override
  List<Object> get props => [];
}

class DisplayTeam extends TeamEvent {
  final Team? team;

  DisplayTeam({required this.team});

  @override
  List<Object> get props => [if (team != null) team!];
}

class CreateTeam extends TeamEvent {
  final String name;

  CreateTeam({required this.name});

  @override
  List<Object> get props => [name];
}

class SearchFinish extends TeamEvent {
  final List<User> users;

  SearchFinish({required this.users});

  @override
  List<Object> get props => [users];
}
