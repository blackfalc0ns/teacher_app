import 'package:flutter/material.dart';

import '../../../../../core/utils/constant/font_manger.dart';
import '../../../../../core/utils/constant/styles_manger.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../../data/models/classroom_model.dart';
import 'assignment_shared.dart';

class AssignmentStudentDetailCard extends StatelessWidget {
  final ClassroomAssignment assignment;
  final AssignmentSubmission submission;

  const AssignmentStudentDetailCard({
    super.key,
    required this.assignment,
    required this.submission,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = assignmentSubmissionStatusColor(submission.status);

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      submission.studentName,
                      style: getBoldStyle(
                        color: AppColors.primaryDark,
                        fontSize: FontSize.size15,
                        fontFamily: FontConstant.cairo,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      assignment.title,
                      style: getRegularStyle(
                        color: AppColors.grey,
                        fontSize: FontSize.size10,
                        fontFamily: FontConstant.cairo,
                      ),
                    ),
                  ],
                ),
              ),
              AssignmentTag(
                label: assignmentSubmissionStatusLabel(submission.status),
                color: statusColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SummaryTile(
                  label: '??????',
                  value: '${submission.score}/${submission.maxScore}',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SummaryTile(
                  label: '??? ???????',
                  value: submission.submittedAtLabel,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.lightGrey.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              submission.feedback.trim().isEmpty ? '?? ???? ??????? ????? ???.' : submission.feedback,
              style: getRegularStyle(
                color: AppColors.primaryDark,
                fontSize: FontSize.size11,
                fontFamily: FontConstant.cairo,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...assignment.questions.map((question) {
            final matches = submission.answers.where((item) => item.questionId == question.id);
            final StudentQuestionAnswer? answer = matches.isEmpty ? null : matches.first;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _QuestionAnswerTile(question: question, answer: answer),
            );
          }),
        ],
      ),
    );
  }
}

class _QuestionAnswerTile extends StatelessWidget {
  final ClassroomQuestion question;
  final StudentQuestionAnswer? answer;

  const _QuestionAnswerTile({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    final answerColor = _buildAnswerColor();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: answerColor.withValues(alpha: 0.2)),
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
              AssignmentTag(
                label: '${answer?.score ?? 0}/${question.points}',
                color: answerColor,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AssignmentTag(
                label: assignmentQuestionTypeLabel(question.type),
                color: AppColors.secondary,
              ),
              AssignmentTag(
                label: _buildAnswerStateLabel(),
                color: answerColor,
              ),
            ],
          ),
          const SizedBox(height: 10),
          _AnswerPanel(
            title: '????? ??????',
            value: answer?.studentAnswer.trim().isNotEmpty == true ? answer!.studentAnswer : '?? ???? ????? ??????',
            background: AppColors.white,
          ),
          const SizedBox(height: 8),
          _AnswerPanel(
            title: '??????? ???????',
            value: question.correctAnswerLabel,
            background: AppColors.green.withValues(alpha: 0.08),
          ),
          if (question.explanation.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            _AnswerPanel(
              title: '????? ??????',
              value: question.explanation,
              background: AppColors.secondary.withValues(alpha: 0.08),
            ),
          ],
        ],
      ),
    );
  }

  Color _buildAnswerColor() {
    if (answer == null) {
      return AppColors.grey;
    }
    if (_isManualQuestion() && answer!.score > 0 && answer!.score < question.points) {
      return AppColors.third;
    }
    if (answer!.isCorrect == null) {
      return AppColors.third;
    }
    return answer!.isCorrect! ? AppColors.green : AppColors.errorRed;
  }

  String _buildAnswerStateLabel() {
    if (answer == null) {
      return '???? ?????';
    }
    if (_isManualQuestion() && answer!.score > 0 && answer!.score < question.points) {
      return '???? ??????';
    }
    if (_isManualQuestion() && answer!.score == question.points) {
      return '???? ????';
    }
    if (answer!.isCorrect == null) {
      return '????? ??????';
    }
    return answer!.isCorrect! ? '????? ?????' : '????? ??? ?????';
  }

  bool _isManualQuestion() {
    return question.type == AssignmentQuestionType.essay ||
        question.type == AssignmentQuestionType.shortAnswer ||
        question.type == AssignmentQuestionType.fillInBlank;
  }
}

class _AnswerPanel extends StatelessWidget {
  final String title;
  final String value;
  final Color background;

  const _AnswerPanel({
    required this.title,
    required this.value,
    required this.background,
  });

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

class _SummaryTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryTile({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: getMediumStyle(
              color: AppColors.grey,
              fontSize: FontSize.size10,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: getBoldStyle(
              color: color,
              fontSize: FontSize.size12,
              fontFamily: FontConstant.cairo,
            ),
          ),
        ],
      ),
    );
  }
}
