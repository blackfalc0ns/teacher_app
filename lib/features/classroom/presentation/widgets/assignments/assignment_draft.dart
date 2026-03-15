import '../../../data/models/classroom_model.dart';

class AssignmentDraftQuestion {
  final String id;
  final AssignmentQuestionType type;
  final String prompt;
  final int points;
  final List<String> options;
  final int correctOptionIndex;
  final String expectedAnswer;

  const AssignmentDraftQuestion({
    required this.id,
    required this.type,
    required this.prompt,
    required this.points,
    required this.options,
    required this.correctOptionIndex,
    required this.expectedAnswer,
  });

  bool get usesOptions {
    return type == AssignmentQuestionType.multipleChoice ||
        type == AssignmentQuestionType.trueFalse ||
        type == AssignmentQuestionType.matching;
  }

  AssignmentDraftQuestion copyWith({
    String? id,
    AssignmentQuestionType? type,
    String? prompt,
    int? points,
    List<String>? options,
    int? correctOptionIndex,
    String? expectedAnswer,
  }) {
    return AssignmentDraftQuestion(
      id: id ?? this.id,
      type: type ?? this.type,
      prompt: prompt ?? this.prompt,
      points: points ?? this.points,
      options: options ?? this.options,
      correctOptionIndex: correctOptionIndex ?? this.correctOptionIndex,
      expectedAnswer: expectedAnswer ?? this.expectedAnswer,
    );
  }
}
