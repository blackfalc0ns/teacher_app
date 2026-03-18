import 'package:flutter/material.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';

class ProfileActionsCard extends StatelessWidget {
  const ProfileActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: const [
          Expanded(
            child: _ActionButton(
              icon: Icons.edit_outlined,
              label: 'تعديل البيانات',
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _ActionButton(
              icon: Icons.folder_shared_outlined,
              label: 'الوثائق',
              color: AppColors.secondary,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: _ActionButton(
              icon: Icons.verified_user_outlined,
              label: 'الأمان',
              color: AppColors.third,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('سيتم إضافة $label قريبًا.')),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size10,
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
