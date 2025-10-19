import 'dart:convert';
import 'dart:developer';

import 'package:google_map_service/core/network/api_exception.dart';
import 'package:http/http.dart' as http;

/// Handles and validates API responses by parsing the response body,
/// detecting errors, and throwing the appropriate custom exceptions.
///
/// This function should be used after every HTTP request to ensure
/// consistent error handling across the app.
///
/// Example usage:
/// ```dart
/// final response = await httpClient.get(Uri.parse(url));
/// final data = handleException(response);
/// ```
///
/// The function performs the following checks:
/// - Parses the API response as JSON.
/// - Detects standard response keys such as `code` and `message`.
/// - Throws meaningful exceptions based on the HTTP status code:
///   - [BadRequestException] for 400
///   - [UnauthorizedException] for 401
///   - [NotFoundException] for 404
///   - [ServerErrorException] for 500+
///   - [ApiException] for all other unexpected errors
///
/// Returns a [Map<String, dynamic>] when the response is valid and successful.
Map<String, dynamic> handleException(http.Response data) {
  final jsonData = json.decode(data.body);

  if (jsonData != null) {
    if (jsonData.containsKey('code')) {
      final statusCode = jsonData['code'];
      final message = jsonData['message']?.toString() ?? 'An error occurred';

      // Handle all non-success (non-200) responses.
      if (statusCode != 200) {
        log('API Error: Status Code - $statusCode, Message - $message');

        // Handle specific HTTP status codes.
        if (statusCode == 400) {
          // 400: Bad Request — invalid request or missing parameters.
          log('API Bad Request: $message');
          throw BadRequestException(statusCode: statusCode, message: message);
        } else if (statusCode == 401) {
          // 401: Unauthorized — invalid credentials or expired session.
          log('API Unauthorized: $message');
          throw UnauthorizedException(statusCode: statusCode, message: message);
        } else if (statusCode == 404) {
          // 404: Not Found — requested resource doesn’t exist.
          log('API Not Found: $message');
          throw NotFoundException(statusCode: statusCode, message: message);
        } else if (statusCode >= 500) {
          // 500+: Server Error — backend issue.
          log('API Server Error ($statusCode): $message');
          throw ServerErrorException(statusCode: statusCode, message: message);
        } else {
          // Any other error code.
          throw ApiException(statusCode: statusCode, message: message);
        }
      } else {
        // 200 OK — response might still contain an error message
        if (jsonData.containsKey('error') && jsonData['error'] != null) {
          final errorMessage = jsonData['error'].toString();
          log('API Success with Error: $errorMessage');
          throw ApiException(statusCode: statusCode, message: errorMessage);
        } else {
          // Valid success response
          return jsonData;
        }
      }
    } else if (jsonData.containsKey('error')) {
      // Handles cases where the top-level key is `error` instead of `code`.
      final errorMessage = jsonData['error'].toString();
      log('API Error: $errorMessage');
      throw ApiException(statusCode: 403, message: errorMessage);
    }
  } else {
    // Handle unexpected or invalid response formats.
    log('API Response format is unexpected: $jsonData');
    throw ApiException(message: 'Unexpected API response format $jsonData');
  }

  return jsonData;
}
