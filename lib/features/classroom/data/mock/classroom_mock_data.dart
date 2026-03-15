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
    final mathQuestions = [
      ClassroomQuestion(
        id: '${item.id}-q1',
        type: AssignmentQuestionType.multipleChoice,
        title: 'ما القيمة المنزلية للرقم 6 في العدد 8642؟',
        points: 2,
        options: const [
          AssignmentOption(id: 'a', text: '6'),
          AssignmentOption(id: 'b', text: '60'),
          AssignmentOption(id: 'c', text: '600', isCorrect: true),
          AssignmentOption(id: 'd', text: '6000'),
        ],
        explanation: 'الرقم 6 في منزلة المئات.',
      ),
      ClassroomQuestion(
        id: '${item.id}-q2',
        type: AssignmentQuestionType.trueFalse,
        title: 'العدد 350 أكبر من العدد 305.',
        points: 1,
        options: const [
          AssignmentOption(id: 'a', text: 'صح', isCorrect: true),
          AssignmentOption(id: 'b', text: 'خطأ'),
        ],
      ),
      ClassroomQuestion(
        id: '${item.id}-q3',
        type: AssignmentQuestionType.shortAnswer,
        title: 'اكتب العدد القياسي للناتج: 3000 + 400 + 20 + 1',
        points: 3,
        expectedAnswer: '3421',
      ),
      ClassroomQuestion(
        id: '${item.id}-q4',
        type: AssignmentQuestionType.fillInBlank,
        title: 'أكمل: منزلة الآحاد في العدد 7,430 هي ____',
        points: 2,
        expectedAnswer: '0',
      ),
    ];

    final writingQuestions = [
      ClassroomQuestion(
        id: '${item.id}-q5',
        type: AssignmentQuestionType.essay,
        title: 'اشرح بخطواتك كيف تميز بين العدد والقيمة المنزلية.',
        points: 5,
        expectedAnswer: 'يذكر الطالب المنزلة ثم قيمة الرقم بحسب موقعه.',
      ),
      ClassroomQuestion(
        id: '${item.id}-q6',
        type: AssignmentQuestionType.matching,
        title: 'صل بين كل منزلة والقيمة المناسبة لها.',
        points: 3,
        options: const [
          AssignmentOption(id: 'a', text: 'الآحاد -> 1', isCorrect: true),
          AssignmentOption(id: 'b', text: 'العشرات -> 10', isCorrect: true),
          AssignmentOption(id: 'c', text: 'المئات -> 100', isCorrect: true),
        ],
        expectedAnswer: 'الآحاد 1، العشرات 10، المئات 100',
      ),
    ];

    return [
      ClassroomAssignment(
        id: '${item.id}-assignment-1',
        title: item.hasHomework ? 'واجب ${item.subjectName}' : 'نشاط ${item.subjectName}',
        dueLabel: item.hasHomework ? 'غدًا 7:00 م' : 'اليوم 12:30 م',
        statusLabel: item.hasHomework ? 'نشط' : 'صفي',
        totalCount: item.studentsCount,
        targetLabel: item.className,
        modeLabel: item.hasHomework ? 'واجب منزلي' : 'نشاط صفي',
        instructions: item.hasHomework
            ? 'ابدأ بالأسئلة الموضوعية ثم أجب عن السؤال القصير في النهاية.'
            : 'حل النشاط داخل الحصة وارفع الإجابات قبل نهاية الوقت.',
        totalMarks: 20,
        estimatedMinutes: 20,
        publishNow: true,
        randomizeQuestions: item.hasHomework,
        questions: mathQuestions,
        submissions: _buildSubmissions(item, mathQuestions),
      ),
      ClassroomAssignment(
        id: '${item.id}-assignment-2',
        title: 'مهمة كتابية ${item.subjectName}',
        dueLabel: 'الخميس 8:00 م',
        statusLabel: 'بانتظار المراجعة',
        totalCount: item.studentsCount,
        targetLabel: 'طلاب المتابعة',
        modeLabel: 'مهمة كتابية',
        instructions: 'اكتب إجاباتك في فقرات قصيرة وواضحة مع مثال واحد على الأقل.',
        totalMarks: 8,
        estimatedMinutes: 15,
        publishNow: false,
        randomizeQuestions: false,
        questions: writingQuestions,
        submissions: _buildWritingSubmissions(item, writingQuestions),
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

  static List<AssignmentSubmission> _buildSubmissions(
    ScheduleModel item,
    List<ClassroomQuestion> questions,
  ) {
    return [
      AssignmentSubmission(
        studentId: '${item.id}-0',
        studentName: 'الطالب 1',
        submittedAtLabel: 'اليوم 10:30 ص',
        status: AssignmentSubmissionStatus.reviewed,
        score: 17,
        maxScore: 20,
        feedback: 'إجابة جيدة، راجع السؤال الكتابي الأخير.',
        answers: [
          StudentQuestionAnswer(questionId: questions[0].id, studentAnswer: '600', correctAnswer: questions[0].correctAnswerLabel, isCorrect: true, score: 2, maxScore: 2),
          StudentQuestionAnswer(questionId: questions[1].id, studentAnswer: 'صح', correctAnswer: questions[1].correctAnswerLabel, isCorrect: true, score: 1, maxScore: 1),
          StudentQuestionAnswer(questionId: questions[2].id, studentAnswer: '3421', correctAnswer: questions[2].correctAnswerLabel, isCorrect: true, score: 3, maxScore: 3),
          StudentQuestionAnswer(questionId: questions[3].id, studentAnswer: '1', correctAnswer: questions[3].correctAnswerLabel, isCorrect: false, score: 1, maxScore: 2),
        ],
      ),
      AssignmentSubmission(
        studentId: '${item.id}-1',
        studentName: 'الطالب 2',
        submittedAtLabel: 'اليوم 10:44 ص',
        status: AssignmentSubmissionStatus.submitted,
        score: 14,
        maxScore: 20,
        feedback: 'بانتظار اعتماد الدرجة النهائية.',
        answers: [
          StudentQuestionAnswer(questionId: questions[0].id, studentAnswer: '600', correctAnswer: questions[0].correctAnswerLabel, isCorrect: true, score: 2, maxScore: 2),
          StudentQuestionAnswer(questionId: questions[1].id, studentAnswer: 'خطأ', correctAnswer: questions[1].correctAnswerLabel, isCorrect: false, score: 0, maxScore: 1),
          StudentQuestionAnswer(questionId: questions[2].id, studentAnswer: '3412', correctAnswer: questions[2].correctAnswerLabel, isCorrect: false, score: 1, maxScore: 3),
          StudentQuestionAnswer(questionId: questions[3].id, studentAnswer: '0', correctAnswer: questions[3].correctAnswerLabel, isCorrect: true, score: 2, maxScore: 2),
        ],
      ),
      AssignmentSubmission(
        studentId: '${item.id}-2',
        studentName: 'الطالب 3',
        submittedAtLabel: 'لم يسلّم',
        status: AssignmentSubmissionStatus.notSubmitted,
        score: 0,
        maxScore: 20,
        feedback: 'لم يتم رفع الحل حتى الآن.',
        answers: const [],
      ),
      AssignmentSubmission(
        studentId: '${item.id}-3',
        studentName: 'الطالب 4',
        submittedAtLabel: 'اليوم 11:10 ص',
        status: AssignmentSubmissionStatus.late,
        score: 12,
        maxScore: 20,
        feedback: 'تسليم متأخر مع نقص في السؤالين الأخيرين.',
        answers: [
          StudentQuestionAnswer(questionId: questions[0].id, studentAnswer: '6000', correctAnswer: questions[0].correctAnswerLabel, isCorrect: false, score: 0, maxScore: 2),
          StudentQuestionAnswer(questionId: questions[1].id, studentAnswer: 'صح', correctAnswer: questions[1].correctAnswerLabel, isCorrect: true, score: 1, maxScore: 1),
        ],
      ),
    ];
  }

  static List<AssignmentSubmission> _buildWritingSubmissions(
    ScheduleModel item,
    List<ClassroomQuestion> questions,
  ) {
    return [
      AssignmentSubmission(
        studentId: '${item.id}-4',
        studentName: 'الطالب 5',
        submittedAtLabel: 'أمس 8:10 م',
        status: AssignmentSubmissionStatus.reviewed,
        score: 7,
        maxScore: 8,
        feedback: 'صياغة جيدة مع مثال واضح.',
        answers: [
          StudentQuestionAnswer(questionId: questions[0].id, studentAnswer: 'أحدد المنزلة أولاً ثم أكتب قيمة الرقم حسب موقعه.', correctAnswer: questions[0].correctAnswerLabel, isCorrect: null, score: 4, maxScore: 5),
          StudentQuestionAnswer(questionId: questions[1].id, studentAnswer: 'الآحاد 1، العشرات 10، المئات 100', correctAnswer: questions[1].correctAnswerLabel, isCorrect: true, score: 3, maxScore: 3),
        ],
      ),
      AssignmentSubmission(
        studentId: '${item.id}-5',
        studentName: 'الطالب 6',
        submittedAtLabel: 'أمس 8:20 م',
        status: AssignmentSubmissionStatus.submitted,
        score: 5,
        maxScore: 8,
        feedback: 'يحتاج مراجعة السؤال المقالي.',
        answers: [
          StudentQuestionAnswer(questionId: questions[0].id, studentAnswer: 'القيمة المنزلية هي مكان الرقم.', correctAnswer: questions[0].correctAnswerLabel, isCorrect: null, score: 2, maxScore: 5),
          StudentQuestionAnswer(questionId: questions[1].id, studentAnswer: 'الآحاد 1، العشرات 100', correctAnswer: questions[1].correctAnswerLabel, isCorrect: false, score: 1, maxScore: 3),
        ],
      ),
    ];
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
