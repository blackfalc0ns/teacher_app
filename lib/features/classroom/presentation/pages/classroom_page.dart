import 'package:flutter/material.dart';

import '../../../schedule/data/model/schedule_model.dart';
import '../../data/mock/classroom_mock_data.dart';
import '../../data/models/classroom_model.dart';
import '../widgets/assignments/assignment_analytics_card.dart';
import '../widgets/assignments/assignment_section.dart';
import '../widgets/assignments/assignment_tracking_filters_card.dart';
import '../widgets/classroom_header_card.dart';
import '../widgets/classroom_metrics_row.dart';
import '../widgets/classroom_quick_actions_card.dart';
import '../widgets/classroom_section.dart';
import '../widgets/classroom_section_tabs.dart';
import '../widgets/classroom_sections.dart';
import 'assignment_create_page.dart';
import 'attendance_page.dart';

class ClassroomPage extends StatefulWidget {
  final ScheduleModel scheduleItem;

  const ClassroomPage({super.key, required this.scheduleItem});

  @override
  State<ClassroomPage> createState() => _ClassroomPageState();
}

class _ClassroomPageState extends State<ClassroomPage> {
  ClassroomSection _selectedSection = ClassroomSection.overview;

  late List<ClassroomStudent> _students;
  late List<ClassroomAssignment> _assignments;

