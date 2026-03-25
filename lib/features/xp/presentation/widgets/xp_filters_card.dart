import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:teacher_app/core/utils/common/custom_text_field.dart';
import 'package:teacher_app/core/utils/constant/font_manger.dart';
import 'package:teacher_app/core/utils/constant/styles_manger.dart';
import 'package:teacher_app/core/utils/theme/app_colors.dart';

class XpFiltersCard extends StatelessWidget {
  final TextEditingController searchController;
  final List<String> cycleOptions;
  final List<String> gradeOptions;
  final List<String> sectionOptions;
  final String selectedCycle;
  final String selectedGrade;
  final String selectedSection;
  final ValueChanged<String> onCycleChanged;
  final ValueChanged<String> onGradeChanged;
  final ValueChanged<String> onSectionChanged;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onReset;

  const XpFiltersCard({
    super.key,
    required this.searchController,
    required this.cycleOptions,
    required this.gradeOptions,
    required this.sectionOptions,
    required this.selectedCycle,
    required this.selectedGrade,
    required this.selectedSection,
    required this.onCycleChanged,
    required this.onGradeChanged,
    required this.onSectionChanged,
    required this.onSearchChanged,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  hint: 'ابحث باسم الطالب أو الصف',
                  prefix: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset("assets/icons/search-normal.svg"),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: onReset,
                child: Text(
                  'إعادة',
                  style: getBoldStyle(
                    color: AppColors.primary,
                    fontSize: FontSize.size12,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _FilterDropdown(
                  label: 'المرحلة',
                  value: selectedCycle,
                  options: cycleOptions,
                  onChanged: onCycleChanged,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _FilterDropdown(
                  label: 'الصف',
                  value: selectedGrade,
                  options: gradeOptions,
                  onChanged: onGradeChanged,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _FilterDropdown(
                  label: 'الشعبة',
                  value: selectedSection,
                  options: sectionOptions,
                  onChanged: onSectionChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6, right: 2),
          child: Text(
            label,
            style: getMediumStyle(
              color: AppColors.primaryDark,
              fontSize: FontSize.size11,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: AppColors.lightGrey.withValues(alpha: 0.28),
            borderRadius: BorderRadius.circular(14),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              items: options
                  .map(
                    (option) => DropdownMenuItem<String>(
                      value: option,
                      child: Text(
                        option,
                        overflow: TextOverflow.ellipsis,
                        style: getMediumStyle(
                          color: AppColors.primaryDark,
                          fontSize: FontSize.size12,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (value) {
                if (value != null) {
                  onChanged(value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
