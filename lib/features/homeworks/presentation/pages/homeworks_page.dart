import 'package:flutter/material.dart';

import '../../../classroom/data/models/classroom_model.dart';
import '../../../classroom/presentation/pages/assignment_create_page.dart';
import '../../../classroom/presentation/pages/assignment_tracking_page.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../data/models/homework_dashboard_model.dart';
import '../../data/repositories/homeworks_repo.dart';
import '../widgets/homework_assignment_card.dart';
import '../widgets/homework_classes_strip.dart';
import '../widgets/homeworks_charts_card.dart';
import '../widgets/homeworks_filters_card.dart';
import '../widgets/homeworks_header.dart';

class HomeworksPage extends StatefulWidget {
  const HomeworksPage({super.key});

  @override
  State<HomeworksPage> createState() => _HomeworksPageState();
}

class _HomeworksPageState extends State<HomeworksPage> {
  static const String _allFilter = 'الكل';

  final HomeworksRepo _repo = HomeworksRepo();
  final TextEditingController _searchController = TextEditingController();

  late Future<HomeworkDashboardData> _future;
  HomeworkDashboardData? _dashboard;
  String _selectedCycle = _allFilter;
  String _selectedTab = 'all';

  @override
  void initState() {
    super.initState();
    _future = _repo.getDashboard();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      body: FutureBuilder<HomeworkDashboardData>(
        future: _future,
        builder: (context, snapshot) {
          final dashboard = _dashboard ?? snapshot.data;

          return Column(
            children: [
              HomeworksHeader(
                assignmentsCount: dashboard?.assignmentsCount ?? 0,
                pendingReviewCount: dashboard?.pendingReviewCount ?? 0,
                missingSubmissionCount: dashboard?.missingSubmissionCount ?? 0,
                draftsCount: dashboard?.draftsCount ?? 0,
                onCreatePressed: () => _openCreatePicker(dashboard),
              ),
              Expanded(
                child: _buildBody(snapshot, dashboard),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(
    AsyncSnapshot<HomeworkDashboardData> snapshot,
    HomeworkDashboardData? dashboard,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting && dashboard == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError && dashboard == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'تعذر تحميل تبويب الواجبات الآن.',
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size14,
              color: AppColors.error,
            ),
          ),
        ),
      );
    }

    if (dashboard == null) {
      return const SizedBox.shrink();
    }

    final cycleOptions = <String>[
      _allFilter,
      ...dashboard.classes.map((item) => item.cycleName).toSet(),
    ];
    final visibleItems = _buildVisibleItems(dashboard);
    final focusClasses = dashboard.classes
        .where((item) => item.needsAttention)
        .take(6)
        .toList(growable: false);

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 110),
        children: [
          HomeworksFiltersCard(
            searchController: _searchController,
            cycleOptions: cycleOptions,
            selectedCycle: _selectedCycle,
            onCycleChanged: (value) {
              setState(() {
                _selectedCycle = value;
              });
            },
            selectedTab: _selectedTab,
            onTabChanged: (value) {
              setState(() {
                _selectedTab = value;
              });
            },
            onReset: _resetFilters,
          ),
          const SizedBox(height: 14),
          HomeworksChartsCard(dashboard: dashboard),
          const SizedBox(height: 14),
          HomeworkClassesStrip(
            classes: focusClasses,
            onCreateForClass: _openCreateForClass,
          ),
          if (focusClasses.isNotEmpty) const SizedBox(height: 14),
          Text(
            'قائمة الواجبات',
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size15,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'عرض موحّد لكل واجبات المعلم مع القدرة على المتابعة أو إنشاء واجب جديد لنفس الفصل.',
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size11,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 12),
          if (visibleItems.isEmpty)
            const _HomeworksEmptyState()
          else
            ...visibleItems.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: HomeworkAssignmentCard(
                  classItem: item.classItem,
                  assignment: item.assignment,
                  onTrackPressed: () => _openTracking(item.classItem),
                  onCreatePressed: () => _openCreateForClass(item.classItem),
                ),
              );
            }),
        ],
      ),
    );
  }

  List<_HomeworkListItem> _buildVisibleItems(HomeworkDashboardData dashboard) {
    final query = _searchController.text.trim().toLowerCase();
    return dashboard.classes
        .where((item) =>
            _selectedCycle == _allFilter || item.cycleName == _selectedCycle)
        .expand((classItem) {
          return classItem.assignments.where((assignment) {
            if (!_matchesTab(assignment)) {
              return false;
            }
            if (query.isEmpty) {
              return true;
            }
            return assignment.title.toLowerCase().contains(query) ||
                classItem.gradeName.toLowerCase().contains(query) ||
                classItem.sectionName.toLowerCase().contains(query) ||
                classItem.subjectName.toLowerCase().contains(query);
          }).map((assignment) {
            return _HomeworkListItem(
              classItem: classItem,
              assignment: assignment,
            );
          });
        })
        .toList(growable: false);
  }

  bool _matchesTab(ClassroomAssignment assignment) {
    switch (_selectedTab) {
      case 'needs_review':
        return assignment.submissions.any((submission) {
          return submission.status == AssignmentSubmissionStatus.submitted ||
              submission.status == AssignmentSubmissionStatus.late;
        });
      case 'missing':
        return assignment.submissions.any((submission) {
          return submission.status == AssignmentSubmissionStatus.notSubmitted;
        });
      case 'drafts':
        return !assignment.publishNow;
      case 'active':
        return assignment.publishNow;
      default:
        return true;
    }
  }

  Future<void> _refresh() async {
    final future = _repo.getDashboard();
    setState(() {
      _future = future;
    });
    final result = await future;
    if (!mounted) {
      return;
    }
    setState(() {
      _dashboard = result;
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedCycle = _allFilter;
      _selectedTab = 'all';
      _searchController.clear();
    });
  }

  Future<void> _openCreatePicker(HomeworkDashboardData? dashboard) async {
    final data = dashboard ?? _dashboard;
    if (data == null || data.classes.isEmpty) {
      return;
    }
    if (data.classes.length == 1) {
      await _openCreateForClass(data.classes.first);
      return;
    }

    final selectedClass = await showModalBottomSheet<HomeworkDashboardClass>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'اختر الفصل المراد إنشاء الواجب له',
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size14,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 10),
              ...data.classes.map((item) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    item.classLabel,
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size12,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  subtitle: Text(
                    item.subjectName,
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size10,
                      color: AppColors.grey,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: () => Navigator.of(context).pop(item),
                );
              }),
            ],
          ),
        );
      },
    );

    if (!mounted || selectedClass == null) {
      return;
    }
    await _openCreateForClass(selectedClass);
  }

  Future<void> _openCreateForClass(HomeworkDashboardClass classItem) async {
    final assignment = await Navigator.of(context).push<ClassroomAssignment>(
      MaterialPageRoute(
        builder: (_) => AssignmentCreatePage(item: classItem.focusItem),
      ),
    );

    if (!mounted || assignment == null) {
      return;
    }

    setState(() {
      final dashboard = _dashboard;
      if (dashboard == null) {
        return;
      }
      _dashboard = HomeworkDashboardData(
        classes: dashboard.classes.map((item) {
          if (item.id != classItem.id) {
            return item;
          }
          return HomeworkDashboardClass(
            teacherClass: item.teacherClass,
            assignments: [assignment, ...item.assignments],
          );
        }).toList(growable: false),
      );
    });
  }

  Future<void> _openTracking(HomeworkDashboardClass classItem) async {
    final updatedAssignments = await Navigator.of(context)
        .push<List<ClassroomAssignment>>(
      MaterialPageRoute(
        builder: (_) => AssignmentTrackingPage(
          item: classItem.focusItem,
          assignments: classItem.assignments,
        ),
      ),
    );

    if (!mounted || updatedAssignments == null) {
      return;
    }

    setState(() {
      final dashboard = _dashboard;
      if (dashboard == null) {
        return;
      }
      _dashboard = HomeworkDashboardData(
        classes: dashboard.classes.map((item) {
          if (item.id != classItem.id) {
            return item;
          }
          return HomeworkDashboardClass(
            teacherClass: item.teacherClass,
            assignments: updatedAssignments,
          );
        }).toList(growable: false),
      );
    });
  }
}

class _HomeworkListItem {
  final HomeworkDashboardClass classItem;
  final ClassroomAssignment assignment;

  const _HomeworkListItem({
    required this.classItem,
    required this.assignment,
  });
}

class _HomeworksEmptyState extends StatelessWidget {
  const _HomeworksEmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.assignment_late_outlined,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'لا توجد واجبات مطابقة للفلاتر الحالية',
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size14,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'جرّب توسيع البحث أو الانتقال إلى تبويب آخر أو إنشاء واجب جديد لفصل من فصولك.',
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size11,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
