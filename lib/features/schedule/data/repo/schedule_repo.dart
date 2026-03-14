import 'package:flutter/material.dart';

import '../../../../core/network/api_helper.dart';
import '../../../../core/network/api_service.dart';
import '../model/schedule_model.dart';

abstract class ScheduleRepo {
  Future<ApiResult<List<ScheduleModel>>> getScheduleByDate(DateTime date);
}

class ScheduleRepoImpl implements ScheduleRepo {
  final ApiService _apiService;

  ScheduleRepoImpl(this._apiService);

  @override
  Future<ApiResult<List<ScheduleModel>>> getScheduleByDate(DateTime date) async {
    final _ = _apiService.hashCode;

    return ApiHelper.safeApiCall(() async {
      await Future.delayed(const Duration(milliseconds: 800));
      return _buildScheduleForDate(date);
    });
  }

  List<ScheduleModel> _buildScheduleForDate(DateTime date) {
    if (date.weekday == DateTime.friday) {
      return [];
    }

    final selectedDayItems =
        _weeklySchedule[date.weekday] ?? _weeklySchedule[DateTime.sunday] ?? [];

    return selectedDayItems
        .map((item) => item.copyWith(status: _resolveStatus(date, item)))
        .toList();
  }

  Map<int, List<ScheduleModel>> get _weeklySchedule => {
    DateTime.sunday: [
      _item(
        id: 'sun-1',
        subjectName: 'الرياضيات',
        cycleName: 'المرحلة الابتدائية',
        gradeName: 'الصف الخامس',
        sectionName: 'أ',
        lessonTitle: 'القيمة المنزلية والأنماط العددية',
        roomName: '5A',
        startTime: '07:00',
        endTime: '07:45',
        periodLabel: 'الحصة الأولى',
        periodIndex: 1,
        studentsCount: 27,
        needsAttendance: true,
        isPrepared: true,
        hasHomework: false,
        notes: 'أخذ الحضور ثم فتح نشاط التهيئة.',
        icon: Icons.calculate_rounded,
      ),
      _item(
        id: 'sun-2',
        subjectName: 'العلوم',
        cycleName: 'المرحلة الابتدائية',
        gradeName: 'الصف الرابع',
        sectionName: 'ب',
        lessonTitle: 'دورات حياة الكائنات الحية',
        roomName: '4B',
        startTime: '07:50',
        endTime: '08:35',
        periodLabel: 'الحصة الثانية',
        periodIndex: 2,
        studentsCount: 29,
        needsAttendance: false,
        isPrepared: true,
        hasHomework: true,
        notes: 'متابعة واجب التجربة العملية.',
        icon: Icons.science_outlined,
      ),
      _item(
        id: 'sun-3',
        subjectName: 'اللغة العربية',
        cycleName: 'المرحلة المتوسطة',
        gradeName: 'الصف الأول المتوسط',
        sectionName: 'أ',
        lessonTitle: 'الفهم القرائي',
        roomName: 'M1-A',
        startTime: '09:10',
        endTime: '09:55',
        periodLabel: 'الحصة الرابعة',
        periodIndex: 4,
        studentsCount: 31,
        needsAttendance: true,
        isPrepared: true,
        hasHomework: false,
        notes: 'فتح الفصل ثم تسجيل المشاركة.',
        icon: Icons.menu_book_rounded,
      ),
      _item(
        id: 'sun-4',
        subjectName: 'الرياضيات',
        cycleName: 'المرحلة الثانوية',
        gradeName: 'الصف الأول الثانوي',
        sectionName: '1',
        lessonTitle: 'المعادلات الخطية',
        roomName: 'S1-1',
        startTime: '10:00',
        endTime: '10:45',
        periodLabel: 'الحصة الخامسة',
        periodIndex: 5,
        studentsCount: 24,
        needsAttendance: false,
        isPrepared: true,
        hasHomework: true,
        notes: 'يوجد واجب قصير بعد الحصة.',
        icon: Icons.functions_rounded,
      ),
    ],
    DateTime.monday: [
      _item(
        id: 'mon-1',
        subjectName: 'الرياضيات',
        cycleName: 'المرحلة الابتدائية',
        gradeName: 'الصف السادس',
        sectionName: 'ب',
        lessonTitle: 'الكسور الاعتيادية',
        roomName: '6B',
        startTime: '07:00',
        endTime: '07:45',
        periodLabel: 'الحصة الأولى',
        periodIndex: 1,
        studentsCount: 26,
        needsAttendance: true,
        isPrepared: true,
        hasHomework: false,
        notes: 'تفعيل بداية الدرس مباشرة.',
        icon: Icons.calculate_rounded,
      ),
      _item(
        id: 'mon-2',
        subjectName: 'اللغة الإنجليزية',
        cycleName: 'المرحلة المتوسطة',
        gradeName: 'الصف الثاني المتوسط',
        sectionName: 'أ',
        lessonTitle: 'Reading Comprehension',
        roomName: 'M2-A',
        startTime: '07:50',
        endTime: '08:35',
        periodLabel: 'الحصة الثانية',
        periodIndex: 2,
        studentsCount: 28,
        needsAttendance: false,
        isPrepared: true,
        hasHomework: true,
        notes: 'تأكيد تسليم المهمة السابقة.',
        icon: Icons.translate_rounded,
      ),
      _item(
        id: 'mon-3',
        subjectName: 'الرياضيات',
        cycleName: 'المرحلة المتوسطة',
        gradeName: 'الصف الثالث المتوسط',
        sectionName: 'ب',
        lessonTitle: 'مساحة الأشكال المركبة',
        roomName: 'M3-B',
        startTime: '09:10',
        endTime: '09:55',
        periodLabel: 'الحصة الرابعة',
        periodIndex: 4,
        studentsCount: 30,
        needsAttendance: true,
        isPrepared: false,
        hasHomework: false,
        notes: 'إكمال التحضير قبل بداية الحصة.',
        icon: Icons.square_foot_outlined,
      ),
      _item(
        id: 'mon-4',
        subjectName: 'الفيزياء',
        cycleName: 'المرحلة الثانوية',
        gradeName: 'الصف الثاني الثانوي',
        sectionName: '2',
        lessonTitle: 'السرعة والتسارع',
        roomName: 'S2-2',
        startTime: '10:00',
        endTime: '10:45',
        periodLabel: 'الحصة الخامسة',
        periodIndex: 5,
        studentsCount: 22,
        needsAttendance: false,
        isPrepared: true,
        hasHomework: true,
        notes: 'متابعة درجات النشاط العملي.',
        icon: Icons.bolt_outlined,
      ),
    ],
    DateTime.tuesday: [
      _item(
        id: 'tue-1',
        subjectName: 'العلوم',
        cycleName: 'المرحلة الابتدائية',
        gradeName: 'الصف الخامس',
        sectionName: 'ب',
        lessonTitle: 'التكيف عند النباتات',
        roomName: '5B',
        startTime: '07:00',
        endTime: '07:45',
        periodLabel: 'الحصة الأولى',
        periodIndex: 1,
        studentsCount: 25,
        needsAttendance: true,
        isPrepared: true,
        hasHomework: false,
        notes: 'أخذ الحضور وبدء النشاط الجماعي.',
        icon: Icons.science_outlined,
      ),
      _item(
        id: 'tue-2',
        subjectName: 'الرياضيات',
        cycleName: 'المرحلة المتوسطة',
        gradeName: 'الصف الأول المتوسط',
        sectionName: 'ج',
        lessonTitle: 'الأعداد الصحيحة',
        roomName: 'M1-C',
        startTime: '07:50',
        endTime: '08:35',
        periodLabel: 'الحصة الثانية',
        periodIndex: 2,
        studentsCount: 32,
        needsAttendance: false,
        isPrepared: true,
        hasHomework: false,
        notes: 'فتح الفصل وعرض الواجب السابق.',
        icon: Icons.calculate_rounded,
      ),
      _item(
        id: 'tue-3',
        subjectName: 'الإحصاء',
        cycleName: 'المرحلة الثانوية',
        gradeName: 'الصف الثالث الثانوي',
        sectionName: 'أدبي',
        lessonTitle: 'تنظيم البيانات',
        roomName: 'S3-A',
        startTime: '09:10',
        endTime: '09:55',
        periodLabel: 'الحصة الرابعة',
        periodIndex: 4,
        studentsCount: 21,
        needsAttendance: true,
        isPrepared: true,
        hasHomework: true,
        notes: 'يوجد تقييم قصير داخل الحصة.',
        icon: Icons.bar_chart_rounded,
      ),
    ],
    DateTime.wednesday: [
      _item(
        id: 'wed-1',
        subjectName: 'الرياضيات',
        cycleName: 'المرحلة الثانوية',
        gradeName: 'الصف الأول الثانوي',
        sectionName: '2',
        lessonTitle: 'المتباينات',
        roomName: 'S1-2',
        startTime: '07:00',
        endTime: '07:45',
        periodLabel: 'الحصة الأولى',
        periodIndex: 1,
        studentsCount: 23,
        needsAttendance: true,
        isPrepared: true,
        hasHomework: false,
        notes: 'بدء الحصة من أمثلة الكتاب.',
        icon: Icons.calculate_rounded,
      ),
      _item(
        id: 'wed-2',
        subjectName: 'اللغة العربية',
        cycleName: 'المرحلة المتوسطة',
        gradeName: 'الصف الثاني المتوسط',
        sectionName: 'ب',
        lessonTitle: 'الأسلوب اللغوي',
        roomName: 'M2-B',
        startTime: '07:50',
        endTime: '08:35',
        periodLabel: 'الحصة الثانية',
        periodIndex: 2,
        studentsCount: 27,
        needsAttendance: false,
        isPrepared: true,
        hasHomework: true,
        notes: 'متابعة تسليمات الواجب.',
        icon: Icons.menu_book_rounded,
      ),
      _item(
        id: 'wed-3',
        subjectName: 'العلوم',
        cycleName: 'المرحلة الابتدائية',
        gradeName: 'الصف السادس',
        sectionName: 'أ',
        lessonTitle: 'مصادر الطاقة',
        roomName: '6A',
        startTime: '09:10',
        endTime: '09:55',
        periodLabel: 'الحصة الرابعة',
        periodIndex: 4,
        studentsCount: 28,
        needsAttendance: true,
        isPrepared: true,
        hasHomework: false,
        notes: 'تسجيل الحضور ثم تنفيذ النشاط.',
        icon: Icons.wb_sunny_outlined,
      ),
    ],
    DateTime.thursday: [
      _item(
        id: 'thu-1',
        subjectName: 'الرياضيات',
        cycleName: 'المرحلة الابتدائية',
        gradeName: 'الصف الرابع',
        sectionName: 'أ',
        lessonTitle: 'الضرب في عدد من رقمين',
        roomName: '4A',
        startTime: '07:00',
        endTime: '07:45',
        periodLabel: 'الحصة الأولى',
        periodIndex: 1,
        studentsCount: 26,
        needsAttendance: true,
        isPrepared: true,
        hasHomework: false,
        notes: 'تسجيل الحضور ثم مراجعة سريعة.',
        icon: Icons.calculate_rounded,
      ),
      _item(
        id: 'thu-2',
        subjectName: 'اللغة الإنجليزية',
        cycleName: 'المرحلة الثانوية',
        gradeName: 'الصف الثاني الثانوي',
        sectionName: '1',
        lessonTitle: 'Writing Skills',
        roomName: 'S2-1',
        startTime: '07:50',
        endTime: '08:35',
        periodLabel: 'الحصة الثانية',
        periodIndex: 2,
        studentsCount: 20,
        needsAttendance: false,
        isPrepared: false,
        hasHomework: true,
        notes: 'تجهيز ملف المهمة قبل الحصة.',
        icon: Icons.translate_rounded,
      ),
      _item(
        id: 'thu-3',
        subjectName: 'الرياضيات',
        cycleName: 'المرحلة المتوسطة',
        gradeName: 'الصف الثالث المتوسط',
        sectionName: 'أ',
        lessonTitle: 'مراجعة أسبوعية',
        roomName: 'M3-A',
        startTime: '09:10',
        endTime: '09:55',
        periodLabel: 'الحصة الرابعة',
        periodIndex: 4,
        studentsCount: 31,
        needsAttendance: true,
        isPrepared: true,
        hasHomework: true,
        notes: 'ربط الحصة بواجب ختامي.',
        icon: Icons.assignment_turned_in_outlined,
      ),
    ],
    DateTime.saturday: [
      _item(
        id: 'sat-1',
        subjectName: 'الرياضيات',
        cycleName: 'المرحلة الثانوية',
        gradeName: 'الصف الثالث الثانوي',
        sectionName: 'علمي',
        lessonTitle: 'المراجعة النهائية',
        roomName: 'S3-SCI',
        startTime: '09:00',
        endTime: '09:45',
        periodLabel: 'الحصة الأولى',
        periodIndex: 1,
        studentsCount: 18,
        needsAttendance: true,
        isPrepared: true,
        hasHomework: false,
        notes: 'جلسة دعم أكاديمي للطلاب المستهدفين.',
        icon: Icons.workspace_premium_outlined,
      ),
    ],
  };

