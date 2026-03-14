import 'package:flutter/material.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../data/models/home_data_model.dart';

class WeeklyScheduleWidget extends StatelessWidget {
  final List<ScheduleDayModel> weeklySchedule;

  const WeeklyScheduleWidget({super.key, required this.weeklySchedule});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildTable(),
          const SizedBox(height: 20),
          _buildFullViewButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(Icons.more_horiz, color: AppColors.grey),
        Text(
          'الجدول الدراسي الأسبوعي',
          style: getBoldStyle(
            color: AppColors.primaryDark,
            fontSize: FontSize.size20,
            fontFamily: FontConstant.cairo,
          ),
        ),
      ],
    );
  }

  Widget _buildTable() {
    // Days: Sun, Mon, Tue
    // Periods: 1, 2, 3, 4, 5
    final periods = [
      {'label': 'الأولى', 'time': '8-8:45'},
      {'label': 'الثانية', 'time': '9-9:45'},
      {'label': 'الثالثة', 'time': '10-10:45'},
      {'label': 'الرابعة', 'time': '11-11:45'},
      {'label': 'الخامسة', 'time': '12-12:45'},
    ];

    final days = ['الأحد', 'الاثنين', 'الثلاثاء'];

    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const {
        0: FlexColumnWidth(1.2), // Day labels
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
        5: FlexColumnWidth(1),
      },
      children: [
        // Table Header (Periods)
        TableRow(
          children: [
            _buildTableHeaderCell('اليوم / الحصة'),
            ...periods.map((p) => _buildTableHeaderCell(p['label']!, subTitle: p['time'])),
          ],
        ),
        // Rows for each day
        ...days.map((dayName) {
          final dayData = weeklySchedule.firstWhere(
            (d) => d.dayName == dayName,
            orElse: () => ScheduleDayModel(dayName: dayName, items: []),
          );
          return TableRow(
            children: [
              _buildDayLabelCell(dayName),
              ...List.generate(5, (index) {
                final periodIndex = index + 1;
                final item = dayData.items.firstWhere(
                  (i) => i.periodIndex == periodIndex,
                  orElse: () => ScheduleItemModel(subject: '', className: '', time: ''),
                );
                return _buildScheduleCell(item);
              }),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildTableHeaderCell(String title, {String? subTitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Text(
            title,
            style: getBoldStyle(
              color: AppColors.grey.withValues(alpha: 0.6),
              fontSize: FontSize.size10,
              fontFamily: FontConstant.cairo,
            ),
            textAlign: TextAlign.center,
          ),
          if (subTitle != null)
            Text(
              subTitle,
              style: getRegularStyle(
                color: AppColors.grey.withValues(alpha: 0.4),
                fontSize: FontSize.size8,
                fontFamily: FontConstant.cairo,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Widget _buildDayLabelCell(String day) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        day,
        style: getBoldStyle(
          color: AppColors.grey,
          fontSize: FontSize.size14,
          fontFamily: FontConstant.cairo,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildScheduleCell(ScheduleItemModel item) {
    if (item.subject.isEmpty) {
      return Container(
        height: 55,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.lightGrey.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(10),
        ),
      );
    }

    return Container(
      height: 55,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: item.isCurrent ? AppColors.primary : AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: item.isCurrent ? null : Border.all(color: AppColors.grey.withValues(alpha: 0.2)),
        boxShadow: item.isCurrent
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.subject,
            style: getBoldStyle(
              color: item.isCurrent ? AppColors.white : AppColors.grey,
              fontSize: FontSize.size10,
              fontFamily: FontConstant.cairo,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            item.className,
            style: getRegularStyle(
              color: item.isCurrent ? AppColors.white.withValues(alpha: 0.8) : AppColors.primary,
              fontSize: FontSize.size10,
              fontFamily: FontConstant.cairo,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFullViewButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          'عرض الجدول بالكامل',
          style: getBoldStyle(
            color: AppColors.white,
            fontSize: FontSize.size16,
            fontFamily: FontConstant.cairo,
          ),
        ),
      ),
    );
  }
}
