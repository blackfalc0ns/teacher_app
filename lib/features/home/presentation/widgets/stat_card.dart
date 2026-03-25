import 'package:flutter/material.dart';
import 'package:teacher_app/core/utils/constant/font_manger.dart';
import 'package:teacher_app/core/utils/constant/styles_manger.dart';
import 'package:teacher_app/core/utils/helper/on_genrated_routes.dart';
import 'package:teacher_app/core/utils/theme/app_colors.dart';

import '../../data/models/home_data_model.dart';

class StatCard extends StatelessWidget {
  final HomeStatModel stat;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.stat,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isFeatured = stat.type == HomeStatType.currentClass;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? _resolveDefaultTap(context),
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          width: 130,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isFeatured ? AppColors.primary : AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: !isFeatured
                ? Border.all(color: AppColors.lightGrey)
                : Border.all(color: AppColors.secondary, width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  if (!isFeatured) _buildIcon(),
                  if (isFeatured) ...[
                    const SizedBox(width: 8),
                    _buildStatusDot(),
                  ],
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      stat.title,
                      style: getBoldStyle(
                        color: isFeatured
                            ? AppColors.white
                            : AppColors.grey.withValues(alpha: 0.6),
                        fontSize: FontSize.size10,
                        fontFamily: FontConstant.cairo,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Text(
                stat.value,
                style: getBoldStyle(
                  color: isFeatured ? AppColors.white : _getValueColor(),
                  fontSize: FontSize.size20,
                  fontFamily: FontConstant.cairo,
                ),
                textAlign: TextAlign.start,
              ),
              if (stat.subValue != null) ...[
                Row(
                  children: [
                    if (isFeatured) ...[
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.class_outlined,
                        color: AppColors.white,
                        size: 14,
                      ),
                    ],
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        stat.subValue!,
                        style: getRegularStyle(
                          color: isFeatured
                              ? AppColors.white.withValues(alpha: 0.8)
                              : AppColors.grey,
                          fontSize: FontSize.size12,
                          fontFamily: FontConstant.cairo,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  VoidCallback? _resolveDefaultTap(BuildContext context) {
    switch (stat.type) {
      case HomeStatType.points:
        return () => Navigator.pushNamed(context, Routes.xpCenter);
      default:
        return null;
    }
  }

  Widget _buildIcon() {
    IconData iconData;
    Color iconColor;

    switch (stat.type) {
      case HomeStatType.remainingClasses:
        iconData = Icons.grid_view_rounded;
        iconColor = AppColors.primary;
        break;
      case HomeStatType.points:
        iconColor = AppColors.third;
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: iconColor,
            shape: BoxShape.circle,
          ),
        );
      default:
        iconData = Icons.star;
        iconColor = AppColors.primary;
    }

    return Icon(iconData, color: iconColor, size: 16);
  }

  Widget _buildStatusDot() {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: AppColors.green,
        shape: BoxShape.circle,
      ),
    );
  }

  Color _getValueColor() {
    switch (stat.type) {
      case HomeStatType.remainingClasses:
        return AppColors.primary;
      case HomeStatType.points:
        return AppColors.third;
      default:
        return AppColors.primary;
    }
  }
}
