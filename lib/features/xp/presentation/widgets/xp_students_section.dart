import 'package:flutter/material.dart';
import 'package:teacher_app/core/utils/constant/font_manger.dart';
import 'package:teacher_app/core/utils/constant/styles_manger.dart';
import 'package:teacher_app/core/utils/theme/app_colors.dart';
import 'package:teacher_app/features/xp/data/models/xp_center_model.dart';

class XpStudentsSection extends StatelessWidget {
  final List<XpStudentProgressModel> students;
  final VoidCallback? onViewAll;

  const XpStudentsSection({
    super.key,
    required this.students,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الطلاب الأعلى تأثيرًا',
                style: getBoldStyle(
                  color: AppColors.primaryDark,
                  fontSize: FontSize.size16,
                  fontFamily: FontConstant.cairo,
                ),
              ),
              if (onViewAll != null)
                TextButton(
                  onPressed: onViewAll,
                  child: Text(
                    'عرض الكل',
                    style: getBoldStyle(
                      color: AppColors.primary,
                      fontSize: FontSize.size12,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'أداء الطلاب الحالي مع رتبتهم وتقدمهم خلال الموسم.',
            style: getRegularStyle(
              color: AppColors.grey.withValues(alpha: 0.72),
              fontSize: FontSize.size11,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 12),
          if (students.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.lightGrey),
              ),
              child: Text(
                'لا توجد نتائج مطابقة للفلاتر الحالية.',
                textAlign: TextAlign.center,
                style: getMediumStyle(
                  color: AppColors.grey,
                  fontSize: FontSize.size12,
                  fontFamily: FontConstant.cairo,
                ),
              ),
            )
          else
            ...students.map((student) {
              return _StudentCard(
                student: student,
              );
            }),
        ],
      ),
    );
  }
}

class _StudentCard extends StatelessWidget {
  final XpStudentProgressModel student;

  const _StudentCard({
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: student.rankTier.accentColor.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 62,
                height: 62,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: student.rankTier.accentColor.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Image.asset(student.rankTier.assetPath),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            student.studentName,
                            style: getBoldStyle(
                              color: AppColors.primaryDark,
                              fontSize: FontSize.size14,
                              fontFamily: FontConstant.cairo,
                            ),
                          ),
                        ),
                        if (student.recentlyPromoted)
                          _Tag(label: 'ترقية حديثة', color: AppColors.green),
                        if (student.needsSupport)
                          _Tag(label: 'يحتاج دعم', color: AppColors.info),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${student.classLabel} • ${student.subjectName}',
                      style: getRegularStyle(
                        color: AppColors.grey.withValues(alpha: 0.72),
                        fontSize: FontSize.size11,
                        fontFamily: FontConstant.cairo,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _MetaChip(
                          label: student.rankTier.label,
                          icon: Icons.workspace_premium_outlined,
                        ),
                        _MetaChip(
                          label: '#${student.rankPosition}',
                          icon: Icons.leaderboard_rounded,
                        ),
                        _MetaChip(
                          label: '${student.weeklyXp} XP أسبوعي',
                          icon: Icons.bolt_rounded,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MetricBox(
                  label: 'إجمالي XP',
                  value: student.seasonXp.toString(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricBox(
                  label: 'الدروس',
                  value: student.completedLessons.toString(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricBox(
                  label: 'الواجبات',
                  value: student.completedHomeworks.toString(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricBox(
                  label: 'الاختبارات',
                  value: student.completedExams.toString(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: student.levelProgress,
              minHeight: 8,
              backgroundColor: student.rankTier.accentColor.withValues(
                alpha: 0.12,
              ),
              color: student.rankTier.accentColor,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'التقدم نحو الرتبة التالية',
                style: getRegularStyle(
                  color: AppColors.grey.withValues(alpha: 0.74),
                  fontSize: FontSize.size10,
                  fontFamily: FontConstant.cairo,
                ),
              ),
              Text(
                '${(student.levelProgress * 100).round()}%',
                style: getBoldStyle(
                  color: student.rankTier.accentColor,
                  fontSize: FontSize.size11,
                  fontFamily: FontConstant.cairo,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  final String label;
  final String value;

  const _MetricBox({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withValues(alpha: 0.24),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: getBoldStyle(
              color: AppColors.primaryDark,
              fontSize: FontSize.size13,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: getRegularStyle(
              color: AppColors.grey.withValues(alpha: 0.72),
              fontSize: FontSize.size9,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _MetaChip({
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withValues(alpha: 0.24),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: getMediumStyle(
              color: AppColors.primaryDark,
              fontSize: FontSize.size10,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;

  const _Tag({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(start: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: getBoldStyle(
          color: color,
          fontSize: FontSize.size9,
          fontFamily: FontConstant.cairo,
        ),
      ),
    );
  }
}
