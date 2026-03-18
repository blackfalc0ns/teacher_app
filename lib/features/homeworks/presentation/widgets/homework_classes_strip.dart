import 'package:flutter/material.dart';

import '../../../../core/utils/common/compact_button.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../data/models/homework_dashboard_model.dart';

class HomeworkClassesStrip extends StatelessWidget {
  final List<HomeworkDashboardClass> classes;
  final ValueChanged<HomeworkDashboardClass> onCreateForClass;

  const HomeworkClassesStrip({
    super.key,
    required this.classes,
    required this.onCreateForClass,
  });

  @override
  Widget build(BuildContext context) {
    if (classes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'فصول تحتاج تحركًا سريعًا',
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size14,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: classes.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final item = classes[index];
              return Container(
                width: 240,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.classLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: getBoldStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: FontSize.size13,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: item.needsAttention
                                ? AppColors.third.withValues(alpha: 0.12)
                                : AppColors.green.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            item.needsAttention ? 'متابعة' : 'مستقر',
                            style: getBoldStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: FontSize.size9,
                              color: item.needsAttention
                                  ? AppColors.third
                                  : AppColors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.subjectName} • ${item.nextSessionLabel}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getRegularStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size10,
                        color: AppColors.grey,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: _MiniMetric(
                            value: '${item.pendingReviewCount}',
                            label: 'تصحيح',
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _MiniMetric(
                            value: '${item.missingSubmissionCount}',
                            label: 'لم يسلّم',
                            color: AppColors.third,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _MiniMetric(
                            value: '${item.activeAssignmentsCount}',
                            label: 'نشطة',
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    CompactButton(
                      text: 'واجب جديد للفصل',
                      isOutlined: true,
                      borderColor: AppColors.primary,
                      textColor: AppColors.primary,
                      width: double.infinity,
                      height: 38,
                      prefix: const Icon(Icons.add_circle_outline_rounded, size: 16, color: AppColors.primary),
                      onPressed: () => onCreateForClass(item),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MiniMetric extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _MiniMetric({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size12,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size9,
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}
