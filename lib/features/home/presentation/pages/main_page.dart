import 'package:flutter/material.dart';
import 'package:teacher_app/core/utils/navigation/custom_bottom_nav_bar.dart';
import 'package:teacher_app/core/utils/theme/app_colors.dart';
import 'package:teacher_app/features/home/presentation/pages/my_classes_tab_page.dart';
import 'package:teacher_app/features/messages/presentation/pages/messages_screen.dart';

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

  final List<Widget> _pages = [
    const HomePage(),
    const SchedulePage(),
    const MyClassesTabPage(),
    const Center(child: Text('الإعدادات')),
    const MessagesScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex.clamp(0, _pages.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      floatingActionButton: _selectedIndex == 1 ? null : _buildFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
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
