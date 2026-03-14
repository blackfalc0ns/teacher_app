import 'package:flutter/material.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../features/schedule/data/model/schedule_model.dart';
import 'classroom_section_card.dart';

class ClassroomQuickActionsCard extends StatelessWidget {
  final ScheduleModel item;
  final VoidCallback onAttendanceTap;
  final VoidCallback onStudentsTap;
  final VoidCallback onAssignmentsTap;

  const ClassroomQuickActionsCard({
    super.key,
    required this.item,
    required this.onAttendanceTap,
    required this.onStudentsTap,
    required this.onAssignmentsTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClassroomSectionCard(
      title: 'إجراءات الفصل',
      child: Row(
        children: [
          Expanded(
            child: _ActionBox(
              title: item.needsAttendance ? 'أخذ الحضور' : 'مراجعة الحضور',
              subtitle: item.needsAttendance ? 'ابدأ الآن' : 'تم التسجيل',
              icon: Icons.fact_check_outlined,
              color: item.needsAttendance ? AppColors.third : AppColors.green,
              onTap: onAttendanceTap,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _ActionBox(
              title: 'طلاب الفصل',
              subtitle: '${item.studentsCount} طالب',
              icon: Icons.groups_rounded,
              color: AppColors.primary,
              onTap: onStudentsTap,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _ActionBox(
              title: item.hasHomework ? 'متابعة الواجب' : 'إنشاء واجب',
              subtitle: item.hasHomework ? 'نشط' : 'جديد',
              icon: Icons.assignment_outlined,
              color: AppColors.secondary,
              onTap: onAssignmentsTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBox extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionBox({
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
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: getBoldStyle(
                color: AppColors.primaryDark,
                fontSize: FontSize.size12,
                fontFamily: FontConstant.cairo,
              ),
            ),
            const SizedBox(height: 2),
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
