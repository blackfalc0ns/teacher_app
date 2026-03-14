import 'package:flutter/material.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../schedule/data/model/schedule_model.dart';

class ClassroomHeaderCard extends StatelessWidget {
  final ScheduleModel item;
  final int followUpCount;

  const ClassroomHeaderCard({
    super.key,
    required this.item,
    required this.followUpCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            item.className,
            style: getBoldStyle(
              color: AppColors.white,
              fontSize: FontSize.size22,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${item.subjectName} • ${item.startTime} - ${item.endTime}',
            style: getRegularStyle(
              color: AppColors.white.withValues(alpha: 0.9),
              fontSize: FontSize.size13,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _TopPill(label: item.cycleName),
              if (item.roomName != null) _TopPill(label: item.roomName!),
              _TopPill(label: '$followUpCount يحتاج متابعة'),
            ],
          ),
        ],
      ),
    );
  }
}

class _TopPill extends StatelessWidget {
  final String label;

  const _TopPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: getMediumStyle(
          color: AppColors.white,
          fontSize: FontSize.size10,
          fontFamily: FontConstant.cairo,
        ),
      ),
    );
  }
}