  @override
  void initState() {
    super.initState();
    _students = ClassroomMockData.buildStudents(widget.scheduleItem);
    _assignments = ClassroomMockData.buildAssignments(widget.scheduleItem);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.scheduleItem;
    final attendance = _attendance;
    final followUpCount = _students.where((student) => student.needsFollowUp).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            ClassroomHeaderCard(item: item, followUpCount: followUpCount),
            const SizedBox(height: 12),
            ClassroomQuickActionsCard(
              item: item.copyWith(
                needsAttendance: attendance.unmarkedCount > 0,
                hasHomework: _assignments.isNotEmpty,
              ),
              onAttendanceTap: _openAttendance,
              onStudentsTap: () => _selectSection(ClassroomSection.students),
              onAssignmentsTap: _openAssignmentTracking,
            ),
            const SizedBox(height: 12),
            ClassroomMetricsRow(
              items: [
                ClassroomMetricItem(title: 'الطلاب', value: '${item.studentsCount}', icon: Icons.groups_rounded, color: const Color(0xFF006D82)),
                ClassroomMetricItem(title: 'تم الحسم', value: '${attendance.resolvedCount}', icon: Icons.fact_check_outlined, color: const Color(0xFF10B981)),
                ClassroomMetricItem(title: 'غير محسوم', value: '${attendance.unmarkedCount}', icon: Icons.pending_actions_rounded, color: const Color(0xFFF7A201)),
                ClassroomMetricItem(title: 'واجبات', value: '${_assignments.length}', icon: Icons.assignment_outlined, color: const Color(0xFF13B3B0)),
              ],
            ),
            const SizedBox(height: 12),
            ClassroomSectionTabs(
              selected: _selectedSection,
              onChanged: (section) {
                setState(() {
                  _selectedSection = section;
                });
              },
            ),
            const SizedBox(height: 12),
            _buildSection(attendance),
          ],
        ),
      ),
    );
  }

  ClassroomAttendanceSummary get _attendance {
    return ClassroomMockData.buildAttendanceSummary(
      students: _students,
      attendancePending: _students.any((student) => student.attendanceMark == AttendanceMark.unmarked),
    );
  }

  Widget _buildSection(ClassroomAttendanceSummary attendance) {
    switch (_selectedSection) {
      case ClassroomSection.overview:
        return ClassroomOverviewSection(
          item: widget.scheduleItem,
          attendance: attendance,
          assignments: _assignments,
          students: _students,
        );
      case ClassroomSection.students:
        return ClassroomStudentsSection(students: _students);
      case ClassroomSection.attendance:
        return ClassroomAttendanceSection(
          attendance: attendance,
          students: _students,
          onOpenAttendance: _openAttendance,
        );
      case ClassroomSection.assignments:
        return ClassroomAssignmentsSection(
          assignments: _assignments,
          onCreateAssignment: _openAssignmentCreate,
          onTrackAssignments: _openAssignmentTracking,
        );
    }
  }

  void _selectSection(ClassroomSection section) {
    setState(() {
      _selectedSection = section;
    });
  }

  Future<void> _openAssignmentCreate() async {
    final assignment = await Navigator.of(context).push<ClassroomAssignment>(
      MaterialPageRoute(
        builder: (_) => AssignmentCreatePage(item: widget.scheduleItem),
      ),
    );

    if (!mounted || assignment == null) {
      return;
    }

    setState(() {
      _assignments = [assignment, ..._assignments];
      _selectedSection = ClassroomSection.assignments;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(assignment.publishNow ? 'تم إنشاء الواجب ونشره.' : 'تم حفظ الواجب كمسودة.'),
      ),
    );
  }

  Future<void> _openAssignmentTracking() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AssignmentTrackingPage(
          item: widget.scheduleItem,
          assignments: _assignments,
        ),
      ),
    );
  }

  Future<void> _openAttendance() async {
    final result = await Navigator.of(context).push<List<ClassroomStudent>>(
      MaterialPageRoute(
        builder: (_) => AttendancePage(
          scheduleItem: widget.scheduleItem,
          initialStudents: _students,
        ),
      ),
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      _students = result;
      _selectedSection = ClassroomSection.attendance;
    });

    final pendingCount = _attendance.unmarkedCount;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          pendingCount == 0 ? 'تم تحديث الحضور واعتماد السجل.' : 'تم تحديث الحضور، ويتبقى $pendingCount طالب يحتاج تحديد.',
        ),
      ),
    );
  }
}

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
    final visibleSubmissions = selectedAssignment == null ? <AssignmentSubmission>[] : _buildVisibleSubmissions(selectedAssignment);
    final safeSelectedSubmission = visibleSubmissions.isEmpty
        ? null
        : visibleSubmissions[_selectedSubmissionIndex.clamp(0, visibleSubmissions.length - 1).toInt()];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _TrackingHeader(
              title: 'متابعة الواجبات',
              subtitle: '${widget.item.className} • ${widget.item.subjectName}',
            ),
            const SizedBox(height: 12),
            _AssignmentsOverview(assignments: _assignments),
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
              AssignmentAnalyticsCard(assignments: _assignments, assignment: selectedAssignment),
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
              _SelectedSubmissionAction(
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

  List<AssignmentSubmission> _buildVisibleSubmissions(ClassroomAssignment assignment) {
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
      return submission.studentName.toLowerCase().contains(normalizedQuery) || submission.studentId.toLowerCase().contains(normalizedQuery);
    }).toList(growable: false);
  }

  bool _matchesTab(AssignmentSubmission submission) {
    switch (_activeTab) {
      case 'not_submitted':
        return submission.status == AssignmentSubmissionStatus.notSubmitted;
      case 'waiting_review':
        return submission.status == AssignmentSubmissionStatus.submitted || submission.status == AssignmentSubmissionStatus.late;
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
    if (submission.maxScore == 0 || submission.status == AssignmentSubmissionStatus.notSubmitted) {
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

class _AssignmentsOverview extends StatelessWidget {
  final List<ClassroomAssignment> assignments;

  const _AssignmentsOverview({required this.assignments});

  @override
  Widget build(BuildContext context) {
    final totalAssignments = assignments.length;
    final totalSubmitted = assignments.fold<int>(0, (sum, assignment) => sum + assignment.submittedCount);
    final totalReviewed = assignments.fold<int>(0, (sum, assignment) => sum + assignment.reviewedCount);
    final averagePercent = _buildAveragePercent(assignments);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(child: _TrackingMetric(label: 'الواجبات', value: '$totalAssignments', color: const Color(0xFF006D82))),
          const SizedBox(width: 8),
          Expanded(child: _TrackingMetric(label: 'التسليمات', value: '$totalSubmitted', color: const Color(0xFF10B981))),
          const SizedBox(width: 8),
          Expanded(child: _TrackingMetric(label: 'تم التصحيح', value: '$totalReviewed', color: const Color(0xFFF7A201))),
          const SizedBox(width: 8),
          Expanded(child: _TrackingMetric(label: 'المتوسط', value: '$averagePercent%', color: const Color(0xFF13B3B0))),
        ],
      ),
    );
  }

  int _buildAveragePercent(List<ClassroomAssignment> assignments) {
    final scores = assignments
        .expand((assignment) => assignment.submissions)
        .where((submission) => submission.maxScore > 0 && submission.status != AssignmentSubmissionStatus.notSubmitted)
        .map((submission) => (submission.score / submission.maxScore) * 100)
        .toList(growable: false);

    if (scores.isEmpty) {
      return 0;
    }
    final average = scores.reduce((first, second) => first + second) / scores.length;
    return average.round();
  }
}

