import '../../../classroom/data/models/classroom_model.dart';
import '../../../my_classes/data/models/teacher_class_model.dart';
import '../../../schedule/data/model/schedule_model.dart';

class HomeworkDashboardData {
  final List<HomeworkDashboardClass> classes;

  const HomeworkDashboardData({required this.classes});

  List<ClassroomAssignment> get allAssignments {
    return classes
        .expand((item) => item.assignments)
        .toList(growable: false);
  }

  int get classesCount => classes.length;

  int get assignmentsCount => allAssignments.length;

  int get draftsCount =>
      allAssignments.where((item) => !item.publishNow).length;

  int get pendingReviewCount => allAssignments.fold<int>(
        0,
        (sum, item) =>
            sum +
            item.submissions.where((submission) {
              return submission.status == AssignmentSubmissionStatus.submitted ||
                  submission.status == AssignmentSubmissionStatus.late;
            }).length,
      );

  int get missingSubmissionCount => allAssignments.fold<int>(
        0,
        (sum, item) =>
            sum +
            item.submissions.where((submission) {
              return submission.status ==
                  AssignmentSubmissionStatus.notSubmitted;
            }).length,
      );

  int get reviewedSubmissionsCount => allAssignments.fold<int>(
        0,
        (sum, item) =>
            sum +
            item.submissions.where((submission) {
              return submission.status ==
                  AssignmentSubmissionStatus.reviewed;
            }).length,
      );
}

class HomeworkDashboardClass {
  final TeacherClassModel teacherClass;
  final List<ClassroomAssignment> assignments;

  const HomeworkDashboardClass({
    required this.teacherClass,
    required this.assignments,
  });

  String get id => teacherClass.id;
  String get cycleName => teacherClass.cycleName;
  String get gradeName => teacherClass.gradeName;
  String get sectionName => teacherClass.sectionName;
  String get subjectName => teacherClass.subjectName;
  int get studentsCount => teacherClass.studentsCount;
  bool get needsAttention =>
      pendingReviewCount > 0 || missingSubmissionCount > 0;
  List<String> get weeklyDays => teacherClass.weeklyDays;
  String get nextSessionLabel => teacherClass.nextSessionLabel;
  ScheduleModel get focusItem => teacherClass.focusItem;
  String get classLabel => teacherClass.classLabel;
  String get cycleAndRoomLabel => teacherClass.cycleAndRoomLabel;

  int get activeAssignmentsCount =>
      assignments.where((item) => item.publishNow).length;

  int get draftsCount =>
      assignments.where((item) => !item.publishNow).length;

  int get pendingReviewCount => assignments.fold<int>(
        0,
        (sum, item) =>
            sum +
            item.submissions.where((submission) {
              return submission.status == AssignmentSubmissionStatus.submitted ||
                  submission.status == AssignmentSubmissionStatus.late;
            }).length,
      );

  int get missingSubmissionCount => assignments.fold<int>(
        0,
        (sum, item) =>
            sum +
            item.submissions.where((submission) {
              return submission.status ==
                  AssignmentSubmissionStatus.notSubmitted;
            }).length,
      );
}
