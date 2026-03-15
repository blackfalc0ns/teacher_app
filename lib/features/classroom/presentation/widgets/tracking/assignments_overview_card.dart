import 'package:flutter/material.dart';
import '../../../data/models/classroom_model.dart';
import 'tracking_metric.dart';

class AssignmentsOverviewCard extends StatelessWidget {
  final List<ClassroomAssignment> assignments;

  const AssignmentsOverviewCard({
    super.key,
    required this.assignments,
  });

  @override
  Widget build(BuildContext context) {
    final totalAssignments = assignments.length;
    final totalSubmitted = assignments.fold<int>(
      0,
      (sum, assignment) => sum + assignment.submittedCount,
    );
    final totalReviewed = assignments.fold<int>(
      0,
      (sum, assignment) => sum + assignment.reviewedCount,
    );
    final averagePercent = _buildAveragePercent(assignments);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: TrackingMetric(
              label: 'الواجبات',
              value: '$totalAssignments',
              color: const Color(0xFF006D82),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TrackingMetric(
              label: 'التسليمات',
              value: '$totalSubmitted',
              color: const Color(0xFF10B981),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TrackingMetric(
              label: 'تم التصحيح',
              value: '$totalReviewed',
              color: const Color(0xFFF7A201),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TrackingMetric(
              label: 'المتوسط',
              value: '$averagePercent%',
              color: const Color(0xFF13B3B0),
            ),
          ),
        ],
      ),
    );
  }

  int _buildAveragePercent(List<ClassroomAssignment> assignments) {
    final scores = assignments
        .expand((assignment) => assignment.submissions)
        .where((submission) =>
            submission.maxScore > 0 &&
            submission.status != AssignmentSubmissionStatus.notSubmitted)
        .map((submission) => (submission.score / submission.maxScore) * 100)
        .toList(growable: false);

    if (scores.isEmpty) {
      return 0;
    }
    final average =
        scores.reduce((first, second) => first + second) / scores.length;
    return average.round();
  }
}
