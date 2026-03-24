import 'package:flutter/material.dart';
import 'package:teacher_app/core/utils/constant/font_manger.dart';
import 'package:teacher_app/core/utils/constant/styles_manger.dart';
import 'package:teacher_app/core/utils/helper/on_genrated_routes.dart';
import 'package:teacher_app/core/utils/theme/app_colors.dart';
import 'package:teacher_app/features/tasks/data/models/teacher_task_model.dart';
import 'package:teacher_app/features/tasks/data/repositories/teacher_tasks_repo.dart';
import 'package:teacher_app/features/tasks/presentation/widgets/teacher_task_card.dart';

class HomeTeacherTasksSection extends StatefulWidget {
  const HomeTeacherTasksSection({super.key});

  @override
  State<HomeTeacherTasksSection> createState() =>
      _HomeTeacherTasksSectionState();
}

class _HomeTeacherTasksSectionState extends State<HomeTeacherTasksSection> {
  late final Future<TeacherTaskDashboardModel> _future;
  final TeacherTasksRepo _repo = TeacherTasksRepo();

  @override
  void initState() {
    super.initState();
    _future = _repo.getDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TeacherTaskDashboardModel>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final dashboard = snapshot.data!;
        final previewTasks = dashboard.tasks
            .where((task) => task.hasPendingApprovals)
            .take(2)
            .toList();
        final fallbackTasks = previewTasks.isEmpty
            ? dashboard.tasks.take(2).toList()
            : previewTasks;

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
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
                          'مهام الطلاب',
                          style: getBoldStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size16,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'إسناد مهام فردية ومتابعة مراحل التنفيذ والاعتمادات.',
                          style: getMediumStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: FontSize.size10,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(Routes.teacherTasks),
                    child: Text(
                      'إدارة المهام',
                      style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.lightGrey.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _MiniStat(
                          title: 'نشطة',
                          value: dashboard.activeTasksCount.toString(),
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 10),
                        _MiniStat(
                          title: 'بانتظار اعتماد',
                          value: dashboard.pendingApprovalTasksCount.toString(),
                          color: AppColors.info,
                        ),
                        const SizedBox(width: 10),
                        _MiniStat(
                          title: 'منفذة',
                          value: dashboard.completedTasksCount.toString(),
                          color: AppColors.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ...fallbackTasks.map(
                      (task) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TeacherTaskCard(
                          task: task,
                          compact: true,
                          onTap: () => Navigator.of(context).pushNamed(
                            Routes.teacherTaskDetails,
                            arguments: task,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.of(
                              context,
                            ).pushNamed(Routes.teacherTasks),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primaryDark,
                              side: BorderSide(
                                color: AppColors.lightGrey.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            icon: const Icon(
                              Icons.dashboard_customize_outlined,
                              size: 18,
                            ),
                            label: Text(
                              'لوحة المهام',
                              style: getBoldStyle(
                                fontFamily: FontConstant.cairo,
                                fontSize: FontSize.size10,
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () => Navigator.of(context).pushNamed(
                              Routes.teacherTaskCreate,
                              arguments: dashboard,
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            icon: const Icon(Icons.add_task_rounded, size: 18),
                            label: Text(
                              'إسناد مهمة',
                              style: getBoldStyle(
                                fontFamily: FontConstant.cairo,
                                fontSize: FontSize.size10,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _MiniStat({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.09),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: getBoldStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size15,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: getMediumStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size9,
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
