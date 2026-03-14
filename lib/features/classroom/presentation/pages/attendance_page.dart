import 'package:flutter/material.dart';

import '../../../schedule/data/model/schedule_model.dart';
import '../../data/mock/classroom_mock_data.dart';
import '../../data/models/classroom_model.dart';
import '../widgets/attendance_widgets.dart';

class AttendancePage extends StatefulWidget {
  final ScheduleModel scheduleItem;
  final List<ClassroomStudent>? initialStudents;

  const AttendancePage({
    super.key,
    required this.scheduleItem,
    this.initialStudents,
  });

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  late List<ClassroomStudent> _students;
  AttendanceMark? _filter;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _students = widget.initialStudents ?? ClassroomMockData.buildStudents(widget.scheduleItem);
  }

  @override
  Widget build(BuildContext context) {
    final summary = _summary;
    final visibleStudents = _visibleStudents;
    final pendingCount = summary.unmarkedCount;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      bottomNavigationBar: AttendanceSaveBar(
        label: pendingCount == 0 ? 'اعتماد الحضور' : 'حفظ ومراجعة الناقص',
        helperText: pendingCount == 0
            ? 'سجل الحضور مكتمل وجاهز للاعتماد.'
            : 'تبقى $pendingCount طالب بدون حالة حضور محددة.',
        enabled: _hasUnsavedChanges || pendingCount == 0,
        onSave: _saveAttendance,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 112),
          children: [
            AttendanceHeaderCard(
              item: widget.scheduleItem,
              onBack: _closeWithResult,
            ),
            if (_hasUnsavedChanges || pendingCount > 0) ...[
              const SizedBox(height: 12),
              PendingAttendanceBanner(pendingCount: pendingCount),
            ],
            const SizedBox(height: 12),
            AttendanceProgressCard(summary: summary),
            const SizedBox(height: 12),
            AttendanceQuickActionsCard(
              activeFilter: _filter,
              onMarkAllPresent: () => _bulkMark(AttendanceMark.present),
              onMarkPendingPresent: _markPendingPresent,
              onFilterChanged: (filter) {
                setState(() {
                  _filter = filter;
                });
              },
            ),
            const SizedBox(height: 12),
            AttendanceStudentsCard(
              students: visibleStudents,
              onMarkChanged: (payload) => _updateStudent(payload.$1, payload.$2),
            ),
          ],
        ),
      ),
    );
  }

  ClassroomAttendanceSummary get _summary {
    return ClassroomMockData.buildAttendanceSummary(
      students: _students,
      attendancePending: false,
    );
  }

  List<ClassroomStudent> get _visibleStudents {
    if (_filter == null) {
      return _students;
    }
    return _students.where((student) => student.attendanceMark == _filter).toList();
  }

  void _bulkMark(AttendanceMark mark) {
    setState(() {
      _students = _students
          .map((student) => student.copyWith(attendanceMark: mark))
          .toList();
      _hasUnsavedChanges = true;
    });
  }

  void _markPendingPresent() {
    setState(() {
      _students = _students
          .map(
            (student) => student.attendanceMark == AttendanceMark.unmarked
                ? student.copyWith(attendanceMark: AttendanceMark.present)
                : student,
          )
          .toList();
      _hasUnsavedChanges = true;
      _filter = null;
    });
  }

  void _updateStudent(String id, AttendanceMark mark) {
    setState(() {
      _students = _students
          .map((student) => student.id == id ? student.copyWith(attendanceMark: mark) : student)
          .toList();
      _hasUnsavedChanges = true;
    });
  }

  void _saveAttendance() {
    _closeWithResult();
  }

  void _closeWithResult() {
    Navigator.of(context).pop(_students);
  }
}
