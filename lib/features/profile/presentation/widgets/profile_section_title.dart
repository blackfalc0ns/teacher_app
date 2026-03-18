import 'package:flutter/material.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';

class ProfileSectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const ProfileSectionTitle({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size14,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: getRegularStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size10,
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }
}
