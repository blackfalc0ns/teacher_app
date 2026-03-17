import 'package:flutter/material.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';

class MyClassesHeader extends StatelessWidget {
  final int classesCount;
  final int studentsCount;
  final int attentionCount;
  final int todayCount;

  const MyClassesHeader({
    super.key,
    required this.classesCount,
    required this.studentsCount,
    required this.attentionCount,
    required this.todayCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'فصولي',
              style: getBoldStyle(
                color: AppColors.white,
                fontSize: FontSize.size22,
                fontFamily: FontConstant.cairo,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'إدارة جميع الفصول من مكان واحد والوصول السريع لأدوات التدريس المختلفة.',
              style: getRegularStyle(
                color: AppColors.white.withValues(alpha: 0.9),
                fontSize: FontSize.size11,
                fontFamily: FontConstant.cairo,
              ),
            ),
            const SizedBox(height: 8),
            
            // Statistics Row
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    title: 'الفصول',
                    value: '$classesCount',
                    icon: Icons.meeting_room_outlined,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatTile(
                    title: 'الطلاب',
                    value: '$studentsCount',
                    icon: Icons.groups_rounded,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatTile(
                    title: 'اليوم',
                    value: '$todayCount',
                    icon: Icons.today_outlined,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatTile(
                    title: 'متابعة',
                    value: '$attentionCount',
                    icon: Icons.priority_high_rounded,
                    color: attentionCount > 0 ? AppColors.third : AppColors.white,
                    isHighlight: attentionCount > 0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isHighlight;

  const _StatTile({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: isHighlight 
            ? AppColors.white.withValues(alpha: 0.15)
            : AppColors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: isHighlight 
            ? Border.all(color: AppColors.white.withValues(alpha: 0.3))
            : null,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 18,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: getBoldStyle(
              color: AppColors.white,
              fontSize: FontSize.size16,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: getMediumStyle(
              color: AppColors.white.withValues(alpha: 0.9),
              fontSize: FontSize.size10,
              fontFamily: FontConstant.cairo,
            ),
          ),
                    const SizedBox(height: 2),

        ],
      ),
    );
  }
}

