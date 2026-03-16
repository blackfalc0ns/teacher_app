import 'package:flutter/material.dart';

import '../../../../../core/utils/constant/font_manger.dart';
import '../../../../../core/utils/constant/styles_manger.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import '../../../data/models/classroom_model.dart';

String assignmentQuestionTypeLabel(AssignmentQuestionType type) {
  switch (type) {
    case AssignmentQuestionType.multipleChoice:
      return 'اختيار متعدد';
    case AssignmentQuestionType.trueFalse:
      return 'صح أو خطأ';
    case AssignmentQuestionType.shortAnswer:
      return 'إجابة قصيرة';
    case AssignmentQuestionType.essay:
      return 'مقالي';
    case AssignmentQuestionType.fillInBlank:
      return 'أكمل الفراغ';
    case AssignmentQuestionType.matching:
      return 'توصيل';
    case AssignmentQuestionType.media:
      return 'ملف / صورة';
  }
}

String assignmentSubmissionStatusLabel(AssignmentSubmissionStatus status) {
  switch (status) {
    case AssignmentSubmissionStatus.notSubmitted:
      return 'لم يسلّم';
    case AssignmentSubmissionStatus.submitted:
      return 'بانتظار التصحيح';
    case AssignmentSubmissionStatus.reviewed:
      return 'تم التصحيح';
    case AssignmentSubmissionStatus.late:
      return 'متأخر';
  }
}

Color assignmentSubmissionStatusColor(AssignmentSubmissionStatus status) {
  switch (status) {
    case AssignmentSubmissionStatus.notSubmitted:
      return AppColors.grey;
    case AssignmentSubmissionStatus.submitted:
      return AppColors.third;
    case AssignmentSubmissionStatus.reviewed:
      return AppColors.green;
    case AssignmentSubmissionStatus.late:
      return AppColors.errorRed;
  }
}

InputDecoration assignmentInputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: getRegularStyle(
      color: AppColors.grey,
      fontSize: FontSize.size10,
      fontFamily: FontConstant.cairo,
    ),
    filled: true,
    fillColor: AppColors.lightGrey.withValues(alpha: 0.18),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
  );
}

class AssignmentTag extends StatelessWidget {
  final String label;
  final Color color;

  const AssignmentTag({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: getBoldStyle(
          color: color,
          fontSize: FontSize.size10,
          fontFamily: FontConstant.cairo,
        ),
      ),
    );
  }
}

class AssignmentSectionLabel extends StatelessWidget {
  final String label;

  const AssignmentSectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: getMediumStyle(
          color: AppColors.primaryDark,
          fontSize: FontSize.size11,
          fontFamily: FontConstant.cairo,
        ),
      ),
    );
  }
}

class AssignmentChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const AssignmentChoiceChip({
    super.key,
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.lightGrey.withValues(alpha: 0.28),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary.withValues(alpha: 0.26) : Colors.transparent,
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
