class HomeDataModel {
  final UserInfoModel userInfo;
  final List<HomeStatModel> stats;
  final List<ScheduleDayModel> weeklySchedule;
  final List<ActionSummaryModel> actionSummaries;

  HomeDataModel({
    required this.userInfo,
    required this.stats,
    required this.weeklySchedule,
    required this.actionSummaries,
  });
}

class UserInfoModel {
  final String name;
  final String date;
  final int points;
  final String avatarUrl;

  UserInfoModel({
    required this.name,
    required this.date,
    required this.points,
    required this.avatarUrl,
  });
}

class HomeStatModel {
  final String title;
  final String value;
  final String? subValue;
  final HomeStatType type;

  HomeStatModel({
    required this.title,
    required this.value,
    this.subValue,
    required this.type,
  });
}

enum HomeStatType { points, remainingClasses, currentClass }

class ScheduleDayModel {
  final String dayName;
  final List<ScheduleItemModel> items;

  ScheduleDayModel({
    required this.dayName,
    required this.items,
  });
}

class ScheduleItemModel {
  final String subject;
  final String className;
  final String time;
  final bool isCurrent;
  final int? periodIndex; // 1, 2, 3, 4, 5

  ScheduleItemModel({
    required this.subject,
    required this.className,
    required this.time,
    this.isCurrent = false,
    this.periodIndex,
  });
}

class ActionSummaryModel {
  final String title;
  final String subTitle;
  final int count;
  final String? tag; // e.g., "12 جديد"
  final double progress; // 0.0 to 1.0

  ActionSummaryModel({
    required this.title,
    required this.subTitle,
    required this.count,
    this.tag,
    this.progress = 0.0,
  });
}
