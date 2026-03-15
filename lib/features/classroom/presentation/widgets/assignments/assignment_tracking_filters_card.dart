import 'package:flutter/material.dart';

import '../../../../../core/utils/constant/font_manger.dart';
import '../../../../../core/utils/constant/styles_manger.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import 'assignment_shared.dart';

class AssignmentTrackingFiltersCard extends StatelessWidget {
  final String activeTab;
  final ValueChanged<String> onTabChanged;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final String scoreFilter;
  final ValueChanged<String> onScoreFilterChanged;
  final bool lateOnly;
  final ValueChanged<bool> onLateOnlyChanged;

  const AssignmentTrackingFiltersCard({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
    required this.searchController,
    required this.onSearchChanged,
    required this.scoreFilter,
    required this.onScoreFilterChanged,
    required this.lateOnly,
    required this.onLateOnlyChanged,
  });

  static const List<MapEntry<String, String>> tabs = [
    MapEntry('all', 'الكل'),
    MapEntry('not_submitted', 'لم يسلّم'),
    MapEntry('waiting_review', 'بانتظار التصحيح'),
    MapEntry('reviewed', 'تم التصحيح'),
  ];

  static const List<MapEntry<String, String>> scoreFilters = [
    MapEntry('all', 'كل الدرجات'),
    MapEntry('low', 'أقل من 50%'),
    MapEntry('medium', '50% - 79%'),
    MapEntry('high', '80%+'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'بحث وفلاتر المتابعة',
            style: getBoldStyle(
              color: AppColors.primaryDark,
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'صفِّ التسليمات حسب الحالة، الطالب، والدرجة للوصول الأسرع.',
            style: getRegularStyle(
              color: AppColors.grey,
              fontSize: FontSize.size10,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: assignmentInputDecoration('ابحث باسم الطالب أو رقم الطالب'),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: tabs
                  .map(
                    (tab) => Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: AssignmentChoiceChip(
                        label: tab.value,
                        selected: activeTab == tab.key,
                        onTap: () => onTabChanged(tab.key),
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: scoreFilters
                .map(
                  (filter) => AssignmentChoiceChip(
                    label: filter.value,
                    selected: scoreFilter == filter.key,
                    onTap: () => onScoreFilterChanged(filter.key),
                  ),
                )
                .toList(growable: false),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.lightGrey.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'المتأخر فقط',
                        style: getMediumStyle(
                          color: AppColors.primaryDark,
                          fontSize: FontSize.size11,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'اعرض التسليمات المتأخرة فقط عند الحاجة.',
                        style: getRegularStyle(
                          color: AppColors.grey,
                          fontSize: FontSize.size10,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: lateOnly,
                  activeThumbColor: AppColors.errorRed,
                  activeTrackColor: AppColors.errorRed.withValues(alpha: 0.35),
                  onChanged: onLateOnlyChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
