import 'package:flutter/material.dart';
import '../../../data/models/classroom_model.dart';

class QuestionReviewTile extends StatelessWidget {
  final ClassroomQuestion question;
  final StudentQuestionAnswer? answer;
  final ValueChanged<int>? onScoreChanged;

  const QuestionReviewTile({
    super.key,
    required this.question,
    required this.answer,
    this.onScoreChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isCorrect = answer?.isCorrect;
    final score = answer?.score ?? 0;
    final maxScore = question.points;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F3F6),
        borderRadius: BorderRadius.circular(14),
        border: isCorrect != null
            ? Border.all(
                color: isCorrect
                    ? const Color(0xFF10B981)
                    : const Color(0xFFE53F3E),
                width: 2,
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  question.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF04506E),
                  ),
                ),
              ),
              if (isCorrect != null)
                Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: isCorrect
                      ? const Color(0xFF10B981)
                      : const Color(0xFFE53F3E),
                  size: 20,
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (answer != null) ...[
            Text(
              'إجابة الطالب: ${answer!.studentAnswer}',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'الإجابة الصحيحة: ${answer!.correctAnswer}',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF10B981),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'الدرجة: $score/$maxScore',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF04506E),
                ),
              ),
              if (onScoreChanged != null) ...[
                const Spacer(),
                _ScoreSelector(
                  currentScore: score,
                  maxScore: maxScore,
                  onScoreChanged: onScoreChanged!,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ScoreSelector extends StatelessWidget {
  final int currentScore;
  final int maxScore;
  final ValueChanged<int> onScoreChanged;

  const _ScoreSelector({
    required this.currentScore,
    required this.maxScore,
    required this.onScoreChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: currentScore > 0
              ? () => onScoreChanged(currentScore - 1)
              : null,
          icon: const Icon(Icons.remove_circle_outline),
          iconSize: 20,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 8),
        Text(
          '$currentScore',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF006D82),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: currentScore < maxScore
              ? () => onScoreChanged(currentScore + 1)
              : null,
          icon: const Icon(Icons.add_circle_outline),
          iconSize: 20,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}
