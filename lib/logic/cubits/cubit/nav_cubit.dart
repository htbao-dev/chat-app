import 'package:bloc/bloc.dart';
import 'package:chat_app/constants/routes.dart';
import 'package:meta/meta.dart';

part 'nav_state.dart';

class NavCubit extends Cubit<String> {
  final _mapIndexToRoute = {
    0: HomeRoutes.home,
    1: HomeRoutes.profile,
  };
  NavCubit() : super(HomeRoutes.home);

  void navigateTo(int index) {
    emit(_mapIndexToRoute[index]!);
  }
}
