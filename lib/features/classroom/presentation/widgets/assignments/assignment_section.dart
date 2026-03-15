import 'package:flutter/material.dart';

import '../../../../../core/utils/constant/font_manger.dart';
import '../../../../../core/utils/constant/styles_manger.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../../data/models/classroom_model.dart';

class ClassroomAssignmentsSection extends StatelessWidget {
  final List<ClassroomAssignment> assignments;
  final VoidCallback onCreateAssignment;
  final VoidCallback onTrackAssignments;

  const ClassroomAssignmentsSection({
    super.key,
    required this.assignments,
    required this.onCreateAssignment,
    required this.onTrackAssignments,
  });

  @override
  Widget build(BuildContext context) {
    final submittedCount = assignments.fold<int>(0, (sum, assignment) => sum + assignment.submittedCount);
    final reviewedCount = assignments.fold<int>(0, (sum, assignment) => sum + assignment.reviewedCount);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'بوابة الواجبات',
                style: getBoldStyle(
                  color: AppColors.primaryDark,
                  fontSize: FontSize.size15,
                  fontFamily: FontConstant.cairo,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'افصل بين إنشاء الواجب ومتابعة أداء الطلاب حتى يبقى workflow أوضح وأسهل.',
                style: getRegularStyle(
                  color: AppColors.grey,
                  fontSize: FontSize.size10,
                  fontFamily: FontConstant.cairo,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ActionCard(
                      title: 'إنشاء واجب',
                      subtitle: 'بناء الأسئلة وتحديد الإجابات الصحيحة',
                      icon: Icons.add_task_rounded,
                      color: AppColors.primary,
                      onTap: onCreateAssignment,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ActionCard(
                      title: 'متابعة الواجب',
                      subtitle: 'التسليمات، الدرجات، وتفاصيل الحل',
                      icon: Icons.assignment_turned_in_outlined,
                      color: AppColors.secondary,
                      onTap: onTrackAssignments,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Expanded(child: _MetricBox(label: 'الواجبات', value: '${assignments.length}', color: AppColors.primary)),
              const SizedBox(width: 8),
              Expanded(child: _MetricBox(label: 'التسليمات', value: '$submittedCount', color: AppColors.green)),
              const SizedBox(width: 8),
              Expanded(child: _MetricBox(label: 'تم التصحيح', value: '$reviewedCount', color: AppColors.third)),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 10),
            Text(
              title,
              style: getBoldStyle(
                color: AppColors.primaryDark,
                fontSize: FontSize.size12,
                fontFamily: FontConstant.cairo,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: getRegularStyle(
                color: AppColors.grey,
                fontSize: FontSize.size10,
                fontFamily: FontConstant.cairo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricBox({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: getBoldStyle(
              color: color,
              fontSize: FontSize.size16,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: getMediumStyle(
              color: AppColors.primaryDark,
              fontSize: FontSize.size10,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ],
      ),
    );
  }
}
