class ApiException implements Exception {
  final int? statusCode;
  final String? message;

  ApiException({this.statusCode, this.message});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class BadRequestException extends ApiException {
  BadRequestException({super.statusCode, super.message});
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({super.statusCode, super.message});
}

class NotFoundException extends ApiException {
  NotFoundException({super.statusCode, super.message});
}

class ServerErrorException extends ApiException {
  ServerErrorException({super.statusCode, super.message});
}

class PermissionException extends ApiException {
  PermissionException({super.statusCode, super.message});
}
