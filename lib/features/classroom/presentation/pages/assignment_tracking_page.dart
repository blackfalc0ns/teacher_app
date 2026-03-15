import 'package:flutter/material.dart';

import '../../../schedule/data/model/schedule_model.dart';
import '../../data/models/classroom_model.dart';
import '../widgets/assignments/assignment_submissions_card.dart';
import 'assignment_submission_page.dart';

class AssignmentTrackingPage extends StatefulWidget {
  final ScheduleModel item;
  final List<ClassroomAssignment> assignments;

  const AssignmentTrackingPage({
    super.key,
    required this.item,
    required this.assignments,
  });

  @override
  State<AssignmentTrackingPage> createState() => _AssignmentTrackingPageState();
}

class _AssignmentTrackingPageState extends State<AssignmentTrackingPage> {
  int _selectedAssignmentIndex = 0;
  int _selectedSubmissionIndex = 0;

  @override
  Widget build(BuildContext context) {
    final selectedAssignment = widget.assignments.isEmpty ? null : widget.assignments[_selectedAssignmentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _Header(
              title: 'متابعة الواجبات',
              subtitle: '${widget.item.className} • ${widget.item.subjectName}',
            ),
            const SizedBox(height: 12),
            _AssignmentsOverview(assignments: widget.assignments),
            const SizedBox(height: 12),
            AssignmentSubmissionsCard(
              assignments: widget.assignments,
              selectedAssignmentIndex: _selectedAssignmentIndex,
              onAssignmentSelected: (index) {
                setState(() {
                  _selectedAssignmentIndex = index;
                  _selectedSubmissionIndex = 0;
                });
              },
            ),
            if (selectedAssignment != null) ...[
              const SizedBox(height: 12),
              AssignmentStudentSubmissionsCard(
                assignment: selectedAssignment,
                selectedSubmissionIndex: _selectedSubmissionIndex,
                onSubmissionSelected: (index) {
                  setState(() {
                    _selectedSubmissionIndex = index;
                  });
                },
              ),
              const SizedBox(height: 12),
              _SelectedSubmissionAction(
                assignment: selectedAssignment,
                selectedSubmissionIndex: _selectedSubmissionIndex,
                item: widget.item,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AssignmentsOverview extends StatelessWidget {
  final List<ClassroomAssignment> assignments;

  const _AssignmentsOverview({required this.assignments});

  @override
  Widget build(BuildContext context) {
    final totalAssignments = assignments.length;
    final totalSubmitted = assignments.fold<int>(0, (sum, assignment) => sum + assignment.submittedCount);
    final totalReviewed = assignments.fold<int>(0, (sum, assignment) => sum + assignment.reviewedCount);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(child: _Metric(label: 'الواجبات', value: '$totalAssignments', color: const Color(0xFF006D82))),
          const SizedBox(width: 8),
          Expanded(child: _Metric(label: 'التسليمات', value: '$totalSubmitted', color: const Color(0xFF10B981))),
          const SizedBox(width: 8),
          Expanded(child: _Metric(label: 'تم التصحيح', value: '$totalReviewed', color: const Color(0xFFF7A201))),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _Metric({required this.label, required this.value, required this.color});

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
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 18)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.black87)),
        ],
      ),
    );
  }
}

class _SelectedSubmissionAction extends StatelessWidget {
  final ClassroomAssignment assignment;
  final int selectedSubmissionIndex;
  final ScheduleModel item;

  const _SelectedSubmissionAction({
    required this.assignment,
    required this.selectedSubmissionIndex,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    if (assignment.submissions.isEmpty) {
      return const SizedBox.shrink();
    }

    final submission = assignment.submissions[selectedSubmissionIndex.clamp(0, assignment.submissions.length - 1)];

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AssignmentSubmissionPage(
                item: item,
                assignment: assignment,
                submission: submission,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0A7A96),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(vertical: 13),
        ),
        child: const Text('عرض تفاصيل حل الطالب'),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final String subtitle;

  const _Header({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back_rounded, size: 18),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
}
