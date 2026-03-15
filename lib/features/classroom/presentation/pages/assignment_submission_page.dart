import 'package:flutter/material.dart';

import '../../../schedule/data/model/schedule_model.dart';
import '../../data/models/classroom_model.dart';
import '../widgets/assignments/assignment_manual_grading_card.dart';
import '../widgets/assignments/assignment_student_detail_card.dart';

class AssignmentSubmissionPage extends StatefulWidget {
  final ScheduleModel item;
  final ClassroomAssignment assignment;
  final AssignmentSubmission submission;

  const AssignmentSubmissionPage({
    super.key,
    required this.item,
    required this.assignment,
    required this.submission,
  });

  @override
  State<AssignmentSubmissionPage> createState() => _AssignmentSubmissionPageState();
}

class _AssignmentSubmissionPageState extends State<AssignmentSubmissionPage> {
  late AssignmentSubmission _submission;
  late TextEditingController _feedbackController;

  @override
  void initState() {
    super.initState();
    _submission = widget.submission;
    _feedbackController = TextEditingController(text: widget.submission.feedback);
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canGrade = _submission.status != AssignmentSubmissionStatus.notSubmitted;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _Header(
              title: '?????? ?? ??????',
              subtitle: '${widget.item.className} • ${widget.assignment.title}',
            ),
            const SizedBox(height: 12),
            AssignmentStudentDetailCard(
              assignment: widget.assignment,
              submission: _submission,
            ),
            if (canGrade) ...[
              const SizedBox(height: 12),
              AssignmentManualGradingCard(
                assignment: widget.assignment,
                submission: _submission,
                feedbackController: _feedbackController,
                onScoreChanged: _updateQuestionScore,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A7A96),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  child: const Text('??? ??????? ?????? ??????'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _updateQuestionScore(ClassroomQuestion question, StudentQuestionAnswer? answer, int score) {
    final updatedAnswers = List<StudentQuestionAnswer>.from(_submission.answers);
    final index = updatedAnswers.indexWhere((item) => item.questionId == question.id);
    final baseAnswer = answer ??
        StudentQuestionAnswer(
          questionId: question.id,
          studentAnswer: '',
          correctAnswer: question.correctAnswerLabel,
          isCorrect: null,
          score: 0,
          maxScore: question.points,
        );

    final gradedAnswer = baseAnswer.copyWith(
      score: score,
      maxScore: question.points,
      isCorrect: score == question.points
          ? true
          : score == 0
              ? false
              : null,
    );

    if (index == -1) {
      updatedAnswers.add(gradedAnswer);
    } else {
      updatedAnswers[index] = gradedAnswer;
    }

    final totalScore = updatedAnswers.fold<int>(0, (sum, item) => sum + item.score);
    setState(() {
      _submission = _submission.copyWith(
        answers: updatedAnswers,
        score: totalScore,
        feedback: _feedbackController.text.trim(),
      );
    });
  }

  void _saveReview() {
    final updatedSubmission = _submission.copyWith(
      feedback: _feedbackController.text.trim(),
      status: AssignmentSubmissionStatus.reviewed,
      score: _submission.answers.fold<int>(0, (sum, item) => sum + item.score),
    );
    Navigator.of(context).pop(updatedSubmission);
  }
}

class _Header extends StatelessWidget {
  final String title;
  final String subtitle;

  const _Header({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back_rounded, size: 18),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
}
