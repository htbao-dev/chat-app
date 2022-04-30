class InternetException implements Exception {
  final String message;
  final int statusCode = 408; //request time out
  InternetException(this.message);
}

class ServerException implements Exception {
  dynamic message;
  final int statusCode;
  ServerException({required this.message, required this.statusCode});

  @override
  String toString() {
    return 'ServerException{message: $message, statusCode: $statusCode}';
  }
}