class _TrackingMetric extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _TrackingMetric({required this.label, required this.value, required this.color});

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
  final AssignmentSubmission? selectedSubmission;
  final ScheduleModel item;
  final ValueChanged<AssignmentSubmission> onSubmissionUpdated;

  const _SelectedSubmissionAction({
    required this.assignment,
    required this.selectedSubmission,
    required this.item,
    required this.onSubmissionUpdated,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedSubmission == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final updatedSubmission = await Navigator.of(context).push<AssignmentSubmission>(
            MaterialPageRoute(
              builder: (_) => AssignmentSubmissionPage(
                item: item,
                assignment: assignment,
                submission: selectedSubmission!,
              ),
            ),
          );

          if (updatedSubmission != null) {
            onSubmissionUpdated(updatedSubmission);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0A7A96),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(vertical: 13),
        ),
        child: Text(
          selectedSubmission!.status == AssignmentSubmissionStatus.notSubmitted ? 'عرض حالة الطالب' : 'عرض الحل والتصحيح اليدوي',
        ),
      ),
    );
  }
}

class _TrackingHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _TrackingHeader({required this.title, required this.subtitle});

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

class AssignmentSubmissionsCard extends StatelessWidget {
  final List<ClassroomAssignment> assignments;
  final int selectedAssignmentIndex;
  final ValueChanged<int> onAssignmentSelected;

