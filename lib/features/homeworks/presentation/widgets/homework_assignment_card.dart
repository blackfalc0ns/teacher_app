import 'package:flutter/material.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../classroom/data/models/classroom_model.dart';
import '../../data/models/homework_dashboard_model.dart';

class HomeworkAssignmentCard extends StatelessWidget {
  final HomeworkDashboardClass classItem;
  final ClassroomAssignment assignment;
  final VoidCallback onTrackPressed;
  final VoidCallback onCreatePressed;

  const HomeworkAssignmentCard({
    super.key,
    required this.classItem,
    required this.assignment,
    required this.onTrackPressed,
    required this.onCreatePressed,
  });

  @override
  Widget build(BuildContext context) {
    final submitted = assignment.submittedCount;
    final total = assignment.totalCount == 0 ? 1 : assignment.totalCount;
    final progress = submitted / total;
    final pendingReview = assignment.submissions.where((submission) {
      return submission.status == AssignmentSubmissionStatus.submitted ||
          submission.status == AssignmentSubmissionStatus.late;
    }).length;
    final missing = assignment.submissions.where((submission) {
      return submission.status == AssignmentSubmissionStatus.notSubmitted;
    }).length;

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
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      assignment.title,
                      style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size14,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${classItem.classLabel} • ${classItem.subjectName}',
                      style: getRegularStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size10,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusChip(
                label: assignment.publishNow ? assignment.statusLabel : 'مسودة',
                color: assignment.publishNow ? AppColors.secondary : AppColors.info,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(icon: Icons.schedule_rounded, label: assignment.dueLabel),
              _InfoChip(
                icon: Icons.rule_folder_outlined,
                label: '${assignment.questionsCount} أسئلة',
              ),
              _InfoChip(
                icon: Icons.timer_outlined,
                label: '${assignment.estimatedMinutes} دقيقة',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MetricBox(
                  title: 'تم التسليم',
                  value: '$submitted/$total',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricBox(
                  title: 'بانتظار التصحيح',
                  value: '$pendingReview',
                  color: AppColors.third,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricBox(
                  title: 'لم يسلّم',
                  value: '$missing',
                  color: AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: progress.clamp(0, 1).toDouble(),
              minHeight: 7,
              backgroundColor: AppColors.lightGrey.withValues(alpha: 0.25),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            assignment.instructions,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size10,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onTrackPressed,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.analytics_outlined, size: 18),
                  label: Text(
                    'متابعة الواجب',
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size11,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onCreatePressed,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.secondary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: const Icon(Icons.addchart_rounded, size: 18),
                  label: Text(
                    'واجب جديد',
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size11,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _MetricBox({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size13,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            textAlign: TextAlign.center,
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

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: getBoldStyle(
          fontFamily: FontConstant.cairo,
          fontSize: FontSize.size9,
          color: color,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primaryDark),
          const SizedBox(width: 6),
          Text(
            label,
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size10,
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}

