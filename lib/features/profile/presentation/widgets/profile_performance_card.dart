import 'package:flutter/material.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../data/models/teacher_profile_model.dart';

class ProfilePerformanceCard extends StatelessWidget {
  final TeacherProfileModel profile;

  const ProfilePerformanceCard({
    super.key,
    required this.profile,
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
        children: [
          _ProgressMetric(
            title: 'الالتزام بالحضور والرصد',
            subtitle: 'نسبة إغلاق سجلات الحضور اليومية في الوقت المناسب.',
            progress: profile.attendanceCommitment,
            color: AppColors.primary,
          ),
          const SizedBox(height: 12),
          _ProgressMetric(
            title: 'إتمام الواجبات والتصحيح',
            subtitle: 'مدى انتظام المتابعة والتغذية الراجعة للواجبات.',
            progress: profile.assignmentsCompletion,
            color: AppColors.secondary,
          ),
        ],
      ),
    );
  }
}

class _ProgressMetric extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress;
  final Color color;

  const _ProgressMetric({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (progress * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size12,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
            Text(
              '$percent%',
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size12,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: getRegularStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size9,
            color: AppColors.grey,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: LinearProgressIndicator(
            value: progress.clamp(0, 1).toDouble(),
            minHeight: 9,
            backgroundColor: AppColors.lightGrey.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
