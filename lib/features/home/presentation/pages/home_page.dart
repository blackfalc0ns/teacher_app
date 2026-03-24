import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/core/error_widgets/api_error_widget.dart';
import 'package:teacher_app/features/tasks/presentation/widgets/home_teacher_tasks_section.dart';

import '../../../../core/utils/theme/app_colors.dart';
import '../../data/models/home_data_model.dart';
import '../cubits/home_cubit.dart';
import '../cubits/home_state.dart';
import '../widgets/home_header.dart';
import '../widgets/stat_card.dart';
import '../widgets/summary_action_card.dart';
import '../widgets/weekly_schedule_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HomeError) {
          return ApiErrorWidget(
            exception: state.error,
            onRetry: () => context.read<HomeCubit>().getHomeData(),
          );
        } else if (state is HomeSuccess) {
          return _buildContent(state.data);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildContent(HomeDataModel data) {
    return Container(
      color: const Color(0xFFF6F9FC),
      child: SingleChildScrollView(
        child: Column(
          children: [
            HomeHeader(userInfo: data.userInfo),
            const SizedBox(height: 16),
            SizedBox(
              height: 85,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: data.stats.length,
                itemBuilder: (context, index) {
                  return StatCard(stat: data.stats[index]);
                },
              ),
            ),
            WeeklyScheduleWidget(weeklySchedule: data.weeklySchedule),
            const HomeTeacherTasksSection(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SummaryActionCard(
                    summary: data.actionSummaries[1],
                    iconColor: AppColors.primary,
                  ),
                  SummaryActionCard(
                    summary: data.actionSummaries[0],
                    iconColor: AppColors.secondary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
