import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../cubits/schedule_cubit.dart';
import '../cubits/schedule_state.dart';
import 'schedule_item_card.dart';

class ScheduleList extends StatelessWidget {
  const ScheduleList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        if (state is ScheduleLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ScheduleSuccess) {
          if (state.schedule.isEmpty) {
            return const Center(
              child: Text(
                'لا يوجد حصص مجدولة لهذا اليوم',
                style: TextStyle(fontFamily: 'Cairo'),
              ),
            );
          }
          return Stack(
            children: [
              // Timeline line
              Positioned(
                right: 27,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 2,
                  color: AppColors.lightGrey.withValues(alpha: 0.5),
                ),
              ),
              ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                itemCount: state.schedule.length,
                itemBuilder: (context, index) {
                  return ScheduleItemCard(item: state.schedule[index]);
                },
              ),
            ],
          );
        } else if (state is ScheduleError) {
          return Center(child: Text(state.error.message));
        }
        return const SizedBox();
      },
    );
  }
}
