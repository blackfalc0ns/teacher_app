import 'package:flutter/material.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../data/models/teacher_profile_model.dart';

class ProfileWorkloadCard extends StatelessWidget {
  final TeacherProfileModel profile;

  const ProfileWorkloadCard({
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
                child: _WorkloadMetric(
                  title: 'عدد الطلاب',
                  value: '${profile.studentsCount}',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _WorkloadMetric(
                  title: 'الحصص الأسبوعية',
                  value: '${profile.weeklyPeriodsCount}',
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _WorkloadMetric(
                  title: 'واجبات نشطة',
                  value: '${profile.activeAssignmentsCount}',
                  color: AppColors.third,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _WorkloadMetric(
                  title: 'تمت مراجعتها',
                  value: '${profile.reviewedItemsCount}',
                  color: AppColors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WorkloadMetric extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _WorkloadMetric({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size18,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            textAlign: TextAlign.center,
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size10,
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}
