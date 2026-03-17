import '../../../schedule/data/model/schedule_model.dart';

class TeacherClassModel {
  final String id;
  final String cycleName;
  final String gradeName;
  final String sectionName;
  final String subjectName;
  final String roomName;
  final int studentsCount;
  final int weeklyPeriods;
  final int todayPeriods;
  final int followUpCount;
  final int pendingAttendanceCount;
  final int activeAssignmentsCount;
  final int pendingReviewCount;
  final bool needsPreparation;
  final String nextSessionLabel;
  final String note;
  final List<String> weeklyDays;
  final ScheduleModel focusItem;

  const TeacherClassModel({
    required this.id,
    required this.cycleName,
    required this.gradeName,
    required this.sectionName,
    required this.subjectName,
    required this.roomName,
    required this.studentsCount,
    required this.weeklyPeriods,
    required this.todayPeriods,
    required this.followUpCount,
    required this.pendingAttendanceCount,
    required this.activeAssignmentsCount,
    required this.pendingReviewCount,
    required this.needsPreparation,
    required this.nextSessionLabel,
    required this.note,
    required this.weeklyDays,
    required this.focusItem,
  });

  String get classLabel => '$gradeName / شعبة $sectionName';

  String get cycleAndRoomLabel => '$cycleName • $roomName';

  bool get needsAttention =>
      pendingAttendanceCount > 0 ||
      pendingReviewCount > 0 ||
      followUpCount > 0 ||
      needsPreparation;
}