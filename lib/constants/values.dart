const kTimeout = Duration(seconds: 3);

class RequestStatusCode {
  static const int success = 200;
  static const int unauthorized = 401;
  static const int notFound = 404;
  static const int timeout = 408;
  static const int badRequest = 400;
  static const int tooManyRequest = 429;
  static const int serverError = 500;
}

class RegisterStatus {
  static const registerFailed = -1;
  static const registerSuscess = 0;
  static const usernameExists = 1;
  static const emailExists = 403;
  static const retry = 2;
}

class RoomTypes {
  static const privateRoom = 'p';
  static const publicRoom = 'c';
}
