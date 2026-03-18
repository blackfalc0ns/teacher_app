import 'package:flutter/material.dart';

import '../../../../core/utils/common/compact_button.dart';
import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';

class HomeworksHeader extends StatelessWidget {
  final int assignmentsCount;
  final int pendingReviewCount;
  final int missingSubmissionCount;
  final int draftsCount;
  final VoidCallback onCreatePressed;

  const HomeworksHeader({
    super.key,
    required this.assignmentsCount,
    required this.pendingReviewCount,
    required this.missingSubmissionCount,
    required this.draftsCount,
    required this.onCreatePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الواجبات',
                      style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size22,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'لوحة موحدة لإنشاء الواجبات ومتابعة التسليمات والتصحيح.',
                      style: getRegularStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size11,
                        color: AppColors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              CompactButton(
                text: 'إنشاء واجب',
                backgroundColor: Colors.white,
                textColor: AppColors.primaryDark,
                height: 36,
                prefix: const Icon(Icons.add_task_rounded, size: 16, color: AppColors.primaryDark),
                onPressed: onCreatePressed,
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Statistics Row - all in one row
          Row(
            children: [
              Expanded(
                child: _CompactStat(
                  title: 'الواجبات',
                  value: '$assignmentsCount',
                  icon: Icons.assignment_outlined,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _CompactStat(
                  title: 'تصحيح',
                  value: '$pendingReviewCount',
                  icon: Icons.rate_review_outlined,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _CompactStat(
                  title: 'لم يسلّم',
                  value: '$missingSubmissionCount',
                  icon: Icons.schedule_outlined,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _CompactStat(
                  title: 'مسودات',
                  value: '$draftsCount',
                  icon: Icons.drafts_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompactStat extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _CompactStat({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 16,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: getBoldStyle(
              color: AppColors.white,
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: getMediumStyle(
              color: AppColors.white.withValues(alpha: 0.9),
              fontSize: FontSize.size9,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ],
      ),
    );
  }
}
