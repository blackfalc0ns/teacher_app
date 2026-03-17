import 'package:flutter/material.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';

class HomeworksFiltersCard extends StatelessWidget {
  final TextEditingController searchController;
  final List<String> cycleOptions;
  final String selectedCycle;
  final ValueChanged<String> onCycleChanged;
  final String selectedTab;
  final ValueChanged<String> onTabChanged;
  final VoidCallback onReset;

  const HomeworksFiltersCard({
    super.key,
    required this.searchController,
    required this.cycleOptions,
    required this.selectedCycle,
    required this.onCycleChanged,
    required this.selectedTab,
    required this.onTabChanged,
    required this.onReset,
  });

  static const List<(String, String)> tabs = [
    ('all', 'الكل'),
    ('needs_review', 'بانتظار التصحيح'),
    ('missing', 'لم يسلّم'),
    ('drafts', 'مسودات'),
    ('active', 'نشطة'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'ابحث باسم الواجب أو الصف أو المادة',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: searchController.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () => searchController.clear(),
                      icon: const Icon(Icons.close_rounded),
                    ),
              filled: true,
              fillColor: AppColors.lightGrey.withValues(alpha: 0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: tabs.map((tab) {
                final isSelected = selectedTab == tab.$1;
                return Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: ChoiceChip(
                    label: Text(tab.$2),
                    selected: isSelected,
                    onSelected: (_) => onTabChanged(tab.$1),
                    selectedColor: AppColors.primary.withValues(alpha: 0.14),
                    backgroundColor: AppColors.lightGrey.withValues(alpha: 0.16),
                    labelStyle: getMediumStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size11,
                      color: isSelected ? AppColors.primaryDark : AppColors.grey,
                    ),
                    side: BorderSide.none,
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                );
              }).toList(growable: false),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: cycleOptions.map((cycle) {
              final isSelected = cycle == selectedCycle;
              return InkWell(
                onTap: () => onCycleChanged(cycle),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.secondary.withValues(alpha: 0.12)
                        : AppColors.lightGrey.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    cycle,
                    style: getMediumStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size10,
                      color: isSelected ? AppColors.primaryDark : AppColors.grey,
                    ),
                  ),
                ),
              );
            }).toList(growable: false),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.restart_alt_rounded, size: 18),
              label: Text(
                'إعادة الضبط',
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size11,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
