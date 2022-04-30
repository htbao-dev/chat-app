import 'package:chat_app/constants/enums.dart';
import 'package:chat_app/constants/string_display.dart';
import 'package:chat_app/data/models/auth.dart';

class StaticData {
  static InternetStatus internetStatus = InternetStatus.connected;
  static LanguageDisplay languageDisplay = EnglishDisplay();
  static Auth? auth;
  static int _idRandom = 0;
  static int get idRandom => _idRandom++;
  static String? roomIdForcus;

  static resetData() {
    internetStatus = InternetStatus.connected;
    languageDisplay = EnglishDisplay();
    auth = null;
    _idRandom = 0;
    roomIdForcus = null;
  }
}
