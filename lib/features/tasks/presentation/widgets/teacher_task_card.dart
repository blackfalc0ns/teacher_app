import 'package:flutter/material.dart';
import 'package:teacher_app/core/utils/constant/font_manger.dart';
import 'package:teacher_app/core/utils/constant/styles_manger.dart';
import 'package:teacher_app/core/utils/theme/app_colors.dart';
import 'package:teacher_app/features/tasks/data/models/teacher_task_model.dart';

class TeacherTaskCard extends StatelessWidget {
  final TeacherStudentTaskModel task;
  final VoidCallback onTap;
  final bool compact;

  const TeacherTaskCard({
    super.key,
    required this.task,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final statusStyle = _statusStyle(task);
    final rewardColor = task.rewardType == TeacherTaskRewardType.financial
        ? const Color(0xFFF59E0B)
        : AppColors.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        padding: EdgeInsets.all(compact ? 14 : 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: task.hasPendingApprovals
                ? AppColors.info.withValues(alpha: 0.25)
                : AppColors.lightGrey.withValues(alpha: 0.45),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.035),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: compact ? FontSize.size12 : FontSize.size14,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${task.studentName} • ${task.classLabel}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getRegularStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size9,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _StatusChip(
                  label: statusStyle.label,
                  color: statusStyle.color,
                  icon: statusStyle.icon,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _MetaChip(
                  icon: Icons.auto_stories_outlined,
                  label: task.subjectName,
                ),
                _MetaChip(
                  icon: Icons.card_giftcard_rounded,
                  label: task.rewardValue,
                  color: rewardColor,
                ),
                _MetaChip(
                  icon: Icons.date_range_outlined,
                  label: _formatDue(task.dueDate),
                ),
                if (task.hasPendingApprovals)
                  _MetaChip(
                    icon: Icons.approval_outlined,
                    label: '${task.pendingApprovalsCount} بانتظار الموافقة',
                    color: AppColors.info,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: task.progress,
                minHeight: compact ? 6 : 8,
                backgroundColor: const Color(0xFFEAF0F5),
                valueColor: AlwaysStoppedAnimation<Color>(
                  task.hasPendingApprovals
                      ? AppColors.secondary
                      : AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'تم إنجاز ${task.completedStagesCount} من ${task.stages.length} مراحل',
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size9,
                    color: AppColors.grey,
                  ),
                ),
                const Spacer(),
                Text(
                  '${(task.progress * 100).round()}%',
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size10,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDue(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
    if (difference == 0) return 'موعد اليوم';
    if (difference == 1) return 'غدًا';
    if (difference > 1) return 'بعد $difference أيام';
    return 'منتهية';
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _StatusChip({
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size9,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _MetaChip({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColors.primaryDark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: chipColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size9,
              color: chipColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskStatusStyle {
  final String label;
  final Color color;
  final IconData icon;

  const _TaskStatusStyle({
    required this.label,
    required this.color,
    required this.icon,
  });
}

_TaskStatusStyle _statusStyle(TeacherStudentTaskModel task) {
  if (task.hasPendingApprovals ||
      task.status == TeacherTaskStatus.underReview) {
    return const _TaskStatusStyle(
      label: 'بانتظار اعتماد',
      color: AppColors.info,
      icon: Icons.hourglass_top_rounded,
    );
  }

  switch (task.status) {
    case TeacherTaskStatus.completed:
      return const _TaskStatusStyle(
        label: 'مكتملة',
        color: AppColors.green,
        icon: Icons.check_circle_rounded,
      );
    case TeacherTaskStatus.inProgress:
      return const _TaskStatusStyle(
        label: 'نشطة',
        color: AppColors.primary,
        icon: Icons.play_circle_outline_rounded,
      );
    case TeacherTaskStatus.pending:
      return const _TaskStatusStyle(
        label: 'لم تبدأ',
        color: AppColors.grey,
        icon: Icons.schedule_rounded,
      );
    case TeacherTaskStatus.underReview:
      return const _TaskStatusStyle(
        label: 'بانتظار اعتماد',
        color: AppColors.info,
        icon: Icons.hourglass_top_rounded,
      );
  }
}
