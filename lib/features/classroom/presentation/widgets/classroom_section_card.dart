import 'package:flutter/material.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';

class ClassroomSectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final String? subtitle;
  final Widget? headerTrailing;
  final EdgeInsetsGeometry? padding;

  const ClassroomSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.headerTrailing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGrey),
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: getBoldStyle(
                        color: AppColors.primaryDark,
                        fontSize: FontSize.size15,
                        fontFamily: FontConstant.cairo,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        subtitle!,
                        style: getRegularStyle(
                          color: AppColors.grey,
                          fontSize: FontSize.size10,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (headerTrailing != null) ...[
                const SizedBox(width: 10),
                headerTrailing!,
              ],
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
