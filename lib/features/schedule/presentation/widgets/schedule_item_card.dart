import 'package:flutter/material.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/helper/on_genrated_routes.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../classroom/presentation/pages/attendance_page.dart';
import '../../data/model/schedule_model.dart';

class ScheduleItemCard extends StatelessWidget {
  final ScheduleModel item;
  final bool showTopLine;
  final bool showBottomLine;

  const ScheduleItemCard({
    super.key,
    required this.item,
    this.showTopLine = true,
    this.showBottomLine = true,
  });

  @override
  Widget build(BuildContext context) {
    final statusConfig = _statusConfig(item.status);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          SizedBox(
            width: 14,
            child: Column(
              children: [
                Container(
                  width: 2,
                  height: 16,
                  color: showTopLine ? statusConfig.lineColor : Colors.transparent,
                ),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: statusConfig.dotColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 2),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: showBottomLine ? statusConfig.lineColor : Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: statusConfig.borderColor.withValues(alpha: 0.14),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
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
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: statusConfig.backgroundColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          item.icon,
                          color: statusConfig.iconColor,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.subjectName,
                                    style: getBoldStyle(
                                      color: AppColors.primaryDark,
                                      fontSize: FontSize.size16,
                                      fontFamily: FontConstant.cairo,
                                    ),
                                  ),
                                ),
                                _StatusBadge(config: statusConfig),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${item.startTime} - ${item.endTime}',
                              style: getMediumStyle(
                                color: AppColors.primary,
                                fontSize: FontSize.size11,
                                fontFamily: FontConstant.cairo,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _MetaBadge(icon: Icons.school_outlined, label: item.cycleName),
                      _MetaBadge(icon: Icons.groups_2_outlined, label: item.className),
                      if (item.roomName != null)
                        _MetaBadge(icon: Icons.meeting_room_outlined, label: item.roomName!),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.lessonTitle,
                    style: getRegularStyle(
                      color: AppColors.primaryDark.withValues(alpha: 0.9),
                      fontSize: FontSize.size12,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionPill(
                          label: item.needsAttendance ? 'أخذ الحضور' : 'مراجعة الحضور',
                          icon: item.needsAttendance ? Icons.fact_check_outlined : Icons.check_circle_outline_rounded,
                          color: item.needsAttendance ? AppColors.third : AppColors.green,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => AttendancePage(scheduleItem: item),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ActionPill(
                          label: 'فتح الفصل',
                          icon: Icons.open_in_new_rounded,
                          color: AppColors.primary,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              Routes.classroom,
                              arguments: item,
                            );
                          },
                        ),
                      ),
                      if (item.hasHomework) ...[
                        const SizedBox(width: 8),
                        Expanded(
                          child: _ActionPill(
                            label: 'الواجبات',
                            icon: Icons.assignment_outlined,
                            color: AppColors.grey,
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                Routes.classroom,
                                arguments: item,
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (item.notes != null && item.notes!.trim().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      item.notes!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getRegularStyle(
                        color: AppColors.grey.withValues(alpha: 0.72),
                        fontSize: FontSize.size11,
                        fontFamily: FontConstant.cairo,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  _ScheduleStatusConfig _statusConfig(ScheduleStatus status) {
    switch (status) {
      case ScheduleStatus.current:
        return _ScheduleStatusConfig(
          label: 'الآن',
          dotColor: AppColors.primary,
          lineColor: AppColors.primary.withValues(alpha: 0.3),
          iconColor: AppColors.primary,
          borderColor: AppColors.primary,
          backgroundColor: const Color(0xFFE7F7FA),
        );
      case ScheduleStatus.completed:
        return const _ScheduleStatusConfig(
          label: 'انتهت',
          dotColor: AppColors.green,
          lineColor: AppColors.green,
          iconColor: AppColors.green,
          borderColor: AppColors.green,
          backgroundColor: Color(0xFFEFFBF6),
        );
      case ScheduleStatus.upcoming:
        return _ScheduleStatusConfig(
          label: 'قادمة',
          dotColor: AppColors.third,
          lineColor: AppColors.lightGrey.withValues(alpha: 0.8),
          iconColor: AppColors.third,
          borderColor: AppColors.third,
          backgroundColor: const Color(0xFFFFF6E8),
        );
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final _ScheduleStatusConfig config;

  const _StatusBadge({required this.config});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        config.label,
        style: getBoldStyle(
          color: config.iconColor,
          fontSize: FontSize.size10,
          fontFamily: FontConstant.cairo,
        ),
      ),
    );
  }
}

class _MetaBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primaryDark),
          const SizedBox(width: 4),
          Text(
            label,
            style: getMediumStyle(
              color: AppColors.primaryDark,
              fontSize: FontSize.size10,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionPill({required this.label, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getMediumStyle(
                  color: color,
                  fontSize: FontSize.size10,
                  fontFamily: FontConstant.cairo,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleStatusConfig {
  final String label;
  final Color dotColor;
  final Color lineColor;
  final Color iconColor;
  final Color borderColor;
  final Color backgroundColor;

  const _ScheduleStatusConfig({
    required this.label,
    required this.dotColor,
    required this.lineColor,
    required this.iconColor,
    required this.borderColor,
    required this.backgroundColor,
  });
}
