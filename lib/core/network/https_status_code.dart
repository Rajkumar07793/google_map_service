/// A utility class that defines commonly used HTTP status codes
/// for handling API responses.
///
/// This class provides constant integer values for easy reference
/// throughout the app, improving readability and maintainability.
class HTTPStatusCodes {
  /// Indicates that the request was successful (HTTP 200).
  ///
  /// Typically used when an API call completes without errors
  /// and returns the expected response data.
  static const int success = 200;

  /// Indicates that the user's session has expired or is unauthorized (HTTP 401).
  ///
  /// Commonly used when authentication fails or the access token
  /// has expired, prompting a re-login or token refresh.
  static const int sessionExpired = 401;
}
