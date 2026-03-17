import 'package:flutter/material.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';

class MyClassesSummaryCard extends StatelessWidget {
  final int classesCount;
  final int studentsCount;
  final int attentionCount;
  final int todayCount;

  const MyClassesSummaryCard({
    super.key,
    required this.classesCount,
    required this.studentsCount,
    required this.attentionCount,
    required this.todayCount,
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
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _MetricTile(title: 'الفصول', value: '$classesCount', color: AppColors.primary, icon: Icons.meeting_room_outlined)),
          const SizedBox(width: 8),
          Expanded(child: _MetricTile(title: 'الطلاب', value: '$studentsCount', color: AppColors.secondary, icon: Icons.groups_rounded)),
          const SizedBox(width: 8),
          Expanded(child: _MetricTile(title: 'اليوم', value: '$todayCount', color: AppColors.green, icon: Icons.today_outlined)),
          const SizedBox(width: 8),
          Expanded(child: _MetricTile(title: 'متابعة', value: '$attentionCount', color: AppColors.third, icon: Icons.priority_high_rounded)),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _MetricTile({required this.title, required this.value, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: getBoldStyle(
              color: color,
              fontSize: FontSize.size16,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
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
