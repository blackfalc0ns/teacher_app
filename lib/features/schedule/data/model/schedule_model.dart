import 'package:flutter/material.dart';

enum ScheduleStatus { completed, current, upcoming }

class ScheduleModel {
  final String id;
  final String subjectName;
  final String className;
  final String cycleName;
  final String gradeName;
  final String sectionName;
  final String lessonTitle;
  final String? roomName;
  final String? notes;
  final String startTime;
  final String endTime;
  final String periodLabel;
  final int periodIndex;
  final int studentsCount;
  final bool needsAttendance;
  final bool isPrepared;
  final bool hasHomework;
  final ScheduleStatus status;
  final IconData icon;

  ScheduleModel({
    required this.id,
    required this.subjectName,
    required this.className,
    required this.cycleName,
    required this.gradeName,
    required this.sectionName,
    required this.lessonTitle,
    this.roomName,
    this.notes,
    required this.startTime,
    required this.endTime,
    required this.periodLabel,
    required this.periodIndex,
    required this.studentsCount,
    required this.needsAttendance,
    required this.isPrepared,
    required this.hasHomework,
    required this.status,
    required this.icon,
  });

  String get fullClassLabel => '$gradeName / $sectionName';

  bool get requiresAttention => needsAttendance || !isPrepared;

  ScheduleModel copyWith({
    String? id,
    String? subjectName,
    String? className,
    String? cycleName,
    String? gradeName,
    String? sectionName,
    String? lessonTitle,
    String? roomName,
    String? notes,
    String? startTime,
    String? endTime,
    String? periodLabel,
    int? periodIndex,
    int? studentsCount,
    bool? needsAttendance,
    bool? isPrepared,
    bool? hasHomework,
    ScheduleStatus? status,
    IconData? icon,
  }) {
    return ScheduleModel(
      id: id ?? this.id,
      subjectName: subjectName ?? this.subjectName,
      className: className ?? this.className,
      cycleName: cycleName ?? this.cycleName,
      gradeName: gradeName ?? this.gradeName,
      sectionName: sectionName ?? this.sectionName,
      lessonTitle: lessonTitle ?? this.lessonTitle,
      roomName: roomName ?? this.roomName,
      notes: notes ?? this.notes,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      periodLabel: periodLabel ?? this.periodLabel,
      periodIndex: periodIndex ?? this.periodIndex,
      studentsCount: studentsCount ?? this.studentsCount,
      needsAttendance: needsAttendance ?? this.needsAttendance,
      isPrepared: isPrepared ?? this.isPrepared,
      hasHomework: hasHomework ?? this.hasHomework,
      status: status ?? this.status,
      icon: icon ?? this.icon,
    );
  }
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
