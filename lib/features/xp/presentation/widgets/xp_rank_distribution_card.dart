import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:teacher_app/core/utils/constant/font_manger.dart';
import 'package:teacher_app/core/utils/constant/styles_manger.dart';
import 'package:teacher_app/core/utils/theme/app_colors.dart';
import 'package:teacher_app/features/xp/data/models/xp_center_model.dart';

class XpRankDistributionCard extends StatelessWidget {
  final List<XpDistributionItemModel> distribution;
  final List<XpSourceBreakdownModel> sources;

  const XpRankDistributionCard({
    super.key,
    required this.distribution,
    required this.sources,
  });

  @override
  Widget build(BuildContext context) {
    final activeDistribution = distribution
        .where((item) => item.studentsCount > 0)
        .toList();
    final totalStudents = activeDistribution.fold<int>(
      0,
      (sum, item) => sum + item.studentsCount,
    );
    final maxSourceValue = sources.fold<int>(
      0,
      (max, item) => item.xpValue > max ? item.xpValue : max,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _ChartCard(
            title: 'توزيع الرتب',
            subtitle: 'حسب الطلاب المعروضين حاليًا',
            footer: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: activeDistribution
                  .take(6)
                  .map((item) {
                    return _LegendChip(
                      color: item.rankTier.accentColor,
                      label: item.rankTier.label,
                    );
                  })
                  .toList(growable: false),
            ),
            child: SizedBox(
              height: 190,
              width: double.infinity,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                  sections: activeDistribution
                      .map((item) {
                        final ratio = totalStudents == 0
                            ? 0.0
                            : (item.studentsCount / totalStudents) * 100;
                        return PieChartSectionData(
                          value: item.studentsCount.toDouble(),
                          title: '${ratio.round()}%',
                          radius: 54,
                          color: item.rankTier.accentColor,
                          titleStyle: getBoldStyle(
                            color: AppColors.white,
                            fontSize: FontSize.size10,
                            fontFamily: FontConstant.cairo,
                          ),
                        );
                      })
                      .toList(growable: false),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          _ChartCard(
            title: 'مصادر XP',
            subtitle: 'من أين يأتي التقدم أساسًا',
            footer: Text(
              'الأولوية التحفيزية تكون بعد الأداء التلقائي، لا بديلًا عنه.',
              style: getRegularStyle(
                color: AppColors.grey.withValues(alpha: 0.72),
                fontSize: FontSize.size10,
                fontFamily: FontConstant.cairo,
              ),
            ),
            child: SizedBox(
              height: 190,
              width: double.infinity,
              child: BarChart(
                BarChartData(
                  maxY: maxSourceValue == 0 ? 100 : maxSourceValue * 1.2,
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= sources.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              sources[index].source.label,
                              style: getSemiBoldStyle(
                                color: AppColors.grey.withValues(alpha: 0.7),
                                fontSize: FontSize.size9,
                                fontFamily: FontConstant.cairo,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: sources
                      .asMap()
                      .entries
                      .map((entry) {
                        return BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value.xpValue.toDouble(),
                              width: 28,
                              borderRadius: BorderRadius.circular(8),
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.secondary.withValues(alpha: 0.8),
                                  AppColors.primary,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ],
                        );
                      })
                      .toList(growable: false),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final Widget footer;

  const _ChartCard({
    required this.title,
    required this.subtitle,
    required this.child,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            title,
            style: getBoldStyle(
              color: AppColors.primaryDark,
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: getRegularStyle(
              color: AppColors.grey.withValues(alpha: 0.72),
              fontSize: FontSize.size10,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 8),
          child,
          const SizedBox(height: 8),
          footer,
        ],
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendChip({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
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
