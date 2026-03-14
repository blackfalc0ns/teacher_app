import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/theme/app_colors.dart';
import '../cubits/home_cubit.dart';
import '../cubits/home_state.dart';
import '../widgets/home_header.dart';
import '../widgets/stat_card.dart';
import '../widgets/weekly_schedule_widget.dart';
import '../widgets/summary_action_card.dart';
import 'package:teacher_app/core/error_widgets/api_error_widget.dart';

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

  Widget _buildContent(dynamic data) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Header
            HomeHeader(userInfo: data.userInfo),

            // Horizontal Stats
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

            // Weekly Schedule
            WeeklyScheduleWidget(weeklySchedule: data.weeklySchedule),

            // Bottom Action Cards
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
            const SizedBox(
              height: 56,
            ), // Extra space for the floating bottom bar
          ],
        ),
      ),
    );
  }
}
