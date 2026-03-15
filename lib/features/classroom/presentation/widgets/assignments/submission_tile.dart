import 'package:flutter/material.dart';
import '../../../data/models/classroom_model.dart';
import '../tracking/tracking_pill.dart';

class SubmissionTile extends StatelessWidget {
  final AssignmentSubmission submission;
  final bool selected;
  final VoidCallback onTap;

  const SubmissionTile({
    super.key,
    required this.submission,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF006D82).withValues(alpha: 0.08)
              : const Color(0xFFF0F3F6),
          borderRadius: BorderRadius.circular(14),
          border: selected
              ? Border.all(color: const Color(0xFF006D82), width: 2)
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    submission.studentName,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? const Color(0xFF006D82)
                          : const Color(0xFF04506E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'الدرجة: ${submission.score}/${submission.maxScore}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            TrackingPill(
              label: _getStatusLabel(submission.status),
              color: _getStatusColor(submission.status),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusLabel(AssignmentSubmissionStatus status) {
    switch (status) {
      case AssignmentSubmissionStatus.notSubmitted:
        return 'لم يسلم';
      case AssignmentSubmissionStatus.submitted:
        return 'تم التسليم';
      case AssignmentSubmissionStatus.late:
        return 'متأخر';
      case AssignmentSubmissionStatus.reviewed:
        return 'تم التصحيح';
    }
  }

  Color _getStatusColor(AssignmentSubmissionStatus status) {
    switch (status) {
      case AssignmentSubmissionStatus.notSubmitted:
        return const Color(0xFFE53F3E);
      case AssignmentSubmissionStatus.submitted:
        return const Color(0xFF10B981);
      case AssignmentSubmissionStatus.late:
        return const Color(0xFFF7A201);
      case AssignmentSubmissionStatus.reviewed:
        return const Color(0xFF006D82);
    }
  }
}
