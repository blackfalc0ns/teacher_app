import 'api_error_type.dart';

class ApiException implements Exception {
  final ApiErrorType errorType;
  final String message;
  final int? statusCode;
  final dynamic response;
  final bool isTranslationKey; //       

  const ApiException({
    required this.errorType,
    required this.message,
    this.statusCode,
    this.response,
    this.isTranslationKey = false,
  });

  @override
  String toString() {
    //        
    return message;
  }
}
