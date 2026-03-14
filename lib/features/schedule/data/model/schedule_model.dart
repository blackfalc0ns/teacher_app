import 'package:flutter/material.dart';

enum ScheduleStatus { completed, current, upcoming }

class ScheduleModel {
  final String id;
  final String subjectName;
  final String className;
  final String? roomName;
  final String startTime;
  final String endTime;
  final String periodLabel;
  final ScheduleStatus status;
  final IconData icon;

  ScheduleModel({
    required this.id,
    required this.subjectName,
    required this.className,
    this.roomName,
    required this.startTime,
    required this.endTime,
    required this.periodLabel,
    required this.status,
    required this.icon,
  });
}

class DayModel {
  final DateTime date;
  final String dayName;
  final bool isSelected;

  DayModel({
    required this.date,
    required this.dayName,
    this.isSelected = false,
  });
}
