import 'package:flutter/material.dart';
import 'package:teacher_app/core/utils/constant/font_manger.dart';
import 'package:teacher_app/core/utils/constant/styles_manger.dart';
import 'package:teacher_app/core/utils/theme/app_colors.dart';

class XpOverviewCards extends StatelessWidget {
  final int trackedStudentsCount;
  final int totalSeasonXp;
  final int autoGrantedXp;
  final int pendingBoostCandidates;

  const XpOverviewCards({
    super.key,
    required this.trackedStudentsCount,
    required this.totalSeasonXp,
    required this.autoGrantedXp,
    required this.pendingBoostCandidates,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 128,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _OverviewCard(
            title: 'طلاب متابعون',
            value: trackedStudentsCount.toString(),
            subtitle: 'ضمن الفصول المسندة',
            color: AppColors.primary,
            icon: Icons.groups_2_rounded,
          ),
          _OverviewCard(
            title: 'إجمالي XP',
            value: totalSeasonXp.toString(),
            subtitle: 'على مستوى الموسم',
            color: AppColors.third,
            icon: Icons.bolt_rounded,
          ),
          _OverviewCard(
            title: 'XP تلقائي',
            value: autoGrantedXp.toString(),
            subtitle: 'من الواجبات والدروس',
            color: AppColors.green,
            icon: Icons.auto_awesome_rounded,
          ),
          _OverviewCard(
            title: 'يحتاج دفعة',
            value: pendingBoostCandidates.toString(),
            subtitle: 'مرشحون لتحفيز إضافي',
            color: AppColors.info,
            icon: Icons.trending_up_rounded,
          ),
        ],
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final IconData icon;

  const _OverviewCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 168,
      margin: const EdgeInsetsDirectional.only(end: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withValues(alpha: 0.14)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const Spacer(),
          Text(
            value,
            style: getBoldStyle(
              color: AppColors.primaryDark,
              fontSize: FontSize.size20,
              fontFamily: FontConstant.cairo,
            ),
          ),
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
              color: AppColors.grey.withValues(alpha: 0.72),
              fontSize: FontSize.size10,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ],
      ),
    );
  }
}
