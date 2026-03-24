import 'package:flutter/material.dart';
import 'package:teacher_app/core/utils/constant/font_manger.dart';
import 'package:teacher_app/core/utils/constant/styles_manger.dart';
import 'package:teacher_app/core/utils/helper/on_genrated_routes.dart';
import 'package:teacher_app/core/utils/theme/app_colors.dart';
import 'package:teacher_app/features/tasks/data/models/teacher_task_model.dart';
import 'package:teacher_app/features/tasks/data/repositories/teacher_tasks_repo.dart';
import 'package:teacher_app/features/tasks/presentation/widgets/teacher_task_card.dart';
import 'package:teacher_app/features/tasks/presentation/widgets/teacher_task_summary_card.dart';
import 'package:teacher_app/features/tasks/presentation/widgets/teacher_tasks_filters_card.dart';
import 'package:teacher_app/features/tasks/presentation/widgets/teacher_tasks_header.dart';
import 'package:teacher_app/features/tasks/presentation/widgets/teacher_tasks_scroll_configuration.dart';

class TeacherTasksPage extends StatefulWidget {
  const TeacherTasksPage({super.key});

  @override
  State<TeacherTasksPage> createState() => _TeacherTasksPageState();
}

enum _TasksViewFilter { pendingApproval, active, completed }

class _TeacherTasksPageState extends State<TeacherTasksPage> {
  final TeacherTasksRepo _repo = TeacherTasksRepo();
  final TextEditingController _searchController = TextEditingController();

  TeacherTaskDashboardModel? _dashboard;
  List<TeacherStudentTaskModel> _tasks = const [];
  bool _loading = true;
  String _selectedClassId = 'all';
  _TasksViewFilter _selectedFilter = _TasksViewFilter.pendingApproval;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final dashboard = await _repo.getDashboard();
    if (!mounted) return;
    setState(() {
      _dashboard = dashboard;
      _tasks = dashboard.tasks;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F9FC),
        surfaceTintColor: Colors.transparent,
        title: Text(
          'مهام الطلاب',
          style: getBoldStyle(
            fontFamily: FontConstant.cairo,
            fontSize: FontSize.size16,
            color: AppColors.primaryDark,
          ),
        ),
      ),
      body: TeacherTasksScrollConfiguration(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _dashboard == null
            ? const SizedBox.shrink()
            : RefreshIndicator(
                onRefresh: _load,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                  children: [
                    TeacherTasksHeader(onCreateTap: _openCreatePage),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: TeacherTaskSummaryCard(
                            title: 'نشطة',
                            value: _tasks
                                .where(
                                  (task) =>
                                      task.isActive &&
                                      !task.hasPendingApprovals,
                                )
                                .length
                                .toString(),
                            subtitle: 'قيد التنفيذ أو لم تبدأ',
                            icon: Icons.play_circle_outline_rounded,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TeacherTaskSummaryCard(
                            title: 'بانتظار اعتماد',
                            value: _tasks
                                .where((task) => task.hasPendingApprovals)
                                .length
                                .toString(),
                            subtitle: 'مراحل مرفوعة من الطلاب',
                            icon: Icons.approval_outlined,
                            color: AppColors.info,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TeacherTaskSummaryCard(
                            title: 'منفذة',
                            value: _tasks
                                .where(
                                  (task) =>
                                      task.status ==
                                      TeacherTaskStatus.completed,
                                )
                                .length
                                .toString(),
                            subtitle: 'تم إنهاؤها واعتمادها',
                            icon: Icons.check_circle_outline_rounded,
                            color: AppColors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TeacherTasksFiltersCard(
                      searchController: _searchController,
                      selectedClassId: _selectedClassId,
                      classes: _dashboard!.assignedClasses,
                      onClassChanged: (value) =>
                          setState(() => _selectedClassId = value),
                      onSearchChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    _buildStatusTabs(),
                    const SizedBox(height: 14),
                    ..._buildGroupedTaskSections(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildStatusTabs() {
    return Row(
      children: [
        Expanded(
          child: _StatusTab(
            label: 'بانتظار اعتماد',
            selected: _selectedFilter == _TasksViewFilter.pendingApproval,
            onTap: () => setState(
              () => _selectedFilter = _TasksViewFilter.pendingApproval,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatusTab(
            label: 'نشطة',
            selected: _selectedFilter == _TasksViewFilter.active,
            onTap: () =>
                setState(() => _selectedFilter = _TasksViewFilter.active),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatusTab(
            label: 'منفذة',
            selected: _selectedFilter == _TasksViewFilter.completed,
            onTap: () =>
                setState(() => _selectedFilter = _TasksViewFilter.completed),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildGroupedTaskSections() {
    final filtered = _filteredTasks();
    if (filtered.isEmpty) {
      return [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Center(
            child: Text(
              'لا توجد مهام مطابقة للفلاتر الحالية.',
              style: getMediumStyle(
                fontFamily: FontConstant.cairo,
                fontSize: FontSize.size11,
                color: AppColors.grey,
              ),
            ),
          ),
        ),
      ];
    }

    final Map<String, List<TeacherStudentTaskModel>> grouped = {};
    for (final task in filtered) {
      grouped.putIfAbsent(task.classLabel, () => []).add(task);
    }

    return grouped.entries.map((entry) {
      final first = entry.value.first;
      return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '${entry.key} • ${first.subjectName}',
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size12,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
            ...entry.value.map(
              (task) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TeacherTaskCard(
                  task: task,
                  onTap: () => _openTaskDetails(task),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<TeacherStudentTaskModel> _filteredTasks() {
    final query = _searchController.text.trim();

    return _tasks.where((task) {
      final matchesClass =
          _selectedClassId == 'all' || task.classId == _selectedClassId;
      final matchesQuery =
          query.isEmpty ||
          task.title.contains(query) ||
          task.studentName.contains(query) ||
          task.subjectName.contains(query);

      final matchesFilter = switch (_selectedFilter) {
        _TasksViewFilter.pendingApproval => task.hasPendingApprovals,
        _TasksViewFilter.active => task.isActive && !task.hasPendingApprovals,
        _TasksViewFilter.completed =>
          task.status == TeacherTaskStatus.completed,
      };

      return matchesClass && matchesQuery && matchesFilter;
    }).toList();
  }

  Future<void> _openCreatePage() async {
    final dashboard = _dashboard;
    if (dashboard == null) return;

    final createdTask = await Navigator.of(
      context,
    ).pushNamed(Routes.teacherTaskCreate, arguments: dashboard);

    if (createdTask is TeacherStudentTaskModel) {
      setState(() {
        _tasks = [createdTask, ..._tasks];
        _selectedFilter = _TasksViewFilter.active;
      });
    }
  }

  Future<void> _openTaskDetails(TeacherStudentTaskModel task) async {
    final updatedTask = await Navigator.of(
      context,
    ).pushNamed(Routes.teacherTaskDetails, arguments: task);

    if (updatedTask is TeacherStudentTaskModel) {
      setState(() {
        _tasks = _tasks
            .map((item) => item.id == updatedTask.id ? updatedTask : item)
            .toList();
      });
    }
  }
}

class _StatusTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _StatusTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.14)
              : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.3)
                : AppColors.lightGrey.withValues(alpha: 0.5),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size10,
              color: selected ? AppColors.primaryDark : AppColors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
