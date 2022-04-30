import 'package:connectivity_plus/connectivity_plus.dart';

class InternetBloc {
  static final InternetBloc _instance = InternetBloc._internal();
  factory InternetBloc() => _instance;
  InternetBloc._internal();
  final _connectivity = Connectivity();
  Stream get stream => _connectivity.onConnectivityChanged;
}
