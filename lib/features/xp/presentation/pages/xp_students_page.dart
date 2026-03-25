import 'package:flutter/material.dart';
import 'package:teacher_app/core/utils/common/custom_app_bar.dart';
import 'package:teacher_app/core/utils/constant/font_manger.dart';
import 'package:teacher_app/core/utils/constant/styles_manger.dart';
import 'package:teacher_app/core/utils/theme/app_colors.dart';
import 'package:teacher_app/features/xp/data/models/xp_center_model.dart';
import 'package:teacher_app/features/xp/presentation/widgets/xp_filters_card.dart';
import 'package:teacher_app/features/xp/presentation/widgets/xp_students_section.dart';

class XpStudentsPageArgs {
  final XpCenterDashboardModel dashboard;

  XpStudentsPageArgs({required this.dashboard});
}

class XpStudentsPage extends StatefulWidget {
  final XpStudentsPageArgs args;

  const XpStudentsPage({super.key, required this.args});

  @override
  State<XpStudentsPage> createState() => _XpStudentsPageState();
}

class _XpStudentsPageState extends State<XpStudentsPage> {
  final TextEditingController _searchController = TextEditingController();
  static const String _allFilter = 'الكل';
  String _selectedCycle = _allFilter;
  String _selectedGrade = _allFilter;
  String _selectedSection = _allFilter;

  List<String> _withAll(Iterable<String> items) => [
    _allFilter,
    ...items.toSet(),
  ];

  List<XpStudentProgressModel> _applyFilters(
    List<XpStudentProgressModel> students,
  ) {
    final query = _searchController.text.trim().toLowerCase();
    return students.where((student) {
      final matchesCycle =
          _selectedCycle == _allFilter || student.cycleName == _selectedCycle;
      final matchesGrade =
          _selectedGrade == _allFilter || student.gradeName == _selectedGrade;
      final matchesSection =
          _selectedSection == _allFilter ||
          student.sectionName == _selectedSection;
      final matchesSearch =
          query.isEmpty || student.studentName.toLowerCase().contains(query);
      return matchesCycle && matchesGrade && matchesSection && matchesSearch;
    }).toList()..sort((a, b) => b.seasonXp.compareTo(a.seasonXp));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = widget.args.dashboard;
    final cycleOptions = _withAll(
      dashboard.assignedClasses.map((item) => item.cycleName),
    );

    // Scoped filtering for dropdowns
    final cycleScoped = _selectedCycle == _allFilter
        ? dashboard.assignedClasses
        : dashboard.assignedClasses
              .where((item) => item.cycleName == _selectedCycle)
              .toList();

    final gradeOptions = _withAll(cycleScoped.map((item) => item.gradeName));

    final gradeScoped = _selectedGrade == _allFilter
        ? cycleScoped
        : cycleScoped
              .where((item) => item.gradeName == _selectedGrade)
              .toList();

    final sectionOptions = _withAll(
      gradeScoped.map((item) => item.sectionName),
    );

    final studentsList = _applyFilters(dashboard.students);

    return Scaffold(
      appBar: CustomAppBar(title: 'قائمة الطلاب الأعلى تأثيرًا'),

      body: Column(
        children: [
          XpFiltersCard(
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
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: XpStudentsSection(
                students: studentsList,
                onViewAll:
                    () {}, // Already here, button won't be visible if handled correctly or just no-op
              ),
            ),
          ),
        ],
      ),
    );
  }
}
