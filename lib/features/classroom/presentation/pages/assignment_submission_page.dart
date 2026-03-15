import 'package:flutter/material.dart';
import '../../../schedule/data/model/schedule_model.dart';
import '../../data/models/classroom_model.dart';
import '../widgets/submission/question_review_tile.dart';
import '../widgets/submission/submission_header_card.dart';
import '../widgets/submission/submission_feedback_card.dart';
import '../widgets/tracking/tracking_header.dart';

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
  State<AssignmentSubmissionPage> createState() =>
      _AssignmentSubmissionPageState();
}

class _AssignmentSubmissionPageState extends State<AssignmentSubmissionPage> {
  late AssignmentSubmission _submission;
  late TextEditingController _feedbackController;

  @override
  void initState() {
    super.initState();
    _submission = widget.submission;
    _feedbackController =
        TextEditingController(text: widget.submission.feedback);
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canGrade =
        _submission.status != AssignmentSubmissionStatus.notSubmitted;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            TrackingHeader(
              title: 'تصحيح حل الطالب',
              subtitle:
                  '${widget.item.className} • ${widget.assignment.title}',
            ),
            const SizedBox(height: 12),
            SubmissionHeaderCard(
              submission: _submission,
              assignmentTitle: widget.assignment.title,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الأسئلة والإجابات',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF04506E),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...widget.assignment.questions.map((question) {
                    final answer = _submission.answers
                        .where((item) => item.questionId == question.id)
                        .firstOrNull;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: QuestionReviewTile(
                        question: question,
                        answer: answer,
                        onScoreChanged: _isManualQuestion(question) && canGrade
                            ? (score) =>
                                _updateQuestionScore(question, answer, score)
                            : null,
                      ),
                    );
                  }),
                ],
              ),
            ),
            if (canGrade) ...[
              const SizedBox(height: 12),
              SubmissionFeedbackCard(
                feedbackController: _feedbackController,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A7A96),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  child: const Text('حفظ التصحيح والملاحظات'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _isManualQuestion(ClassroomQuestion question) {
    return question.type == AssignmentQuestionType.essay ||
        question.type == AssignmentQuestionType.shortAnswer ||
        question.type == AssignmentQuestionType.fillInBlank;
  }

  void _updateQuestionScore(
      ClassroomQuestion question, StudentQuestionAnswer? answer, int score) {
    final updatedAnswers =
        List<StudentQuestionAnswer>.from(_submission.answers);
    final index =
        updatedAnswers.indexWhere((item) => item.questionId == question.id);
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
      isCorrect:
          score == question.points ? true : (score == 0 ? false : null),
    );

    if (index == -1) {
      updatedAnswers.add(gradedAnswer);
    } else {
      updatedAnswers[index] = gradedAnswer;
    }

    setState(() {
      _submission = _submission.copyWith(
        answers: updatedAnswers,
        score: updatedAnswers.fold<int>(
            0, (sum, answer) => sum + answer.score),
        status: AssignmentSubmissionStatus.reviewed,
      );
    });
  }

  void _save() {
    final updatedSubmission = _submission.copyWith(
      feedback: _feedbackController.text.trim(),
      status: AssignmentSubmissionStatus.reviewed,
    );

    if (mounted) {
      Navigator.of(context).pop(updatedSubmission);
    }
  }
}
