import 'package:flutter/material.dart';
import 'package:teacher_app/core/utils/constant/font_manger.dart';
import 'package:teacher_app/core/utils/constant/styles_manger.dart';
import 'package:teacher_app/core/utils/theme/app_colors.dart';
import 'package:teacher_app/features/xp/data/models/xp_center_model.dart';

class XpBonusPolicyCard extends StatelessWidget {
  final BonusXpPolicyModel policy;

  const XpBonusPolicyCard({
    super.key,
    required this.policy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.third.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.workspace_premium_outlined,
                  color: AppColors.third,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'سياسة Bonus XP للمعلم',
                  style: getBoldStyle(
                    color: AppColors.primaryDark,
                    fontSize: FontSize.size14,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _PolicyItem(
                  label: 'لكل طالب أسبوعيًا',
                  value: '${policy.weeklyLimitPerStudent} XP',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PolicyItem(
                  label: 'لكل فصل أسبوعيًا',
                  value: '${policy.weeklyLimitPerClass} XP',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PolicyItem(
                  label: 'المتاح الآن',
                  value: '${policy.teacherAvailableBudget} XP',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: policy.allowedReasons.map((reason) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  reason,
                  style: getMediumStyle(
                    color: AppColors.primaryDark,
                    fontSize: FontSize.size10,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
              );
            }).toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class _PolicyItem extends StatelessWidget {
  final String label;
  final String value;

  const _PolicyItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: getBoldStyle(
              color: AppColors.primaryDark,
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: getRegularStyle(
              color: AppColors.grey.withValues(alpha: 0.72),
              fontSize: FontSize.size10,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ],
      ),
    );
  }
}
