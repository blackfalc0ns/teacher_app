import 'package:flutter/material.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';

class MyClassesFiltersCard extends StatelessWidget {
  final TextEditingController searchController;
  final List<String> cycleOptions;
  final String selectedCycle;
  final ValueChanged<String> onCycleSelected;
  final bool showAttentionOnly;
  final ValueChanged<bool> onAttentionToggle;
  final VoidCallback onReset;

  const MyClassesFiltersCard({
    super.key,
    required this.searchController,
    required this.cycleOptions,
    required this.selectedCycle,
    required this.onCycleSelected,
    required this.showAttentionOnly,
    required this.onAttentionToggle,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final hasActiveFilters = selectedCycle != 'الكل' || showAttentionOnly || searchController.text.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'فلترة وبحث الفصول',
                style: getBoldStyle(
                  color: AppColors.primaryDark,
                  fontSize: FontSize.size14,
                  fontFamily: FontConstant.cairo,
                ),
              ),
              const Spacer(),
              if (hasActiveFilters)
                TextButton(
                  onPressed: onReset,
                  child: Text(
                    'إعادة تعيين',
                    style: getBoldStyle(
                      color: AppColors.primary,
                      fontSize: FontSize.size11,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                ),
            ],
          ),
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'ابحث بالصف أو الشعبة أو المادة',
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: AppColors.lightGrey.withValues(alpha: 0.22),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: cycleOptions
                .map(
                  (cycle) => _CycleChip(
                    label: cycle,
                    selected: cycle == selectedCycle,
                    onTap: () => onCycleSelected(cycle),
                  ),
                )
                .toList(growable: false),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.lightGrey.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.track_changes_outlined, color: AppColors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'إظهار الفصول التي تحتاج متابعة فقط',
                        style: getMediumStyle(
                          color: AppColors.primaryDark,
                          fontSize: FontSize.size11,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                      Text(
                        'حضور وواجبات وتحضير ومتابعة الطلاب.',
                        style: getRegularStyle(
                          color: AppColors.grey,
                          fontSize: FontSize.size10,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: showAttentionOnly,
                  onChanged: onAttentionToggle,
                  activeThumbColor: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CycleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CycleChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.lightGrey.withValues(alpha: 0.28),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: getBoldStyle(
            color: selected ? AppColors.white : AppColors.primaryDark,
            fontSize: FontSize.size10,
            fontFamily: FontConstant.cairo,
          ),
        ),
      ),
    );
  }
}
