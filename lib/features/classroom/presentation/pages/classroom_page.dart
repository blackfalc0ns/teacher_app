import 'package:flutter/material.dart';

import '../../../schedule/data/model/schedule_model.dart';
import '../../data/mock/classroom_mock_data.dart';
import '../../data/models/classroom_model.dart';
import '../widgets/classroom_header_card.dart';
import '../widgets/classroom_metrics_row.dart';
import '../widgets/classroom_quick_actions_card.dart';
import '../widgets/classroom_section.dart';
import '../widgets/classroom_section_tabs.dart';
import '../widgets/classroom_sections.dart';
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
  late final List<ClassroomAssignment> _assignments;

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
    final followUpCount = _students
        .where((student) => student.needsFollowUp)
        .length;

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
              ),
              onAttendanceTap: _openAttendance,
              onStudentsTap: () => _selectSection(ClassroomSection.students),
              onAssignmentsTap: () =>
                  _selectSection(ClassroomSection.assignments),
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
        return ClassroomAssignmentsSection(assignments: _assignments);
    }
  }

  void _selectSection(ClassroomSection section) {
    setState(() {
      _selectedSection = section;
    });
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
    ScaffoldMessenger.of(this.context).showSnackBar(
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
