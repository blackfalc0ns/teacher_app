import '../../../home/data/models/home_data_model.dart';

class TeacherEmploymentModel {
  final String employeeId;
  final String jobTitle;
  final String department;
  final String schoolName;
  final String employmentType;
  final String workStatus;
  final String directManager;
  final String startDateLabel;
  final String experienceLabel;
  final String specialization;
  final String stageAssignment;
  final List<String> subjects;
  final List<String> assignedClasses;
  final int studentsCount;
  final int weeklyPeriodsCount;
  final int officeHoursCount;
  final String workDaysLabel;
  final List<String> permissions;
  final List<String> responsibilities;
  final List<EmploymentInfoItem> organizationalInfo;
  final List<EmploymentInfoItem> workloadInfo;

  const TeacherEmploymentModel({
    required this.employeeId,
    required this.jobTitle,
    required this.department,
    required this.schoolName,
    required this.employmentType,
    required this.workStatus,
    required this.directManager,
    required this.startDateLabel,
    required this.experienceLabel,
    required this.specialization,
    required this.stageAssignment,
    required this.subjects,
    required this.assignedClasses,
    required this.studentsCount,
    required this.weeklyPeriodsCount,
    required this.officeHoursCount,
    required this.workDaysLabel,
    required this.permissions,
    required this.responsibilities,
    required this.organizationalInfo,
    required this.workloadInfo,
  });

  factory TeacherEmploymentModel.fromHomeData(HomeDataModel data) {
    final allItems = data.weeklySchedule.expand((day) => day.items).toList(growable: false);
    final assignedClasses = allItems
        .map((item) => item.className)
        .toSet()
        .toList(growable: false);
    final subjects = allItems
        .map((item) => item.subject)
        .toSet()
        .toList(growable: false);
    final weeklyPeriodsCount = allItems.length;

    return TeacherEmploymentModel(
      employeeId: 'TCH-2048',
      jobTitle: 'معلم مواد أساسية',
      department: 'القسم الأكاديمي',
      schoolName: 'مدارس معزز الأهلية',
      employmentType: 'دوام كامل',
      workStatus: 'على رأس العمل',
      directManager: 'وكيل الشؤون التعليمية',
      startDateLabel: '15 أغسطس 2018',
      experienceLabel: '8 سنوات خبرة',
      specialization: 'الرياضيات والعلوم',
      stageAssignment: 'المرحلة الابتدائية والمتوسطة',
      subjects: subjects,
      assignedClasses: assignedClasses,
      studentsCount: assignedClasses.length * 24,
      weeklyPeriodsCount: weeklyPeriodsCount,
      officeHoursCount: 35,
      workDaysLabel: 'الأحد - الخميس',
      permissions: const [
        'عرض وإدارة الجدول الدراسي',
        'فتح الفصل وأخذ الحضور',
        'إنشاء الواجبات ومتابعة التسليمات',
        'الوصول إلى ملفات الطلاب المسندين',
        'التواصل مع الإدارة وأولياء الأمور عبر الرسائل',
      ],
      responsibilities: const [
        'الالتزام برصد الحضور اليومي في وقته',
        'متابعة الواجبات وإغلاق التصحيح بانتظام',
        'رفع الملاحظات الأكاديمية والسلوكية عند الحاجة',
        'تحديث التحضير والمحتوى التعليمي للحصص',
      ],
      organizationalInfo: const [
        EmploymentInfoItem(label: 'الرقم الوظيفي', value: 'TCH-2048'),
        EmploymentInfoItem(label: 'نوع التوظيف', value: 'دوام كامل'),
        EmploymentInfoItem(label: 'الحالة الوظيفية', value: 'على رأس العمل'),
        EmploymentInfoItem(label: 'المدير المباشر', value: 'وكيل الشؤون التعليمية'),
        EmploymentInfoItem(label: 'تاريخ المباشرة', value: '15 أغسطس 2018'),
      ],
      workloadInfo: [
        EmploymentInfoItem(label: 'عدد الفصول المسندة', value: '${assignedClasses.length}'),
        EmploymentInfoItem(label: 'عدد المواد', value: '${subjects.length}'),
        EmploymentInfoItem(label: 'عدد الطلاب', value: '${assignedClasses.length * 24}'),
        EmploymentInfoItem(label: 'الحصص الأسبوعية', value: '$weeklyPeriodsCount'),
        EmploymentInfoItem(label: 'ساعات العمل', value: '35 ساعة أسبوعيًا'),
      ],
    );
  }
}

class EmploymentInfoItem {
  final String label;
  final String value;

  const EmploymentInfoItem({
    required this.label,
    required this.value,
  });
}
