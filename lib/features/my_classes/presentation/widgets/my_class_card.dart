import 'package:flutter/material.dart';

import '../../../../core/utils/common/custom_button.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/helper/on_genrated_routes.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../data/models/teacher_class_model.dart';

class MyClassCard extends StatelessWidget {
  final TeacherClassModel teacherClass;

  const MyClassCard({
    super.key,
    required this.teacherClass,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: teacherClass.needsAttention
              ? AppColors.third.withValues(alpha: 0.15)
              : AppColors.lightGrey.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with class info and status
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teacherClass.classLabel,
                      style: getBoldStyle(
                        color: AppColors.primaryDark,
                        fontSize: FontSize.size16,
                        fontFamily: FontConstant.cairo,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${teacherClass.subjectName} • ${teacherClass.cycleAndRoomLabel}',
                      style: getRegularStyle(
                        color: AppColors.grey,
                        fontSize: FontSize.size11,
                        fontFamily: FontConstant.cairo,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusTag(
                label: teacherClass.needsAttention ? 'يحتاج متابعة' : 'جاهز',
                color: teacherClass.needsAttention ? AppColors.third : AppColors.green,
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Quick info pills
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _InfoPill(label: '${teacherClass.studentsCount} طالب', icon: Icons.groups_rounded),
              _InfoPill(label: '${teacherClass.todayPeriods} حصة اليوم', icon: Icons.today_outlined),
              if (teacherClass.followUpCount > 0)
                _InfoPill(label: '${teacherClass.followUpCount} متابعة', icon: Icons.track_changes_outlined, isHighlight: true),
            ],
          ),
          const SizedBox(height: 12),
          
          // Metrics row - more compact
          Row(
            children: [
              Expanded(child: _CompactMetric(title: 'حضور معلق', value: '${teacherClass.pendingAttendanceCount}', color: AppColors.primary)),
              const SizedBox(width: 6),
              Expanded(child: _CompactMetric(title: 'واجبات نشطة', value: '${teacherClass.activeAssignmentsCount}', color: AppColors.secondary)),
              const SizedBox(width: 6),
              Expanded(child: _CompactMetric(title: 'تصحيح مطلوب', value: '${teacherClass.pendingReviewCount}', color: AppColors.third)),
            ],
          ),
          const SizedBox(height: 12),
          
          // Next session info - more compact
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.lightGrey.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.schedule_rounded, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teacherClass.nextSessionLabel,
                        style: getBoldStyle(
                          color: AppColors.primaryDark,
                          fontSize: FontSize.size11,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                      if (teacherClass.note.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          teacherClass.note,
                          style: getRegularStyle(
                            color: AppColors.grey,
                            fontSize: FontSize.size9,
                            fontFamily: FontConstant.cairo,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          
          // Single enter classroom button
          CustomButton(
            text: 'دخول الفصل',
            height: 45,
            prefix: const Icon(Icons.door_front_door_outlined, color: Colors.white, size: 18),
            onPressed: () {
              Navigator.of(context).pushNamed(
                Routes.classroom,
                arguments: teacherClass.focusItem,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CompactMetric extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _CompactMetric({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: getBoldStyle(
              color: color,
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            textAlign: TextAlign.center,
            style: getMediumStyle(
              color: AppColors.primaryDark,
              fontSize: FontSize.size8,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusTag extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusTag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: getBoldStyle(
          color: color,
          fontSize: FontSize.size9,
          fontFamily: FontConstant.cairo,
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isHighlight;

  const _InfoPill({required this.label, required this.icon, this.isHighlight = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: isHighlight 
            ? AppColors.third.withValues(alpha: 0.1)
            : AppColors.lightGrey.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon, 
            size: 12, 
            color: isHighlight ? AppColors.third : AppColors.primaryDark,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: getMediumStyle(
              color: isHighlight ? AppColors.third : AppColors.primaryDark,
              fontSize: FontSize.size9,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ],
      ),
    );
  }
}