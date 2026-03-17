import 'package:flutter/material.dart';

import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../data/models/teacher_class_model.dart';
import '../../data/repositories/my_classes_repo.dart';
import '../widgets/my_class_card.dart';
import '../widgets/my_classes_filters_card.dart';
import '../widgets/my_classes_header.dart';
import '../widgets/my_classes_summary_card.dart';

class MyClassesPage extends StatefulWidget {
  const MyClassesPage({super.key});

  @override
  State<MyClassesPage> createState() => _MyClassesPageState();
}

class _MyClassesPageState extends State<MyClassesPage> {
  static const String _allFilter = 'الكل';

  final MyClassesRepo _repo = MyClassesRepo();
  final TextEditingController _searchController = TextEditingController();

  late Future<List<TeacherClassModel>> _future;
  String _selectedCycle = _allFilter;
  bool _showAttentionOnly = false;

  @override
  void initState() {
    super.initState();
    _future = _repo.getTeacherClasses();
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
      body: Column(
        children: [
          const MyClassesHeader(),
          Expanded(
            child: FutureBuilder<List<TeacherClassModel>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'حدث خطأ أثناء تحميل البيانات.',
                        style: getRegularStyle(
                          color: AppColors.error,
                          fontSize: FontSize.size14,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                    ),
                  );
                }

                final classes = snapshot.data ?? <TeacherClassModel>[];
                final cycleOptions = <String>[_allFilter, ...classes.map((item) => item.cycleName).toSet()];
                final filteredClasses = _applyFilters(classes);
                final studentsCount = filteredClasses.fold<int>(0, (sum, item) => sum + item.studentsCount);
                final attentionCount = filteredClasses.where((item) => item.needsAttention).length;
                final todayCount = filteredClasses.where((item) => item.todayPeriods > 0).length;

                return RefreshIndicator(
                  onRefresh: () async {
                    final future = _repo.getTeacherClasses();
                    setState(() {
                      _future = future;
                    });
                    await future;
                  },
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                    children: [
                      MyClassesSummaryCard(
                        classesCount: filteredClasses.length,
                        studentsCount: studentsCount,
                        attentionCount: attentionCount,
                        todayCount: todayCount,
                      ),
                      const SizedBox(height: 12),
                      MyClassesFiltersCard(
                        searchController: _searchController,
                        cycleOptions: cycleOptions,
                        selectedCycle: _selectedCycle,
                        onCycleSelected: (value) {
                          setState(() {
                            _selectedCycle = value;
                          });
                        },
                        showAttentionOnly: _showAttentionOnly,
                        onAttentionToggle: (value) {
                          setState(() {
                            _showAttentionOnly = value;
                          });
                        },
                        onReset: _resetFilters,
                      ),
                      const SizedBox(height: 14),
                      if (filteredClasses.isEmpty)
                        _EmptyState(showFilteredState: classes.isNotEmpty)
                      else
                        ...filteredClasses.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: MyClassCard(teacherClass: item),
                          ),
                        ),
                      const SizedBox(height: 56),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedCycle = _allFilter;
      _showAttentionOnly = false;
      _searchController.clear();
    });
  }

  List<TeacherClassModel> _applyFilters(List<TeacherClassModel> classes) {
    final query = _searchController.text.trim().toLowerCase();
    return classes.where((item) {
      final matchesCycle = _selectedCycle == _allFilter || item.cycleName == _selectedCycle;
      final matchesAttention = !_showAttentionOnly || item.needsAttention;
      final matchesQuery = query.isEmpty ||
          item.gradeName.toLowerCase().contains(query) ||
          item.sectionName.toLowerCase().contains(query) ||
          item.subjectName.toLowerCase().contains(query);
      return matchesCycle && matchesAttention && matchesQuery;
    }).toList(growable: false);
  }
}

class _EmptyState extends StatelessWidget {
  final bool showFilteredState;

  const _EmptyState({required this.showFilteredState});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.class_outlined, size: 28, color: AppColors.primary),
          ),
          const SizedBox(height: 12),
          Text(
            showFilteredState ? 'لا توجد فصول تطابق المعايير المحددة' : 'لا توجد فصول مضافة لحسابك بعد',
            style: getBoldStyle(
              color: AppColors.primaryDark,
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            showFilteredState
                ? 'جرب تغيير المعايير أو إعادة تعيين الفلاتر للعثور على نتائج.'
                : 'سوف تظهر الفصول المضافة لحسابك هنا مع إمكانية الوصول والمتابعة.',
            textAlign: TextAlign.center,
            style: getRegularStyle(
              color: AppColors.grey,
              fontSize: FontSize.size11,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ],
      ),
    );
  }
}