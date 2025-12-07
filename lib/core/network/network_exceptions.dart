class NetworkException implements Exception {
  final String message;
  final dynamic data;

  NetworkException(this.message, [this.data]);

  @override
  String toString() => message;
}

class TimeoutException extends NetworkException {
  TimeoutException(super.message, [super.data]);
}

class BadRequestException extends NetworkException {
  BadRequestException(super.message, [super.data]);
}

class UnauthorizedException extends NetworkException {
  UnauthorizedException(super.message, [super.data]);
}

class NotFoundException extends NetworkException {
  NotFoundException(super.message, [super.data]);
}

class ServerException extends NetworkException {
  ServerException(super.message, [super.data]);
}





