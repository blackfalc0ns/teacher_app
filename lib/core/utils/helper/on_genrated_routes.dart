import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/features/home/presentation/pages/main_page.dart';

import '../../di/injection_container.dart';
import '../../../features/classroom/presentation/pages/classroom_page.dart';
import '../../../features/home/presentation/cubits/home_cubit.dart';
import '../../../features/schedule/data/model/schedule_model.dart';
import '../../../features/schedule/presentation/pages/schedule_page.dart';

class Routes {
  static const String home = '/';
  static const String schedule = '/schedule';
  static const String myClasses = '/my-classes';
  static const String classroom = '/classroom';
}

class OnGeneratedRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl.get<HomeCubit>(),
            child: const MainPage(),
          ),
        );
      case Routes.schedule:
        return MaterialPageRoute(
          builder: (_) => const SchedulePage(),
        );
      case Routes.myClasses:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl.get<HomeCubit>(),
            child: const MainPage(initialIndex: 2),
          ),
        );
      case Routes.classroom:
        final args = settings.arguments;
        if (args is! ScheduleModel) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Invalid classroom route arguments')),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => ClassroomPage(scheduleItem: args),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
