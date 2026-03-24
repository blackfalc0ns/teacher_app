import 'package:flutter/material.dart';
import 'package:teacher_app/core/utils/constant/font_manger.dart';
import 'package:teacher_app/core/utils/constant/styles_manger.dart';
import 'package:teacher_app/core/utils/theme/app_colors.dart';
import 'package:teacher_app/features/tasks/data/models/teacher_task_model.dart';

class TeacherTasksFiltersCard extends StatelessWidget {
  final TextEditingController searchController;
  final String selectedClassId;
  final List<TeacherTaskClassOption> classes;
  final ValueChanged<String> onClassChanged;
  final ValueChanged<String> onSearchChanged;

  const TeacherTasksFiltersCard({
    super.key,
    required this.searchController,
    required this.selectedClassId,
    required this.classes,
    required this.onClassChanged,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.lightGrey.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'ابحث باسم الطالب أو المهمة',
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: const Color(0xFFF6F9FC),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _FilterChip(
                  label: 'كل الفصول',
                  selected: selectedClassId == 'all',
                  onTap: () => onClassChanged('all'),
                ),
                ...classes.map(
                  (item) => Padding(
                    padding: const EdgeInsetsDirectional.only(start: 8),
                    child: _FilterChip(
                      label: item.label,
                      selected: selectedClassId == item.id,
                      onTap: () => onClassChanged(item.id),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.14)
              : const Color(0xFFF6F9FC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.3)
                : AppColors.lightGrey.withValues(alpha: 0.45),
          ),
        ),
        child: Text(
          label,
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size10,
            color: selected ? AppColors.primaryDark : AppColors.grey,
          ),
        ),
      ),
    );
  }
}
