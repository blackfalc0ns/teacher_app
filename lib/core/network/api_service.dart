import 'dart:io';
import 'dart:developer' as developer;
import 'package:teacher_app/core/network/api_helper.dart';
import 'package:dio/dio.dart';
import 'dio_client.dart';

class ApiService {
  final DioClient _dioClient = DioClient.instance;

  // GET request with error handling
  Future<T> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? fromJson,
  }) async {
    return await ApiHelper.executeApiCall<T>(() async {
      final response = await _dioClient.get(
        endpoint,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );

      if (fromJson != null) {
        return fromJson(response.data);
      }
      return response.data as T;
    });
  }

  // POST request with error handling
  Future<T> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? fromJson,
  }) async {
    return await ApiHelper.executeApiCall<T>(() async {
      final response = await _dioClient.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );

      if (fromJson != null) {
        return fromJson(response.data);
      }
      return response.data as T;
    });
  }

  // PUT request with error handling
  Future<T> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? fromJson,
  }) async {
    return await ApiHelper.executeApiCall<T>(() async {
      final response = await _dioClient.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );

      if (fromJson != null) {
        return fromJson(response.data);
      }
      return response.data as T;
    });
  }

  // DELETE request with error handling
  Future<T> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? fromJson,
  }) async {
    return await ApiHelper.executeApiCall<T>(() async {
      final response = await _dioClient.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );

      if (fromJson != null) {
        return fromJson(response.data);
      }
      return response.data as T;
    });
  }

  // PATCH request with error handling
  Future<T> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? fromJson,
  }) async {
    return await ApiHelper.executeApiCall<T>(() async {
      final response = await _dioClient.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );

      if (fromJson != null) {
        return fromJson(response.data);
      }
      return response.data as T;
    });
  }

  // Safe API call that returns ApiResult
  Future<ApiResult<T>> safeGet<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? fromJson,
  }) async {
    return await ApiHelper.safeApiCall<T>(() async {
      // Log request details for packages endpoint
      if (endpoint.contains('package')) {
        developer.log(
          '========== PACKAGES REQUEST ==========',
          name: 'ApiService',
        );
        developer.log('[ApiService] Endpoint: $endpoint', name: 'ApiService');
        developer.log(
          '[ApiService] Query Parameters: $queryParameters',
          name: 'ApiService',
        );
        developer.log(
          '[ApiService] Custom Headers: $headers',
          name: 'ApiService',
        );
      }

      final response = await _dioClient.get(
        endpoint,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );

      // Log raw response for packages endpoint
      if (endpoint.contains('package')) {
        developer.log(
          '========== PACKAGES RESPONSE ==========',
          name: 'ApiService',
        );
        developer.log(
          '[ApiService] Status: ${response.statusCode}',
          name: 'ApiService',
        );
        developer.log(
          '[ApiService] Response type: ${response.data.runtimeType}',
          name: 'ApiService',
        );
        if (response.data is Map) {
          final data = response.data as Map;
          developer.log(
            '[ApiService] Response keys: ${data.keys}',
            name: 'ApiService',
          );
          developer.log(
            '[ApiService] Full response: $data',
            name: 'ApiService',
          );
          if (data.containsKey('data') && data['data'] is Map) {
            final innerData = data['data'] as Map;
            developer.log(
              '[ApiService] Inner data keys: ${innerData.keys}',
              name: 'ApiService',
            );
            if (innerData.containsKey('companies')) {
              developer.log(
                '[ApiService] Companies type: ${innerData['companies'].runtimeType}',
                name: 'ApiService',
              );
              developer.log(
                '[ApiService] Companies content: ${innerData['companies']}',
                name: 'ApiService',
              );
            }
          }
        }
        developer.log(
          '======================================',
          name: 'ApiService',
        );
      }

      if (fromJson != null) {
        return fromJson(response.data);
      }
      return response.data as T;
    });
  }

  Future<ApiResult<T>> safePost<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? fromJson,
  }) async {
    return await ApiHelper.safeApiCall<T>(() async {
      final response = await _dioClient.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );

      if (fromJson != null) {
        return fromJson(response.data);
      }
      return response.data as T;
    });
  }

  // Safe PATCH request that returns ApiResult (sends JSON body)
  Future<ApiResult<T>> safePatch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? fromJson,
  }) async {
    return await ApiHelper.safeApiCall<T>(() async {
      final response = await _dioClient.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );

      if (fromJson != null) {
        return fromJson(response.data);
      }
      return response.data as T;
    });
  }

  // Update language for all future requests
  void updateLanguage(String languageCode) {
    _dioClient.updateLanguage(languageCode);
  }

  // Set authentication token
  void setAuthToken(String token) {
    _dioClient.setAuthToken(token);
  }

  // Clear authentication token
  void clearAuthToken() {
    _dioClient.clearAuthToken();
  }

  // Update base URL
  void updateBaseUrl(String newBaseUrl) {
    _dioClient.updateBaseUrl(newBaseUrl);
  }

  // POST multipart request for file uploads
  Future<T> postMultipart<T>(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, String>? files,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? fromJson,
  }) async {
    return await ApiHelper.executeApiCall<T>(() async {
      // Create FormData for multipart request
      final formData = FormData();

      // Add regular data fields
      if (data != null) {
        data.forEach((key, value) {
          formData.fields.add(MapEntry(key, value.toString()));
        });
      }

      // Add file fields
      if (files != null) {
        for (final entry in files.entries) {
          final file = await MultipartFile.fromFile(
            entry.value,
            filename: entry.value.split('/').last,
          );
          formData.files.add(MapEntry(entry.key, file));
        }
      }

      final response = await _dioClient.post(
        endpoint,
        data: formData,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );

      if (fromJson != null) {
        return fromJson(response.data);
      }
      return response.data as T;
    });
  }

  // Safe POST multipart request for file uploads with ApiResult
  Future<ApiResult<T>> safePostMultipart<T>(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, File>? files,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? fromJson,
  }) async {
    return await ApiHelper.safeApiCall<T>(() async {
      ////print('========== MULTIPART UPLOAD ==========');
      ////print('Endpoint: $endpoint');
      ////print('Data: $data');
      ////print('Files: ${files?.keys.toList()}');

      // Create FormData for multipart request
      final formData = FormData();

      // Add regular data fields
      if (data != null) {
        data.forEach((key, value) {
          ////print('Adding field: $key = $value');
          formData.fields.add(MapEntry(key, value.toString()));
        });
      }

      // Add file fields
      if (files != null) {
        for (final entry in files.entries) {
          ////print('Processing file: ${entry.key}');
          ////print('File path: ${entry.value.path}');
          ////print('File exists: ${await entry.value.exists()}');
          ////print('File size: ${await entry.value.length()} bytes');

          final file = await MultipartFile.fromFile(
            entry.value.path,
            filename: entry.value.path.split('/').last,
          );
          ////print('Created MultipartFile: ${file.filename}');
          formData.files.add(MapEntry(entry.key, file));
        }
      }

      ////print('Sending multipart request...');
      final response = await _dioClient.post(
        endpoint,
        data: formData,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );

      ////print('Response status: ${response.statusCode}');
      ////print('Response data: ${response.data}');
      ////print('======================================');

      if (fromJson != null) {
        return fromJson(response.data);
      }
      return response.data as T;
    });
  }

  // Safe PATCH multipart request for file uploads with ApiResult
  Future<ApiResult<T>> safePatchMultipart<T>(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, File>? files,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    T Function(dynamic)? fromJson,
  }) async {
    return await ApiHelper.safeApiCall<T>(() async {
      ////print('========== MULTIPART PATCH ==========');
      ////print('Endpoint: $endpoint');
      ////print('Data: $data');
      ////print('Files: ${files?.keys.toList()}');

      // Create FormData for multipart request
      final formData = FormData();

      // Add regular data fields
      if (data != null) {
        data.forEach((key, value) {
          ////print('Adding field: $key = $value');
          formData.fields.add(MapEntry(key, value.toString()));
        });
      }

      // Add file fields
      if (files != null) {
        for (final entry in files.entries) {
          ////print('Processing file: ${entry.key}');
          ////print('File path: ${entry.value.path}');
          ////print('File exists: ${await entry.value.exists()}');
          ////print('File size: ${await entry.value.length()} bytes');

          final file = await MultipartFile.fromFile(
            entry.value.path,
            filename: entry.value.path.split('/').last,
          );
          ////print('Created MultipartFile: ${file.filename}');
          formData.files.add(MapEntry(entry.key, file));
        }
      }

      ////print('Sending PATCH multipart request...');
      final response = await _dioClient.patch(
        endpoint,
        data: formData,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );

      ////print('Response status: ${response.statusCode}');
      ////print('Response data: ${response.data}');
      ////print('======================================');

      if (fromJson != null) {
        return fromJson(response.data);
      }
      return response.data as T;
    });
  }
}
