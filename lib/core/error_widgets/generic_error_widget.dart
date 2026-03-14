import 'package:teacher_app/core/errors/api_error_type.dart';
import 'package:teacher_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'base_error_widget.dart';

class GenericErrorWidget extends BaseErrorWidget {
  final ApiErrorType errorType;
  final String? serverMessage; // رسالة الـ server المخصصة

  const GenericErrorWidget({
    super.key,
    required this.errorType,
    this.serverMessage,
    super.onRetry,
    VoidCallback? onGoBack,
  }) : super(
         title: '',
         description: '',
         icon: Icons.error,
         onSecondaryAction: onGoBack,
         secondaryActionText: '',
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
    IconData iconData = Icons.error;
    Color color = Colors.red;

    switch (errorType) {
      case ApiErrorType.cancelled:
        title = l10n?.error_cancelled ?? '';
        description = l10n?.error_cancelled_desc ?? '';
        iconData = Icons.cancel;
        color = Colors.grey;
        break;
      case ApiErrorType.unknown:
        title = l10n?.error_unknown ?? '';
        description = l10n?.error_unknown_desc ?? '';
        iconData = Icons.help_outline;
        color = Colors.grey;
        break;
      case ApiErrorType.other:
        title = l10n?.error_other ?? '';
        description = l10n?.error_other_desc ?? '';
        iconData = Icons.error_outline;
        break;
      default:
        title = l10n?.error_unknown ?? '';
        description = l10n?.error_unknown_desc ?? '';
        iconData = Icons.help_outline;
        color = Colors.grey;
    }

    // لا تعرض رسالة الـ server إذا كانت تحتوي على تفاصيل تقنية
    final finalDescription =
        (serverMessage != null &&
            serverMessage!.isNotEmpty &&
            !_isTechnicalMessage(serverMessage) &&
            serverMessage!.length < 150)
        ? serverMessage!
        : description;

    return BaseErrorWidget(
      title: title,
      description: finalDescription,
      icon: iconData,
      onRetry: onRetry,
      onSecondaryAction: onSecondaryAction,
      secondaryActionText: l10n?.go_back ?? '',
      primaryColor: color,
    );
  }

  @override
  String getRetryButtonText(BuildContext context) {
    return AppLocalizations.of(context)?.retry ?? '';
  }
}
