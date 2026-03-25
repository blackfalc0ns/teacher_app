import 'package:flutter/material.dart';

enum XpRankTier {
  bronze1,
  bronze2,
  bronze3,
  silver1,
  silver2,
  silver3,
  gold1,
  gold2,
  gold3,
  master,
}

enum XpActivitySource { homework, lesson, exam, participation, project, behavior }

class XpClassFilterModel {
  final String cycleName;
  final String gradeName;
  final String sectionName;
  final String subjectName;
  final int studentsCount;

  const XpClassFilterModel({
    required this.cycleName,
    required this.gradeName,
    required this.sectionName,
    required this.subjectName,
    required this.studentsCount,
  });

  String get classLabel => '$gradeName / $sectionName';
}

class XpStudentProgressModel {
  final String id;
  final String studentName;
  final String classLabel;
  final String cycleName;
  final String gradeName;
  final String sectionName;
  final String subjectName;
  final int seasonXp;
  final int weeklyXp;
  final int completedLessons;
  final int completedHomeworks;
  final int completedExams;
  final int rankPosition;
  final double levelProgress;
  final XpRankTier rankTier;
  final bool needsSupport;
  final bool recentlyPromoted;

  const XpStudentProgressModel({
    required this.id,
    required this.studentName,
    required this.classLabel,
    required this.cycleName,
    required this.gradeName,
    required this.sectionName,
    required this.subjectName,
    required this.seasonXp,
    required this.weeklyXp,
    required this.completedLessons,
    required this.completedHomeworks,
    required this.completedExams,
    required this.rankPosition,
    required this.levelProgress,
    required this.rankTier,
    this.needsSupport = false,
    this.recentlyPromoted = false,
  });
}

class XpDistributionItemModel {
  final XpRankTier rankTier;
  final int studentsCount;

  const XpDistributionItemModel({
    required this.rankTier,
    required this.studentsCount,
  });
}

class XpSourceBreakdownModel {
  final XpActivitySource source;
  final int xpValue;

  const XpSourceBreakdownModel({
    required this.source,
    required this.xpValue,
  });
}

class BonusXpPolicyModel {
  final int weeklyLimitPerStudent;
  final int weeklyLimitPerClass;
  final int teacherAvailableBudget;
  final List<String> allowedReasons;

  const BonusXpPolicyModel({
    required this.weeklyLimitPerStudent,
    required this.weeklyLimitPerClass,
    required this.teacherAvailableBudget,
    required this.allowedReasons,
  });
}

class BonusXpRecordModel {
  final String id;
  final String studentName;
  final String classLabel;
  final int xpValue;
  final String reason;
  final DateTime grantedAt;

  const BonusXpRecordModel({
    required this.id,
    required this.studentName,
    required this.classLabel,
    required this.xpValue,
    required this.reason,
    required this.grantedAt,
  });
}

class XpCenterDashboardModel {
  final String seasonLabel;
  final int trackedStudentsCount;
  final int totalSeasonXp;
  final int autoGrantedXp;
  final int pendingBoostCandidates;
  final BonusXpPolicyModel bonusPolicy;
  final List<XpClassFilterModel> assignedClasses;
  final List<XpStudentProgressModel> students;
  final List<XpSourceBreakdownModel> sourceBreakdown;
  final List<BonusXpRecordModel> recentBonusRecords;

  const XpCenterDashboardModel({
    required this.seasonLabel,
    required this.trackedStudentsCount,
    required this.totalSeasonXp,
    required this.autoGrantedXp,
    required this.pendingBoostCandidates,
    required this.bonusPolicy,
    required this.assignedClasses,
    required this.students,
    required this.sourceBreakdown,
    required this.recentBonusRecords,
  });
}

class GrantBonusXpArgs {
  final XpCenterDashboardModel dashboard;
  final XpStudentProgressModel? initialStudent;

  const GrantBonusXpArgs({
    required this.dashboard,
    this.initialStudent,
  });
}

extension XpRankTierUi on XpRankTier {
  String get label {
    switch (this) {
      case XpRankTier.bronze1:
        return 'برونزي I';
      case XpRankTier.bronze2:
        return 'برونزي II';
      case XpRankTier.bronze3:
        return 'برونزي III';
      case XpRankTier.silver1:
        return 'فضي I';
      case XpRankTier.silver2:
        return 'فضي II';
      case XpRankTier.silver3:
        return 'فضي III';
      case XpRankTier.gold1:
        return 'ذهبي I';
      case XpRankTier.gold2:
        return 'ذهبي II';
      case XpRankTier.gold3:
        return 'ذهبي III';
      case XpRankTier.master:
        return 'ماستر';
    }
  }

  String get assetPath {
    switch (this) {
      case XpRankTier.bronze1:
        return 'assets/images/rank/Bronze I.png';
      case XpRankTier.bronze2:
        return 'assets/images/rank/Bronze II.png';
      case XpRankTier.bronze3:
        return 'assets/images/rank/Bronze III.png';
      case XpRankTier.silver1:
        return 'assets/images/rank/Silver I.png';
      case XpRankTier.silver2:
        return 'assets/images/rank/Silver II.png';
      case XpRankTier.silver3:
        return 'assets/images/rank/Silver III.png';
      case XpRankTier.gold1:
        return 'assets/images/rank/Gold I.png';
      case XpRankTier.gold2:
        return 'assets/images/rank/Gold II.png';
      case XpRankTier.gold3:
        return 'assets/images/rank/Gold III.png';
      case XpRankTier.master:
        return 'assets/images/rank/Master.png';
    }
  }

  Color get accentColor {
    switch (this) {
      case XpRankTier.bronze1:
      case XpRankTier.bronze2:
      case XpRankTier.bronze3:
        return const Color(0xFFB87444);
      case XpRankTier.silver1:
      case XpRankTier.silver2:
      case XpRankTier.silver3:
        return const Color(0xFF93A4BB);
      case XpRankTier.gold1:
      case XpRankTier.gold2:
      case XpRankTier.gold3:
        return const Color(0xFFD9A11D);
      case XpRankTier.master:
        return const Color(0xFF7A5AF8);
    }
  }
}

extension XpActivitySourceUi on XpActivitySource {
  String get label {
    switch (this) {
      case XpActivitySource.homework:
        return 'الواجبات';
      case XpActivitySource.lesson:
        return 'مشاهدة الدروس';
      case XpActivitySource.exam:
        return 'الاختبارات';
      case XpActivitySource.participation:
        return 'المشاركة الصفية';
      case XpActivitySource.project:
        return 'المشاريع';
      case XpActivitySource.behavior:
        return 'السلوك الإيجابي';
    }
  }
}
