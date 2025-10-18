import 'dart:convert';
import 'dart:developer';

import 'package:google_map_service/core/errors/exception_handling.dart';
import 'package:google_map_service/core/network/api_constants.dart';
import 'package:http/http.dart' as http;

/// A lightweight HTTP client wrapper for handling RESTful API requests.
///
/// The [ApiClient] class provides convenient methods to perform
/// standard HTTP operations such as `GET`, `POST`, `PUT`, `DELETE`,
/// and `Multipart POST` requests.
///
/// It includes built-in JSON encoding, logging, and response handling
/// through a centralized exception manager (`handleException`).
///
/// This client is primarily used throughout the `google_map_service` package
/// to interact with Google Maps Platform APIs and other backend services.
///
/// Example usage:
/// ```dart
/// final client = ApiClient(baseUrl: "https://maps.googleapis.com/maps");
///
/// final result = await client.get(
///   "/api/place/details/json",
///   params: {"place_id": "ChIJN1t_tDeuEmsRUsoyG83frY4", "key": "YOUR_KEY"},
/// );
/// print(result);
/// ```
class ApiClient {
  /// The base URL for all requests (e.g., `"https://maps.googleapis.com/maps"`).
  final String baseUrl;

  /// The HTTP client used to send network requests.
  /// Defaults to a new instance of [http.Client] if not provided.
  final http.Client httpClient;

  /// Creates a new [ApiClient] with the given [baseUrl].
  ///
  /// Optionally, you can inject a custom [http.Client] for testing or configuration.
  ApiClient({required this.baseUrl, http.Client? client})
    : httpClient = client ?? http.Client();

  // ---------------------------------------------------------------------------
  // HTTP GET
  // ---------------------------------------------------------------------------

  /// Sends a GET request to the specified [endpoint].
  ///
  /// [headers] can override or add additional request headers.
  /// [params] are automatically appended as query parameters.
  ///
  /// Example:
  /// ```dart
  /// final response = await apiClient.get(
  ///   "/api/place/queryautocomplete/json",
  ///   params: {"input": "Pizza", "key": "YOUR_API_KEY"},
  /// );
  /// ```
  ///
  /// Returns the decoded JSON response or throws an exception handled by
  /// [handleException] if the request fails.
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? params,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: params);
    final response = await httpClient.get(
      uri,
      headers: headers ?? await ApiUriConstants.headers(),
    );
    return handleException(response);
  }

  // ---------------------------------------------------------------------------
  // HTTP POST
  // ---------------------------------------------------------------------------

  /// Sends a POST request to the specified [endpoint].
  ///
  /// [headers] allows custom headers (defaults to JSON content type).
  /// [body] can be any JSON-serializable object.
  ///
  /// Example:
  /// ```dart
  /// final response = await apiClient.post(
  ///   "/directions/v2:computeRoutes",
  ///   body: {
  ///     "origin": {"latLng": {"latitude": 40.748817, "longitude": -73.985428}},
  ///     "destination": {"latLng": {"latitude": 40.712776, "longitude": -74.005974}},
  ///   },
  /// );
  /// ```
  Future<dynamic> post(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    log(baseUrl + endpoint);
    log(jsonEncode(body));
    log(jsonEncode(headers ?? await ApiUriConstants.headers()));

    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await httpClient.post(
      uri,
      headers: headers ?? await ApiUriConstants.headers(),
      body: body != null ? jsonEncode(body) : null,
    );

    log(response.body);
    return handleException(response);
  }

  // ---------------------------------------------------------------------------
  // MULTIPART POST
  // ---------------------------------------------------------------------------

  /// Sends a multipart POST request to the given [endpoint].
  ///
  /// This method is typically used for file uploads.
  ///
  /// [headers] – optional custom headers
  /// [body] – additional text fields
  /// [multipartFiles] – list of [http.MultipartFile] objects to upload
  ///
  /// Example:
  /// ```dart
  /// final file = await http.MultipartFile.fromPath('image', filePath);
  /// final response = await apiClient.multiPartPost(
  ///   '/upload',
  ///   body: {'userId': '123'},
  ///   multipartFiles: [file],
  /// );
  /// ```
  Future<dynamic> multiPartPost(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, String>? body,
    Iterable<http.MultipartFile>? multipartFiles,
  }) async {
    log(baseUrl + endpoint);
    log(jsonEncode(body));

    final uri = Uri.parse('$baseUrl$endpoint');
    final multipartReq = http.MultipartRequest('POST', uri);
    multipartReq.headers.addAll(headers ?? await ApiUriConstants.headers());

    if (multipartFiles?.isNotEmpty ?? false) {
      multipartReq.files.addAll(multipartFiles!);
    }

    if (body != null) multipartReq.fields.addAll(body);

    final response = await multipartReq.send();
    final res = await http.Response.fromStream(response);
    return handleException(res);
  }

  // ---------------------------------------------------------------------------
  // HTTP PUT
  // ---------------------------------------------------------------------------

  /// Sends a PUT request to the specified [endpoint].
  ///
  /// [headers] allows custom headers (defaults to JSON content type).
  /// [body] can be any JSON-serializable object.
  ///
  /// Example:
  /// ```dart
  /// await apiClient.put(
  ///   "/api/user/updateProfile",
  ///   body: {"name": "John Doe"},
  /// );
  /// ```
  Future<dynamic> put(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await httpClient.put(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );
    return handleException(response);
  }

  // ---------------------------------------------------------------------------
  // HTTP DELETE
  // ---------------------------------------------------------------------------

  /// Sends a DELETE request to the specified [endpoint].
  ///
  /// [headers] allows custom headers (defaults to JSON content type).
  /// [body] can be any JSON-serializable object if required.
  ///
  /// Example:
  /// ```dart
  /// await apiClient.delete(
  ///   "/api/user/deleteAccount",
  ///   body: {"userId": "123"},
  /// );
  /// ```
  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final response = await httpClient.delete(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );
    return handleException(response);
  }

  // ---------------------------------------------------------------------------
  // Response Handling
  // ---------------------------------------------------------------------------

  // /// Internal method to process and validate API responses.
  // ///
  // /// If the response status code is between 200–299, returns the decoded JSON body.
  // /// Otherwise, throws an [ApiException] with the appropriate error message.
  // dynamic _processResponse(http.Response response) {
  //   final statusCode = response.statusCode;
  //   final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;
  //
  //   if (statusCode >= 200 && statusCode < 300) {
  //     return body;
  //   } else {
  //     throw ApiException(
  //       statusCode: statusCode,
  //       message: body?['message'] ?? 'Unknown error',
  //     );
  //   }
  // }
}
