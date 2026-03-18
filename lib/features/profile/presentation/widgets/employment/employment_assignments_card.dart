import 'package:flutter/material.dart';

import '../../../../../core/utils/constant/font_manger.dart';
import '../../../../../core/utils/constant/styles_manger.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../../data/models/teacher_employment_model.dart';

class EmploymentAssignmentsCard extends StatelessWidget {
  final TeacherEmploymentModel employment;

  const EmploymentAssignmentsCard({
    super.key,
    required this.employment,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'المواد المسندة',
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size12,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: employment.subjects.map((item) {
              return _Tag(label: item, color: AppColors.primary);
            }).toList(growable: false),
          ),
          const SizedBox(height: 14),
          Text(
            'الفصول والشعب',
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size12,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: employment.assignedClasses.map((item) {
              return _Tag(label: item, color: AppColors.secondary);
            }).toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;

  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: getBoldStyle(
          fontFamily: FontConstant.cairo,
          fontSize: FontSize.size10,
          color: color,
        ),
      ),
    );
  }
}
