import 'package:flutter/material.dart';
import 'package:teacher_app/generated/app_localizations.dart';
import 'base_error_widget.dart';
import 'package:teacher_app/core/errors/api_error_type.dart';

class TimeoutErrorWidget extends BaseErrorWidget {
  final ApiErrorType timeoutType;

  const TimeoutErrorWidget({
    super.key,
    required this.timeoutType,
    super.onRetry,
  }) : super(
         title: '',
         description: '',
         icon: Icons.access_time,
         primaryColor: Colors.amber,
       );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    String title;
    String description;

    switch (timeoutType) {
      case ApiErrorType.connectionTimeout:
        title = l10n?.error_connection_timeout ?? '';
        description = l10n?.error_connection_timeout_desc ?? '';
        break;
      case ApiErrorType.receiveTimeout:
        title = l10n?.error_receive_timeout ?? '';
        description = l10n?.error_receive_timeout_desc ?? '';
        break;
      case ApiErrorType.sendTimeout:
        title = l10n?.error_send_timeout ?? '';
        description = l10n?.error_send_timeout_desc ?? '';
        break;
      case ApiErrorType.requestTimeout:
        title = l10n?.error_request_timeout ?? '';
        description = l10n?.error_request_timeout_desc ?? '';
        break;
      default:
        title = l10n?.error_connection_timeout ?? '';
        description = l10n?.error_connection_timeout_desc ?? '';
    }

    return BaseErrorWidget(
      title: title,
      description: description,
      icon: Icons.access_time,
      onRetry: onRetry,
      primaryColor: Colors.amber,
    );
  }

  @override
  String getRetryButtonText(BuildContext context) {
    return AppLocalizations.of(context)?.retry ?? '';
  }
}
