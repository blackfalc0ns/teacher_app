import 'package:flutter/material.dart';
import 'base_error_widget.dart';
import 'package:teacher_app/core/errors/api_error_type.dart';
import 'package:teacher_app/generated/app_localizations.dart';

class ServerErrorWidget extends BaseErrorWidget {
  final ApiErrorType serverErrorType;
  final int? statusCode;
  final String? serverMessage; // رسالة الـ server المخصصة

  const ServerErrorWidget({
    super.key,
    required this.serverErrorType,
    this.statusCode,
    this.serverMessage,
    super.onRetry,
    VoidCallback? onContactSupport,
  }) : super(
         title: '',
         description: '',
         icon: Icons.error_outline,
         onSecondaryAction: onContactSupport,
         secondaryActionText: '',
         primaryColor: Colors.red,
       );

  /// Check if message contains technical details that should be hidden
  bool _isTechnicalMessage(String? message) {
    if (message == null || message.isEmpty) return true;

    final technicalPatterns = [
      'sql',
      'mysql',
      'database',
      'exception',
      'error:',
      'stack',
      'trace',
      'file:',
      '/tmp/',
      'errcode',
      'connection:',
      'select ',
      'insert ',
      'update ',
      'delete ',
      'from ',
      'where ',
      '.php',
      '.dart',
      'laravel',
      'eloquent',
      'null and',
      'is null',
      'sqlstate',
      'pdo',
      'query',
    ];

    final lowerMessage = message.toLowerCase();
    return technicalPatterns.any((pattern) => lowerMessage.contains(pattern));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    String title;
    String description;
    IconData iconData = Icons.error_outline;

    switch (serverErrorType) {
      case ApiErrorType.internalServerError:
        title = l10n?.error_internal_server_error ?? '';
        description = l10n?.error_internal_server_error_desc ?? '';
        iconData = Icons.dns;
        break;
      case ApiErrorType.badGateway:
        title = l10n?.error_bad_gateway ?? '';
        description = l10n?.error_bad_gateway_desc ?? '';
        iconData = Icons.router;
        break;
      case ApiErrorType.serviceUnavailable:
        title = l10n?.error_service_unavailable ?? '';
        description = l10n?.error_service_unavailable_desc ?? '';
        iconData = Icons.cloud_off;
        break;
      case ApiErrorType.gatewayTimeout:
        title = l10n?.error_gateway_timeout ?? '';
        description = l10n?.error_gateway_timeout_desc ?? '';
        iconData = Icons.access_time;
        break;
      default:
        title = l10n?.error_server_error ?? '';
        description = l10n?.error_server_error_desc ?? '';
        iconData = Icons.error_outline;
    }

    // لا تعرض رسالة الـ server إذا كانت تحتوي على تفاصيل تقنية
    // استخدم الوصف المترجم فقط
    final finalDescription =
        (serverMessage != null &&
            serverMessage!.isNotEmpty &&
            !_isTechnicalMessage(serverMessage) &&
            serverMessage!.length < 150)
        ? serverMessage!
        : description;

    return BaseErrorWidget(
      title: title, // لا تعرض status code للمستخدم
      description: finalDescription,
      icon: iconData,
      onRetry: onRetry,
      onSecondaryAction: onSecondaryAction,
      secondaryActionText: l10n?.contact_support ?? '',
      primaryColor: Colors.red,
    );
  }

  @override
  String getRetryButtonText(BuildContext context) {
    return AppLocalizations.of(context)?.retry ?? '';
  }
}