  ScheduleModel _item({
    required String id,
    required String subjectName,
    required String cycleName,
    required String gradeName,
    required String sectionName,
    required String lessonTitle,
    required String? roomName,
    required String startTime,
    required String endTime,
    required String periodLabel,
    required int periodIndex,
    required int studentsCount,
    required bool needsAttendance,
    required bool isPrepared,
    required bool hasHomework,
    required String notes,
    required IconData icon,
  }) {
    return ScheduleModel(
      id: id,
      subjectName: subjectName,
      className: '$gradeName / شعبة $sectionName',
      cycleName: cycleName,
      gradeName: gradeName,
      sectionName: sectionName,
      lessonTitle: lessonTitle,
      roomName: roomName,
      notes: notes,
      startTime: startTime,
      endTime: endTime,
      periodLabel: periodLabel,
      periodIndex: periodIndex,
      studentsCount: studentsCount,
      needsAttendance: needsAttendance,
      isPrepared: isPrepared,
      hasHomework: hasHomework,
      status: ScheduleStatus.upcoming,
      icon: icon,
    );
  }

  ScheduleStatus _resolveStatus(DateTime selectedDate, ScheduleModel item) {
    final now = DateTime.now();
    final selectedDay = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    final today = DateTime(now.year, now.month, now.day);

    if (selectedDay.isBefore(today)) {
      return ScheduleStatus.completed;
    }

    if (selectedDay.isAfter(today)) {
      return ScheduleStatus.upcoming;
    }

    final start = _timeOnDate(selectedDate, item.startTime);
    final end = _timeOnDate(selectedDate, item.endTime);

    if (now.isAfter(end)) {
      return ScheduleStatus.completed;
    }
    if (!now.isBefore(start) && now.isBefore(end)) {
      return ScheduleStatus.current;
    }
    return ScheduleStatus.upcoming;
  }

  DateTime _timeOnDate(DateTime date, String value) {
    final parts = value.split(':');
    return DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }
}
