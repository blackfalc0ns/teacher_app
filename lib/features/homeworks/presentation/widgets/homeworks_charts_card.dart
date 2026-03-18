import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../classroom/data/models/classroom_model.dart';
import '../../data/models/homework_dashboard_model.dart';

class HomeworksChartsCard extends StatelessWidget {
  final HomeworkDashboardData dashboard;

  const HomeworksChartsCard({
    super.key,
    required this.dashboard,
  });

  @override
  Widget build(BuildContext context) {
    final allAssignments = dashboard.allAssignments;
    final reviewed = dashboard.reviewedSubmissionsCount.toDouble();
    final waiting = dashboard.pendingReviewCount.toDouble();
    final missing = dashboard.missingSubmissionCount.toDouble();
    final draft = dashboard.draftsCount.toDouble();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'مؤشرات الأداء',
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size15,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'صورة سريعة للتسليمات والتصحيح ومتوسط درجات الواجبات.',
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size11,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 170,
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      centerSpaceRadius: 28,
                      sectionsSpace: 2,
                      sections: [
                        _pieSection(reviewed, AppColors.green, 'مصحح'),
                        _pieSection(waiting, AppColors.third, 'بانتظار'),
                        _pieSection(missing, AppColors.error, 'لم يسلّم'),
                        _pieSection(draft, AppColors.info, 'مسودات'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      _ChartLegend(color: AppColors.green, label: 'مصحح'),
                      SizedBox(height: 8),
                      _ChartLegend(color: AppColors.third, label: 'بانتظار التصحيح'),
                      SizedBox(height: 8),
                      _ChartLegend(color: AppColors.error, label: 'لم يسلّم'),
                      SizedBox(height: 8),
                      _ChartLegend(color: AppColors.info, label: 'مسودات'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 190,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _maxPendingY(dashboard).toDouble(),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      reservedSize: 28,
                      showTitles: true,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: getRegularStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size9,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= dashboard.classes.length) {
                          return const SizedBox.shrink();
                        }
                        final item = dashboard.classes[index];
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            item.sectionName,
                            style: getMediumStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: FontSize.size9,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: dashboard.classes.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.pendingReviewCount.toDouble(),
                        color: AppColors.secondary,
                        width: 14,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      BarChartRodData(
                        toY: entry.value.missingSubmissionCount.toDouble(),
                        color: AppColors.third,
                        width: 14,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ],
                  );
                }).toList(growable: false),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ...allAssignments.take(3).map((assignment) {
            final average = _averageScoreLabel(assignment);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _AverageScoreTile(
                title: assignment.title,
                subtitle: assignment.targetLabel,
                averageLabel: average,
              ),
            );
          }),
        ],
      ),
    );
  }

  PieChartSectionData _pieSection(double value, Color color, String label) {
    return PieChartSectionData(
      value: value <= 0 ? 0.2 : value,
      color: color,
      radius: 24,
      title: value <= 0 ? '' : label,
      titleStyle: getBoldStyle(
        fontFamily: FontConstant.cairo,
        fontSize: FontSize.size8,
        color: Colors.white,
      ),
    );
  }

  int _maxPendingY(HomeworkDashboardData dashboard) {
    final values = dashboard.classes
        .expand((item) => [item.pendingReviewCount, item.missingSubmissionCount])
        .toList(growable: false);
    if (values.isEmpty) {
      return 4;
    }
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    return maxValue < 4 ? 4 : maxValue + 2;
  }

  String _averageScoreLabel(ClassroomAssignment assignment) {
    final graded = assignment.submissions.where((submission) {
      return submission.status == AssignmentSubmissionStatus.reviewed ||
          submission.status == AssignmentSubmissionStatus.submitted ||
          submission.status == AssignmentSubmissionStatus.late;
    }).toList(growable: false);
    if (graded.isEmpty) {
      return 'لا توجد درجات بعد';
    }
    final average = graded.fold<double>(0, (sum, item) {
          if (item.maxScore == 0) {
            return sum;
          }
          return sum + ((item.score / item.maxScore) * 100);
        }) /
        graded.length;
    return '${average.toStringAsFixed(0)}% متوسط الأداء';
  }
}

class _ChartLegend extends StatelessWidget {
  final Color color;
  final String label;

  const _ChartLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size10,
              color: AppColors.primaryDark,
            ),
          ),
        ),
      ],
    );
  }
}

class _AverageScoreTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String averageLabel;

  const _AverageScoreTile({
    required this.title,
    required this.subtitle,
    required this.averageLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size11,
                    color: AppColors.primaryDark,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size9,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            averageLabel,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size10,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
