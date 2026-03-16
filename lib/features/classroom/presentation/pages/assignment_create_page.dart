import '../../../../core/utils/constant/font_manger.dart';
import '../../../../core/utils/constant/styles_manger.dart';
import '../../../../core/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../schedule/data/model/schedule_model.dart';
import '../../data/models/classroom_model.dart';
import '../widgets/assignments/assignment_creation_card.dart';
import '../widgets/assignments/assignment_draft.dart';
import '../widgets/assignments/assignment_questions_card.dart';
import '../widgets/assignments/assignment_shared.dart';

class AssignmentCreatePage extends StatefulWidget {
  final ScheduleModel item;

  const AssignmentCreatePage({super.key, required this.item});

  @override
  State<AssignmentCreatePage> createState() => _AssignmentCreatePageState();
}

class _AssignmentCreatePageState extends State<AssignmentCreatePage> {
  late final TextEditingController _titleController;
  late final TextEditingController _instructionsController;

  String _modeLabel = 'واجب';
  String _targetLabel = 'كل الشعبة';
  String _dueLabel = 'غدًا 7:00 م';
  int _totalMarks = 10;
  int _estimatedMinutes = 15;
  bool _publishNow = true;
  bool _randomizeQuestions = false;
  late List<AssignmentDraftQuestion> _draftQuestions;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: 'واجب ${widget.item.subjectName}',
    );
    _instructionsController = TextEditingController(
      text: 'أجب عن جميع الأسئلة ثم راجع إجاباتك قبل الإرسال.',
    );
    _draftQuestions = [_newDraftQuestion(1)];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _AssignmentPageHeader(
              title: 'إنشاء واجب جديد',
              subtitle: '${widget.item.className} • ${widget.item.subjectName}',
            ),
            const SizedBox(height: 12),
            AssignmentCreationCard(
              titleController: _titleController,
              instructionsController: _instructionsController,
              modeLabel: _modeLabel,
              targetLabel: _targetLabel,
              dueLabel: _dueLabel,
              totalMarks: _totalMarks,
              estimatedMinutes: _estimatedMinutes,
              publishNow: _publishNow,
              randomizeQuestions: _randomizeQuestions,
              questionsCount: _draftQuestions.length,
              onChanged: _refresh,
              onModeChanged: (value) => setState(() => _modeLabel = value),
              onTargetChanged: (value) => setState(() => _targetLabel = value),
              onDueChanged: (value) => setState(() => _dueLabel = value),
              onPublishChanged: (value) => setState(() => _publishNow = value),
              onRandomizeChanged: (value) =>
                  setState(() => _randomizeQuestions = value),
              onMarksIncrement: () => _changeMarks(5),
              onMarksDecrement: () => _changeMarks(-5),
              onMinutesIncrement: () => _changeMinutes(5),
              onMinutesDecrement: () => _changeMinutes(-5),
            ),
            const SizedBox(height: 12),
            AssignmentQuestionsCard(
              questions: _draftQuestions,
              onQuestionChanged: _updateDraftQuestion,
              onQuestionDeleted: _deleteDraftQuestion,
              onAddQuestion: _addDraftQuestion,
              onAddMedia: _addMediaItem,
            ),
            const SizedBox(height: 12),
            _CreatePreviewCard(
              assignmentTitle: _titleController.text.trim().isEmpty
                  ? 'بدون عنوان'
                  : _titleController.text.trim(),
              instructions: _instructionsController.text.trim(),
              modeLabel: _modeLabel,
              targetLabel: _targetLabel,
              dueLabel: _dueLabel,
              totalMarks: _totalMarks,
              estimatedMinutes: _estimatedMinutes,
              questions: _draftQuestions,
              publishNow: _publishNow,
              onCreate: _createAssignment,
              isEnabled: _canCreate,
            ),
          ],
        ),
      ),
    );
  }

  bool get _canCreate {
    return _titleController.text.trim().isNotEmpty &&
        _instructionsController.text.trim().isNotEmpty &&
        _draftQuestions.isNotEmpty &&
        _draftQuestions.every((question) {
          if (question.type == AssignmentQuestionType.media) {
            return question.attachmentPath != null || question.prompt.isNotEmpty;
          }
          return question.prompt.trim().isNotEmpty && _isQuestionValid(question);
        });
  }

  void _refresh() {
    setState(() {});
  }

  void _changeMarks(int delta) {
    final next = _totalMarks + delta;
    if (next < 5 || next > 100) return;
    setState(() => _totalMarks = next);
  }

  void _changeMinutes(int delta) {
    final next = _estimatedMinutes + delta;
    if (next < 5 || next > 120) return;
    setState(() => _estimatedMinutes = next);
  }

  void _addDraftQuestion() {
    setState(() {
      _draftQuestions = [
        ..._draftQuestions,
        _newDraftQuestion(_draftQuestions.length + 1),
      ];
    });
  }

  void _addMediaItem() {
    setState(() {
      _draftQuestions = [
        ..._draftQuestions,
        _newDraftQuestion(
          _draftQuestions.length + 1,
          type: AssignmentQuestionType.media,
        ),
      ];
    });
  }

  void _updateDraftQuestion(AssignmentDraftQuestion updatedQuestion) {
    setState(() {
      _draftQuestions = _draftQuestions
          .map(
            (question) =>
                question.id == updatedQuestion.id ? updatedQuestion : question,
          )
          .toList(growable: false);
    });
  }

  void _deleteDraftQuestion(String id) {
    if (_draftQuestions.length == 1) return;
    setState(() {
      _draftQuestions = _draftQuestions
          .where((question) => question.id != id)
          .toList(growable: false);
    });
  }

  void _createAssignment() {
    if (!_canCreate) return;

    final questions = _draftQuestions
        .map((draft) {
          final options = draft.usesOptions
              ? draft.options
                    .asMap()
                    .entries
                    .map((entry) {
                      return AssignmentOption(
                        id: '${draft.id}-${entry.key}',
                        text: entry.value,
                        isCorrect: draft.correctOptionIndex == entry.key,
                      );
                    })
                    .toList(growable: false)
              : const <AssignmentOption>[];

          final expectedAnswer = draft.usesOptions
              ? (draft.correctOptionIndex < draft.options.length
                    ? draft.options[draft.correctOptionIndex]
                    : '')
              : draft.expectedAnswer;

          return ClassroomQuestion(
            id: draft.id,
            type: draft.type,
            title: draft.prompt,
            points: draft.points,
            options: options,
            expectedAnswer: expectedAnswer,
            attachmentPath: draft.attachmentPath,
            attachmentName: draft.attachmentName,
            explanation: draft.usesOptions
                ? 'تم تحديد الإجابة الصحيحة ضمن الخيارات.'
                : 'يمكن للمعلم مراجعة الإجابة بناء على النموذج.',
          );
        })
        .toList(growable: false);

    final assignment = ClassroomAssignment(
      id: '${widget.item.id}-${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      dueLabel: _dueLabel,
      statusLabel: _publishNow ? 'نشط' : 'مسودة',
      totalCount: widget.item.studentsCount,
      targetLabel: _targetLabel,
      modeLabel: _modeLabel,
      instructions: _instructionsController.text.trim(),
      totalMarks: _totalMarks,
      estimatedMinutes: _estimatedMinutes,
      publishNow: _publishNow,
      randomizeQuestions: _randomizeQuestions,
      questions: questions,
      submissions: const [],
    );

    Navigator.of(context).pop(assignment);
  }

  bool _isQuestionValid(AssignmentDraftQuestion question) {
    if (question.type == AssignmentQuestionType.media) return true;
    if (question.usesOptions) {
      return question.options.every((option) => option.trim().isNotEmpty);
    }
    return question.expectedAnswer.trim().isNotEmpty;
  }

  AssignmentDraftQuestion _newDraftQuestion(
    int order, {
    AssignmentQuestionType type = AssignmentQuestionType.multipleChoice,
  }) {
    return AssignmentDraftQuestion(
      id: 'draft-$order-${DateTime.now().microsecondsSinceEpoch}',
      type: type,
      prompt: '',
      points: type == AssignmentQuestionType.media ? 0 : 2,
      options: type == AssignmentQuestionType.media
          ? const []
          : const [
              'الخيار الأول',
              'الخيار الثاني',
              'الخيار الثالث',
              'الخيار الرابع',
            ],
      correctOptionIndex: 0,
      expectedAnswer: '',
    );
  }
}

