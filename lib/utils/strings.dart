import 'package:chat_app/constants/enums.dart';
import 'package:chat_app/utils/static_data.dart';

String getAuthDisplayString(AuthStatus status) {
  switch (status) {
    case AuthStatus.unauthorirzed:
      return StaticData.languageDisplay.kIncorrectLoginInfo;
    case AuthStatus.timeout:
      return StaticData.languageDisplay.kPleaseRetryLogin;
    default:
      return StaticData.languageDisplay.kUnknown;
  }
}
