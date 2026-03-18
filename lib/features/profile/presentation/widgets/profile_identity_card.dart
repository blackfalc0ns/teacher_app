import 'package:flutter/material.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../data/models/teacher_profile_model.dart';

class ProfileIdentityCard extends StatelessWidget {
  final TeacherProfileModel profile;

  const ProfileIdentityCard({
    super.key,
    required this.profile,
  });

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
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _IdentityTile(
                  icon: Icons.badge_outlined,
                  label: 'الرقم الوظيفي',
                  value: profile.employeeId,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _IdentityTile(
                  icon: Icons.workspace_premium_outlined,
                  label: 'الخبرة',
                  value: profile.experienceLabel,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _IdentityTile(
                  icon: Icons.account_tree_outlined,
                  label: 'المرحلة',
                  value: profile.cycleLabel,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _IdentityTile(
                  icon: Icons.schedule_rounded,
                  label: 'ساعات العمل',
                  value: profile.officeHours,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IdentityTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _IdentityTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryDark, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size9,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size11,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
