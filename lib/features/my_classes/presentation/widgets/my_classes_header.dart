import 'package:flutter/material.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';

class MyClassesHeader extends StatelessWidget {
  const MyClassesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'فصولي',
              style: getBoldStyle(
                color: AppColors.white,
                fontSize: FontSize.size22,
                fontFamily: FontConstant.cairo,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'إدارة جميع الفصول من مكان واحد والوصول السريع لأدوات التدريس المختلفة.',
              style: getRegularStyle(
                color: AppColors.white.withValues(alpha: 0.9),
                fontSize: FontSize.size11,
                fontFamily: FontConstant.cairo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

