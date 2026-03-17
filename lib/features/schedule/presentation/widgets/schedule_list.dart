import 'package:flutter/material.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../data/model/schedule_model.dart';
import 'schedule_item_card.dart';

class ScheduleList extends StatelessWidget {
  final List<ScheduleModel> schedule;
  final bool hasActiveFilters;
  final VoidCallback onClearFilters;

  const ScheduleList({
    super.key,
    required this.schedule,
    required this.hasActiveFilters,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    if (schedule.isEmpty) {
      return _EmptyScheduleState(
        hasActiveFilters: hasActiveFilters,
        onClearFilters: onClearFilters,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'تسلسل الحصص',
              style: getBoldStyle(
                color: AppColors.primaryDark,
                fontSize: FontSize.size18,
                fontFamily: FontConstant.cairo,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${schedule.length} حصة',
                style: getMediumStyle(
                  color: AppColors.primary,
                  fontSize: FontSize.size12,
                  fontFamily: FontConstant.cairo,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          children: List.generate(schedule.length, (index) {
            return ScheduleItemCard(
              item: schedule[index],
              showTopLine: index != 0,
              showBottomLine: index != schedule.length - 1,
            );
          }
          
          ),
          
        ),
        const SizedBox(height: 120),
      ],
    );
  }
}

class _EmptyScheduleState extends StatelessWidget {
  final bool hasActiveFilters;
  final VoidCallback onClearFilters;

  const _EmptyScheduleState({
    required this.hasActiveFilters,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.lightGrey.withValues(alpha: 0.45),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.event_busy_outlined,
              color: AppColors.primaryDark,
              size: 26,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            hasActiveFilters ? 'لا توجد حصص مطابقة' : 'لا توجد حصص مجدولة',
            style: getBoldStyle(
              color: AppColors.primaryDark,
              fontSize: FontSize.size16,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasActiveFilters
                ? 'جرّب توسيع الفلاتر أو اختيار مرحلة وشعبة مختلفة.'
                : 'يمكنك تغيير اليوم أو مراجعة بقية الأسبوع لعرض الحصص المرتبطة بك.',
            textAlign: TextAlign.center,
            style: getRegularStyle(
              color: AppColors.grey.withValues(alpha: 0.8),
              fontSize: FontSize.size13,
              fontFamily: FontConstant.cairo,
            ),
          ),
          if (hasActiveFilters) ...[
            const SizedBox(height: 14),
            TextButton(
              onPressed: onClearFilters,
              child: Text(
                'إعادة ضبط الفلاتر',
                style: getBoldStyle(
                  color: AppColors.primary,
                  fontSize: FontSize.size13,
                  fontFamily: FontConstant.cairo,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
