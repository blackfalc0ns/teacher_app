enum AttendanceMark { unmarked, present, absent, late, excused }

class ClassroomStudent {
  final String id;
  final String name;
  final String seatNumber;
  final AttendanceMark attendanceMark;
  final bool needsFollowUp;
  final bool homeworkSubmitted;
  final String note;

  const ClassroomStudent({
    required this.id,
    required this.name,
    required this.seatNumber,
    required this.attendanceMark,
    required this.needsFollowUp,
    required this.homeworkSubmitted,
    required this.note,
  });

  String get statusLabel {
    switch (attendanceMark) {
      case AttendanceMark.unmarked:
        return 'غير محسوم';
      case AttendanceMark.present:
        return 'حاضر';
      case AttendanceMark.absent:
        return 'غائب';
      case AttendanceMark.late:
        return 'متأخر';
      case AttendanceMark.excused:
        return 'مستأذن';
    }
  }

  bool get isAttendanceResolved => attendanceMark != AttendanceMark.unmarked;

  ClassroomStudent copyWith({
    String? id,
    String? name,
    String? seatNumber,
    AttendanceMark? attendanceMark,
    bool? needsFollowUp,
    bool? homeworkSubmitted,
    String? note,
  }) {
    return ClassroomStudent(
      id: id ?? this.id,
      name: name ?? this.name,
      seatNumber: seatNumber ?? this.seatNumber,
      attendanceMark: attendanceMark ?? this.attendanceMark,
      needsFollowUp: needsFollowUp ?? this.needsFollowUp,
      homeworkSubmitted: homeworkSubmitted ?? this.homeworkSubmitted,
      note: note ?? this.note,
    );
  }
}

class ClassroomAssignment {
  final String title;
  final String dueLabel;
  final String statusLabel;
  final int submittedCount;
  final int totalCount;

  const ClassroomAssignment({
    required this.title,
    required this.dueLabel,
    required this.statusLabel,
    required this.submittedCount,
    required this.totalCount,
  });
}

class ClassroomAttendanceSummary {
  final int unmarkedCount;
  final int presentCount;
  final int absentCount;
  final int lateCount;
  final int excusedCount;
  final int resolvedCount;
  final int totalCount;
  final String lastUpdatedLabel;

  const ClassroomAttendanceSummary({
    required this.unmarkedCount,
    required this.presentCount,
    required this.absentCount,
    required this.lateCount,
    required this.excusedCount,
    required this.resolvedCount,
    required this.totalCount,
    required this.lastUpdatedLabel,
  });

  int get actionableCount => absentCount + lateCount + excusedCount;

  double get completionProgress {
    if (totalCount == 0) {
      return 0;
    }
    return resolvedCount / totalCount;
  }
}
