import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/schedule_model.dart';
import '../cubits/schedule_cubit.dart';
import '../../../../core/di/injection_container.dart';
import '../widgets/schedule_header.dart';
import '../widgets/day_date_selector.dart';
import '../widgets/schedule_list.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late DateTime _selectedDate;
  late List<DayModel> _days;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _generateDays();
  }

  void _generateDays() {
    _days = List.generate(7, (index) {
      final now = DateTime.now();
      final offset = index - now.weekday;
      final date = now.add(Duration(days: offset));
      return DayModel(
        date: date,
        dayName: _getDayName(date.weekday),
        isSelected: date.day == _selectedDate.day,
      );
    });
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case DateTime.sunday: return 'الأحد';
      case DateTime.monday: return 'الاثنين';
      case DateTime.tuesday: return 'الثلاثاء';
      case DateTime.wednesday: return 'الأربعاء';
      case DateTime.thursday: return 'الخميس';
      case DateTime.friday: return 'الجمعة';
      case DateTime.saturday: return 'السبت';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ScheduleCubit>()..fetchSchedule(_selectedDate),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          child: Column(
            children: [
              const ScheduleHeader(),
              Builder(
                builder: (context) => DayDateSelector(
                  days: _days,
                  selectedDate: _selectedDate,
                  onDateSelected: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                    context.read<ScheduleCubit>().fetchSchedule(date);
                  },
                ),
              ),
              const Expanded(
                child: ScheduleList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
