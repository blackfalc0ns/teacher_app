import 'package:flutter/material.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';

class ScheduleHeader extends StatelessWidget {
  final DateTime selectedDate;
  final int totalPeriods;
  final int classCount;

  const ScheduleHeader({
    super.key,
    required this.selectedDate,
    required this.totalPeriods,
    required this.classCount,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = _formatDate(selectedDate);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.18),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.calendar_month_rounded,
                    color: AppColors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الجدول الدراسي',
                        style: getBoldStyle(
                          color: AppColors.white,
                          fontSize: FontSize.size18,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        formattedDate,
                        style: getRegularStyle(
                          color: AppColors.white.withValues(alpha: 0.86),
                          fontSize: FontSize.size11,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    _HeaderMiniMetric(
                      title: 'حصص',
                      value: totalPeriods.toString(),
                      icon: Icons.access_time_rounded,
                    ),
                    const SizedBox(width: 8),
                    _HeaderMiniMetric(
                      title: 'فصول',
                      value: classCount.toString(),
                      icon: Icons.groups_rounded,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'فلترة سريعة بالمرحلة والصف والفصل مع متابعة التحضير والغياب.',
              style: getRegularStyle(
                color: AppColors.white.withValues(alpha: 0.85),
                fontSize: FontSize.size11,
                fontFamily: FontConstant.cairo,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const weekdays = <int, String>{
      DateTime.sunday: 'الأحد',
      DateTime.monday: 'الاثنين',
      DateTime.tuesday: 'الثلاثاء',
      DateTime.wednesday: 'الأربعاء',
      DateTime.thursday: 'الخميس',
      DateTime.friday: 'الجمعة',
      DateTime.saturday: 'السبت',
    };

    const months = <int, String>{
      1: 'يناير',
      2: 'فبراير',
      3: 'مارس',
      4: 'أبريل',
      5: 'مايو',
      6: 'يونيو',
      7: 'يوليو',
      8: 'أغسطس',
      9: 'سبتمبر',
      10: 'أكتوبر',
      11: 'نوفمبر',
      12: 'ديسمبر',
    };

    return '${weekdays[date.weekday]} ${date.day} ${months[date.month]}';
  }
}

class _HeaderMiniMetric extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _HeaderMiniMetric({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.white, size: 14),
              const SizedBox(width: 4),
              Text(
                value,
                style: getBoldStyle(
                  color: AppColors.white,
                  fontSize: FontSize.size16,
                  fontFamily: FontConstant.cairo,
                ),
              ),
            ],
          ),
          Text(
            title,
            style: getRegularStyle(
              color: AppColors.white.withValues(alpha: 0.8),
              fontSize: FontSize.size9,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ],
      ),
    );
  }
}
