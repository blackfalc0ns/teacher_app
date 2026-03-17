import 'package:flutter/material.dart';

import '../../../schedule/data/model/schedule_model.dart';
import '../../data/models/classroom_model.dart';
import '../widgets/assignments/assignment_analytics_card.dart';
import '../widgets/assignments/assignment_submissions_card.dart';
import '../widgets/assignments/assignment_student_submissions_card.dart';
import '../widgets/assignments/assignment_tracking_filters_card.dart';
import '../widgets/tracking/assignments_overview_card.dart';
import '../widgets/tracking/selected_submission_action.dart';
import '../widgets/tracking/tracking_header.dart';

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
  final TextEditingController _searchController = TextEditingController();
  late List<ClassroomAssignment> _assignments;
  int _selectedAssignmentIndex = 0;
  int _selectedSubmissionIndex = 0;
  String _activeTab = 'all';
  String _scoreFilter = 'all';
  bool _lateOnly = false;

  @override
  void initState() {
    super.initState();
    _assignments = List<ClassroomAssignment>.from(widget.assignments);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedAssignment = _selectedAssignment;
    final visibleSubmissions = selectedAssignment == null
        ? <AssignmentSubmission>[]
        : _buildVisibleSubmissions(selectedAssignment);
    final safeSelectedSubmission = visibleSubmissions.isEmpty
        ? null
        : visibleSubmissions[
            _selectedSubmissionIndex.clamp(0, visibleSubmissions.length - 1).toInt()
          ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            TrackingHeader(
              title: 'متابعة الواجبات',
              subtitle: '${widget.item.className} • ${widget.item.subjectName}',
              onBack: () => Navigator.of(context).pop(_assignments),
            ),
            const SizedBox(height: 12),
            AssignmentsOverviewCard(assignments: _assignments),
            const SizedBox(height: 12),
            AssignmentSubmissionsCard(
              assignments: _assignments,
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
              AssignmentAnalyticsCard(
                assignments: _assignments,
                assignment: selectedAssignment,
              ),
              const SizedBox(height: 12),
              AssignmentTrackingFiltersCard(
                activeTab: _activeTab,
                onTabChanged: (value) {
                  setState(() {
                    _activeTab = value;
                    _selectedSubmissionIndex = 0;
                  });
                },
                searchController: _searchController,
                onSearchChanged: (_) {
                  setState(() {
                    _selectedSubmissionIndex = 0;
                  });
                },
                scoreFilter: _scoreFilter,
                onScoreFilterChanged: (value) {
                  setState(() {
                    _scoreFilter = value;
                    _selectedSubmissionIndex = 0;
                  });
                },
                lateOnly: _lateOnly,
                onLateOnlyChanged: (value) {
                  setState(() {
                    _lateOnly = value;
                    _selectedSubmissionIndex = 0;
                  });
                },
              ),
              const SizedBox(height: 12),
              AssignmentStudentSubmissionsCard(
                assignment: selectedAssignment,
                submissions: visibleSubmissions,
                selectedSubmissionIndex: _selectedSubmissionIndex,
                onSubmissionSelected: (index) {
                  setState(() {
                    _selectedSubmissionIndex = index;
                  });
                },
              ),
              const SizedBox(height: 12),
              SelectedSubmissionAction(
                assignment: selectedAssignment,
                selectedSubmission: safeSelectedSubmission,
                item: widget.item,
                onSubmissionUpdated: _updateSubmission,
              ),
            ],
          ],
        ),
      ),
    );
  }

  ClassroomAssignment? get _selectedAssignment {
    if (_assignments.isEmpty) {
      return null;
    }
    final safeIndex = _selectedAssignmentIndex.clamp(0, _assignments.length - 1).toInt();
    return _assignments[safeIndex];
  }

  List<AssignmentSubmission> _buildVisibleSubmissions(
    ClassroomAssignment assignment,
  ) {
    final query = _searchController.text.trim();
    return assignment.submissions.where((submission) {
      if (!_matchesTab(submission)) {
        return false;
      }
      if (_lateOnly && submission.status != AssignmentSubmissionStatus.late) {
        return false;
      }
      if (!_matchesScoreFilter(submission)) {
        return false;
      }
      if (query.isEmpty) {
        return true;
      }
      final normalizedQuery = query.toLowerCase();
      return submission.studentName.toLowerCase().contains(normalizedQuery) ||
          submission.studentId.toLowerCase().contains(normalizedQuery);
    }).toList(growable: false);
  }

  bool _matchesTab(AssignmentSubmission submission) {
    switch (_activeTab) {
      case 'not_submitted':
        return submission.status == AssignmentSubmissionStatus.notSubmitted;
      case 'waiting_review':
        return submission.status == AssignmentSubmissionStatus.submitted ||
            submission.status == AssignmentSubmissionStatus.late;
      case 'reviewed':
        return submission.status == AssignmentSubmissionStatus.reviewed;
      default:
        return true;
    }
  }

  bool _matchesScoreFilter(AssignmentSubmission submission) {
    if (_scoreFilter == 'all') {
      return true;
    }
    if (submission.maxScore == 0 ||
        submission.status == AssignmentSubmissionStatus.notSubmitted) {
      return _scoreFilter == 'low';
    }

    final scorePercent = (submission.score / submission.maxScore) * 100;
    switch (_scoreFilter) {
      case 'low':
        return scorePercent < 50;
      case 'medium':
        return scorePercent >= 50 && scorePercent < 80;
      case 'high':
        return scorePercent >= 80;
      default:
        return true;
    }
  }

  void _updateSubmission(AssignmentSubmission updatedSubmission) {
    final assignment = _selectedAssignment;
    if (assignment == null) {
      return;
    }

    final updatedSubmissions = assignment.submissions.map((submission) {
      if (submission.studentId == updatedSubmission.studentId) {
        return updatedSubmission;
      }
      return submission;
    }).toList(growable: false);

    final updatedAssignment = assignment.copyWith(submissions: updatedSubmissions);
    setState(() {
      _assignments = _assignments.map((item) {
        if (item.id == assignment.id) {
          return updatedAssignment;
        }
        return item;
      }).toList(growable: false);
    });
  }
}
