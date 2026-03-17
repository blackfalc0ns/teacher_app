import 'package:flutter/material.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';

class ClassroomMetricsRow extends StatelessWidget {
  final List<ClassroomMetricItem> items;

  const ClassroomMetricsRow({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Container(
              width: 112,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: item.color.withValues(alpha: 0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(item.icon, size: 16, color: item.color),
                  const SizedBox(height: 8),
                  Text(
                    item.value,
                    style: getBoldStyle(
                      color: AppColors.primaryDark,
                      fontSize: FontSize.size18,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.title,
                    style: getRegularStyle(
                      color: AppColors.grey,
                      fontSize: FontSize.size11,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(growable: false),
      ),
    );
  }
}

class ClassroomMetricItem {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const ClassroomMetricItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}
