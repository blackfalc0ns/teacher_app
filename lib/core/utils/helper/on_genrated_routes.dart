import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/features/home/presentation/pages/main_page.dart';
import 'package:teacher_app/features/messages/presentation/pages/chat_details_screen.dart';
import 'package:teacher_app/features/profile/presentation/pages/teacher_employment_page.dart';
import 'package:teacher_app/features/profile/presentation/pages/teacher_profile_page.dart';
import 'package:teacher_app/features/settings/presentation/pages/settings_page.dart';

import '../../di/injection_container.dart';
import '../../../features/classroom/presentation/pages/classroom_page.dart';
import '../../../features/home/data/models/home_data_model.dart';
import '../../../features/home/presentation/cubits/home_cubit.dart';
import '../../../features/profile/data/models/teacher_employment_model.dart';
import '../../../features/profile/data/models/teacher_profile_model.dart';
import '../../../features/schedule/data/model/schedule_model.dart';
import '../../../features/schedule/presentation/pages/schedule_page.dart';

class Routes {
  static const String home = '/';
  static const String schedule = '/schedule';
  static const String myClasses = '/my-classes';
  static const String homeworks = '/homeworks';
  static const String classroom = '/classroom';
  static const String chatDetails = '/chat_details';
  static const String profile = '/profile';
  static const String employment = '/employment';
  static const String settings = '/settings';
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
      case Routes.homeworks:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => sl.get<HomeCubit>(),
            child: const MainPage(initialIndex: 3),
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
      case Routes.chatDetails:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ChatDetailsScreen(
            peerName: args?['name'] ?? 'محادثة',
            peerAvatarUrl: args?['avatarUrl'],
          ),
        );
      case Routes.profile:
        final args = settings.arguments;
        if (args is! HomeDataModel) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Invalid profile route arguments')),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => TeacherProfilePage(
            profile: TeacherProfileModel.fromHomeData(args),
          ),
        );
      case Routes.employment:
        final args = settings.arguments;
        if (args is! HomeDataModel) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Invalid employment route arguments')),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => TeacherEmploymentPage(
            employment: TeacherEmploymentModel.fromHomeData(args),
          ),
        );
      case Routes.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsPage(),
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