  const AssignmentSubmissionsCard({
    super.key,
    required this.assignments,
    required this.selectedAssignmentIndex,
    required this.onAssignmentSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (assignments.isEmpty) {
      return const _TrackingEmptyCard(message: '?? ???? ?????? ????? ???.');
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('???????? ??????????', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF04506E))),
          const SizedBox(height: 3),
          const Text('???? ?????? ???? ???? ?????? ??????????.', style: TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
          const SizedBox(height: 12),
          ...assignments.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _AssignmentOverviewTile(
                assignment: entry.value,
                selected: entry.key == selectedAssignmentIndex,
                onTap: () => onAssignmentSelected(entry.key),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
    final safeSelectedIndex = submissions.isEmpty ? 0 : selectedSubmissionIndex.clamp(0, submissions.length - 1).toInt();

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
                child: Text('???? ??????', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF04506E))),
              ),
              _TrackingPill(label: '${submissions.length}/${assignment.submissions.length}', color: const Color(0xFF006D82)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _TrackingMetric(label: '?? ???????', value: '${assignment.submittedCount}', color: const Color(0xFF10B981))),
              const SizedBox(width: 8),
              Expanded(child: _TrackingMetric(label: '?? ???????', value: '${assignment.reviewedCount}', color: const Color(0xFF006D82))),
              const SizedBox(width: 8),
              Expanded(child: _TrackingMetric(label: '?? ?????', value: '${assignment.totalCount - assignment.submittedCount}', color: const Color(0xFFE53F3E))),
            ],
          ),
          const SizedBox(height: 12),
          if (submissions.isEmpty)
            const _TrackingEmptyCard(message: '?? ???? ????? ?????? ??????? ???????.')
          else
            ...submissions.asMap().entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _SubmissionTile(
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

class AssignmentSubmissionPage extends StatefulWidget {
  final ScheduleModel item;
  final ClassroomAssignment assignment;
  final AssignmentSubmission submission;

  const AssignmentSubmissionPage({
    super.key,
    required this.item,
    required this.assignment,
    required this.submission,
  });

  @override
  State<AssignmentSubmissionPage> createState() => _AssignmentSubmissionPageState();
}

class _AssignmentSubmissionPageState extends State<AssignmentSubmissionPage> {
  late AssignmentSubmission _submission;
  late TextEditingController _feedbackController;

  @override
  void initState() {
    super.initState();
    _submission = widget.submission;
    _feedbackController = TextEditingController(text: widget.submission.feedback);
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canGrade = _submission.status != AssignmentSubmissionStatus.notSubmitted;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _TrackingHeader(
              title: '?????? ?? ??????',
              subtitle: '${widget.item.className} � ${widget.assignment.title}',
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_submission.studentName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF04506E))),
                            const SizedBox(height: 3),
                            Text(widget.assignment.title, style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
                          ],
                        ),
                      ),
                      _TrackingPill(label: _trackingStatusLabel(_submission.status), color: _trackingStatusColor(_submission.status)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _SubmissionSummaryTile(label: '??????', value: '${_submission.score}/${_submission.maxScore}', color: const Color(0xFF006D82))),
                      const SizedBox(width: 8),
                      Expanded(child: _SubmissionSummaryTile(label: '??? ???????', value: _submission.submittedAtLabel, color: const Color(0xFF13B3B0))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFF0F3F6), borderRadius: BorderRadius.circular(14)),
                    child: Text(_submission.feedback.trim().isEmpty ? '?? ???? ??????? ????? ???.' : _submission.feedback),
                  ),
                  const SizedBox(height: 12),
                  ...widget.assignment.questions.map((question) {
                    final answer = _submission.answers.where((item) => item.questionId == question.id).firstOrNull;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _QuestionReviewTile(
                        question: question,
                        answer: answer,
                        onScoreChanged: _isManualQuestion(question) && canGrade
                            ? (score) => _updateQuestionScore(question, answer, score)
                            : null,
                      ),
                    );
                  }),
                ],
              ),
            ),
            if (canGrade) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('??????? ??????', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF04506E))),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _feedbackController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: '???? ???????? ???',
                        filled: true,
                        fillColor: const Color(0xFFF0F3F6),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A7A96),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  child: const Text('??? ??????? ?????? ??????'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _isManualQuestion(ClassroomQuestion question) {
    return question.type == AssignmentQuestionType.essay ||
        question.type == AssignmentQuestionType.shortAnswer ||
        question.type == AssignmentQuestionType.fillInBlank;
  }

  void _updateQuestionScore(ClassroomQuestion question, StudentQuestionAnswer? answer, int score) {
    final updatedAnswers = List<StudentQuestionAnswer>.from(_submission.answers);
    final index = updatedAnswers.indexWhere((item) => item.questionId == question.id);
    final baseAnswer = answer ?? StudentQuestionAnswer(
      questionId: question.id,
      studentAnswer: '',
      correctAnswer: question.correctAnswerLabel,
      isCorrect: null,
      score: 0,
      maxScore: question.points,
    );
    final gradedAnswer = baseAnswer.copyWith(
      score: score,
      maxScore: question.points,
      isCorrect: score == question.points ? true : (score == 0 ? false : null),
    );

    if (index == -1) {
      updatedAnswers.add(gradedAnswer);
    } else {
      updatedAnswers[index] = gradedAnswer;
    }

    setState(() {
      _submission = _submission.copyWith(
        answers: updatedAnswers,
        score: updatedAnswers.fold<int>(0, (sum, item) => sum + item.score),
        feedback: _feedbackController.text.trim(),
      );
    });
  }

  void _save() {
    Navigator.of(context).pop(
      _submission.copyWith(
        status: AssignmentSubmissionStatus.reviewed,
        feedback: _feedbackController.text.trim(),
        score: _submission.answers.fold<int>(0, (sum, item) => sum + item.score),
      ),
    );
  }
}
class _AssignmentOverviewTile extends StatelessWidget {
  final ClassroomAssignment assignment;
  final bool selected;
  final VoidCallback onTap;

