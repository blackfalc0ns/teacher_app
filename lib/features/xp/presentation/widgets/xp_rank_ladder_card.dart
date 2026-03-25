import 'package:flutter/material.dart';
import 'package:teacher_app/core/utils/constant/font_manger.dart';
import 'package:teacher_app/core/utils/constant/styles_manger.dart';
import 'package:teacher_app/core/utils/theme/app_colors.dart';
import 'package:teacher_app/features/xp/data/models/xp_center_model.dart';

class XpRankLadderCard extends StatelessWidget {
  final List<XpDistributionItemModel> distribution;

  const XpRankLadderCard({
    super.key,
    required this.distribution,
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
            'سلم الرتب',
            style: getBoldStyle(
              color: AppColors.primaryDark,
              fontSize: FontSize.size15,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'من البرونزي حتى الماستر مع توزيع الطلاب الحالي.',
            style: getRegularStyle(
              color: AppColors.grey.withValues(alpha: 0.72),
              fontSize: FontSize.size11,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 118,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: distribution.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final item = distribution[index];
                return Container(
                  width: 94,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: item.rankTier.accentColor.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: item.rankTier.accentColor.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.asset(
                          item.rankTier.assetPath,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.rankTier.label,
                        textAlign: TextAlign.center,
                        style: getBoldStyle(
                          color: AppColors.primaryDark,
                          fontSize: FontSize.size10,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${item.studentsCount} طالب',
                        style: getRegularStyle(
                          color: AppColors.grey.withValues(alpha: 0.74),
                          fontSize: FontSize.size10,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
