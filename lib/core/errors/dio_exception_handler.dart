import 'dart:io';
import 'package:dio/dio.dart';
import 'api_exception.dart';
import 'api_error_type.dart';

class DioExceptionHandler {
  static ApiException handleDioException(DioException dioException) {
    ApiErrorType errorType;
    int? statusCode;

    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        errorType = ApiErrorType.connectionTimeout;
        break;

      case DioExceptionType.sendTimeout:
        errorType = ApiErrorType.sendTimeout;
        break;

      case DioExceptionType.receiveTimeout:
        errorType = ApiErrorType.receiveTimeout;
        break;

      case DioExceptionType.badResponse:
        statusCode = dioException.response?.statusCode;
        errorType = _getErrorTypeFromStatusCode(statusCode);
        break;

      case DioExceptionType.cancel:
        errorType = ApiErrorType.cancelled;
        break;

      case DioExceptionType.connectionError:
        if (dioException.error is SocketException) {
          errorType = ApiErrorType.noInternetConnection;
        } else {
          errorType = ApiErrorType.unknown;
        }
        break;

      case DioExceptionType.badCertificate:
        errorType = ApiErrorType.other;
        break;

      case DioExceptionType.unknown:
        errorType = ApiErrorType.unknown;
        break;
    }

    // استخراج رسالة الخطأ من الـ server response
    String errorMessage = _extractErrorMessage(dioException, errorType);

    // تحديد ما إذا كانت الرسالة من الـ server أم مفتاح ترجمة
    final isServerMessage = _isServerMessage(dioException, errorMessage);
    
    return ApiException(
      errorType: errorType,
      message: errorMessage,
      statusCode: statusCode,
      response: dioException.response,
      isTranslationKey: !isServerMessage, // إذا لم تكن من الـ server، فهي مفتاح ترجمة
    );
  }

  static ApiErrorType _getErrorTypeFromStatusCode(int? statusCode) {
    if (statusCode == null) return ApiErrorType.unknown;

    switch (statusCode) {
      case 400:
        return ApiErrorType.badRequest;
      case 401:
        return ApiErrorType.unauthorized;
      case 403:
        return ApiErrorType.forbidden;
      case 404:
        return ApiErrorType.notFound;
      case 405:
        return ApiErrorType.methodNotAllowed;
      case 406:
        return ApiErrorType.notAcceptable;
      case 408:
        return ApiErrorType.requestTimeout;
      case 409:
        return ApiErrorType.conflict;
      case 410:
        return ApiErrorType.gone;
      case 411:
        return ApiErrorType.lengthRequired;
      case 412:
        return ApiErrorType.preconditionFailed;
      case 413:
        return ApiErrorType.payloadTooLarge;
      case 414:
        return ApiErrorType.uriTooLong;
      case 415:
        return ApiErrorType.unsupportedMediaType;
      case 416:
        return ApiErrorType.rangeNotSatisfiable;
      case 417:
        return ApiErrorType.expectationFailed;
      case 422:
        return ApiErrorType.badRequest; // Unprocessable Entity - validation errors
      case 429:
        return ApiErrorType.tooManyRequests;
      case 500:
        return ApiErrorType.internalServerError;
      case 502:
        return ApiErrorType.badGateway;
      case 503:
        return ApiErrorType.serviceUnavailable;
      case 504:
        return ApiErrorType.gatewayTimeout;
      default:
        if (statusCode >= 500) {
          return ApiErrorType.serverError;
        } else {
          return ApiErrorType.unknown;
        }
    }
  }

  /// استخراج رسالة الخطأ من الـ server response
  static String _extractErrorMessage(DioException dioException, ApiErrorType errorType) {
    try {
      final response = dioException.response;
      if (response?.data != null && response!.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        
        // محاولة استخراج الرسالة الرئيسية
        if (data.containsKey('message') && data['message'] != null) {
          String message = data['message'].toString();
          
          // تنظيف الرسالة من النص الإضافي مثل "(and X more errors)"
          if (message.contains('(and ') && message.contains(' more errors)')) {
            // إذا كانت الرسالة تحتوي على "(and X more errors)"، نحاول استخراج التفاصيل
            if (data.containsKey('errors') && data['errors'] is Map<String, dynamic>) {
              final errors = data['errors'] as Map<String, dynamic>;
              List<String> errorMessages = [];
              
              // استخراج جميع رسائل الخطأ
              errors.forEach((field, fieldErrors) {
                if (fieldErrors is List) {
                  for (var error in fieldErrors) {
                    errorMessages.add(error.toString());
                  }
                }
              });
              
              // إذا كان لدينا رسائل خطأ مفصلة، نستخدمها
              if (errorMessages.isNotEmpty) {
                return errorMessages.join('\n');
              }
            }
            
            // إزالة النص الإضافي من الرسالة الأساسية
            final cleanMessage = message.split('(and ')[0].trim();
            if (cleanMessage.isNotEmpty) {
              return cleanMessage;
            }
          }
          
          // إرجاع الرسالة كما هي إذا لم تحتوي على نص إضافي
          return message;
        }
        
        // محاولة استخراج رسالة من حقل آخر
        if (data.containsKey('error') && data['error'] != null) {
          return data['error'].toString();
        }
      }
    } catch (e) {
      // في حالة فشل استخراج الرسالة، نستخدم الرسالة الافتراضية
    }
    
    // استخدام الرسالة الافتراضية إذا لم نتمكن من استخراج رسالة من الـ server
    return _getDefaultErrorMessage(errorType);
  }

  /// الحصول على مفتاح الترجمة حسب نوع الخطأ
  static String _getDefaultErrorMessage(ApiErrorType errorType) {
    // استخدام مفتاح الترجمة بدلاً من النص المكتوب بقوة
    return errorType.translationKey;
  }

  /// تحديد ما إذا كانت الرسالة من الـ server أم مفتاح ترجمة
  static bool _isServerMessage(DioException dioException, String message) {
    try {
      final response = dioException.response;
      if (response?.data != null && response!.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        
        // إذا كانت الرسالة موجودة في response data، فهي من الـ server
        if (data.containsKey('message') && data['message'] != null) {
          final serverMessage = data['message'].toString();
          // التحقق من أن الرسالة تطابق رسالة الـ server (مع تنظيف النص الإضافي)
          if (message == serverMessage || message == serverMessage.split('(and ')[0].trim()) {
            return true;
          }
        }
        
        // التحقق من حقل error أيضاً
        if (data.containsKey('error') && data['error'] != null) {
          if (message == data['error'].toString()) {
            return true;
          }
        }
      }
    } catch (e) {
      // في حالة الخطأ، نفترض أنها ليست من الـ server
    }
    
    return false; // الرسالة مفتاح ترجمة
  }

}
