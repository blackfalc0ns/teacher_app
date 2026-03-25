import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teacher_app/core/utils/constant/font_manger.dart';
import 'package:teacher_app/core/utils/constant/styles_manger.dart';
import 'package:teacher_app/core/utils/theme/app_colors.dart';
import 'package:teacher_app/features/xp/data/models/xp_center_model.dart';

class XpRecentAwardsCard extends StatelessWidget {
  final List<BonusXpRecordModel> records;

  const XpRecentAwardsCard({
    super.key,
    required this.records,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'آخر منح Bonus XP',
            style: getBoldStyle(
              color: AppColors.primaryDark,
              fontSize: FontSize.size15,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'سجل مختصر للمنح التحفيزية الأخيرة من المعلم.',
            style: getRegularStyle(
              color: AppColors.grey.withValues(alpha: 0.72),
              fontSize: FontSize.size11,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 10),
          ...records.map((record) => _AwardRow(record: record)),
        ],
      ),
    );
  }
}

class _AwardRow extends StatelessWidget {
  final BonusXpRecordModel record;

  const _AwardRow({
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('d MMM - h:mm a', 'ar').format(record.grantedAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.third.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: AppColors.third,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.studentName,
                  style: getBoldStyle(
                    color: AppColors.primaryDark,
                    fontSize: FontSize.size12,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${record.classLabel} • ${record.reason}',
                  style: getRegularStyle(
                    color: AppColors.grey.withValues(alpha: 0.74),
                    fontSize: FontSize.size10,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+${record.xpValue} XP',
                style: getBoldStyle(
                  color: AppColors.third,
                  fontSize: FontSize.size12,
                  fontFamily: FontConstant.cairo,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                dateLabel,
                style: getRegularStyle(
                  color: AppColors.grey.withValues(alpha: 0.7),
                  fontSize: FontSize.size9,
                  fontFamily: FontConstant.cairo,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
