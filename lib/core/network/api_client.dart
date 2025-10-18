import 'dart:convert';
import 'dart:developer';

import 'package:google_map_service/core/errors/exception_handling.dart';
import 'package:google_map_service/core/network/api_constants.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final http.Client httpClient;

  ApiClient({required this.baseUrl, http.Client? client})
    : httpClient = client ?? http.Client();

  /// GET request
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

  // /// GET request
  // Future<dynamic> getCustom(
  //   String endpoint, {
  //   Map<String, String>? headers,
  //   Map<String, dynamic>? params,
  // }) async {
  //   final uri = Uri.parse("$baseUrl$endpoint").replace(queryParameters: params);
  //   log(uri.toString());
  //   final response = await httpClient.get(
  //     uri,
  //     headers: headers,
  //   );
  //   return handleException(response);
  // }

  /// POST request
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

  /// Multipart POST request
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

  /// PUT request
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

  /// DELETE request
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

  /// Handle API response
  // dynamic _processResponse(http.Response response) {
  //   final statusCode = response.statusCode;
  //   final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

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
