import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teacher_app/features/home/presentation/pages/main_page.dart';
import 'package:teacher_app/features/messages/presentation/pages/chat_details_screen.dart';
import 'package:teacher_app/features/profile/presentation/pages/teacher_employment_page.dart';
import 'package:teacher_app/features/profile/presentation/pages/teacher_profile_page.dart';
import 'package:teacher_app/features/settings/presentation/pages/about_app_page.dart';
import 'package:teacher_app/features/settings/presentation/pages/app_rating_page.dart';
import 'package:teacher_app/features/settings/presentation/pages/contact_us_page.dart';
import 'package:teacher_app/features/settings/presentation/pages/help_center_page.dart';
import 'package:teacher_app/features/settings/presentation/pages/privacy_policy_page.dart';
import 'package:teacher_app/features/settings/presentation/pages/privacy_security_page.dart';
import 'package:teacher_app/features/settings/presentation/pages/settings_page.dart';
import 'package:teacher_app/features/settings/presentation/pages/support_page.dart';
import 'package:teacher_app/features/settings/presentation/pages/terms_conditions_page.dart';
import 'package:teacher_app/features/tasks/data/models/teacher_task_model.dart';
import 'package:teacher_app/features/tasks/presentation/pages/teacher_task_create_page.dart';
import 'package:teacher_app/features/tasks/presentation/pages/teacher_task_details_page.dart';
import 'package:teacher_app/features/tasks/presentation/pages/teacher_tasks_page.dart';

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
  static const String privacySecurity = '/privacy-security';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsConditions = '/terms-conditions';
  static const String support = '/support';
  static const String helpCenter = '/help-center';
  static const String contactUs = '/contact-us';
  static const String aboutApp = '/about-app';
  static const String appRating = '/app-rating';
  static const String teacherTasks = '/teacher-tasks';
  static const String teacherTaskDetails = '/teacher-task-details';
  static const String teacherTaskCreate = '/teacher-task-create';
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
      case Routes.privacySecurity:
        return MaterialPageRoute(
          builder: (_) => const PrivacySecurityPage(),
        );
      case Routes.privacyPolicy:
        return MaterialPageRoute(
          builder: (_) => const PrivacyPolicyPage(),
        );
      case Routes.termsConditions:
        return MaterialPageRoute(
          builder: (_) => const TermsConditionsPage(),
        );
      case Routes.support:
        return MaterialPageRoute(
          builder: (_) => const SupportPage(),
        );
      case Routes.helpCenter:
        return MaterialPageRoute(
          builder: (_) => const HelpCenterPage(),
        );
      case Routes.contactUs:
        return MaterialPageRoute(
          builder: (_) => const ContactUsPage(),
        );
      case Routes.aboutApp:
        return MaterialPageRoute(
          builder: (_) => const AboutAppPage(),
        );
      case Routes.appRating:
        return MaterialPageRoute(
          builder: (_) => const AppRatingPage(),
        );
      case Routes.teacherTasks:
        return MaterialPageRoute(
          builder: (_) => const TeacherTasksPage(),
        );
      case Routes.teacherTaskDetails:
        final args = settings.arguments;
        if (args is! TeacherStudentTaskModel) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Invalid teacher task route arguments')),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => TeacherTaskDetailsPage(task: args),
        );
      case Routes.teacherTaskCreate:
        final args = settings.arguments;
        if (args is! TeacherTaskDashboardModel) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text('Invalid teacher task create arguments')),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => TeacherTaskCreatePage(dashboard: args),
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
