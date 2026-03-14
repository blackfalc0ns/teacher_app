import 'package:flutter/material.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';

class ClassroomSectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const ClassroomSectionCard({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
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
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
