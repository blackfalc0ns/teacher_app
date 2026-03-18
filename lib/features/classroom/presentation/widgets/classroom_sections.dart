import 'package:flutter/material.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../schedule/data/model/schedule_model.dart';
import '../../data/models/classroom_model.dart';
import 'classroom_section_card.dart';

class ClassroomOverviewSection extends StatelessWidget {
  final ScheduleModel item;
  final ClassroomAttendanceSummary attendance;
  final List<ClassroomAssignment> assignments;
  final List<ClassroomStudent> students;

  const ClassroomOverviewSection({
    super.key,
    required this.item,
    required this.attendance,
    required this.assignments,
    required this.students,
  });

  @override
  Widget build(BuildContext context) {
    final followUp = students
        .where((student) => student.needsFollowUp)
        .take(4)
        .toList(growable: false);

    return Column(
      children: [
        ClassroomSectionCard(
          title: 'سير العمل',
          child: Column(
            children: [
              _InfoRow(
                title: 'حالة الحضور',
                value: attendance.lastUpdatedLabel,
              ),
              _InfoRow(
                title: 'التقدم',
                value:
                    '${attendance.resolvedCount} من ${attendance.totalCount} طالب',
              ),
              _InfoRow(
                title: 'الواجب الحالي',
                value: assignments.isEmpty
                    ? 'لا يوجد واجب مضاف'
                    : assignments.first.title,
              ),
              _InfoRow(
                title: 'ملاحظة الحصة',
                value: item.notes ?? 'لا توجد ملاحظات إضافية.',
                isLast: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ClassroomSectionCard(
          title: 'طلاب يحتاجون متابعة',
          child: followUp.isEmpty
              ? const _EmptySectionState(
                  message: 'لا توجد حالات متابعة في هذه الحصة.',
                )
              : Column(
                  children: followUp
                      .map((student) => ClassroomStudentRow(student: student))
                      .toList(growable: false),
                ),
        ),
                const SizedBox(height: 32),

      ],
    );
  }
}

class ClassroomStudentsSection extends StatelessWidget {
  final List<ClassroomStudent> students;

  const ClassroomStudentsSection({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    return ClassroomSectionCard(
      title: 'قائمة الطلاب',
      child: students.isEmpty
          ? const _EmptySectionState(message: 'لا توجد بيانات طلاب متاحة.')
          : Column(
              children: students
                  .take(12)
                  .map(
                    (student) =>
                        ClassroomStudentRow(student: student, expanded: true),
                  )
                  .toList(growable: false),
            ),
    );
  }
}

class ClassroomAttendanceSection extends StatelessWidget {
  final ClassroomAttendanceSummary attendance;
  final List<ClassroomStudent> students;
  final VoidCallback onOpenAttendance;

  const ClassroomAttendanceSection({
    super.key,
    required this.attendance,
    required this.students,
    required this.onOpenAttendance,
  });

  @override
  Widget build(BuildContext context) {
    final pendingStudents = students
        .where((student) => student.attendanceMark == AttendanceMark.unmarked)
        .toList(growable: false);
    final actionStudents = students
        .where(
          (student) =>
              student.attendanceMark == AttendanceMark.absent ||
              student.attendanceMark == AttendanceMark.late,
        )
        .take(5)
        .toList(growable: false);

    return Column(
      children: [
        ClassroomSectionCard(
          title: 'موقف الحضور',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _AttendanceCountTile(
                      label: 'غير محسوم',
                      count: attendance.unmarkedCount,
                      color: AppColors.third,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _AttendanceCountTile(
                      label: 'غياب/تأخر',
                      count: attendance.actionableCount,
                      color: AppColors.errorRed,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: attendance.completionProgress,
                  minHeight: 8,
                  backgroundColor: AppColors.lightGrey,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'تم حسم ${attendance.resolvedCount} من ${attendance.totalCount} طالب',
                style: getMediumStyle(
                  color: AppColors.primaryDark,
                  fontSize: FontSize.size11,
                  fontFamily: FontConstant.cairo,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onOpenAttendance,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    pendingStudents.isEmpty
                        ? 'مراجعة سجل الحضور'
                        : 'استكمال أخذ الحضور',
                    style: getBoldStyle(
                      color: AppColors.white,
                      fontSize: FontSize.size12,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ClassroomSectionCard(
          title: pendingStudents.isNotEmpty
              ? 'طلاب بانتظار التحديد'
              : 'طلاب يحتاجون متابعة',
          child: pendingStudents.isNotEmpty
              ? Column(
                  children: pendingStudents
                      .map(
                        (student) => ClassroomStudentRow(
                          student: student,
                          expanded: true,
                        ),
                      )
                      .toList(growable: false),
                )
              : actionStudents.isEmpty
              ? const _EmptySectionState(
                  message: 'كل الطلاب حاضرون ولا توجد حالات تحتاج متابعة.',
                )
              : Column(
                  children: actionStudents
                      .map(
                        (student) => ClassroomStudentRow(
                          student: student,
                          expanded: true,
                        ),
                      )
                      .toList(growable: false),
                ),
        ),
      ],
    );
  }
}

class ClassroomStudentRow extends StatelessWidget {
  final ClassroomStudent student;
  final bool expanded;

  const ClassroomStudentRow({
    super.key,
    required this.student,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: student.needsFollowUp
                  ? AppColors.third.withValues(alpha: 0.14)
                  : AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                student.seatNumber,
                style: getBoldStyle(
                  color: AppColors.primaryDark,
                  fontSize: FontSize.size11,
                  fontFamily: FontConstant.cairo,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: getBoldStyle(
                    color: AppColors.primaryDark,
                    fontSize: FontSize.size12,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  expanded ? student.note : student.statusLabel,
                  style: getRegularStyle(
                    color: AppColors.grey,
                    fontSize: FontSize.size10,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
              ],
            ),
          ),
          _StatePill(
            label: expanded
                ? student.statusLabel
                : (student.homeworkSubmitted ? 'سلّم' : 'لم يسلّم'),
            background: _pillBackground(student, expanded),
            textColor: _pillColor(student, expanded),
          ),
        ],
      ),
    );
  }

  Color _pillBackground(ClassroomStudent student, bool expanded) {
    if (expanded) {
      return _pillColor(student, expanded).withValues(alpha: 0.1);
    }
    return student.homeworkSubmitted
        ? AppColors.green.withValues(alpha: 0.1)
        : AppColors.errorRed.withValues(alpha: 0.1);
  }

  Color _pillColor(ClassroomStudent student, bool expanded) {
    if (!expanded) {
      return student.homeworkSubmitted ? AppColors.green : AppColors.errorRed;
    }

    switch (student.attendanceMark) {
      case AttendanceMark.unmarked:
        return AppColors.third;
      case AttendanceMark.present:
        return AppColors.green;
      case AttendanceMark.absent:
        return AppColors.errorRed;
      case AttendanceMark.late:
        return AppColors.third;
      case AttendanceMark.excused:
        return AppColors.secondary;
    }
  }
}

class _AttendanceCountTile extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _AttendanceCountTile({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$count',
            style: getBoldStyle(
              color: color,
              fontSize: FontSize.size16,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: getMediumStyle(
              color: AppColors.primaryDark,
              fontSize: FontSize.size10,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isLast;

  const _InfoRow({
    required this.title,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: Text(
              title,
              style: getMediumStyle(
                color: AppColors.grey,
                fontSize: FontSize.size11,
                fontFamily: FontConstant.cairo,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: getBoldStyle(
                color: AppColors.primaryDark,
                fontSize: FontSize.size12,
                fontFamily: FontConstant.cairo,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatePill extends StatelessWidget {
  final String label;
  final Color? background;
  final Color? textColor;

  const _StatePill({required this.label, this.background, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background ?? AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: getMediumStyle(
          color: textColor ?? AppColors.primary,
          fontSize: FontSize.size10,
          fontFamily: FontConstant.cairo,
        ),
      ),
    );
  }
}

class _EmptySectionState extends StatelessWidget {
  final String message;

  const _EmptySectionState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        message,
        style: getRegularStyle(
          color: AppColors.grey,
          fontSize: FontSize.size11,
          fontFamily: FontConstant.cairo,
        ),
      ),
    );
  }
}
