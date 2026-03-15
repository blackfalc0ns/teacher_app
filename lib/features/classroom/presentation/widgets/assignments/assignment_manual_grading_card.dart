import 'package:flutter/material.dart';

import '../../../../../core/utils/constant/font_manger.dart';
import '../../../../../core/utils/constant/styles_manger.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../../data/models/classroom_model.dart';
import 'assignment_shared.dart';

class AssignmentManualGradingCard extends StatelessWidget {
  final ClassroomAssignment assignment;
  final AssignmentSubmission submission;
  final TextEditingController feedbackController;
  final void Function(ClassroomQuestion question, StudentQuestionAnswer? answer, int score) onScoreChanged;

  const AssignmentManualGradingCard({
    super.key,
    required this.assignment,
    required this.submission,
    required this.feedbackController,
    required this.onScoreChanged,
  });

  @override
  Widget build(BuildContext context) {
    final manualQuestions = assignment.questions.where(_isManualQuestion).toList(growable: false);
    if (manualQuestions.isEmpty) {
      return const SizedBox.shrink();
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
            'التصحيح اليدوي',
            style: getBoldStyle(
              color: AppColors.primaryDark,
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'صحّح الأسئلة المفتوحة، عدّل الدرجة، ثم احفظ النتيجة النهائية للطالب.',
            style: getRegularStyle(
              color: AppColors.grey,
              fontSize: FontSize.size10,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 12),
          ...manualQuestions.map((question) {
            final answer = submission.answers.where((item) => item.questionId == question.id).firstOrNull;
            final currentScore = answer?.score ?? 0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ManualQuestionTile(
                question: question,
                answer: answer,
                currentScore: currentScore,
                onScoreChanged: (score) => onScoreChanged(question, answer, score),
              ),
            );
          }),
          AssignmentSectionLabel(label: 'ملاحظات المعلم'),
          TextField(
            controller: feedbackController,
            maxLines: 4,
            decoration: assignmentInputDecoration('اكتب ملحوظة تظهر في سجل التصحيح أو للطالب لاحقًا.'),
          ),
        ],
      ),
    );
  }

  bool _isManualQuestion(ClassroomQuestion question) {
    return question.type == AssignmentQuestionType.essay ||
        question.type == AssignmentQuestionType.shortAnswer ||
        question.type == AssignmentQuestionType.fillInBlank;
  }
}

class _ManualQuestionTile extends StatelessWidget {
  final ClassroomQuestion question;
  final StudentQuestionAnswer? answer;
  final int currentScore;
  final ValueChanged<int> onScoreChanged;

  const _ManualQuestionTile({
    required this.question,
    required this.answer,
    required this.currentScore,
    required this.onScoreChanged,
  });

  @override
  Widget build(BuildContext context) {
    final safeScore = currentScore.clamp(0, question.points);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  question.title,
                  style: getBoldStyle(
                    color: AppColors.primaryDark,
                    fontSize: FontSize.size12,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
              ),
              AssignmentTag(label: '$safeScore/${question.points}', color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AssignmentTag(label: assignmentQuestionTypeLabel(question.type), color: AppColors.secondary),
              AssignmentTag(label: answer == null ? 'لا توجد إجابة' : 'تمت المراجعة يدويًا', color: answer == null ? AppColors.grey : AppColors.third),
            ],
          ),
          const SizedBox(height: 10),
          _AnswerBlock(
            title: 'إجابة الطالب',
            value: answer?.studentAnswer.trim().isNotEmpty == true ? answer!.studentAnswer : 'لم يرفع الطالب إجابة لهذا السؤال.',
            background: AppColors.white,
          ),
          const SizedBox(height: 8),
          _AnswerBlock(
            title: 'الإجابة النموذجية',
            value: question.correctAnswerLabel,
            background: AppColors.green.withValues(alpha: 0.08),
          ),
          const SizedBox(height: 10),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.lightGrey,
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withValues(alpha: 0.14),
            ),
            child: Slider(
              value: safeScore.toDouble(),
              max: question.points.toDouble(),
              divisions: question.points,
              label: '$safeScore',
              onChanged: answer == null ? null : (value) => onScoreChanged(value.round()),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _QuickScoreChip(label: 'صفر', selected: safeScore == 0, onTap: answer == null ? null : () => onScoreChanged(0)),
              _QuickScoreChip(
                label: 'منتصف الدرجة',
                selected: safeScore == (question.points / 2).round(),
                onTap: answer == null ? null : () => onScoreChanged((question.points / 2).round()),
              ),
              _QuickScoreChip(
                label: 'الدرجة كاملة',
                selected: safeScore == question.points,
                onTap: answer == null ? null : () => onScoreChanged(question.points),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnswerBlock extends StatelessWidget {
  final String title;
  final String value;
  final Color background;

  const _AnswerBlock({required this.title, required this.value, required this.background});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: getMediumStyle(
              color: AppColors.grey,
              fontSize: FontSize.size10,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: getRegularStyle(
              color: AppColors.primaryDark,
              fontSize: FontSize.size11,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickScoreChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _QuickScoreChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary.withValues(alpha: 0.22) : AppColors.lightGrey,
          ),
        ),
        child: Text(
          label,
          style: getMediumStyle(
            color: selected ? AppColors.primary : AppColors.primaryDark,
            fontSize: FontSize.size10,
            fontFamily: FontConstant.cairo,
          ),
        ),
      ),
    );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
