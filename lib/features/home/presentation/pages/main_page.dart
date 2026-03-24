import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/core/di/injection_container.dart';
import 'package:teacher_app/core/utils/navigation/custom_bottom_nav_bar.dart';
import 'package:teacher_app/core/utils/theme/app_colors.dart';
import 'package:teacher_app/features/home/presentation/cubits/home_cubit.dart';
import 'package:teacher_app/features/home/presentation/cubits/home_state.dart';
import 'package:teacher_app/features/home/presentation/pages/my_classes_tab_page.dart';
import 'package:teacher_app/features/home/presentation/widgets/teacher_drawer.dart';
import 'package:teacher_app/features/homeworks/presentation/pages/homeworks_page.dart';
import 'package:teacher_app/features/messages/presentation/pages/messages_screen.dart';
import 'package:teacher_app/features/schedule/presentation/cubits/schedule_cubit.dart';

import '../../../schedule/presentation/pages/schedule_page.dart';
import 'home_page.dart';

class MainPage extends StatefulWidget {
  final int initialIndex;

  const MainPage({super.key, this.initialIndex = 0});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _selectedIndex;
  late final ScheduleCubit _scheduleCubit;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _scheduleCubit = sl<ScheduleCubit>()..fetchSchedule(DateTime.now());
    _pages = [
      const HomePage(),
      BlocProvider.value(
        value: _scheduleCubit,
        child: const SchedulePage(),
      ),
      const MyClassesTabPage(),
      const HomeworksPage(),
      const MessagesScreen(),
    ];
    _selectedIndex = widget.initialIndex.clamp(0, _pages.length - 1);
  }

  @override
  void dispose() {
    _scheduleCubit.close();
    super.dispose();
  }

  void _onTabChanged(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          _selectedIndex == 0 || previous.runtimeType != current.runtimeType,
      builder: (context, state) {
        return Scaffold(
          extendBody: true,
          drawer: _selectedIndex == 0 && state is HomeSuccess
              ? TeacherDrawer(data: state.data)
              : null,
          body: IndexedStack(
            index: _selectedIndex,
            children: _pages,
          ),
          bottomNavigationBar: CustomBottomNavBar(
            selectedIndex: _selectedIndex,
            onTap: _onTabChanged,
          ),
          floatingActionButton:
              _selectedIndex == 1 || _selectedIndex == 3 ? null : _buildFab(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniEndFloat,
        );
      },
    );
  }

  Widget _buildFab() {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.white,
        elevation: 0,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: AppColors.primary, size: 35),
      ),
    );
  }
}
