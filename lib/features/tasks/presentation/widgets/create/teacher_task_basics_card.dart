import 'package:flutter/material.dart';
import 'package:teacher_app/core/utils/constant/font_manger.dart';
import 'package:teacher_app/core/utils/constant/styles_manger.dart';
import 'package:teacher_app/core/utils/theme/app_colors.dart';
import 'package:teacher_app/features/tasks/data/models/teacher_task_model.dart';

class TeacherTaskBasicsCard extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController rewardController;
  final List<TeacherTaskClassOption> classes;
  final List<TeacherTaskStudentModel> students;
  final String? selectedClassId;
  final String? selectedStudentId;
  final TeacherTaskRewardType rewardType;
  final DateTime dueDate;
  final ValueChanged<String?> onClassChanged;
  final ValueChanged<String?> onStudentChanged;
  final ValueChanged<TeacherTaskRewardType?> onRewardTypeChanged;
  final VoidCallback onPickDueDate;

  const TeacherTaskBasicsCard({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.rewardController,
    required this.classes,
    required this.students,
    required this.selectedClassId,
    required this.selectedStudentId,
    required this.rewardType,
    required this.dueDate,
    required this.onClassChanged,
    required this.onStudentChanged,
    required this.onRewardTypeChanged,
    required this.onPickDueDate,
  });

  @override
  Widget build(BuildContext context) {
    final availableStudents = selectedClassId == null
        ? const <TeacherTaskStudentModel>[]
        : students
              .where((student) => student.classId == selectedClassId)
              .toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'بيانات المهمة الأساسية',
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size14,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          TextField(
            controller: titleController,
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size11,
            ),
            decoration: _inputDecoration('عنوان المهمة', Icons.title_rounded),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: descriptionController,
            maxLines: 3,
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size10,
            ),
            decoration: _inputDecoration(
              'وصف المهمة (اختياري)',
              Icons.description_outlined,
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: selectedClassId,
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size11,
              color: AppColors.primaryDark,
            ),
            decoration: _inputDecoration(
              'الفصل أو الشعبة',
              Icons.class_outlined,
            ),
            items: [
              DropdownMenuItem(
                value: null,
                child: Text(
                  'اختر الشعبة',
                  style: getMediumStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size11,
                    color: AppColors.grey,
                  ),
                ),
              ),
              ...classes.map(
                (item) => DropdownMenuItem(
                  value: item.id,
                  child: Text(
                    item.label,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size12,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ),
            ],
            onChanged: onClassChanged,
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: selectedStudentId,
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size11,
              color: AppColors.primaryDark,
            ),
            decoration: _inputDecoration(
              'الطالب المستهدف',
              Icons.person_outline_rounded,
            ),
            items: [
              DropdownMenuItem(
                value: null,
                child: Text(
                  'اختر الطالب',
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size12,
                    color: AppColors.grey,
                  ),
                ),
              ),
              ...availableStudents.map(
                (item) => DropdownMenuItem(
                  value: item.id,
                  child: Text(
                    item.name,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size12,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ),
            ],
            onChanged: onStudentChanged,
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFEDF2F7)),
          const SizedBox(height: 14),
          Text(
            'المكافأة والجدول الزمني',
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size10,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<TeacherTaskRewardType>(
                  initialValue: rewardType,
                  style: getMediumStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size10,
                    color: AppColors.primaryDark,
                  ),
                  decoration: _inputDecoration(
                    'نوع المكافأة',
                    Icons.workspace_premium_outlined,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: TeacherTaskRewardType.financial,
                      child: Text(
                        'مادية',
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size12,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: TeacherTaskRewardType.moral,
                      child: Text(
                        'معنوية',
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size12,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ],
                  onChanged: onRewardTypeChanged,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: rewardController,
                  style: getMediumStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size13,
                  ),
                  decoration: _inputDecoration(
                    rewardType == TeacherTaskRewardType.financial
                        ? 'القيمة'
                        : 'الوصف',
                    null,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: onPickDueDate,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F9FC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.lightGrey.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.primary,
                    size: 16,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تاريخ الاستحقاق',
                        style: getRegularStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size12,
                          color: AppColors.grey,
                        ),
                      ),
                      Text(
                        '${dueDate.day}/${dueDate.month}/${dueDate.year}',
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size11,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.edit_outlined,
                    color: AppColors.grey,
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData? icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null
          ? Icon(
              icon,
              size: 18,
              color: AppColors.primary.withValues(alpha: 0.7),
            )
          : null,
      hintStyle: getSemiBoldStyle(
        fontFamily: FontConstant.cairo,
        fontSize: FontSize.size11,
        color: AppColors.grey,
      ),
      filled: true,
      fillColor: const Color(0xFFF6F9FC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 1),
      ),
    );
  }
}
