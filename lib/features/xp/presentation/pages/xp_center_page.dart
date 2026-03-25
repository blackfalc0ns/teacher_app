import 'package:flutter/material.dart';
import 'package:teacher_app/core/utils/helper/on_genrated_routes.dart';
import 'package:teacher_app/features/xp/data/models/xp_center_model.dart';
import 'package:teacher_app/features/xp/data/repositories/xp_repo.dart';
import 'package:teacher_app/features/xp/presentation/pages/xp_students_page.dart';
import 'package:teacher_app/features/xp/presentation/widgets/xp_center_header.dart';
import 'package:teacher_app/features/xp/presentation/widgets/xp_filters_card.dart';
import 'package:teacher_app/features/xp/presentation/widgets/xp_overview_cards.dart';
import 'package:teacher_app/features/xp/presentation/widgets/xp_rank_distribution_card.dart';
import 'package:teacher_app/features/xp/presentation/widgets/xp_rank_ladder_card.dart';
import 'package:teacher_app/features/xp/presentation/widgets/xp_recent_awards_card.dart';
import 'package:teacher_app/features/xp/presentation/widgets/xp_students_section.dart';

class XpCenterPage extends StatefulWidget {
  const XpCenterPage({super.key});

  @override
  State<XpCenterPage> createState() => _XpCenterPageState();
}

class _XpCenterPageState extends State<XpCenterPage> {
  static const String _allFilter = 'الكل';

  final _repo = XpRepoImpl();
  final _searchController = TextEditingController();
  late final XpCenterDashboardModel _dashboard;

  String _selectedCycle = _allFilter;
  String _selectedGrade = _allFilter;
  String _selectedSection = _allFilter;

  @override
  void initState() {
    super.initState();
    _dashboard = _repo.getDashboard();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> _withAll(Iterable<String> values) {
    return <String>[_allFilter, ...values.toSet()];
  }

  List<XpStudentProgressModel> _applyFilters(
    List<XpStudentProgressModel> items,
  ) {
    final query = _searchController.text.trim();
    return items.where((student) {
      final matchesCycle =
          _selectedCycle == _allFilter || student.cycleName == _selectedCycle;
      final matchesGrade =
          _selectedGrade == _allFilter || student.gradeName == _selectedGrade;
      final matchesSection =
          _selectedSection == _allFilter ||
          student.sectionName == _selectedSection;
      final matchesQuery =
          query.isEmpty ||
          student.studentName.contains(query) ||
          student.classLabel.contains(query);

      return matchesCycle && matchesGrade && matchesSection && matchesQuery;
    }).toList()..sort((a, b) => b.seasonXp.compareTo(a.seasonXp));
  }

  List<XpDistributionItemModel> _distributionFor(
    List<XpStudentProgressModel> students,
  ) {
    return XpRankTier.values
        .map((tier) {
          return XpDistributionItemModel(
            rankTier: tier,
            studentsCount: students
                .where((student) => student.rankTier == tier)
                .length,
          );
        })
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final cycleOptions = _withAll(
      _dashboard.assignedClasses.map((item) => item.cycleName),
    );
    final cycleScoped = _selectedCycle == _allFilter
        ? _dashboard.students
        : _dashboard.students
              .where((student) => student.cycleName == _selectedCycle)
              .toList();
    final gradeOptions = _withAll(cycleScoped.map((item) => item.gradeName));
    final gradeScoped = _selectedGrade == _allFilter
        ? cycleScoped
        : cycleScoped
              .where((student) => student.gradeName == _selectedGrade)
              .toList();
    final sectionOptions = _withAll(
      gradeScoped.map((item) => item.sectionName),
    );
    final students = _applyFilters(_dashboard.students);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: XpCenterHeader(
              seasonLabel: _dashboard.seasonLabel,
              availableBonusXp: _dashboard.bonusPolicy.teacherAvailableBudget,
            ),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 14)),
          SliverToBoxAdapter(
            child: XpOverviewCards(
              trackedStudentsCount: _dashboard.trackedStudentsCount,
              totalSeasonXp: _dashboard.totalSeasonXp,
              autoGrantedXp: _dashboard.autoGrantedXp,
              pendingBoostCandidates: _dashboard.pendingBoostCandidates,
            ),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 14)),
          SliverToBoxAdapter(
            child: XpFiltersCard(
              searchController: _searchController,
              cycleOptions: cycleOptions,
              gradeOptions: gradeOptions,
              sectionOptions: sectionOptions,
              selectedCycle: _selectedCycle,
              selectedGrade: _selectedGrade,
              selectedSection: _selectedSection,
              onCycleChanged: (value) {
                setState(() {
                  _selectedCycle = value;
                  _selectedGrade = _allFilter;
                  _selectedSection = _allFilter;
                });
              },
              onGradeChanged: (value) {
                setState(() {
                  _selectedGrade = value;
                  _selectedSection = _allFilter;
                });
              },
              onSectionChanged: (value) {
                setState(() {
                  _selectedSection = value;
                });
              },
              onSearchChanged: (_) => setState(() {}),
              onReset: () {
                setState(() {
                  _searchController.clear();
                  _selectedCycle = _allFilter;
                  _selectedGrade = _allFilter;
                  _selectedSection = _allFilter;
                });
              },
            ),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 14)),
          SliverToBoxAdapter(
            child: XpRankLadderCard(distribution: _distributionFor(students)),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 14)),
          SliverToBoxAdapter(
            child: XpRankDistributionCard(
              distribution: _distributionFor(students),
              sources: _dashboard.sourceBreakdown,
            ),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 24)),
          SliverToBoxAdapter(
            child: XpStudentsSection(
              students: students,
              onViewAll: () {
                Navigator.pushNamed(
                  context,
                  Routes.xpStudents,
                  arguments: XpStudentsPageArgs(dashboard: _dashboard),
                );
              },
            ),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 2)),
          SliverToBoxAdapter(
            child: XpRecentAwardsCard(records: _dashboard.recentBonusRecords),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}
