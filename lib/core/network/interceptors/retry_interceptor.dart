import 'dart:io';
import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;
  final List<int> retryStatusCodes;
  
  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 2),
    this.retryStatusCodes = const [500, 502, 503, 504, 408, 429],
  });
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final shouldRetry = _shouldRetry(err);
    final retryCount = _getRetryCount(err.requestOptions);
    
    if (shouldRetry && retryCount < maxRetries) {
      // زيادة عدد المحاولات
      _setRetryCount(err.requestOptions, retryCount + 1);
      
      // انتظار قبل إعادة المحاولة
      await Future.delayed(_calculateDelay(retryCount));
      
      try {
        // إعادة تنفيذ الطلب
        final response = await _retry(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (e) {
        // في حالة فشل إعادة المحاولة، تمرير الخطأ الأصلي
        if (e is DioException) {
          handler.next(e);
        } else {
          handler.next(err);
        }
        return;
      }
    }
    
    // إذا لم تعد هناك محاولات أو لا يجب إعادة المحاولة
    handler.next(err);
  }
  
  bool _shouldRetry(DioException error) {
    // إعادة المحاولة في حالات معينة
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return true;
      
      case DioExceptionType.connectionError:
        // إعادة المحاولة في حالة مشاكل الشبكة
        if (error.error is SocketException) {
          return true;
        }
        return false;
      
      case DioExceptionType.badResponse:
        // إعادة المحاولة للـ status codes المحددة
        final statusCode = error.response?.statusCode;
        return statusCode != null && retryStatusCodes.contains(statusCode);
      
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return false;
    }
  }
  
  int _getRetryCount(RequestOptions options) {
    return options.extra['retry_count'] as int? ?? 0;
  }
  
  void _setRetryCount(RequestOptions options, int count) {
    options.extra['retry_count'] = count;
  }
  
  Duration _calculateDelay(int retryCount) {
    // Exponential backoff: 2s, 4s, 8s, ...
    final multiplier = (retryCount + 1) * 2;
    return Duration(seconds: retryDelay.inSeconds * multiplier);
  }
  
  Future<Response> _retry(RequestOptions requestOptions) async {
    final dio = Dio();
    
    // نسخ الإعدادات الأساسية
    dio.options = BaseOptions(
      baseUrl: requestOptions.baseUrl,
      connectTimeout: Duration(milliseconds: (requestOptions.connectTimeout as int?) ?? 30000),
      receiveTimeout: Duration(milliseconds: (requestOptions.receiveTimeout as int?) ?? 30000),
      sendTimeout: Duration(milliseconds: (requestOptions.sendTimeout as int?) ?? 30000),
      headers: requestOptions.headers,
    );
    
    // تنفيذ الطلب حسب النوع
    switch (requestOptions.method.toUpperCase()) {
      case 'GET':
        return await dio.get(
          requestOptions.path,
          queryParameters: requestOptions.queryParameters,
          options: Options(
            headers: requestOptions.headers,
            responseType: requestOptions.responseType,
            contentType: requestOptions.contentType,
          ),
        );
      
      case 'POST':
        return await dio.post(
          requestOptions.path,
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
          options: Options(
            headers: requestOptions.headers,
            responseType: requestOptions.responseType,
            contentType: requestOptions.contentType,
          ),
        );
      
      case 'PUT':
        return await dio.put(
          requestOptions.path,
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
          options: Options(
            headers: requestOptions.headers,
            responseType: requestOptions.responseType,
            contentType: requestOptions.contentType,
          ),
        );
      
      case 'DELETE':
        return await dio.delete(
          requestOptions.path,
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
          options: Options(
            headers: requestOptions.headers,
            responseType: requestOptions.responseType,
            contentType: requestOptions.contentType,
          ),
        );
      
      case 'PATCH':
        return await dio.patch(
          requestOptions.path,
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
          options: Options(
            headers: requestOptions.headers,
            responseType: requestOptions.responseType,
            contentType: requestOptions.contentType,
          ),
        );
      
      default:
        throw DioException(
          requestOptions: requestOptions,
          error: 'Unsupported HTTP method: ${requestOptions.method}',
        );
    }
  }
}
