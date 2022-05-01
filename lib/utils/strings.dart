import 'package:chat_app/constants/enums.dart';
import 'package:chat_app/utils/static_data.dart';

String getAuthDisplayString(AuthStatus status, String? error) {
  switch (status) {
    case AuthStatus.unauthorirzed:
      return StaticData.languageDisplay.kIncorrectLoginInfo + (error ?? 'aa');
    case AuthStatus.timeout:
      return StaticData.languageDisplay.kPleaseRetryLogin + (error ?? 'aa');
    default:
      return StaticData.languageDisplay.kUnknown + (error ?? 'aa');
  }
}
