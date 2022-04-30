import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/constants/enums.dart';
import 'package:chat_app/data/data_providers/websocket/app_socket.dart';
import 'package:chat_app/logic/blocs/internet_bloc.dart';
import 'package:chat_app/logic/notification/message_notification.dart';
import 'package:chat_app/utils/static_data.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AppSocket _appSocket = AppSocket();
  late final StreamSubscription _subscription;
  late final StreamSubscription _notificationSub;
  final MessageNotification _messageNotification = MessageNotification();
  final InternetBloc network;
  AppBloc({required this.network}) : super(AppInitial()) {
    _subscription = network.stream.listen((event) {
      _setInternetStatus(event);
      _appSocket.init();
    });
    _notificationSub = _appSocket.notificationStream.listen((event) {
      _messageNotification.showNotification(
          title: event['fields']['args'][0]['title'],
          text: event['fields']['args'][0]['text'],
          payload: event['fields']['args'][0]['payload']);
    });
    on<InitApp>(_initApp);
  }

  FutureOr<void> _initApp(event, emit) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    _setInternetStatus(connectivityResult);
    // _appSocket.init();
    emit(InitDone());
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    _notificationSub.cancel();
    return super.close();
  }

  void _setInternetStatus(ConnectivityResult event) {
    if (event == ConnectivityResult.mobile ||
        event == ConnectivityResult.wifi) {
      StaticData.internetStatus = InternetStatus.connected;
    } else {
      StaticData.internetStatus = InternetStatus.disconnected;
    }
  }
}