  const _AssignmentOverviewTile({required this.assignment, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF006D82).withValues(alpha: 0.08) : const Color(0xFFF0F3F6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? const Color(0xFF006D82).withValues(alpha: 0.24) : Colors.transparent),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(assignment.title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF04506E)))),
                _TrackingPill(label: assignment.statusLabel, color: selected ? const Color(0xFF006D82) : const Color(0xFF13B3B0)),
              ],
            ),
            const SizedBox(height: 6),
            Text('${assignment.modeLabel} � ${assignment.questionsCount} ???? � ${assignment.totalMarks} ????', style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
            const SizedBox(height: 6),
            Text('${assignment.submittedCount} ?? ${assignment.totalCount} ??????', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF04506E))),
          ],
        ),
      ),
    );
  }
}

class _SubmissionTile extends StatelessWidget {
  final AssignmentSubmission submission;
  final bool selected;
  final VoidCallback onTap;

  const _SubmissionTile({required this.submission, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = _trackingStatusColor(submission.status);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.08) : const Color(0xFFF0F3F6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? color.withValues(alpha: 0.24) : Colors.transparent),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(submission.studentName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF04506E))),
                  const SizedBox(height: 3),
                  Text(submission.submittedAtLabel, style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _TrackingPill(label: _trackingStatusLabel(submission.status), color: color),
                const SizedBox(height: 6),
                Text('${submission.score}/${submission.maxScore}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF04506E))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionReviewTile extends StatelessWidget {
  final ClassroomQuestion question;
  final StudentQuestionAnswer? answer;
  final ValueChanged<int>? onScoreChanged;

  const _QuestionReviewTile({required this.question, required this.answer, required this.onScoreChanged});

  @override
  Widget build(BuildContext context) {
    final color = _answerColor(question, answer);
    final safeScore = (answer?.score ?? 0).clamp(0, question.points);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(question.title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF04506E)))),
              _TrackingPill(label: '$safeScore/${question.points}', color: color),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _TrackingPill(label: _questionTypeLabel(question.type), color: const Color(0xFF13B3B0)),
              _TrackingPill(label: _answerStateLabel(question, answer), color: color),
            ],
          ),
          const SizedBox(height: 10),
          _AnswerPanel(title: '????? ??????', value: answer?.studentAnswer.trim().isNotEmpty == true ? answer!.studentAnswer : '?? ???? ????? ??????', background: Colors.white),
          const SizedBox(height: 8),
          _AnswerPanel(title: '??????? ???????', value: question.correctAnswerLabel, background: const Color(0xFFECFDF5)),
          if (question.explanation.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            _AnswerPanel(title: '????? ??????', value: question.explanation, background: const Color(0xFFEFFBFB)),
          ],
          if (onScoreChanged != null) ...[
            const SizedBox(height: 10),
            Slider(
              value: safeScore.toDouble(),
              max: question.points.toDouble(),
              divisions: question.points,
              label: '$safeScore',
              onChanged: answer == null ? null : (value) => onScoreChanged!(value.round()),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ScoreAction(label: '???', onTap: answer == null ? null : () => onScoreChanged!(0)),
                _ScoreAction(label: '????? ??????', onTap: answer == null ? null : () => onScoreChanged!((question.points / 2).round())),
                _ScoreAction(label: '?????? ?????', onTap: answer == null ? null : () => onScoreChanged!(question.points)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _AnswerPanel extends StatelessWidget {
  final String title;
  final String value;
  final Color background;

  const _AnswerPanel({required this.title, required this.value, required this.background});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 11, color: Color(0xFF04506E))),
        ],
      ),
    );
  }
}

