import 'package:flutter/material.dart';

import '../../../../../core/utils/constant/font_manger.dart';
import '../../../../../core/utils/constant/styles_manger.dart';
import '../../../../../core/utils/theme/app_colors.dart';

class ContactChannelCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;

  const ContactChannelCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.lightGrey.withValues(alpha: 0.45),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppColors.primaryDark, size: 21),
        ),
        title: Text(
          title,
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size11,
            color: AppColors.primaryDark,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: getRegularStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size9,
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: getMediumStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size10,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        trailing: onTap == null
            ? null
            : const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.grey,
              ),
        onTap: onTap,
      ),
    );
  }
}
