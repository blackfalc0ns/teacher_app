import 'package:flutter/material.dart';
import 'package:teacher_app/core/utils/navigation/custom_bottom_nav_bar.dart';
import 'package:teacher_app/core/utils/theme/app_colors.dart';
import 'home_page.dart';
import '../../../schedule/presentation/pages/schedule_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const SchedulePage(),
    const Center(child: Text('الواجبات')),
    const Center(child: Text('الأداء والتقارير')),
    const Center(child: Text('الرسائل')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // For the floating look of the bottom bar
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
        elevation:
            0, // Elevation is handled by the Container box shadow for better control
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: AppColors.primary, size: 35),
      ),
    );
  }
}
