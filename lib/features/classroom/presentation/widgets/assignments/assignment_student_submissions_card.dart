import 'package:flutter/material.dart';
import '../../../data/models/classroom_model.dart';
import '../tracking/tracking_empty_card.dart';
import '../tracking/tracking_metric.dart';
import '../tracking/tracking_pill.dart';
import 'submission_tile.dart';

class AssignmentStudentSubmissionsCard extends StatelessWidget {
  final ClassroomAssignment assignment;
  final List<AssignmentSubmission> submissions;
  final int selectedSubmissionIndex;
  final ValueChanged<int> onSubmissionSelected;

  const AssignmentStudentSubmissionsCard({
    super.key,
    required this.assignment,
    required this.submissions,
    required this.selectedSubmissionIndex,
    required this.onSubmissionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final safeSelectedIndex = submissions.isEmpty
        ? 0
        : selectedSubmissionIndex.clamp(0, submissions.length - 1).toInt();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'حلول الطلاب',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF04506E),
                  ),
                ),
              ),
              TrackingPill(
                label: '${submissions.length}/${assignment.submissions.length}',
                color: const Color(0xFF006D82),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TrackingMetric(
                  label: 'تم التسليم',
                  value: '${assignment.submittedCount}',
                  color: const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TrackingMetric(
                  label: 'تم التصحيح',
                  value: '${assignment.reviewedCount}',
                  color: const Color(0xFF006D82),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TrackingMetric(
                  label: 'لم يسلم',
                  value: '${assignment.totalCount - assignment.submittedCount}',
                  color: const Color(0xFFE53F3E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (submissions.isEmpty)
            const TrackingEmptyCard(
              message: 'لا توجد تسليمات تطابق المعايير المحددة.',
            )
          else
            ...submissions.asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SubmissionTile(
                      submission: entry.value,
                      selected: entry.key == safeSelectedIndex,
                      onTap: () => onSubmissionSelected(entry.key),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
