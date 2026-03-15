enum AttendanceMark { unmarked, present, absent, late, excused }

enum AssignmentQuestionType {
  multipleChoice,
  trueFalse,
  shortAnswer,
  essay,
  fillInBlank,
  matching,
}

enum AssignmentSubmissionStatus { notSubmitted, submitted, reviewed, late }

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

class AssignmentOption {
  final String id;
  final String text;
  final bool isCorrect;

  const AssignmentOption({
    required this.id,
    required this.text,
    this.isCorrect = false,
  });
}

class ClassroomQuestion {
  final String id;
  final AssignmentQuestionType type;
  final String title;
  final int points;
  final List<AssignmentOption> options;
  final String expectedAnswer;
  final String explanation;

  const ClassroomQuestion({
    required this.id,
    required this.type,
    required this.title,
    required this.points,
    this.options = const [],
    this.expectedAnswer = '',
    this.explanation = '',
  });

  bool get usesOptions {
    return type == AssignmentQuestionType.multipleChoice ||
        type == AssignmentQuestionType.trueFalse ||
        type == AssignmentQuestionType.matching;
  }

  String get correctAnswerLabel {
    if (expectedAnswer.trim().isNotEmpty) {
      return expectedAnswer;
    }
    final correctOptions = options.where((option) => option.isCorrect).map((option) => option.text).toList();
    if (correctOptions.isEmpty) {
      return 'غير محدد';
    }
    return correctOptions.join('، ');
  }
}

class StudentQuestionAnswer {
  final String questionId;
  final String studentAnswer;
  final String correctAnswer;
  final bool? isCorrect;
  final int score;
  final int maxScore;

  const StudentQuestionAnswer({
    required this.questionId,
    required this.studentAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    required this.score,
    required this.maxScore,
  });

  StudentQuestionAnswer copyWith({
    String? questionId,
    String? studentAnswer,
    String? correctAnswer,
    bool? isCorrect,
    bool clearCorrectness = false,
    int? score,
    int? maxScore,
  }) {
    return StudentQuestionAnswer(
      questionId: questionId ?? this.questionId,
      studentAnswer: studentAnswer ?? this.studentAnswer,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      isCorrect: clearCorrectness ? null : (isCorrect ?? this.isCorrect),
      score: score ?? this.score,
      maxScore: maxScore ?? this.maxScore,
    );
  }
}

class AssignmentSubmission {
  final String studentId;
  final String studentName;
  final String submittedAtLabel;
  final AssignmentSubmissionStatus status;
  final int score;
  final int maxScore;
  final String feedback;
  final List<StudentQuestionAnswer> answers;

  const AssignmentSubmission({
    required this.studentId,
    required this.studentName,
    required this.submittedAtLabel,
    required this.status,
    required this.score,
    required this.maxScore,
    required this.feedback,
    required this.answers,
  });

  String get statusLabel {
    switch (status) {
      case AssignmentSubmissionStatus.notSubmitted:
        return 'لم يسلّم';
      case AssignmentSubmissionStatus.submitted:
        return 'بانتظار التصحيح';
      case AssignmentSubmissionStatus.reviewed:
        return 'مصَحح';
      case AssignmentSubmissionStatus.late:
        return 'تسليم متأخر';
    }
  }

  AssignmentSubmission copyWith({
    String? studentId,
    String? studentName,
    String? submittedAtLabel,
    AssignmentSubmissionStatus? status,
    int? score,
    int? maxScore,
    String? feedback,
    List<StudentQuestionAnswer>? answers,
  }) {
    return AssignmentSubmission(
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      submittedAtLabel: submittedAtLabel ?? this.submittedAtLabel,
      status: status ?? this.status,
      score: score ?? this.score,
      maxScore: maxScore ?? this.maxScore,
      feedback: feedback ?? this.feedback,
      answers: answers ?? this.answers,
    );
  }
}

class ClassroomAssignment {
  final String id;
  final String title;
  final String dueLabel;
  final String statusLabel;
  final int totalCount;
  final String targetLabel;
  final String modeLabel;
  final String instructions;
  final int totalMarks;
  final int estimatedMinutes;
  final bool publishNow;
  final bool randomizeQuestions;
  final List<ClassroomQuestion> questions;
  final List<AssignmentSubmission> submissions;

  const ClassroomAssignment({
    required this.id,
    required this.title,
    required this.dueLabel,
    required this.statusLabel,
    required this.totalCount,
    required this.targetLabel,
    required this.modeLabel,
    required this.instructions,
    required this.totalMarks,
    required this.estimatedMinutes,
    required this.publishNow,
    required this.randomizeQuestions,
    required this.questions,
    required this.submissions,
  });

  int get submittedCount {
    return submissions.where((submission) => submission.status != AssignmentSubmissionStatus.notSubmitted).length;
  }

  int get reviewedCount {
    return submissions.where((submission) => submission.status == AssignmentSubmissionStatus.reviewed).length;
  }

  int get questionsCount => questions.length;

  List<AssignmentQuestionType> get questionTypes {
    return questions.map((question) => question.type).toSet().toList(growable: false);
  }

  Map<AssignmentQuestionType, int> get questionCounts {
    final counts = <AssignmentQuestionType, int>{};
    for (final question in questions) {
      counts.update(question.type, (value) => value + 1, ifAbsent: () => 1);
    }
    return counts;
  }

  ClassroomAssignment copyWith({
    String? id,
    String? title,
    String? dueLabel,
    String? statusLabel,
    int? totalCount,
    String? targetLabel,
    String? modeLabel,
    String? instructions,
    int? totalMarks,
    int? estimatedMinutes,
    bool? publishNow,
    bool? randomizeQuestions,
    List<ClassroomQuestion>? questions,
    List<AssignmentSubmission>? submissions,
  }) {
    return ClassroomAssignment(
      id: id ?? this.id,
      title: title ?? this.title,
      dueLabel: dueLabel ?? this.dueLabel,
      statusLabel: statusLabel ?? this.statusLabel,
      totalCount: totalCount ?? this.totalCount,
      targetLabel: targetLabel ?? this.targetLabel,
      modeLabel: modeLabel ?? this.modeLabel,
      instructions: instructions ?? this.instructions,
      totalMarks: totalMarks ?? this.totalMarks,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      publishNow: publishNow ?? this.publishNow,
      randomizeQuestions: randomizeQuestions ?? this.randomizeQuestions,
      questions: questions ?? this.questions,
      submissions: submissions ?? this.submissions,
    );
  }
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
