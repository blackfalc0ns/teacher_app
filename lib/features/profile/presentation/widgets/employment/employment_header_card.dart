import 'package:flutter/material.dart';

import '../../../../../core/utils/constant/font_manger.dart';
import '../../../../../core/utils/constant/styles_manger.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../../data/models/teacher_employment_model.dart';

class EmploymentHeaderCard extends StatelessWidget {
  final TeacherEmploymentModel employment;

  const EmploymentHeaderCard({
    super.key,
    required this.employment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            employment.jobTitle,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size18,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${employment.schoolName} • ${employment.department}',
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size11,
              color: AppColors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _EmploymentChip(label: employment.workStatus),
              _EmploymentChip(label: employment.employmentType),
              _EmploymentChip(label: employment.specialization),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _HeaderMetric(
                  title: 'الفصول',
                  value: '${employment.assignedClasses.length}',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _HeaderMetric(
                  title: 'الطلاب',
                  value: '${employment.studentsCount}',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _HeaderMetric(
                  title: 'الحصص',
                  value: '${employment.weeklyPeriodsCount}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmploymentChip extends StatelessWidget {
  final String label;

  const _EmploymentChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: getMediumStyle(
          fontFamily: FontConstant.cairo,
          fontSize: FontSize.size10,
          color: AppColors.white,
        ),
      ),
    );
  }
}

class _HeaderMetric extends StatelessWidget {
  final String title;
  final String value;

  const _HeaderMetric({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size16,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size9,
              color: AppColors.white.withValues(alpha: 0.88),
            ),
          ),
        ],
      ),
    );
  }
}
