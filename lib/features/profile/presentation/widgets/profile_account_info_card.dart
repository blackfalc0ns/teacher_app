import 'package:flutter/material.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../data/models/teacher_profile_model.dart';

class ProfileAccountInfoCard extends StatelessWidget {
  final List<ProfileInfoItem> items;

  const ProfileAccountInfoCard({
    super.key,
    required this.items,
  });

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
        children: items.asMap().entries.map((entry) {
          final item = entry.value;
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.label,
                      style: getRegularStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size10,
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                  Text(
                    item.value,
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size10,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
              if (entry.key != items.length - 1) ...[
                const SizedBox(height: 10),
                Divider(
                  height: 1,
                  color: AppColors.lightGrey.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 10),
              ],
            ],
          );
        }).toList(growable: false),
      ),
    );
  }
}
