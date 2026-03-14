import 'package:flutter/material.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../data/model/schedule_model.dart';

class DayDateSelector extends StatelessWidget {
  final List<DayModel> days;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const DayDateSelector({
    super.key,
    required this.days,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: days.length,
        itemBuilder: (context, index) {
          final day = days[index];
          final isSelected = day.date.day == selectedDate.day;

          return GestureDetector(
            onTap: () => onDateSelected(day.date),
            child: Container(
              width: 70,
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 5,
                        )
                      ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day.dayName,
                    style: getRegularStyle(
                      color: isSelected ? AppColors.white : AppColors.grey,
                      fontSize: FontSize.size12,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    day.date.day.toString(),
                    style: getBoldStyle(
                      color: isSelected ? AppColors.white : AppColors.primaryDark,
                      fontSize: FontSize.size18,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                  if (isSelected)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
