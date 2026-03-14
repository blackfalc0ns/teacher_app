import 'package:dio/dio.dart';
import '../errors/dio_exception_handler.dart';
import '../errors/api_exception.dart';
import '../errors/api_error_type.dart';

class ApiHelper {
  /// Executes an API call and handles exceptions
  static Future<T> executeApiCall<T>(
    Future<T> Function() apiCall,
  ) async {
    try {
      return await apiCall();
    } on DioException catch (dioException) {
      throw DioExceptionHandler.handleDioException(dioException);
    } on ApiException {
      // إذا كان ApiException بالفعل، أعد رميه كما هو
      rethrow;
    } catch (e) {
      throw ApiException(
        errorType: ApiErrorType.unknown,
        message: e.toString(),
      );
    }
  }

  /// Executes an API call with custom error handling
  static Future<T> executeApiCallWithHandler<T>(
    Future<T> Function() apiCall,
    void Function(ApiException) onError,
  ) async {
    try {
      return await apiCall();
    } on DioException catch (dioException) {
      final apiException = DioExceptionHandler.handleDioException(dioException);
      onError(apiException);
      throw apiException;
    } on ApiException catch (apiException) {
      // إذا كان ApiException بالفعل، استخدمه مباشرة
      onError(apiException);
      rethrow;
    } catch (e) {
      final apiException = ApiException(
        errorType: ApiErrorType.unknown,
        message: e.toString(),
      );
      onError(apiException);
      throw apiException;
    }
  }

  /// Executes an API call and returns a result wrapper
  static Future<ApiResult<T>> safeApiCall<T>(
    Future<T> Function() apiCall,
  ) async {
    try {
      final result = await apiCall();
      return ApiResult.success(result);
    } on DioException catch (dioException) {
      final apiException = DioExceptionHandler.handleDioException(dioException);
      return ApiResult.failure(apiException);
    } on ApiException catch (apiException) {
      // إذا كان ApiException بالفعل، استخدمه مباشرة
      return ApiResult.failure(apiException);
    } catch (e) {
      final apiException = ApiException(
        errorType: ApiErrorType.unknown,
        message: e.toString(),
      );
      return ApiResult.failure(apiException);
    }
  }
}

/// Result wrapper for API calls
class ApiResult<T> {
  final T? data;
  final ApiException? error;
  final bool isSuccess;

  const ApiResult._({
    this.data,
    this.error,
    required this.isSuccess,
  });

  factory ApiResult.success(T data) {
    return ApiResult._(
      data: data,
      isSuccess: true,
    );
  }

  factory ApiResult.failure(ApiException error) {
    return ApiResult._(
      error: error,
      isSuccess: false,
    );
  }

  /// Execute different callbacks based on result
  R when<R>({
    required R Function(T data) success,
    required R Function(ApiException error) failure,
  }) {
    if (isSuccess) {
      // Handle void type where data is null but operation succeeded
      return success(data as T);
    } else if (error != null) {
      return failure(error!);
    } else {
      throw StateError('Invalid ApiResult state');
    }
  }

  /// Execute callbacks with optional error handling
  void fold({
    void Function(T data)? onSuccess,
    void Function(ApiException error)? onError,
  }) {
    if (isSuccess && data != null && onSuccess != null) {
      onSuccess(data as T);
    } else if (error != null && onError != null) {
      onError(error!);
    }
  }
}
