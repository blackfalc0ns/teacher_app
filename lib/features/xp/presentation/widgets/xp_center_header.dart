import 'package:flutter/material.dart';
import 'package:teacher_app/core/utils/constant/font_manger.dart';
import 'package:teacher_app/core/utils/constant/styles_manger.dart';
import 'package:teacher_app/core/utils/theme/app_colors.dart';

class XpCenterHeader extends StatelessWidget {
  final String seasonLabel;
  final int availableBonusXp;

  const XpCenterHeader({
    super.key,
    required this.seasonLabel,
    required this.availableBonusXp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0FA8B8),
            AppColors.primary,
            AppColors.primaryDeep,
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            bottom: false,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مركز XP',
                        style: getBoldStyle(
                          color: AppColors.white,
                          fontSize: FontSize.size22,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        seasonLabel,
                        style: getRegularStyle(
                          color: AppColors.white.withValues(alpha: 0.86),
                          fontSize: FontSize.size12,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.insights_rounded,
                        color: AppColors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'إحصائيات التقدم',
                        style: getBoldStyle(
                          color: AppColors.white,
                          fontSize: FontSize.size11,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'لوحة موحدة لمتابعة تقدم الطلاب وتفاعلهم، يتم احتساب الـ XP تلقائياً بناءً على إنجازات الطالب الأكاديمية ونشاطه.',
            style: getRegularStyle(
              color: AppColors.white.withValues(alpha: 0.94),
              fontSize: FontSize.size13,
              fontFamily: FontConstant.cairo,
            ).copyWith(height: 1.4),
          ),
        ],
      ),
    );
  }
}
