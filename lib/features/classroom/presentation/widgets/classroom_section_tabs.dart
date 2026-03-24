import 'package:flutter/material.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import 'classroom_section.dart';

class ClassroomSectionTabs extends StatelessWidget {
  final ClassroomSection selected;
  final ValueChanged<ClassroomSection> onChanged;

  const ClassroomSectionTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = <(ClassroomSection, String)>[
      (ClassroomSection.overview, 'نظرة عامة'),
      (ClassroomSection.students, 'الطلاب'),
      (ClassroomSection.attendance, 'الحضور'),
      (ClassroomSection.assignments, 'الواجبات'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs
            .map((tab) {
              final isSelected = tab.$1 == selected;
              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Center(
                  child: InkWell(
                    onTap: () => onChanged(tab.$1),
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.lightGrey.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        tab.$2,
                        style: getBoldStyle(
                          color: isSelected
                              ? AppColors.white
                              : AppColors.primaryDark,
                          fontSize: FontSize.size11,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            })
            .toList(growable: false),
      ),
    );
  }
}
