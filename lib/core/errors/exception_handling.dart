import 'dart:convert';
import 'dart:developer';

import 'package:google_map_service/core/network/api_exception.dart';
import 'package:http/http.dart' as http;

Map<String, dynamic> handleException(http.Response data) {
  final jsonData = json.decode(data.body);
  if (jsonData != null) {
    if (jsonData.containsKey('code')) {
      final statusCode = jsonData['code'];
      final message = jsonData['message']?.toString() ?? 'An error occurred';

      if (statusCode != 200) {
        log('API Error: Status Code - $statusCode, Message - $message');
        // You can add more specific error handling based on status codes
        if (statusCode == 400) {
          // Bad Request
          log('API Bad Request: $message');
          // Optionally throw a custom exception
          throw BadRequestException(statusCode: statusCode, message: message);
        } else if (statusCode == 401) {
          // sessionExpired(message);
          // Unauthorized
          log('API Unauthorized: $message');
          // Optionally handle token refresh or logout
          throw UnauthorizedException(statusCode: statusCode, message: message);
        } else if (statusCode == 404) {
          // Not Found
          log('API Not Found: $message');
          throw NotFoundException(statusCode: statusCode, message: message);
        } else if (statusCode >= 500) {
          // Server Error
          log('API Server Error ($statusCode): $message');
          throw ServerErrorException(statusCode: statusCode, message: message);
        } else {
          // Other error codes
          throw ApiException(statusCode: statusCode, message: message);
        }
      } else {
        // Status code is 200, but you might want to check for specific error messages within the data
        if (jsonData.containsKey('error') && jsonData['error'] != null) {
          final errorMessage = jsonData['error'].toString();
          log('API Success with Error: $errorMessage');
          throw ApiException(statusCode: statusCode, message: message);
        } else {
          return jsonData;
        }
        // You can add checks for other error indicators in your success response if needed
      }
    } else if (jsonData.containsKey('error')) {
      // Handle cases where the top-level key is 'error'
      final errorMessage = jsonData['error'].toString();
      log('API Error: $errorMessage');
      throw ApiException(statusCode: 403, message: errorMessage);
    }
    // Add more checks for different error structures your API might return
  } else {
    log('API Response format is unexpected: $jsonData');
    throw ApiException(message: 'Unexpected API response format $jsonData');
  }
  return jsonData;
}
