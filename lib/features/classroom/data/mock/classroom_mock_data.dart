import '../../../schedule/data/model/schedule_model.dart';
import '../models/classroom_model.dart';

class ClassroomMockData {
  static List<ClassroomStudent> buildStudents(ScheduleModel item) {
    return List.generate(item.studentsCount, (index) {
      final mark = _buildAttendanceMark(item, index);
      final needsFollowUp = index % 7 == 0 || mark == AttendanceMark.late || mark == AttendanceMark.absent;
      final homeworkSubmitted = !item.hasHomework || index % 4 != 0;

      return ClassroomStudent(
        id: '${item.id}-$index',
        name: 'الطالب ${index + 1}',
        seatNumber: '${index + 1}'.padLeft(2, '0'),
        attendanceMark: mark,
        needsFollowUp: needsFollowUp,
        homeworkSubmitted: homeworkSubmitted,
        note: needsFollowUp
            ? 'يحتاج متابعة في المشاركة أو الواجب أو الانضباط.'
            : 'أداء مستقر داخل الفصل.',
      );
    });
  }

  static List<ClassroomAssignment> buildAssignments(ScheduleModel item) {
    return [
      ClassroomAssignment(
        title: item.hasHomework ? 'واجب ${item.subjectName}' : 'نشاط ${item.subjectName}',
        dueLabel: item.hasHomework ? 'التسليم غدًا' : 'خلال الحصة',
        statusLabel: item.hasHomework ? 'نشط' : 'صفي',
        submittedCount: item.hasHomework ? item.studentsCount - 5 : 0,
        totalCount: item.studentsCount,
      ),
      ClassroomAssignment(
        title: 'متابعة المشاركة',
        dueLabel: 'نهاية الأسبوع',
        statusLabel: 'رصد',
        submittedCount: item.studentsCount - 2,
        totalCount: item.studentsCount,
      ),
    ];
  }

  static ClassroomAttendanceSummary buildAttendanceSummary({
    required List<ClassroomStudent> students,
    required bool attendancePending,
  }) {
    final unmarkedCount = students.where((student) => student.attendanceMark == AttendanceMark.unmarked).length;
    final presentCount = students.where((student) => student.attendanceMark == AttendanceMark.present).length;
    final absentCount = students.where((student) => student.attendanceMark == AttendanceMark.absent).length;
    final lateCount = students.where((student) => student.attendanceMark == AttendanceMark.late).length;
    final excusedCount = students.where((student) => student.attendanceMark == AttendanceMark.excused).length;
    final resolvedCount = students.where((student) => student.isAttendanceResolved).length;

    return ClassroomAttendanceSummary(
      unmarkedCount: unmarkedCount,
      presentCount: presentCount,
      absentCount: absentCount,
      lateCount: lateCount,
      excusedCount: excusedCount,
      resolvedCount: resolvedCount,
      totalCount: students.length,
      lastUpdatedLabel: attendancePending
          ? 'بانتظار اعتماد الحضور'
          : unmarkedCount > 0
              ? 'يوجد طلاب غير محسومين'
              : 'تم التحديث قبل قليل',
    );
  }

  static AttendanceMark _buildAttendanceMark(ScheduleModel item, int index) {
    if (item.needsAttendance) {
      if (index < 3) {
        return AttendanceMark.unmarked;
      }
      if (index == 3) {
        return AttendanceMark.late;
      }
      return AttendanceMark.present;
    }

    if (index == 1) return AttendanceMark.absent;
    if (index == 4) return AttendanceMark.excused;
    if (index == 7) return AttendanceMark.late;
    return AttendanceMark.present;
  }
}
