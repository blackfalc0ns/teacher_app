enum TeacherTaskSource { teacher, parent, system }

enum TeacherTaskStatus { pending, inProgress, completed, underReview }

enum TeacherTaskProofType { image, document, none }

enum TeacherTaskRewardType { financial, moral }

class TeacherTaskStageModel {
  final String id;
  final String title;
  final bool isCompleted;
  final bool isApproved;
  final bool requiresApproval;
  final TeacherTaskProofType proofType;
  final String? proofPath;
  final String? teacherNote;

  const TeacherTaskStageModel({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.isApproved = false,
    this.requiresApproval = true,
    this.proofType = TeacherTaskProofType.none,
    this.proofPath,
    this.teacherNote,
  });

  TeacherTaskStageModel copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    bool? isApproved,
    bool? requiresApproval,
    TeacherTaskProofType? proofType,
    String? proofPath,
    String? teacherNote,
  }) {
    return TeacherTaskStageModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      isApproved: isApproved ?? this.isApproved,
      requiresApproval: requiresApproval ?? this.requiresApproval,
      proofType: proofType ?? this.proofType,
      proofPath: proofPath ?? this.proofPath,
      teacherNote: teacherNote ?? this.teacherNote,
    );
  }
}

class TeacherTaskStudentModel {
  final String id;
  final String name;
  final String classId;
  final String cycleName;
  final String gradeName;
  final String sectionName;

  const TeacherTaskStudentModel({
    required this.id,
    required this.name,
    required this.classId,
    required this.cycleName,
    required this.gradeName,
    required this.sectionName,
  });

  String get classLabel => '$gradeName / شعبة $sectionName';
}

class TeacherTaskClassOption {
  final String id;
  final String cycleName;
  final String gradeName;
  final String sectionName;
  final String subjectName;
  final int studentsCount;

  const TeacherTaskClassOption({
    required this.id,
    required this.cycleName,
    required this.gradeName,
    required this.sectionName,
    required this.subjectName,
    required this.studentsCount,
  });

  String get label => '$gradeName / شعبة $sectionName';

  String get subtitle => '$cycleName • $subjectName';
}

class TeacherStudentTaskModel {
  final String id;
  final String title;
  final String? description;
  final TeacherTaskSource source;
  final TeacherTaskStatus status;
  final TeacherTaskRewardType rewardType;
  final String rewardValue;
  final double progress;
  final DateTime dueDate;
  final String subjectName;
  final String classId;
  final String cycleName;
  final String gradeName;
  final String sectionName;
  final String studentId;
  final String studentName;
  final List<TeacherTaskStageModel> stages;

  const TeacherStudentTaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.source,
    required this.status,
    required this.rewardType,
    required this.rewardValue,
    required this.progress,
    required this.dueDate,
    required this.subjectName,
    required this.classId,
    required this.cycleName,
    required this.gradeName,
    required this.sectionName,
    required this.studentId,
    required this.studentName,
    required this.stages,
  });

  TeacherStudentTaskModel copyWith({
    String? id,
    String? title,
    String? description,
    TeacherTaskSource? source,
    TeacherTaskStatus? status,
    TeacherTaskRewardType? rewardType,
    String? rewardValue,
    double? progress,
    DateTime? dueDate,
    String? subjectName,
    String? classId,
    String? cycleName,
    String? gradeName,
    String? sectionName,
    String? studentId,
    String? studentName,
    List<TeacherTaskStageModel>? stages,
  }) {
    return TeacherStudentTaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      source: source ?? this.source,
      status: status ?? this.status,
      rewardType: rewardType ?? this.rewardType,
      rewardValue: rewardValue ?? this.rewardValue,
      progress: progress ?? this.progress,
      dueDate: dueDate ?? this.dueDate,
      subjectName: subjectName ?? this.subjectName,
      classId: classId ?? this.classId,
      cycleName: cycleName ?? this.cycleName,
      gradeName: gradeName ?? this.gradeName,
      sectionName: sectionName ?? this.sectionName,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      stages: stages ?? this.stages,
    );
  }

  String get classLabel => '$gradeName / شعبة $sectionName';

  String get cycleClassLabel => '$cycleName • $gradeName • شعبة $sectionName';

  int get completedStagesCount => stages.where((stage) => stage.isCompleted).length;

  int get approvedStagesCount => stages.where((stage) => stage.isApproved).length;

  int get pendingApprovalsCount => stages
      .where((stage) => stage.isCompleted && stage.requiresApproval && !stage.isApproved)
      .length;

  bool get hasPendingApprovals => pendingApprovalsCount > 0;

  bool get isActive =>
      status == TeacherTaskStatus.pending ||
      status == TeacherTaskStatus.inProgress ||
      status == TeacherTaskStatus.underReview;
}

class TeacherTaskDashboardModel {
  final List<TeacherTaskClassOption> assignedClasses;
  final List<TeacherTaskStudentModel> students;
  final List<TeacherStudentTaskModel> tasks;

  const TeacherTaskDashboardModel({
    required this.assignedClasses,
    required this.students,
    required this.tasks,
  });

  int get activeTasksCount => tasks.where((task) => task.isActive && !task.hasPendingApprovals).length;

  int get pendingApprovalTasksCount => tasks.where((task) => task.hasPendingApprovals).length;

  int get completedTasksCount => tasks.where((task) => task.status == TeacherTaskStatus.completed).length;
}