class _SubmissionSummaryTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SubmissionSummaryTile({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}

class _TrackingPill extends StatelessWidget {
  final String label;
  final Color color;

  const _TrackingPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(999)),
      child: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700)),
    );
  }
}

class _TrackingEmptyCard extends StatelessWidget {
  final String message;

  const _TrackingEmptyCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFFF0F3F6), borderRadius: BorderRadius.circular(16)),
      child: Text(message, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
    );
  }
}

class _ScoreAction extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _ScoreAction({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      child: Text(label),
    );
  }
}

String _trackingStatusLabel(AssignmentSubmissionStatus status) {
  switch (status) {
    case AssignmentSubmissionStatus.notSubmitted:
      return '?? ?????';
    case AssignmentSubmissionStatus.submitted:
      return '??????? ???????';
    case AssignmentSubmissionStatus.reviewed:
      return '?? ???????';
    case AssignmentSubmissionStatus.late:
      return '?????';
  }
}

Color _trackingStatusColor(AssignmentSubmissionStatus status) {
  switch (status) {
    case AssignmentSubmissionStatus.notSubmitted:
      return const Color(0xFF6B7280);
    case AssignmentSubmissionStatus.submitted:
      return const Color(0xFFF7A201);
    case AssignmentSubmissionStatus.reviewed:
      return const Color(0xFF10B981);
    case AssignmentSubmissionStatus.late:
      return const Color(0xFFE53F3E);
  }
}

String _questionTypeLabel(AssignmentQuestionType type) {
  switch (type) {
    case AssignmentQuestionType.multipleChoice:
      return '?????? ?????';
    case AssignmentQuestionType.trueFalse:
      return '?? ?? ???';
    case AssignmentQuestionType.shortAnswer:
      return '????? ?????';
    case AssignmentQuestionType.essay:
      return '?????';
    case AssignmentQuestionType.fillInBlank:
      return '???? ??????';
    case AssignmentQuestionType.matching:
      return '?????';
  }
}

String _answerStateLabel(ClassroomQuestion question, StudentQuestionAnswer? answer) {
  if (answer == null) {
    return '???? ?????';
  }
  final isManual = question.type == AssignmentQuestionType.essay || question.type == AssignmentQuestionType.shortAnswer || question.type == AssignmentQuestionType.fillInBlank;
  if (isManual && answer.score > 0 && answer.score < question.points) {
    return '???? ??????';
  }
  if (isManual && answer.score == question.points) {
    return '???? ????';
  }
  if (answer.isCorrect == null) {
    return '????? ??????';
  }
  return answer.isCorrect! ? '????? ?????' : '????? ??? ?????';
}

Color _answerColor(ClassroomQuestion question, StudentQuestionAnswer? answer) {
  if (answer == null) {
    return const Color(0xFF6B7280);
  }
  final isManual = question.type == AssignmentQuestionType.essay || question.type == AssignmentQuestionType.shortAnswer || question.type == AssignmentQuestionType.fillInBlank;
  if (isManual && answer.score > 0 && answer.score < question.points) {
    return const Color(0xFFF7A201);
  }
  if (answer.isCorrect == null) {
    return const Color(0xFFF7A201);
  }
  return answer.isCorrect! ? const Color(0xFF10B981) : const Color(0xFFE53F3E);
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
