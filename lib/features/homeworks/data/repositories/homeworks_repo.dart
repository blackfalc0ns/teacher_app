import '../../../classroom/data/mock/classroom_mock_data.dart';
import '../../../classroom/data/models/classroom_model.dart';
import '../../../my_classes/data/models/teacher_class_model.dart';
import '../../../my_classes/data/repositories/my_classes_repo.dart';
import '../models/homework_dashboard_model.dart';

class HomeworksRepo {
  final MyClassesRepo _myClassesRepo = MyClassesRepo();

  Future<HomeworkDashboardData> getDashboard() async {
    final classes = await _myClassesRepo.getTeacherClasses();
    final dashboardClasses = classes
        .map(_buildDashboardClass)
        .toList(growable: false);
    return HomeworkDashboardData(classes: dashboardClasses);
  }

  HomeworkDashboardClass _buildDashboardClass(TeacherClassModel teacherClass) {
    final assignments = ClassroomMockData.buildAssignments(teacherClass.focusItem);
    final enrichedAssignments = [
      ...assignments,
      if (teacherClass.pendingReviewCount > 4)
        _buildDraftAssignment(teacherClass),
    ];

    return HomeworkDashboardClass(
      teacherClass: teacherClass,
      assignments: enrichedAssignments,
    );
  }

  ClassroomAssignment _buildDraftAssignment(TeacherClassModel teacherClass) {
    return ClassroomAssignment(
      id: '${teacherClass.id}-draft',
      title: 'مسودة متابعة ${teacherClass.subjectName}',
      dueLabel: 'لم يحدد بعد',
      statusLabel: 'مسودة',
      totalCount: teacherClass.studentsCount,
      targetLabel: teacherClass.classLabel,
      modeLabel: 'واجب علاجي',
      instructions:
          'أسئلة قصيرة لمعالجة الفجوات لدى الطلاب الذين انخفض أداؤهم في آخر تقييم.',
      totalMarks: 10,
      estimatedMinutes: 12,
      publishNow: false,
      randomizeQuestions: false,
      questions: const [
        ClassroomQuestion(
          id: 'draft-q1',
          type: AssignmentQuestionType.shortAnswer,
          title: 'اكتب القاعدة الأساسية للدرس بأسلوبك.',
          points: 5,
          expectedAnswer: 'يذكر الطالب القاعدة الأساسية بصورة صحيحة.',
        ),
        ClassroomQuestion(
          id: 'draft-q2',
          type: AssignmentQuestionType.multipleChoice,
          title: 'اختر التطبيق الصحيح للقاعدة.',
          points: 5,
          options: [
            AssignmentOption(id: '1', text: 'الخيار الأول'),
            AssignmentOption(id: '2', text: 'الخيار الثاني', isCorrect: true),
            AssignmentOption(id: '3', text: 'الخيار الثالث'),
            AssignmentOption(id: '4', text: 'الخيار الرابع'),
          ],
        ),
      ],
      submissions: const [],
    );
  }
}