class _AssignmentPageHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _AssignmentPageHeader({required this.title, required this.subtitle});

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
              color: AppColors.white,
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
              Text(
                title,
                style: getBoldStyle(
                  color: AppColors.primaryDark,
                  fontSize: FontSize.size17,
                  fontFamily: FontConstant.cairo,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: getRegularStyle(
                  color: AppColors.grey,
                  fontSize: FontSize.size11,
                  fontFamily: FontConstant.cairo,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CreatePreviewCard extends StatelessWidget {
  final String assignmentTitle;
  final String instructions;
  final String modeLabel;
  final String targetLabel;
  final String dueLabel;
  final int totalMarks;
  final int estimatedMinutes;
  final List<AssignmentDraftQuestion> questions;
  final bool publishNow;
  final bool isEnabled;
  final VoidCallback onCreate;

  const _CreatePreviewCard({
    required this.assignmentTitle,
    required this.instructions,
    required this.modeLabel,
    required this.targetLabel,
    required this.dueLabel,
    required this.totalMarks,
    required this.estimatedMinutes,
    required this.questions,
    required this.publishNow,
    required this.isEnabled,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    final questionsSummary = questions
        .map((question) => assignmentQuestionTypeLabel(question.type))
        .toSet()
        .join(' • ');

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
                  'معاينة قبل الحفظ',
                  style: getBoldStyle(
                    color: AppColors.primaryDark,
                    fontSize: FontSize.size14,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
              ),
              AssignmentTag(
                label: publishNow ? 'سينشر الآن' : 'مسودة',
                color: publishNow ? AppColors.green : AppColors.third,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            assignmentTitle,
            style: getBoldStyle(
              color: AppColors.primaryDark,
              fontSize: FontSize.size13,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            instructions,
            style: getRegularStyle(
              color: AppColors.grey,
              fontSize: FontSize.size10,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$modeLabel • $targetLabel • $dueLabel',
            style: getMediumStyle(
              color: AppColors.primaryDark,
              fontSize: FontSize.size10,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${questions.length} سؤال • $questionsSummary • $totalMarks درجة • $estimatedMinutes دقيقة',
            style: getRegularStyle(
              color: AppColors.grey,
              fontSize: FontSize.size10,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isEnabled ? onCreate : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 13),
              ),
              child: Text(
                publishNow ? 'إنشاء ونشر الواجب' : 'حفظ الواجب كمسودة',
                style: getBoldStyle(
                  fontSize: FontSize.size12,
                  fontFamily: FontConstant.cairo,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
