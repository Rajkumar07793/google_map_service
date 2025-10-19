/// A base class for all API-related exceptions.
///
/// This class represents a general API error with an optional [statusCode]
/// and [message]. It is the parent class of more specific API exceptions
/// like [BadRequestException], [UnauthorizedException], etc.
class ApiException implements Exception {
  /// The HTTP status code associated with the error, if available.
  final int? statusCode;

  /// A human-readable message providing more details about the error.
  final String? message;

  /// Creates an [ApiException] with an optional [statusCode] and [message].
  ApiException({this.statusCode, this.message});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Exception thrown when the server returns a **400 Bad Request** response.
///
/// Indicates that the request sent to the server was invalid or malformed.
class BadRequestException extends ApiException {
  /// Creates a [BadRequestException] with an optional [statusCode] and [message].
  BadRequestException({super.statusCode, super.message});
}

/// Exception thrown when the server returns a **401 Unauthorized** response.
///
/// Indicates that authentication failed or user credentials are invalid.
class UnauthorizedException extends ApiException {
  /// Creates an [UnauthorizedException] with an optional [statusCode] and [message].
  UnauthorizedException({super.statusCode, super.message});
}

/// Exception thrown when the server returns a **404 Not Found** response.
///
/// Indicates that the requested resource could not be found on the server.
class NotFoundException extends ApiException {
  /// Creates a [NotFoundException] with an optional [statusCode] and [message].
  NotFoundException({super.statusCode, super.message});
}

/// Exception thrown when the server returns a **500 Internal Server Error** response.
///
/// Indicates that an unexpected error occurred on the server side.
class ServerErrorException extends ApiException {
  /// Creates a [ServerErrorException] with an optional [statusCode] and [message].
  ServerErrorException({super.statusCode, super.message});
}

/// Exception thrown when the app does not have sufficient permissions to perform
/// a certain action or access a protected resource.
///
/// For example, when a user denies location permissions or other required access.
class PermissionException extends ApiException {
  /// Creates a [PermissionException] with an optional [statusCode] and [message].
  PermissionException({super.statusCode, super.message});
}
