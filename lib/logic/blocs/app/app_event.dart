part of 'app_bloc.dart';

@immutable
abstract class AppEvent extends Equatable {}

class InitApp extends AppEvent {
  // InitApp() {
  //   print('InitApp');
  // }

  @override
  List<Object> get props => [];
}
