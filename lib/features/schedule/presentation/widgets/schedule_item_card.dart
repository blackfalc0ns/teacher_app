import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../data/model/schedule_model.dart';

class ScheduleItemCard extends StatelessWidget {
  final ScheduleModel item;

  const ScheduleItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isCurrent = item.status == ScheduleStatus.current;
    final bool isCompleted = item.status == ScheduleStatus.completed;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline dot (Now on the left)
          Column(
            children: [
              const SizedBox(height: 25),
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  boxShadow: [
                    if (isCurrent)
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                  ],
                  color: isCurrent ? AppColors.primary : AppColors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCurrent ? AppColors.primary : AppColors.lightGrey,
                    width: 3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: isCurrent
                    ? Border.all(color: AppColors.primary, width: 1.5)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isCurrent
                                  ? AppColors.primary.withValues(alpha: 0.1)
                                  : isCompleted
                                  ? AppColors.green.withValues(alpha: 0.1)
                                  : AppColors.lightGrey.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              item.icon,
                              color: isCurrent
                                  ? AppColors.primary
                                  : isCompleted
                                  ? AppColors.green
                                  : AppColors.grey,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item.startTime} - ${item.endTime}',
                                style: getRegularStyle(
                                  color: AppColors.grey.withValues(alpha: 0.5),
                                  fontSize: FontSize.size12,
                                  fontFamily: FontConstant.cairo,
                                ),
                              ),
                              Text(
                                item.periodLabel,
                                style: getBoldStyle(
                                  color: isCurrent
                                      ? AppColors.primary
                                      : AppColors.grey,
                                  fontSize: FontSize.size14,
                                  fontFamily: FontConstant.cairo,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (isCurrent)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F2F1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'جاري الآن',
                            style: getBoldStyle(
                              color: AppColors.primary,
                              fontSize: FontSize.size10,
                              fontFamily: FontConstant.cairo,
                            ),
                          ),
                        )
                      else if (isCompleted)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'مكتملة',
                            style: getBoldStyle(
                              color: AppColors.green,
                              fontSize: FontSize.size10,
                              fontFamily: FontConstant.cairo,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item.subjectName,
                    style: getBoldStyle(
                      color: AppColors.primaryDark,
                      fontSize: FontSize.size18,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Iconsax.user, size: 16, color: AppColors.grey),
                      const SizedBox(width: 8),
                      Text(
                        item.className,
                        style: getRegularStyle(
                          color: AppColors.grey,
                          fontSize: FontSize.size12,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                      if (item.roomName != null) ...[
                        const SizedBox(width: 16),
                        const Icon(
                          Iconsax.location,
                          size: 16,
                          color: AppColors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item.roomName!,
                          style: getRegularStyle(
                            color: AppColors.grey,
                            fontSize: FontSize.size12,
                            fontFamily: FontConstant.cairo,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (isCurrent) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Iconsax.play_circle,
                            color: AppColors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'بدء الحصة الدراسية',
                            style: getBoldStyle(
                              color: AppColors.white,
                              fontSize: FontSize.size14,
                              fontFamily: FontConstant.cairo,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
