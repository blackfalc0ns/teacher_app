import 'package:teacher_app/core/utils/common/custom_dialog_button.dart';
import 'package:flutter/material.dart';
import '../constant/styles_manger.dart';
import '../constant/font_manger.dart';
import '../theme/app_colors.dart';
import '../common/custom_button.dart';

class LoginRequiredDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onLoginPressed;

  const LoginRequiredDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onLoginPressed,
  });

  static Future<void> show({
    required BuildContext context,
    String? title,
    String? message,
    required VoidCallback onLoginPressed,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return LoginRequiredDialog(
          title: title ?? 'تسجيل الدخول مطلوب',
          message: message ?? 'يجب تسجيل الدخول أولاً للمتابعة مع هذا الإجراء',
          onLoginPressed: onLoginPressed,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 340),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.grey[50]!],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with icon
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.login_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size18,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Body
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Icon illustration
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_outline_rounded,
                      color: AppColors.primary,
                      size: 40,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Message
                  Text(
                    message,
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size15,
                      color: Colors.grey[700]!,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    children: [
                      // Cancel button
                      Expanded(
                        child: SizedBox(
                          child: CustomDialogButton(
                            onPressed: () => Navigator.of(context).pop(),
                            text: "الغاء",
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Login button
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 48,
                          child: CustomButton(
                            text: 'تسجيل الدخول',
                            onPressed: () {
                              Navigator.of(context).pop();
                              onLoginPressed();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
