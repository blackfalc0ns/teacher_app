import '../../../home/data/models/home_data_model.dart';

class TeacherProfileModel {
  final String name;
  final String roleLabel;
  final String schoolName;
  final String avatarUrl;
  final String specialization;
  final String cycleLabel;
  final String employeeId;
  final String experienceLabel;
  final String phone;
  final String email;
  final String officeHours;
  final String statusLabel;
  final int points;
  final int assignedClassesCount;
  final int studentsCount;
  final int weeklyPeriodsCount;
  final int pendingTasksCount;
  final int activeAssignmentsCount;
  final int reviewedItemsCount;
  final double attendanceCommitment;
  final double assignmentsCompletion;
  final List<ProfileHighlight> highlights;
  final List<ProfileInfoItem> accountItems;

  const TeacherProfileModel({
    required this.name,
    required this.roleLabel,
    required this.schoolName,
    required this.avatarUrl,
    required this.specialization,
    required this.cycleLabel,
    required this.employeeId,
    required this.experienceLabel,
    required this.phone,
    required this.email,
    required this.officeHours,
    required this.statusLabel,
    required this.points,
    required this.assignedClassesCount,
    required this.studentsCount,
    required this.weeklyPeriodsCount,
    required this.pendingTasksCount,
    required this.activeAssignmentsCount,
    required this.reviewedItemsCount,
    required this.attendanceCommitment,
    required this.assignmentsCompletion,
    required this.highlights,
    required this.accountItems,
  });

  factory TeacherProfileModel.fromHomeData(HomeDataModel data) {
    final assignedClassesCount = data.weeklySchedule
        .expand((day) => day.items)
        .map((item) => item.className)
        .toSet()
        .length;
    final weeklyPeriodsCount = data.weeklySchedule.fold<int>(
      0,
      (sum, day) => sum + day.items.length,
    );
    final pendingTasksCount = data.actionSummaries.fold<int>(
      0,
      (sum, item) => sum + item.count,
    );
    final activeAssignmentsCount = data.actionSummaries.isNotEmpty
        ? data.actionSummaries.first.count
        : 0;
    final reviewedItemsCount = data.actionSummaries.length > 1
        ? data.actionSummaries[1].count
        : 0;

    return TeacherProfileModel(
      name: data.userInfo.name,
      roleLabel: 'معلم مواد أساسية',
      schoolName: 'مدارس معزز الأهلية',
      avatarUrl: data.userInfo.avatarUrl,
      specialization: 'الرياضيات والعلوم',
      cycleLabel: 'الابتدائية والمتوسطة',
      employeeId: 'TCH-2048',
      experienceLabel: '8 سنوات خبرة',
      phone: '+966 55 102 4587',
      email: 'teacher@moaaz-school.sa',
      officeHours: 'الأحد - الخميس • 7:00 ص إلى 2:00 م',
      statusLabel: 'نشط اليوم',
      points: data.userInfo.points,
      assignedClassesCount: assignedClassesCount,
      studentsCount: assignedClassesCount * 24,
      weeklyPeriodsCount: weeklyPeriodsCount,
      pendingTasksCount: pendingTasksCount,
      activeAssignmentsCount: activeAssignmentsCount,
      reviewedItemsCount: reviewedItemsCount,
      attendanceCommitment: 0.94,
      assignmentsCompletion: 0.89,
      highlights: const [
        ProfileHighlight(
          title: 'جاهزية الحصص',
          value: 'مرتفعة',
          note: 'تحضير منتظم وتحديث أسبوعي للمحتوى.',
        ),
        ProfileHighlight(
          title: 'متابعة الواجبات',
          value: 'جيدة جدًا',
          note: 'تصحيح سريع وملاحظات واضحة للطلاب.',
        ),
        ProfileHighlight(
          title: 'التواصل',
          value: 'فعّال',
          note: 'استجابة جيدة للرسائل والمتابعات اليومية.',
        ),
      ],
      accountItems: const [
        ProfileInfoItem(
          label: 'الرقم الوظيفي',
          value: 'TCH-2048',
        ),
        ProfileInfoItem(
          label: 'نوع الحساب',
          value: 'حساب معلم',
        ),
        ProfileInfoItem(
          label: 'آخر مزامنة',
          value: 'اليوم • 12:45 م',
        ),
        ProfileInfoItem(
          label: 'المنطقة الزمنية',
          value: 'السعودية',
        ),
      ],
    );
  }
}

class ProfileHighlight {
  final String title;
  final String value;
  final String note;

  const ProfileHighlight({
    required this.title,
    required this.value,
    required this.note,
  });
}

class ProfileInfoItem {
  final String label;
  final String value;

  const ProfileInfoItem({
    required this.label,
    required this.value,
  });
}
