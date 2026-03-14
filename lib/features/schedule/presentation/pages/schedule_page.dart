import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../data/model/schedule_model.dart';
import '../cubits/schedule_cubit.dart';
import '../cubits/schedule_state.dart';
import '../widgets/day_date_selector.dart';
import '../widgets/schedule_header.dart';
import '../widgets/schedule_list.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  static const String _allFilter = 'الكل';

  late DateTime _selectedDate;
  late List<DayModel> _days;
  String _selectedCycle = _allFilter;
  String _selectedGrade = _allFilter;
  String _selectedSection = _allFilter;
  bool _showAttentionOnly = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _generateDays();
  }

  void _generateDays() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday % 7));

    _days = List.generate(7, (index) {
      final date = startOfWeek.add(Duration(days: index));
      return DayModel(
        date: date,
        dayName: _getDayName(date.weekday),
        isSelected: _isSameDay(date, _selectedDate),
      );
    });
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case DateTime.sunday:
        return 'الأحد';
      case DateTime.monday:
        return 'الاثنين';
      case DateTime.tuesday:
        return 'الثلاثاء';
      case DateTime.wednesday:
        return 'الأربعاء';
      case DateTime.thursday:
        return 'الخميس';
      case DateTime.friday:
        return 'الجمعة';
      case DateTime.saturday:
        return 'السبت';
      default:
        return '';
    }
  }

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  void _resetFilters() {
    setState(() {
      _selectedCycle = _allFilter;
      _selectedGrade = _allFilter;
      _selectedSection = _allFilter;
      _showAttentionOnly = false;
    });
  }

  List<String> _withAllOption(Iterable<String> values) {
    final unique = <String>{};
    for (final value in values) {
      if (value.trim().isNotEmpty) {
        unique.add(value);
      }
    }
    return <String>[_allFilter, ...unique];
  }

  List<ScheduleModel> _applyFilters(
    List<ScheduleModel> items, {
    required String cycle,
    required String grade,
    required String section,
    required bool attentionOnly,
  }) {
    return items.where((item) {
      final matchesCycle = cycle == _allFilter || item.cycleName == cycle;
      final matchesGrade = grade == _allFilter || item.gradeName == grade;
      final matchesSection =
          section == _allFilter || item.sectionName == section;
      final matchesAttention = !attentionOnly || item.requiresAttention;

      return matchesCycle &&
          matchesGrade &&
          matchesSection &&
          matchesAttention;
    }).toList()
      ..sort((a, b) => a.periodIndex.compareTo(b.periodIndex));
  }

  ScheduleModel? _pickFocusItem(List<ScheduleModel> schedule) {
    for (final item in schedule) {
      if (item.status == ScheduleStatus.current) {
        return item;
      }
    }
    for (final item in schedule) {
      if (item.status == ScheduleStatus.upcoming) {
        return item;
      }
    }
    if (schedule.isNotEmpty) {
      return schedule.last;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ScheduleCubit>()..fetchSchedule(_selectedDate),
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F9FC),
        body: SafeArea(
          child: BlocBuilder<ScheduleCubit, ScheduleState>(
            builder: (context, state) {
              final allSchedule = state is ScheduleSuccess
                  ? (List<ScheduleModel>.from(state.schedule)
                    ..sort((a, b) => a.periodIndex.compareTo(b.periodIndex)))
                  : <ScheduleModel>[];

              final cycleOptions =
                  _withAllOption(allSchedule.map((item) => item.cycleName));
              final effectiveCycle = cycleOptions.contains(_selectedCycle)
                  ? _selectedCycle
                  : _allFilter;

              final cycleScoped = effectiveCycle == _allFilter
                  ? allSchedule
                  : allSchedule
                        .where((item) => item.cycleName == effectiveCycle)
                        .toList();

              final gradeOptions =
                  _withAllOption(cycleScoped.map((item) => item.gradeName));
              final effectiveGrade = gradeOptions.contains(_selectedGrade)
                  ? _selectedGrade
                  : _allFilter;

              final gradeScoped = effectiveGrade == _allFilter
                  ? cycleScoped
                  : cycleScoped
                        .where((item) => item.gradeName == effectiveGrade)
                        .toList();

              final sectionOptions =
                  _withAllOption(gradeScoped.map((item) => item.sectionName));
              final effectiveSection =
                  sectionOptions.contains(_selectedSection)
                  ? _selectedSection
                  : _allFilter;

              final filteredSchedule = _applyFilters(
                allSchedule,
                cycle: effectiveCycle,
                grade: effectiveGrade,
                section: effectiveSection,
                attentionOnly: _showAttentionOnly,
              );

              final focusItem = _pickFocusItem(filteredSchedule);
              final totalClasses =
                  allSchedule.map((item) => item.className).toSet().length;

              return Column(
                children: [
                  ScheduleHeader(
                    selectedDate: _selectedDate,
                    totalPeriods: allSchedule.length,
                    classCount: totalClasses,
                  ),
                  DayDateSelector(
                    days: _days,
                    selectedDate: _selectedDate,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                        _generateDays();
                      });
                      context.read<ScheduleCubit>().fetchSchedule(date);
                    },
                  ),
                  Expanded(
                    child: _buildBody(
                      state: state,
                      filteredSchedule: filteredSchedule,
                      focusItem: focusItem,
                      cycleOptions: cycleOptions,
                      gradeOptions: gradeOptions,
                      sectionOptions: sectionOptions,
                      effectiveCycle: effectiveCycle,
                      effectiveGrade: effectiveGrade,
                      effectiveSection: effectiveSection,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody({
    required ScheduleState state,
    required List<ScheduleModel> filteredSchedule,
    required ScheduleModel? focusItem,
    required List<String> cycleOptions,
    required List<String> gradeOptions,
    required List<String> sectionOptions,
    required String effectiveCycle,
    required String effectiveGrade,
    required String effectiveSection,
  }) {
    if (state is ScheduleLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ScheduleError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            state.error.message,
            textAlign: TextAlign.center,
            style: getRegularStyle(
              color: AppColors.error,
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ),
      );
    }

    if (state is! ScheduleSuccess) {
      return const SizedBox.shrink();
    }

    final hasActiveFilters =
        effectiveCycle != _allFilter ||
        effectiveGrade != _allFilter ||
        effectiveSection != _allFilter ||
        _showAttentionOnly;

    final attentionCount =
        filteredSchedule.where((item) => item.requiresAttention).length;
    final classCount =
        filteredSchedule.map((item) => item.className).toSet().length;
    final attendanceCount =
        filteredSchedule.where((item) => item.needsAttendance).length;
    final homeworkCount =
        filteredSchedule.where((item) => item.hasHomework).length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
      children: [
        _TeacherFocusCard(
          item: focusItem,
          selectedDate: _selectedDate,
          filteredCount: filteredSchedule.length,
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _StatCard(
                title: 'حصص اليوم',
                value: filteredSchedule.length.toString(),
                icon: Icons.view_agenda_outlined,
                color: AppColors.primary,
              ),
              const SizedBox(width: 10),
              _StatCard(
                title: 'الشعب',
                value: classCount.toString(),
                icon: Icons.groups_rounded,
                color: AppColors.secondary,
              ),
              const SizedBox(width: 10),
              _StatCard(
                title: 'حضور مطلوب',
                value: attendanceCount.toString(),
                icon: Icons.fact_check_outlined,
                color: AppColors.third,
              ),
              const SizedBox(width: 10),
              _StatCard(
                title: 'متابعة',
                value: attentionCount.toString(),
                icon: Icons.priority_high_rounded,
                color: AppColors.errorRed,
              ),
              const SizedBox(width: 10),
              _StatCard(
                title: 'واجبات',
                value: homeworkCount.toString(),
                icon: Icons.assignment_outlined,
                color: AppColors.green,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _FiltersCard(
          cycleOptions: cycleOptions,
          gradeOptions: gradeOptions,
          sectionOptions: sectionOptions,
          selectedCycle: effectiveCycle,
          selectedGrade: effectiveGrade,
          selectedSection: effectiveSection,
          showAttentionOnly: _showAttentionOnly,
          hasActiveFilters: hasActiveFilters,
          onCycleSelected: (value) {
            setState(() {
              _selectedCycle = value;
              _selectedGrade = _allFilter;
              _selectedSection = _allFilter;
            });
          },
          onGradeSelected: (value) {
            setState(() {
              _selectedGrade = value;
              _selectedSection = _allFilter;
            });
          },
          onSectionSelected: (value) {
            setState(() {
              _selectedSection = value;
            });
          },
          onAttentionToggle: (value) {
            setState(() {
              _showAttentionOnly = value;
            });
          },
          onReset: _resetFilters,
        ),
        const SizedBox(height: 14),
        ScheduleList(
          schedule: filteredSchedule,
          hasActiveFilters: hasActiveFilters,
          onClearFilters: _resetFilters,
        ),
      ],
    );
  }
}

class _TeacherFocusCard extends StatelessWidget {
  final ScheduleModel? item;
  final DateTime selectedDate;
  final int filteredCount;

  const _TeacherFocusCard({
    required this.item,
    required this.selectedDate,
    required this.filteredCount,
  });

  @override
  Widget build(BuildContext context) {
    final isToday = DateUtils.isSameDay(selectedDate, DateTime.now());
    final title = item == null
        ? 'لا توجد حصة ظاهرة الآن'
        : item!.status == ScheduleStatus.current
        ? 'الحصة الحالية'
        : item!.status == ScheduleStatus.upcoming
        ? 'الحصة القادمة'
        : 'آخر حصة في اليوم';

    final subtitle = item == null
        ? 'يمكنك تغيير اليوم أو توسيع الفلاتر لعرض حصص المدرس.'
        : '${item!.subjectName} - ${item!.lessonTitle}';

    final footer = item == null
        ? 'عدد الحصص الظاهرة: $filteredCount'
        : '${item!.className} • ${item!.startTime} - ${item!.endTime}';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.tips_and_updates_outlined,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: getBoldStyle(
                        color: AppColors.primaryDark,
                        fontSize: FontSize.size15,
                        fontFamily: FontConstant.cairo,
                      ),
                    ),
                    Text(
                      isToday
                          ? 'وصول سريع للحصة والحضور وفتح الفصل'
                          : 'عرض مختصر للحصص المجدولة',
                      style: getRegularStyle(
                        color: AppColors.grey.withValues(alpha: 0.72),
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
          Text(
            subtitle,
            style: getBoldStyle(
              color: AppColors.primaryDark,
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item == null
                ? 'الجدول هنا مخصص للحصص والشعب المرتبطة بالمدرس فقط، بما يتوافق مع توزيع الجداول الأكاديمية.'
                : item!.notes ??
                    'ابدأ من أخذ الحضور أو فتح الفصل حسب سياق الحصة.',
            style: getRegularStyle(
              color: AppColors.grey.withValues(alpha: 0.84),
              fontSize: FontSize.size12,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.lightGrey.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              footer,
              style: getMediumStyle(
                color: AppColors.primaryDark,
                fontSize: FontSize.size11,
                fontFamily: FontConstant.cairo,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 108,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: getBoldStyle(
              color: AppColors.primaryDark,
              fontSize: FontSize.size18,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: getRegularStyle(
              color: AppColors.grey.withValues(alpha: 0.75),
              fontSize: FontSize.size11,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ],
      ),
    );
  }
}

class _FiltersCard extends StatelessWidget {
  final List<String> cycleOptions;
  final List<String> gradeOptions;
  final List<String> sectionOptions;
  final String selectedCycle;
  final String selectedGrade;
  final String selectedSection;
  final bool showAttentionOnly;
  final bool hasActiveFilters;
  final ValueChanged<String> onCycleSelected;
  final ValueChanged<String> onGradeSelected;
  final ValueChanged<String> onSectionSelected;
  final ValueChanged<bool> onAttentionToggle;
  final VoidCallback onReset;

  const _FiltersCard({
    required this.cycleOptions,
    required this.gradeOptions,
    required this.sectionOptions,
    required this.selectedCycle,
    required this.selectedGrade,
    required this.selectedSection,
    required this.showAttentionOnly,
    required this.hasActiveFilters,
    required this.onCycleSelected,
    required this.onGradeSelected,
    required this.onSectionSelected,
    required this.onAttentionToggle,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'فلاتر الجدول',
                style: getBoldStyle(
                  color: AppColors.primaryDark,
                  fontSize: FontSize.size15,
                  fontFamily: FontConstant.cairo,
                ),
              ),
              const Spacer(),
              if (hasActiveFilters)
                TextButton(
                  onPressed: onReset,
                  child: Text(
                    'إعادة الضبط',
                    style: getBoldStyle(
                      color: AppColors.primary,
                      fontSize: FontSize.size11,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                ),
            ],
          ),
          Text(
            'المرحلة ثم الصف ثم الشعبة، بما يتوافق مع الهيكل الأكاديمي وتوزيع الجداول.',
            style: getRegularStyle(
              color: AppColors.grey.withValues(alpha: 0.76),
              fontSize: FontSize.size11,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: cycleOptions
                .map(
                  (option) => _CycleChip(
                    label: option,
                    isSelected: option == selectedCycle,
                    onTap: () => onCycleSelected(option),
                  ),
                )
                .toList(growable: false),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _FilterDropdown(
                  label: 'الصف',
                  value: selectedGrade,
                  options: gradeOptions,
                  onChanged: onGradeSelected,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _FilterDropdown(
                  label: 'الشعبة',
                  value: selectedSection,
                  options: sectionOptions,
                  onChanged: onSectionSelected,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.lightGrey.withValues(alpha: 0.32),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  showAttentionOnly
                      ? Icons.priority_high_rounded
                      : Icons.remove_red_eye_outlined,
                  color: AppColors.primaryDark,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'إظهار ما يحتاج متابعة فقط',
                        style: getBoldStyle(
                          color: AppColors.primaryDark,
                          fontSize: FontSize.size12,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                      Text(
                        'مثل الحضور غير المسجل أو الحصة التي تحتاج استكمال التحضير.',
                        style: getRegularStyle(
                          color: AppColors.grey.withValues(alpha: 0.72),
                          fontSize: FontSize.size10,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: showAttentionOnly,
                  onChanged: onAttentionToggle,
                  activeThumbColor: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CycleChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CycleChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.lightGrey.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: getBoldStyle(
            color: isSelected ? AppColors.white : AppColors.primaryDark,
            fontSize: FontSize.size11,
            fontFamily: FontConstant.cairo,
          ),
        ),
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6, right: 4),
          child: Text(
            label,
            style: getMediumStyle(
              color: AppColors.primaryDark,
              fontSize: FontSize.size12,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.lightGrey.withValues(alpha: 0.24),
            borderRadius: BorderRadius.circular(16),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              borderRadius: BorderRadius.circular(18),
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              items: options
                  .map(
                    (option) => DropdownMenuItem<String>(
                      value: option,
                      child: Text(
                        option,
                        style: getMediumStyle(
                          color: AppColors.primaryDark,
                          fontSize: FontSize.size13,
                          fontFamily: FontConstant.cairo,
                        ),
                      ),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (value) {
                if (value != null) {
                  onChanged(value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
