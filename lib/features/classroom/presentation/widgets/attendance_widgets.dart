import 'package:flutter/material.dart';
import 'package:teacher_app/core/utils/common/custom_button.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../schedule/data/model/schedule_model.dart';
import '../../data/models/classroom_model.dart';
import 'classroom_section_card.dart';

class AttendanceHeaderCard extends StatelessWidget {
  final ScheduleModel item;
  final VoidCallback onBack;

  const AttendanceHeaderCard({
    super.key,
    required this.item,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.lightGrey.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_rounded, size: 18),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أخذ الحضور',
                  style: getBoldStyle(
                    color: AppColors.primaryDark,
                    fontSize: FontSize.size17,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.className} • ${item.periodLabel}',
                  style: getRegularStyle(
                    color: AppColors.grey,
                    fontSize: FontSize.size11,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
              ],
            ),
          ),
          _HeaderStatePill(
            label: item.needsAttendance ? 'جاري التسجيل' : 'مراجعة',
            color: item.needsAttendance ? AppColors.third : AppColors.green,
          ),
        ],
      ),
    );
  }
}

class PendingAttendanceBanner extends StatelessWidget {
  final int pendingCount;

  const PendingAttendanceBanner({super.key, required this.pendingCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.third.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.third),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              pendingCount > 0
                  ? 'ما زال هناك $pendingCount طالب بدون تحديد حالة الحضور.'
                  : 'لديك تعديلات غير محفوظة على سجل الحضور.',
              style: getMediumStyle(
                color: AppColors.primaryDark,
                fontSize: FontSize.size11,
                fontFamily: FontConstant.cairo,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AttendanceProgressCard extends StatelessWidget {
  final ClassroomAttendanceSummary summary;

  const AttendanceProgressCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return ClassroomSectionCard(
      title: 'تقدم الحضور',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${summary.resolvedCount} من ${summary.totalCount} تم اعتمادهم',
                  style: getBoldStyle(
                    color: AppColors.primaryDark,
                    fontSize: FontSize.size12,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
              ),
              Text(
                summary.lastUpdatedLabel,
                style: getMediumStyle(
                  color: AppColors.grey,
                  fontSize: FontSize.size10,
                  fontFamily: FontConstant.cairo,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: summary.completionProgress,
              minHeight: 8,
              backgroundColor: AppColors.lightGrey,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _CountBox(
                  label: 'غير محسوم',
                  count: summary.unmarkedCount,
                  color: AppColors.third,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _CountBox(
                  label: 'حاضر',
                  count: summary.presentCount,
                  color: AppColors.green,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _CountBox(
                  label: 'غياب/تأخر',
                  count: summary.actionableCount,
                  color: AppColors.errorRed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AttendanceQuickActionsCard extends StatelessWidget {
  final AttendanceMark? activeFilter;
  final VoidCallback onMarkAllPresent;
  final VoidCallback onMarkPendingPresent;
  final ValueChanged<AttendanceMark?> onFilterChanged;

  const AttendanceQuickActionsCard({
    super.key,
    required this.activeFilter,
    required this.onMarkAllPresent,
    required this.onMarkPendingPresent,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ClassroomSectionCard(
      title: 'إجراءات سريعة',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _QuickMarkButton(
                  label: 'الكل حاضر',
                  color: AppColors.green,
                  onTap: onMarkAllPresent,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _QuickMarkButton(
                  label: 'اعتماد المعلق',
                  color: AppColors.primary,
                  onTap: onMarkPendingPresent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _FilterChip(
                label: 'الكل',
                selected: activeFilter == null,
                onTap: () => onFilterChanged(null),
              ),
              _FilterChip(
                label: 'غير محسوم',
                selected: activeFilter == AttendanceMark.unmarked,
                onTap: () => onFilterChanged(AttendanceMark.unmarked),
              ),
              _FilterChip(
                label: 'حاضر',
                selected: activeFilter == AttendanceMark.present,
                onTap: () => onFilterChanged(AttendanceMark.present),
              ),
              _FilterChip(
                label: 'غائب',
                selected: activeFilter == AttendanceMark.absent,
                onTap: () => onFilterChanged(AttendanceMark.absent),
              ),
              _FilterChip(
                label: 'متأخر',
                selected: activeFilter == AttendanceMark.late,
                onTap: () => onFilterChanged(AttendanceMark.late),
              ),
              _FilterChip(
                label: 'مستأذن',
                selected: activeFilter == AttendanceMark.excused,
                onTap: () => onFilterChanged(AttendanceMark.excused),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AttendanceStudentsCard extends StatelessWidget {
  final List<ClassroomStudent> students;
  final ValueChanged<(String, AttendanceMark)> onMarkChanged;

  const AttendanceStudentsCard({
    super.key,
    required this.students,
    required this.onMarkChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ClassroomSectionCard(
      title: 'قائمة الطلاب',
      child: students.isEmpty
          ? Text(
              'لا توجد نتائج مطابقة للتصفية الحالية.',
              style: getRegularStyle(
                color: AppColors.grey,
                fontSize: FontSize.size11,
                fontFamily: FontConstant.cairo,
              ),
            )
          : Column(
              children:  students
                  .map(
                    (student) => _AttendanceStudentRow(
                      student: student,
                      onChanged: (mark) => onMarkChanged((student.id, mark)),
                    ),
                  )
                  .toList(growable: false),
            ),
            // ignore: prefer_const_constructors
      
    );
  }
}

class AttendanceSaveBar extends StatelessWidget {
  final String label;
  final String helperText;
  final bool enabled;
  final VoidCallback onSave;

  const AttendanceSaveBar({
    super.key,
    required this.label,
    required this.helperText,
    required this.enabled,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            helperText,
            style: getMediumStyle(
              color: AppColors.grey,
              fontSize: FontSize.size10,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 52,
            width: double.infinity,
            child: SafeArea(
              child: CustomButton(
                onPressed: enabled ? onSave : null,

                text: label,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderStatePill extends StatelessWidget {
  final String label;
  final Color color;

  const _HeaderStatePill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: getBoldStyle(
          color: color,
          fontSize: FontSize.size10,
          fontFamily: FontConstant.cairo,
        ),
      ),
    );
  }
}

class _CountBox extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _CountBox({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
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

class _QuickMarkButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickMarkButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            label,
            style: getBoldStyle(
              color: color,
              fontSize: FontSize.size11,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : AppColors.lightGrey.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: getMediumStyle(
            color: selected ? AppColors.white : AppColors.primaryDark,
            fontSize: FontSize.size10,
            fontFamily: FontConstant.cairo,
          ),
        ),
      ),
    );
  }
}

class _AttendanceStudentRow extends StatelessWidget {
  final ClassroomStudent student;
  final ValueChanged<AttendanceMark> onChanged;

  const _AttendanceStudentRow({required this.student, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withValues(alpha: 0.24),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
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
                      student.note,
                      style: getRegularStyle(
                        color: AppColors.grey,
                        fontSize: FontSize.size10,
                        fontFamily: FontConstant.cairo,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                student.statusLabel,
                style: getBoldStyle(
                  color: _colorForMark(student.attendanceMark),
                  fontSize: FontSize.size10,
                  fontFamily: FontConstant.cairo,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _MarkButton(
                  label: 'حاضر',
                  mark: AttendanceMark.present,
                  current: student.attendanceMark,
                  color: AppColors.green,
                  onTap: onChanged,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MarkButton(
                  label: 'غائب',
                  mark: AttendanceMark.absent,
                  current: student.attendanceMark,
                  color: AppColors.errorRed,
                  onTap: onChanged,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MarkButton(
                  label: 'متأخر',
                  mark: AttendanceMark.late,
                  current: student.attendanceMark,
                  color: AppColors.third,
                  onTap: onChanged,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MarkButton(
                  label: 'مستأذن',
                  mark: AttendanceMark.excused,
                  current: student.attendanceMark,
                  color: AppColors.secondary,
                  onTap: onChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _colorForMark(AttendanceMark mark) {
    switch (mark) {
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

class _MarkButton extends StatelessWidget {
  final String label;
  final AttendanceMark mark;
  final AttendanceMark current;
  final Color color;
  final ValueChanged<AttendanceMark> onTap;

  const _MarkButton({
    required this.label,
    required this.mark,
    required this.current,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selected = current == mark;
    return InkWell(
      onTap: () => onTap(mark),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: getBoldStyle(
              color: selected ? AppColors.white : color,
              fontSize: FontSize.size10,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ),
      ),
    );
  }
}
