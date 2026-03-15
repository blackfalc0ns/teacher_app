import 'package:flutter/material.dart';
import '../../../data/models/classroom_model.dart';
import '../tracking/tracking_pill.dart';
import 'submission_summary_tile.dart';

class SubmissionHeaderCard extends StatelessWidget {
  final AssignmentSubmission submission;
  final String assignmentTitle;

  const SubmissionHeaderCard({
    super.key,
    required this.submission,
    required this.assignmentTitle,
  });

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      submission.studentName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF04506E),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      assignmentTitle,
                      style: const TextStyle(
                        fontSize: 10,
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
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SubmissionSummaryTile(
                  label: 'الدرجة',
                  value: '${submission.score}/${submission.maxScore}',
                  color: const Color(0xFF006D82),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SubmissionSummaryTile(
                  label: 'وقت التسليم',
                  value: submission.submittedAtLabel,
                  color: const Color(0xFF13B3B0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F3F6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              submission.feedback.trim().isEmpty
                  ? 'لا توجد ملاحظات متاحة بعد.'
                  : submission.feedback,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF04506E),
              ),
            ),
          ),
        ],
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
