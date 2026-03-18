import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/constant/font_manger.dart';
import '../../../../../core/utils/constant/styles_manger.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../../data/models/classroom_model.dart';

class AssignmentAnalyticsCard extends StatelessWidget {
  final List<ClassroomAssignment> assignments;
  final ClassroomAssignment assignment;

  const AssignmentAnalyticsCard({
    super.key,
    required this.assignments,
    required this.assignment,
  });

  @override
  Widget build(BuildContext context) {
    final submissions = assignment.submissions;
    final notSubmitted = assignment.totalCount - assignment.submittedCount;
    final submitted = submissions.where((item) => item.status == AssignmentSubmissionStatus.submitted).length;
    final reviewed = submissions.where((item) => item.status == AssignmentSubmissionStatus.reviewed).length;
    final late = submissions.where((item) => item.status == AssignmentSubmissionStatus.late).length;
    final scoreValues = submissions.where((item) => item.maxScore > 0).map((item) => (item.score / item.maxScore) * 100).toList(growable: false);
    final averageScore = scoreValues.isEmpty ? 0.0 : scoreValues.reduce((a, b) => a + b) / scoreValues.length;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'تحليلات الأداء',
                style: getBoldStyle(
                  color: AppColors.primaryDark,
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'رؤية سريعة للتسليم، التصحيح، ومتوسط الدرجات.',
                style: getRegularStyle(
                  color: AppColors.grey,
                  fontSize: FontSize.size10,
                  fontFamily: FontConstant.cairo,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _MetricBox(label: 'المتوسط', value: '${averageScore.toStringAsFixed(0)}%', color: AppColors.primary)),
                  const SizedBox(width: 8),
                  Expanded(child: _MetricBox(label: 'المراجعة', value: '$reviewed', color: AppColors.green)),
                  const SizedBox(width: 8),
                  Expanded(child: _MetricBox(label: 'غير مسلّم', value: '$notSubmitted', color: AppColors.errorRed)),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 190,
                      child: PieChart(
                        PieChartData(
                          centerSpaceRadius: 36,
                          sectionsSpace: 2,
                          sections: [
                            _pieSection(reviewed.toDouble(), AppColors.green, 'تم التصحيح'),
                            _pieSection(submitted.toDouble(), AppColors.third, 'بانتظار'),
                            _pieSection(late.toDouble(), AppColors.secondary, 'متأخر'),
                            _pieSection(notSubmitted.toDouble(), AppColors.errorRed, 'لم يسلّم'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      children: [
                        _LegendRow(label: 'تم التصحيح', color: AppColors.green, value: '$reviewed'),
                        const SizedBox(height: 8),
                        _LegendRow(label: 'بانتظار التصحيح', color: AppColors.third, value: '$submitted'),
                        const SizedBox(height: 8),
                        _LegendRow(label: 'متأخر', color: AppColors.secondary, value: '$late'),
                        const SizedBox(height: 8),
                        _LegendRow(label: 'لم يسلّم', color: AppColors.errorRed, value: '$notSubmitted'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'توزيع الدرجات',
                style: getBoldStyle(
                  color: AppColors.primaryDark,
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 180,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: submissions.isEmpty ? 5 : submissions.length.toDouble() + 1,
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (value, meta) => Text(
                            value.toInt().toString(),
                            style: getRegularStyle(color: AppColors.grey, fontSize: FontSize.size9, fontFamily: FontConstant.cairo),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const labels = ['0-49', '50-69', '70-84', '85+'];
                            final index = value.toInt();
                            if (index < 0 || index >= labels.length) return const SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                labels[index],
                                style: getRegularStyle(color: AppColors.grey, fontSize: FontSize.size9, fontFamily: FontConstant.cairo),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    barGroups: _scoreDistribution(submissions),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'متوسط كل واجب',
                style: getBoldStyle(
                  color: AppColors.primaryDark,
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 180,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    minY: 0,
                    maxY: 100,
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          interval: 25,
                          getTitlesWidget: (value, meta) => Text(
                            '${value.toInt()}%',
                            style: getRegularStyle(color: AppColors.grey, fontSize: FontSize.size9, fontFamily: FontConstant.cairo),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 || index >= assignments.length) return const SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                '${index + 1}',
                                style: getRegularStyle(color: AppColors.grey, fontSize: FontSize.size9, fontFamily: FontConstant.cairo),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        color: AppColors.secondary,
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(show: true, color: AppColors.primary.withValues(alpha: 0.12)),
                        spots: _assignmentAverageSpots(assignments),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  PieChartSectionData _pieSection(double value, Color color, String title) {
    return PieChartSectionData(
      value: value == 0 ? 0.1 : value,
      color: color,
      title: value == 0 ? '' : '${value.toInt()}',
      radius: 42,
      titleStyle: getBoldStyle(color: AppColors.white, fontSize: FontSize.size10, fontFamily: FontConstant.cairo),
    );
  }

  List<BarChartGroupData> _scoreDistribution(List<AssignmentSubmission> submissions) {
    final buckets = [0, 0, 0, 0];
    for (final submission in submissions) {
      if (submission.maxScore == 0 || submission.status == AssignmentSubmissionStatus.notSubmitted) {
        continue;
      }
      final percent = (submission.score / submission.maxScore) * 100;
      if (percent < 50) {
        buckets[0]++;
      } else if (percent < 70) {
        buckets[1]++;
      } else if (percent < 85) {
        buckets[2]++;
      } else {
        buckets[3]++;
      }
    }

    final colors = [AppColors.errorRed, AppColors.third, AppColors.secondary, AppColors.green];
    return buckets.asMap().entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            width: 18,
            borderRadius: BorderRadius.circular(8),
            color: colors[entry.key],
          ),
        ],
      );
    }).toList(growable: false);
  }

  List<FlSpot> _assignmentAverageSpots(List<ClassroomAssignment> assignments) {
    return assignments.asMap().entries.map((entry) {
      final scores = entry.value.submissions.where((item) => item.maxScore > 0).map((item) => (item.score / item.maxScore) * 100).toList(growable: false);
      final average = scores.isEmpty ? 0.0 : scores.reduce((a, b) => a + b) / scores.length;
      return FlSpot(entry.key.toDouble(), average);
    }).toList(growable: false);
  }
}

class _MetricBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricBox({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: getBoldStyle(color: color, fontSize: FontSize.size15, fontFamily: FontConstant.cairo),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: getMediumStyle(color: AppColors.primaryDark, fontSize: FontSize.size10, fontFamily: FontConstant.cairo),
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final String label;
  final Color color;
  final String value;

  const _LegendRow({required this.label, required this.color, required this.value});

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
            style: getRegularStyle(color: AppColors.primaryDark, fontSize: FontSize.size10, fontFamily: FontConstant.cairo),
          ),
        ),
        Text(
          value,
          style: getBoldStyle(color: AppColors.primaryDark, fontSize: FontSize.size10, fontFamily: FontConstant.cairo),
        ),
      ],
    );
  }
}
