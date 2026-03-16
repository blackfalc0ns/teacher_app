import 'package:flutter/material.dart';

import '../../../../../core/utils/constant/font_manger.dart';
import '../../../../../core/utils/constant/styles_manger.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../../data/models/classroom_model.dart';
import 'assignment_draft.dart';
import 'assignment_shared.dart';

class AssignmentQuestionsCard extends StatelessWidget {
  final List<AssignmentDraftQuestion> questions;
  final ValueChanged<AssignmentDraftQuestion> onQuestionChanged;
  final ValueChanged<String> onQuestionDeleted;
  final VoidCallback onAddQuestion;
  final VoidCallback onAddMedia;

  const AssignmentQuestionsCard({
    super.key,
    required this.questions,
    required this.onQuestionChanged,
    required this.onQuestionDeleted,
    required this.onAddQuestion,
    required this.onAddMedia,
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
          Text(
            'بناء الأسئلة',
            style: getBoldStyle(
              color: AppColors.primaryDark,
              fontSize: FontSize.size14,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'أنشئ سؤالًا بعد الآخر وحدد الإجابة الصحيحة أو النموذجية بوضوح.',
            style: getRegularStyle(
              color: AppColors.grey,
              fontSize: FontSize.size10,
              fontFamily: FontConstant.cairo,
            ),
          ),
          const SizedBox(height: 12),
          ...questions.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _QuestionEditor(
                index: entry.key,
                question: entry.value,
                onChanged: onQuestionChanged,
                onDeleted: onQuestionDeleted,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: onAddQuestion,
                  borderRadius: BorderRadius.circular(14),
                  child: _DashedContainer(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_rounded, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(
                          'إضافة سؤال',
                          style: getBoldStyle(
                            color: AppColors.primary,
                            fontSize: FontSize.size11,
                            fontFamily: FontConstant.cairo,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InkWell(
                  onTap: onAddMedia,
                  borderRadius: BorderRadius.circular(14),
                  child: _DashedContainer(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.upload_file_rounded, color: AppColors.secondary),
                        const SizedBox(width: 6),
                        Text(
                          'إرفاق ملف',
                          style: getBoldStyle(
                            color: AppColors.secondary,
                            fontSize: FontSize.size11,
                            fontFamily: FontConstant.cairo,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuestionEditor extends StatelessWidget {
  final int index;
  final AssignmentDraftQuestion question;
  final ValueChanged<AssignmentDraftQuestion> onChanged;
  final ValueChanged<String> onDeleted;

  const _QuestionEditor({
    required this.index,
    required this.question,
    required this.onChanged,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _questionAccent(question.type).withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AssignmentTag(
                label: question.type == AssignmentQuestionType.media
                    ? 'مرفق / ملف'
                    : 'سؤال ${index + 1}',
                color: _questionAccent(question.type),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: AssignmentQuestionType.values
                        .map(
                          (type) => Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: AssignmentChoiceChip(
                              label: assignmentQuestionTypeLabel(type),
                              selected: question.type == type,
                              onTap: () => onChanged(
                                question.copyWith(
                                  type: type,
                                  options: _defaultOptionsForType(type),
                                  correctOptionIndex: 0,
                                  expectedAnswer: _defaultExpectedAnswer(type),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(growable: false),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => onDeleted(question.id),
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.errorRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AssignmentSectionLabel(
            label: question.type == AssignmentQuestionType.media
                ? 'وصف المرفق (اختياري)'
                : 'نص السؤال',
          ),
          TextFormField(
            initialValue: question.prompt,
            onChanged: (value) => onChanged(question.copyWith(prompt: value)),
            decoration: assignmentInputDecoration(
              question.type == AssignmentQuestionType.media
                  ? 'اكتب وصفاً أو تعليمات للملف...'
                  : 'اكتب نص السؤال هنا...',
            ),
          ),
          const SizedBox(height: 12),
          _QuestionAttachment(
            path: question.attachmentPath,
            name: question.attachmentName,
            onRemove: () => onChanged(question.copyWith(clearAttachment: true)),
            onAdd: () {
              // MIGRATION_TODO: Implement real file/image picker here
              // For now, we mock it by updating the state with dummy data
              onChanged(
                question.copyWith(
                  attachmentPath: 'assets/mock/image.png',
                  attachmentName: 'صورة_توضيحية.png',
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          AssignmentSectionLabel(label: 'الدرجة'),
          Row(
            children: [
              _PointButton(
                icon: Icons.remove_rounded,
                onTap: () => onChanged(
                  question.copyWith(
                    points: question.points > 1 ? question.points - 1 : 1,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '${question.points}',
                  style: getBoldStyle(
                    color: AppColors.primaryDark,
                    fontSize: FontSize.size14,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
              ),
              _PointButton(
                icon: Icons.add_rounded,
                onTap: () =>
                    onChanged(question.copyWith(points: question.points + 1)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (question.type != AssignmentQuestionType.media)
            if (question.usesOptions)
              _OptionsEditor(question: question, onChanged: onChanged)
            else
              _ExpectedAnswerEditor(question: question, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _OptionsEditor extends StatelessWidget {
  final AssignmentDraftQuestion question;
  final ValueChanged<AssignmentDraftQuestion> onChanged;

  const _OptionsEditor({required this.question, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AssignmentSectionLabel(label: 'الخيارات والإجابة الصحيحة'),
        ...question.options.asMap().entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () =>
                  onChanged(question.copyWith(correctOptionIndex: entry.key)),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: question.correctOptionIndex == entry.key
                      ? AppColors.primary.withValues(alpha: 0.08)
                      : AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: question.correctOptionIndex == entry.key
                        ? AppColors.primary.withValues(alpha: 0.3)
                        : AppColors.lightGrey,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: question.correctOptionIndex == entry.key
                            ? AppColors.primary
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: question.correctOptionIndex == entry.key
                          ? const Icon(
                              Icons.check_rounded,
                              size: 12,
                              color: AppColors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        initialValue: entry.value,
                        onChanged: (value) {
                          final updated = [...question.options];
                          updated[entry.key] = value;
                          onChanged(question.copyWith(options: updated));
                        },
                        decoration: assignmentInputDecoration(
                          'الخيار ${entry.key + 1}',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ExpectedAnswerEditor extends StatelessWidget {
  final AssignmentDraftQuestion question;
  final ValueChanged<AssignmentDraftQuestion> onChanged;

  const _ExpectedAnswerEditor({
    required this.question,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AssignmentSectionLabel(label: 'الإجابة النموذجية'),
        TextFormField(
          initialValue: question.expectedAnswer,
          onChanged: (value) =>
              onChanged(question.copyWith(expectedAnswer: value)),
          maxLines: question.type == AssignmentQuestionType.essay ? 3 : 1,
          decoration: assignmentInputDecoration(
            'اكتب الإجابة الصحيحة أو النموذجية هنا',
          ),
        ),
      ],
    );
  }
}

class _DashedContainer extends StatelessWidget {
  final Widget child;

  const _DashedContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
      ),
      child: child,
    );
  }
}

class _PointButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _PointButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 16, color: AppColors.primaryDark),
      ),
    );
  }
}

Color _questionAccent(AssignmentQuestionType type) {
  switch (type) {
    case AssignmentQuestionType.multipleChoice:
      return AppColors.third;
    case AssignmentQuestionType.trueFalse:
      return AppColors.secondary;
    case AssignmentQuestionType.shortAnswer:
      return AppColors.primary;
    case AssignmentQuestionType.essay:
      return AppColors.errorRed;
    case AssignmentQuestionType.fillInBlank:
      return AppColors.green;
    case AssignmentQuestionType.matching:
      return AppColors.primaryDark;
    case AssignmentQuestionType.media:
      return AppColors.secondary;
  }
}

List<String> _defaultOptionsForType(AssignmentQuestionType type) {
  if (type == AssignmentQuestionType.trueFalse) {
    return ['صح', 'خطأ'];
  }
  if (type == AssignmentQuestionType.matching) {
    return ['العنصر الأول', 'العنصر الثاني', 'العنصر الثالث'];
  }
  if (type == AssignmentQuestionType.multipleChoice) {
    return ['الخيار الأول', 'الخيار الثاني', 'الخيار الثالث', 'الخيار الرابع'];
  }
  return const [];
}

String _defaultExpectedAnswer(AssignmentQuestionType type) {
  if (type == AssignmentQuestionType.shortAnswer) {
    return 'إجابة مختصرة نموذجية';
  }
  if (type == AssignmentQuestionType.essay) {
    return 'عناصر الإجابة المتوقعة أو rubric التصحيح';
  }
  if (type == AssignmentQuestionType.fillInBlank) {
    return 'الكلمة أو القيمة الصحيحة';
  }
  return '';
}

class _QuestionAttachment extends StatelessWidget {
  final String? path;
  final String? name;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const _QuestionAttachment({
    this.path,
    this.name,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (path != null) {
      final isImage = name?.toLowerCase().endsWith('.png') ?? false;

      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.lightGrey),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isImage
                    ? Icons.image_outlined
                    : Icons.insert_drive_file_outlined,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name ?? 'ملف مرفق',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getBoldStyle(
                      color: AppColors.primaryDark,
                      fontSize: FontSize.size11,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isImage ? 'صورة' : 'ملف PDF',
                    style: getRegularStyle(
                      color: AppColors.grey,
                      fontSize: FontSize.size9,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onRemove,
              icon: const Icon(
                Icons.close_rounded,
                size: 18,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: onAdd,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.upload_file_rounded,
              size: 18,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'إرفاق صورة أو ملف للسؤال',
              style: getBoldStyle(
                color: AppColors.primary,
                fontSize: FontSize.size11,
                fontFamily: FontConstant.cairo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
