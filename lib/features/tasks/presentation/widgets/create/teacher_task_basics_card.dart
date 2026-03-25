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
  final List<String> selectedStudentIds;
  final bool isClassTask;
  final TeacherTaskRewardType rewardType;
  final DateTime dueDate;
  final ValueChanged<String?> onClassChanged;
  final ValueChanged<List<String>> onStudentsChanged;
  final ValueChanged<bool> onTypeChanged;
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
    required this.selectedStudentIds,
    required this.isClassTask,
    required this.rewardType,
    required this.dueDate,
    required this.onClassChanged,
    required this.onStudentsChanged,
    required this.onTypeChanged,
    required this.onRewardTypeChanged,
    required this.onPickDueDate,
  });

  void _showStudentPicker(
    BuildContext context,
    List<TeacherTaskStudentModel> students,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _StudentPickerSheet(
        allStudents: students,
        selectedIds: selectedStudentIds,
        onSelectionChanged: onStudentsChanged,
      ),
    );
  }

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
          TextFormField(
            controller: titleController,
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size11,
            ),
            decoration: _inputDecoration('عنوان المهمة', Icons.title_rounded),
          ),
          const SizedBox(height: 10),
          TextFormField(
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
          const SizedBox(height: 14),
          Text(
            'تحديد المستهدف',
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size13,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _TargetOption(
                label: 'طلاب محددون',
                isSelected: !isClassTask,
                onTap: () => onTypeChanged(false),
                icon: Icons.person_outline_rounded,
              ),
              const SizedBox(width: 10),
              _TargetOption(
                label: 'الفصل بالكامل',
                isSelected: isClassTask,
                onTap: () => onTypeChanged(true),
                icon: Icons.groups_3_outlined,
              ),
            ],
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            value: selectedClassId,
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
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size13,
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
                      fontSize: FontSize.size13,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ),
            ],
            onChanged: onClassChanged,
          ),
          if (!isClassTask) ...[
            const SizedBox(height: 10),
            InkWell(
              onTap: selectedClassId == null
                  ? null
                  : () => _showStudentPicker(context, availableStudents),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F9FC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.lightGrey.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.person_add_alt_1_rounded,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        selectedStudentIds.isEmpty
                            ? 'حدد الطلاب المستهدفين'
                            : 'تم تحديد ${selectedStudentIds.length} طلاب',
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size13,
                          color: selectedStudentIds.isEmpty
                              ? AppColors.grey
                              : AppColors.primaryDark,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down_circle_outlined,
                      size: 16,
                      color: AppColors.grey,
                    ),
                  ],
                ),
              ),
            ),
            if (selectedStudentIds.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: selectedStudentIds.map((id) {
                  final name = availableStudents
                      .firstWhere(
                        (s) => s.id == id,
                        orElse: () => const TeacherTaskStudentModel(
                          id: '',
                          name: '',
                          classId: '',
                          cycleName: '',
                          gradeName: '',
                          sectionName: '',
                        ),
                      )
                      .name;
                  if (name.isEmpty) return const SizedBox.shrink();
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          name,
                          style: getMediumStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size12,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: () {
                            final newList = selectedStudentIds.toList()
                              ..remove(id);
                            onStudentsChanged(newList);
                          },
                          child: const Icon(
                            Icons.close_rounded,
                            size: 12,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFEDF2F7)),
          const SizedBox(height: 14),
          Text(
            'المكافأة والجدول الزمني',
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size13,
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
                          fontSize: FontSize.size13,
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
                          fontSize: FontSize.size13,
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
                          fontSize: FontSize.size13,
                          color: AppColors.grey,
                        ),
                      ),
                      Text(
                        '${dueDate.day}/${dueDate.month}/${dueDate.year}',
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size12,
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
        fontSize: FontSize.size13,
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

class _StudentPickerSheet extends StatefulWidget {
  final List<TeacherTaskStudentModel> allStudents;
  final List<String> selectedIds;
  final ValueChanged<List<String>> onSelectionChanged;

  const _StudentPickerSheet({
    required this.allStudents,
    required this.selectedIds,
    required this.onSelectionChanged,
  });

  @override
  State<_StudentPickerSheet> createState() => _StudentPickerSheetState();
}

class _StudentPickerSheetState extends State<_StudentPickerSheet> {
  late List<String> _currentSelected;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _currentSelected = List.from(widget.selectedIds);
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.allStudents
        .where((s) => s.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.lightGrey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تحديد الطلاب',
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size16,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      Text(
                        'يمكنك اختيار أكثر من طالب لإسناد المهمة لهم',
                        style: getMediumStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size11,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      if (_currentSelected.length ==
                          widget.allStudents.length) {
                        _currentSelected.clear();
                      } else {
                        _currentSelected = widget.allStudents
                            .map((s) => s.id)
                            .toList();
                      }
                    });
                    widget.onSelectionChanged(_currentSelected);
                  },
                  child: Text(
                    _currentSelected.length == widget.allStudents.length
                        ? 'إلغاء الكل'
                        : 'تحديد الكل',
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size12,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'ابحث عن اسم الطالب...',
                prefixIcon: const Icon(Icons.search, size: 20),
                filled: true,
                fillColor: const Color(0xFFF6F9FC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final student = filtered[index];
                final isSelected = _currentSelected.contains(student.id);
                return CheckboxListTile(
                  value: isSelected,
                  title: Text(
                    student.name,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size13,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.primaryDark,
                    ),
                  ),
                  subtitle: Text(
                    student.classLabel,
                    style: getMediumStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size10,
                      color: AppColors.grey,
                    ),
                  ),
                  activeColor: AppColors.primary,
                  checkboxShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  onChanged: (checked) {
                    setState(() {
                      if (checked == true) {
                        _currentSelected.add(student.id);
                      } else {
                        _currentSelected.remove(student.id);
                      }
                    });
                    widget.onSelectionChanged(_currentSelected);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'تأكيد الاختيار (${_currentSelected.length})',
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size14,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TargetOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData icon;

  const _TargetOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.1)
                : const Color(0xFFF6F9FC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : AppColors.lightGrey.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? AppColors.primary : AppColors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size13,
                  color: isSelected ? AppColors.primaryDark : AppColors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
