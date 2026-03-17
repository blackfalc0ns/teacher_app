import 'package:flutter/material.dart';
import '../../../schedule/data/model/schedule_model.dart';
import '../../data/mock/classroom_mock_data.dart';
import '../../data/models/classroom_model.dart';
import '../widgets/assignments/assignment_section.dart';
import '../widgets/classroom_header_card.dart';
import '../widgets/classroom_metrics_row.dart';
import '../widgets/classroom_quick_actions_card.dart';
import '../widgets/classroom_section.dart';
import '../widgets/classroom_section_tabs.dart';
import '../widgets/classroom_sections.dart';
import 'assignment_create_page.dart';
import 'assignment_tracking_page.dart';
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
    final followUpCount =
        _students.where((student) => student.needsFollowUp).length;

    return Scaffold(
      body: Column(
        children: [
          // Header Card خارج الـ scroll
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: ClassroomHeaderCard(
              item: item,
              followUpCount: followUpCount,
            ),
          ),
          // المحتوى القابل للتمرير
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
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
                          ClassroomMetricItem(
                            title: 'الطلاب',
                            value: '${item.studentsCount}',
                            icon: Icons.groups_rounded,
                            color: const Color(0xFF006D82),
                          ),
                          ClassroomMetricItem(
                            title: 'تم الحسم',
                            value: '${attendance.resolvedCount}',
                            icon: Icons.fact_check_outlined,
                            color: const Color(0xFF10B981),
                          ),
                          ClassroomMetricItem(
                            title: 'غير محسوم',
                            value: '${attendance.unmarkedCount}',
                            icon: Icons.pending_actions_rounded,
                            color: const Color(0xFFF7A201),
                          ),
                          ClassroomMetricItem(
                            title: 'واجبات',
                            value: '${_assignments.length}',
                            icon: Icons.assignment_outlined,
                            color: const Color(0xFF13B3B0),
                          ),
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
                      const SizedBox(height: 2),
                      _buildSection(attendance),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ClassroomAttendanceSummary get _attendance {
    return ClassroomMockData.buildAttendanceSummary(
      students: _students,
      attendancePending: _students.any(
        (student) => student.attendanceMark == AttendanceMark.unmarked,
      ),
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
    final assignment =
        await Navigator.of(context).push<ClassroomAssignment>(
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

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          assignment.publishNow
              ? 'تم إنشاء الواجب ونشره.'
              : 'تم حفظ الواجب كمسودة.',
        ),
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

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          pendingCount == 0
              ? 'تم تحديث الحضور واعتماد السجل.'
              : 'تم تحديث الحضور، ويتبقى $pendingCount طالب يحتاج تحديد.',
        ),
      ),
    );
  }
}
