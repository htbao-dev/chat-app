import 'package:chat_app/logic/notification/notification_api.dart';
import 'package:chat_app/utils/static_data.dart';

class MessageNotification {
  final _notiApi = NotificationApi();

  void showNotification({
    required String title,
    required String text,
    dynamic payload,
  }) {
    if (StaticData.roomIdForcus == payload['rid']) {
      return;
    }
    if (payload['sender']['_id'] != StaticData.auth?.userId) {
      _notiApi.showNotification(
        title: title,
        body: text,
        payload: 'event.payload', //TODO: edit payload
      );
    }
  }
}
