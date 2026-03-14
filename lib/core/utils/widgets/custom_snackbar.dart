import 'package:teacher_app/core/errors/api_exception.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constant/font_manger.dart';
import '../constant/styles_manger.dart';
import '../theme/app_colors.dart';

enum SnackbarType { success, error, warning, info }

class CustomSnackbar {
  static void showSuccess({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    _showEnhancedSnackbar(
      context: context,
      message: _getTranslatedMessage(context, message),
      type: SnackbarType.success,
      duration: duration,
    );
  }

  static void showError({
    required BuildContext context,
    String? message,
    ApiException? exception,
    Duration duration = const Duration(seconds: 5),
  }) {
    String finalMessage;

    if (message != null) {
      finalMessage = message;
    } else if (exception != null) {
      finalMessage = exception.toString();
    } else {
      finalMessage = 'An error occurred';
    }

    _showEnhancedSnackbar(
      context: context,
      message: _getTranslatedMessage(context, finalMessage),
      type: SnackbarType.error,
      duration: duration,
    );
  }

  static void showWarning({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    _showEnhancedSnackbar(
      context: context,
      message: _getTranslatedMessage(context, message),
      type: SnackbarType.warning,
      duration: duration,
    );
  }

  static void showInfo({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showEnhancedSnackbar(
      context: context,
      message: _getTranslatedMessage(context, message),
      type: SnackbarType.info,
      duration: duration,
    );
  }

  static void _showEnhancedSnackbar({
    required BuildContext context,
    required String message,
    required SnackbarType type,
    required Duration duration,
  }) {
    // Get colors and icons based on type
    Color backgroundColor;
    Color iconBackgroundColor;
    IconData icon;

    switch (type) {
      case SnackbarType.success:
        backgroundColor = const Color.fromARGB(255, 13, 184, 70); // Green-500
        iconBackgroundColor = const Color.fromARGB(
          255,
          13,
          184,
          70,
        ); // Green-600
        icon = FontAwesomeIcons.circleCheck;
        break;
      case SnackbarType.error:
        backgroundColor = const Color(0xFFEF4444); // Red-500
        iconBackgroundColor = const Color(0xFFDC2626); // Red-600
        icon = FontAwesomeIcons.circleXmark;
        break;
      case SnackbarType.warning:
        backgroundColor = const Color(0xFFF59E0B); // Amber-500
        iconBackgroundColor = const Color(0xFFD97706); // Amber-600
        icon = FontAwesomeIcons.triangleExclamation;
        break;
      case SnackbarType.info:
        backgroundColor = AppColors.primary;
        iconBackgroundColor = AppColors.primarySecondary;
        icon = FontAwesomeIcons.circleInfo;
        break;
    }
    // Remove any existing snackbar first
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.clearSnackBars();

    final snackBar = SnackBar(
      duration: duration,
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      content: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 600),
        tween: Tween<double>(begin: 0.0, end: 1.0),
        curve: Curves.elasticOut,
        builder: (context, animationValue, child) {
          // Clamp values to prevent elasticOut from going outside valid ranges
          final clampedValue = animationValue.clamp(0.0, 1.0);
          final scaleValue = (animationValue * 0.8 + 0.2).clamp(0.2, 1.0);

          return Transform.scale(
            scale: scaleValue,
            child: Transform.translate(
              offset: Offset(0, (1 - clampedValue) * 50),
              child: Opacity(
                opacity: clampedValue,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        backgroundColor,
                        backgroundColor.withValues(alpha: 0.9),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: backgroundColor.withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                        spreadRadius: -8,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Animated Icon Container
                      TweenAnimationBuilder<double>(
                        duration: Duration(
                          milliseconds: 800 + (animationValue * 200).round(),
                        ),
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        curve: Curves.elasticOut,
                        builder: (context, iconAnimation, child) {
                          // Clamp icon animation values to prevent elasticOut overshoot
                          final clampedIconValue = iconAnimation.clamp(
                            0.0,
                            1.0,
                          );
                          final iconScaleValue = (iconAnimation * 0.8 + 0.2)
                              .clamp(0.2, 1.0);

                          return Transform.scale(
                            scale: iconScaleValue,
                            child: Transform.rotate(
                              angle: (1 - clampedIconValue) * 0.5,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withValues(alpha: 0.3),
                                      Colors.white.withValues(alpha: 0.1),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                                child: FaIcon(
                                  icon,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 16),
                      // Message Text
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message,
                              style: getBoldStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: FontConstant.cairo,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            // Subtle animated progress bar
                            TweenAnimationBuilder<double>(
                              duration: duration,
                              tween: Tween<double>(begin: 1.0, end: 0.0),
                              curve: Curves.linear,
                              builder: (context, progress, child) {
                                return Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(1),
                                    color: Colors.white.withValues(alpha: 0.2),
                                  ),
                                  child: FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: progress,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(1),
                                        color: Colors.white.withValues(
                                          alpha: 0.8,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Close Button
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => scaffoldMessenger.hideCurrentSnackBar(),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    scaffoldMessenger.showSnackBar(snackBar);
  }

  // Helper method to get appropriate message based on locale
  static String getLocalizedMessage({
    required BuildContext context,
    required String messageAr,
    required String messageEn,
  }) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'ar' ? messageAr : messageEn;
  }

  /// Get translated message from translation key or return the message as is
  static String _getTranslatedMessage(BuildContext context, String message) {
    try {
      // Check if message is a translation key by checking common error prefixes
      if (message.startsWith('error_')) {
        // Use reflection-like approach to get the translation
        // Since we can't use reflection in Flutter, we'll use a simple map approach
        final Map<String, String> errorTranslations = {
          'error_no_internet_connection': 'لا يوجد اتصال بالإنترنت',
          'error_connection_timeout': 'انتهت مهلة الاتصال',
          'error_receive_timeout': 'انتهت مهلة الاستقبال',
          'error_send_timeout': 'انتهت مهلة الإرسال',
          'error_server_error': 'خطأ في الخادم',
          'error_internal_server_error': 'خطأ داخلي في الخادم',
          'error_bad_gateway': 'بوابة سيئة',
          'error_service_unavailable': 'الخدمة غير متاحة',
          'error_gateway_timeout': 'انتهت مهلة البوابة',
          'error_bad_request': 'طلب غير صحيح',
          'error_unauthorized': 'غير مصرح للوصول',
          'error_forbidden': 'الوصول مرفوض',
          'error_not_found': 'غير موجود',
          'error_method_not_allowed': 'الطريقة غير مسموحة',
          'error_not_acceptable': 'غير مقبول',
          'error_request_timeout': 'انتهت مهلة الطلب',
          'error_conflict': 'تعارض',
          'error_gone': 'غير موجود',
          'error_length_required': 'الطول مطلوب',
          'error_precondition_failed': 'فشل الشرط المسبق',
          'error_payload_too_large': 'البيانات كبيرة جداً',
          'error_uri_too_long': 'الرابط طويل جداً',
          'error_unsupported_media_type': 'نوع الوسائط غير مدعوم',
          'error_range_not_satisfiable': 'النطاق غير قابل للتحقيق',
          'error_expectation_failed': 'فشل التوقع',
          'error_too_many_requests': 'طلبات كثيرة جداً',
          'error_unknown': 'خطأ غير معروف',
          'error_cancelled': 'تم الإلغاء',
          'error_other': 'خطأ آخر',
        };

        // Check if we're in Arabic locale
        final locale = Localizations.localeOf(context);
        if (locale.languageCode == 'ar') {
          return errorTranslations[message] ?? 'خطأ غير معروف';
        } else {
          // English translations
          final Map<String, String> englishErrorTranslations = {
            'error_no_internet_connection': 'No internet connection',
            'error_connection_timeout': 'Connection timeout',
            'error_receive_timeout': 'Receive timeout',
            'error_send_timeout': 'Send timeout',
            'error_server_error': 'Server error',
            'error_internal_server_error': 'Internal server error',
            'error_bad_gateway': 'Bad gateway',
            'error_service_unavailable': 'Service unavailable',
            'error_gateway_timeout': 'Gateway timeout',
            'error_bad_request': 'Bad request',
            'error_unauthorized': 'Unauthorized',
            'error_forbidden': 'Access denied',
            'error_not_found': 'Not found',
            'error_method_not_allowed': 'Method not allowed',
            'error_not_acceptable': 'Not acceptable',
            'error_request_timeout': 'Request timeout',
            'error_conflict': 'Conflict',
            'error_gone': 'Gone',
            'error_length_required': 'Length required',
            'error_precondition_failed': 'Precondition failed',
            'error_payload_too_large': 'Payload too large',
            'error_uri_too_long': 'URI too long',
            'error_unsupported_media_type': 'Unsupported media type',
            'error_range_not_satisfiable': 'Range not satisfiable',
            'error_expectation_failed': 'Expectation failed',
            'error_too_many_requests': 'Too many requests',
            'error_unknown': 'Unknown error',
            'error_cancelled': 'Cancelled',
            'error_other': 'Other error',
          };
          return englishErrorTranslations[message] ?? 'Unknown error';
        }
      }
    } catch (e) {
      // If there's any error in translation, return the original message
    }

    // If it's not a translation key, return the message as is
    return message;
  }
}
