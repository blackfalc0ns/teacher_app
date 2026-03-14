// import 'package:dio/dio.dart';
// import 'dart:developer' as developer;

// class LoggingInterceptor extends Interceptor {
//   final bool logRequest;
//   final bool logResponse;
//   final bool logError;
  
//   LoggingInterceptor({
//     this.logRequest = true,
//     this.logResponse = true,
//     this.logError = true,
//   });
  
//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
//     if (logRequest) {
//       _logRequest(options);
//     }
//     super.onRequest(options, handler);
//   }
  
//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) {
//     if (logResponse) {
//       _logResponse(response);
//     }
//     super.onResponse(response, handler);
//   }
  
//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) {
//     if (logError) {
//       _logError(err);
//     }
//     super.onError(err, handler);
//   }
  
//   void _logRequest(RequestOptions options) {
//     final uri = options.uri;
//     final method = options.method.toUpperCase();
//     final headers = options.headers;
//     final data = options.data;
//     final retryCount = options.extra['retry_count'] ?? 0;
    
//     developer.log(
//       '🚀 REQUEST [$method] $uri',
//       name: 'DioClient',
//     );
    
//     if (retryCount > 0) {
//       developer.log(
//         '🔄 Retry attempt: $retryCount',
//         name: 'DioClient',
//       );
//     }
    
//     developer.log(
//       '📋 Headers: $headers',
//       name: 'DioClient',
//     );
    
//     if (data != null) {
//       developer.log(
//         '📦 Data: $data',
//         name: 'DioClient',
//       );
//     }
//   }
  
//   void _logResponse(Response response) {
//     final uri = response.requestOptions.uri;
//     final method = response.requestOptions.method.toUpperCase();
//     final statusCode = response.statusCode;
//     final data = response.data;
    
//     developer.log(
//       '✅ RESPONSE [$method] $uri - Status: $statusCode',
//       name: 'DioClient',
//     );
    
//     developer.log(
//       '📋 Headers: ${response.headers}',
//       name: 'DioClient',
//     );
    
//     if (data != null) {
//       // تحديد طول البيانات لتجنب logs طويلة جداً
//       final dataString = data.toString();
//       final truncatedData = dataString.length > 500 
//           ? '${dataString.substring(0, 500)}...[truncated]'
//           : dataString;
      
//       developer.log(
//         '📦 Response Data: $truncatedData',
//         name: 'DioClient',
//       );
//     }
//   }
  
//   void _logError(DioException error) {
//     final uri = error.requestOptions.uri;
//     final method = error.requestOptions.method.toUpperCase();
//     final statusCode = error.response?.statusCode;
//     final errorMessage = error.message;
//     final errorType = error.type;
    
//     developer.log(
//       '❌ ERROR [$method] $uri - Type: $errorType',
//       name: 'DioClient',
//       error: errorMessage,
//     );
    
//     if (statusCode != null) {
//       developer.log(
//         '📊 Status Code: $statusCode',
//         name: 'DioClient',
//       );
//     }
    
//     if (error.response?.data != null) {
//       developer.log(
//         '📦 Error Data: ${error.response?.data}',
//         name: 'DioClient',
//       );
//     }
//   }
// }
