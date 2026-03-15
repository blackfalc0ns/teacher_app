import 'package:flutter/material.dart';

import '../../../../../core/utils/constant/font_manger.dart';
import '../../../../../core/utils/constant/styles_manger.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../../data/models/classroom_model.dart';
import 'assignment_shared.dart';

class AssignmentSubmissionsCard extends StatelessWidget {
  final List<ClassroomAssignment> assignments;
  final int selectedAssignmentIndex;
  final ValueChanged<int> onAssignmentSelected;

  const AssignmentSubmissionsCard({
    super.key,
    required this.assignments,
    required this.selectedAssignmentIndex,
    required this.onAssignmentSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (assignments.isEmpty) {
      return _EmptyCard(message: 'لا توجد واجبات منشأة بعد.');
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الواجبات والتسليمات',
            style: getBoldStyle(
              color: AppColors.primaryDark,
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'اطلع على من سلّم، من تأخر، ومن يحتاج مراجعة.',
            style: getRegularStyle(
              color: AppColors.grey,
              fontSize: FontSize.size10,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 12),
          ...assignments.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _AssignmentOverviewTile(
                assignment: entry.value,
                selected: entry.key == selectedAssignmentIndex,
                onTap: () => onAssignmentSelected(entry.key),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AssignmentStudentSubmissionsCard extends StatelessWidget {
  final ClassroomAssignment assignment;
  final int selectedSubmissionIndex;
  final ValueChanged<int> onSubmissionSelected;

  const AssignmentStudentSubmissionsCard({
    super.key,
    required this.assignment,
    required this.selectedSubmissionIndex,
    required this.onSubmissionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'أداء الطلاب',
                  style: getBoldStyle(
                    color: AppColors.primaryDark,
                    fontSize: FontSize.size14,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
              ),
              AssignmentTag(label: '${assignment.submittedCount}/${assignment.totalCount}', color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _MetricBox(label: 'تم التسليم', value: '${assignment.submittedCount}', color: AppColors.green)),
              const SizedBox(width: 8),
              Expanded(child: _MetricBox(label: 'تم التصحيح', value: '${assignment.reviewedCount}', color: AppColors.primary)),
              const SizedBox(width: 8),
              Expanded(child: _MetricBox(label: 'لم يسلّم', value: '${assignment.totalCount - assignment.submittedCount}', color: AppColors.errorRed)),
            ],
          ),
          const SizedBox(height: 12),
          ...assignment.submissions.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _SubmissionTile(
                submission: entry.value,
                selected: entry.key == selectedSubmissionIndex,
                onTap: () => onSubmissionSelected(entry.key),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AssignmentOverviewTile extends StatelessWidget {
  final ClassroomAssignment assignment;
  final bool selected;
  final VoidCallback onTap;

  const _AssignmentOverviewTile({
    required this.assignment,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.08) : AppColors.lightGrey.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? AppColors.primary.withValues(alpha: 0.25) : Colors.transparent),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    assignment.title,
                    style: getBoldStyle(
                      color: AppColors.primaryDark,
                      fontSize: FontSize.size12,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                ),
                AssignmentTag(label: assignment.statusLabel, color: selected ? AppColors.primary : AppColors.secondary),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${assignment.modeLabel} • ${assignment.questionsCount} سؤال • ${assignment.totalMarks} درجة',
              style: getRegularStyle(
                color: AppColors.grey,
                fontSize: FontSize.size10,
                fontFamily: FontConstant.cairo,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${assignment.submittedCount} من ${assignment.totalCount} سلّموا',
              style: getMediumStyle(
                color: AppColors.primaryDark,
                fontSize: FontSize.size10,
                fontFamily: FontConstant.cairo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubmissionTile extends StatelessWidget {
  final AssignmentSubmission submission;
  final bool selected;
  final VoidCallback onTap;

  const _SubmissionTile({required this.submission, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = assignmentSubmissionStatusColor(submission.status);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.08) : AppColors.lightGrey.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? color.withValues(alpha: 0.24) : Colors.transparent),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    submission.studentName,
                    style: getBoldStyle(
                      color: AppColors.primaryDark,
                      fontSize: FontSize.size12,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    submission.submittedAtLabel,
                    style: getRegularStyle(
                      color: AppColors.grey,
                      fontSize: FontSize.size10,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AssignmentTag(label: assignmentSubmissionStatusLabel(submission.status), color: color),
                const SizedBox(height: 6),
                Text(
                  '${submission.score}/${submission.maxScore}',
                  style: getBoldStyle(
                    color: AppColors.primaryDark,
                    fontSize: FontSize.size11,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricBox({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: getBoldStyle(
              color: color,
              fontSize: FontSize.size15,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 4),
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

class _EmptyCard extends StatelessWidget {
  final String message;

  const _EmptyCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        message,
        style: getRegularStyle(
          color: AppColors.grey,
          fontSize: FontSize.size11,
          fontFamily: FontConstant.cairo,
        ),
      ),
    );
  }
}
