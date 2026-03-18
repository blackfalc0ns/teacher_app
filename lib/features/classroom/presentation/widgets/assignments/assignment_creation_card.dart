import 'package:flutter/material.dart';

import '../../../../../core/utils/constant/font_manger.dart';
import '../../../../../core/utils/constant/styles_manger.dart';
import '../../../../../core/utils/theme/app_colors.dart';
import 'assignment_shared.dart';

class AssignmentCreationCard extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController instructionsController;
  final String modeLabel;
  final String targetLabel;
  final String dueLabel;
  final int totalMarks;
  final int estimatedMinutes;
  final bool publishNow;
  final bool randomizeQuestions;
  final int questionsCount;
  final VoidCallback onChanged;
  final ValueChanged<String> onModeChanged;
  final ValueChanged<String> onTargetChanged;
  final ValueChanged<String> onDueChanged;
  final ValueChanged<bool> onPublishChanged;
  final ValueChanged<bool> onRandomizeChanged;
  final VoidCallback onMarksIncrement;
  final VoidCallback onMarksDecrement;
  final VoidCallback onMinutesIncrement;
  final VoidCallback onMinutesDecrement;

  const AssignmentCreationCard({
    super.key,
    required this.titleController,
    required this.instructionsController,
    required this.modeLabel,
    required this.targetLabel,
    required this.dueLabel,
    required this.totalMarks,
    required this.estimatedMinutes,
    required this.publishNow,
    required this.randomizeQuestions,
    required this.questionsCount,
    required this.onChanged,
    required this.onModeChanged,
    required this.onTargetChanged,
    required this.onDueChanged,
    required this.onPublishChanged,
    required this.onRandomizeChanged,
    required this.onMarksIncrement,
    required this.onMarksDecrement,
    required this.onMinutesIncrement,
    required this.onMinutesDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _BuilderBlock(
          title: 'إعداد الواجب',
          subtitle: 'أنشئ الواجب بسرعة وحدد لمن سيُنشر ومتى.',
          trailing: AssignmentTag(label: '$questionsCount سؤال', color: AppColors.primary),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AssignmentSectionLabel(label: 'اسم الواجب'),
              TextField(
                controller: titleController,
                onChanged: (_) => onChanged(),
                decoration: assignmentInputDecoration('مثال: واجب مهارات القيمة المنزلية'),
              ),
              const SizedBox(height: 12),
              AssignmentSectionLabel(label: 'تعليمات إضافية'),
              TextField(
                controller: instructionsController,
                onChanged: (_) => onChanged(),
                maxLines: 3,
                decoration: assignmentInputDecoration('اكتب أي ملاحظات أو تعليمات للطلاب هنا...'),
              ),
              const SizedBox(height: 12),
              AssignmentSectionLabel(label: 'نوع الواجب'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  AssignmentChoiceChip(label: 'واجب', selected: modeLabel == 'واجب', onTap: () => onModeChanged('واجب')),
                  AssignmentChoiceChip(label: 'اختبار', selected: modeLabel == 'اختبار', onTap: () => onModeChanged('اختبار')),
                  AssignmentChoiceChip(label: 'ورقة عمل', selected: modeLabel == 'ورقة عمل', onTap: () => onModeChanged('ورقة عمل')),
                  AssignmentChoiceChip(label: 'مهمة كتابية', selected: modeLabel == 'مهمة كتابية', onTap: () => onModeChanged('مهمة كتابية')),
                ],
              ),
              const SizedBox(height: 12),
              AssignmentSectionLabel(label: 'الطلاب المستهدفون'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  AssignmentChoiceChip(label: 'كل الشعبة', selected: targetLabel == 'كل الشعبة', onTap: () => onTargetChanged('كل الشعبة')),
                  AssignmentChoiceChip(label: 'طلاب المتابعة', selected: targetLabel == 'طلاب المتابعة', onTap: () => onTargetChanged('طلاب المتابعة')),
                  AssignmentChoiceChip(label: 'مجموعة إثرائية', selected: targetLabel == 'مجموعة إثرائية', onTap: () => onTargetChanged('مجموعة إثرائية')),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _BuilderBlock(
          title: 'النشر والدرجات',
          subtitle: 'اضبط الزمن والدرجة الكلية وموعد التسليم.',
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      title: 'الدرجة الكلية',
                      value: '$totalMarks',
                      onIncrement: onMarksIncrement,
                      onDecrement: onMarksDecrement,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MetricCard(
                      title: 'الزمن المتوقع',
                      value: '$estimatedMinutes د',
                      onIncrement: onMinutesIncrement,
                      onDecrement: onMinutesDecrement,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AssignmentSectionLabel(label: 'موعد التسليم'),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  AssignmentChoiceChip(label: 'اليوم', selected: dueLabel == 'اليوم 8:00 م', onTap: () => onDueChanged('اليوم 8:00 م')),
                  AssignmentChoiceChip(label: 'غدًا', selected: dueLabel == 'غدًا 7:00 م', onTap: () => onDueChanged('غدًا 7:00 م')),
                  AssignmentChoiceChip(label: 'نهاية الأسبوع', selected: dueLabel == 'الخميس 8:00 م', onTap: () => onDueChanged('الخميس 8:00 م')),
                ],
              ),
              const SizedBox(height: 8),
              SwitchListTile.adaptive(
                value: publishNow,
                contentPadding: EdgeInsets.zero,
                activeThumbColor: AppColors.primary,
                title: Text(
                  'نشر مباشر',
                  style: getMediumStyle(
                    color: AppColors.primaryDark,
                    fontSize: FontSize.size12,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
                subtitle: Text(
                  'إذا أُغلق، سيبقى الواجب كمسودة داخل الفصل.',
                  style: getRegularStyle(
                    color: AppColors.grey,
                    fontSize: FontSize.size10,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
                onChanged: onPublishChanged,
              ),
              SwitchListTile.adaptive(
                value: randomizeQuestions,
                contentPadding: EdgeInsets.zero,
                activeThumbColor: AppColors.primary,
                title: Text(
                  'تبديل ترتيب الأسئلة',
                  style: getMediumStyle(
                    color: AppColors.primaryDark,
                    fontSize: FontSize.size12,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
                subtitle: Text(
                  'مناسب للاختبارات والأسئلة الموضوعية.',
                  style: getRegularStyle(
                    color: AppColors.grey,
                    fontSize: FontSize.size10,
                    fontFamily: FontConstant.cairo,
                  ),
                ),
                onChanged: onRandomizeChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BuilderBlock extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final Widget? trailing;

  const _BuilderBlock({
    required this.title,
    required this.subtitle,
    required this.child,
    this.trailing,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: getBoldStyle(
                        color: AppColors.primaryDark,
                        fontSize: FontSize.size14,
                        fontFamily: FontConstant.cairo,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: getRegularStyle(
                        color: AppColors.grey,
                        fontSize: FontSize.size10,
                        fontFamily: FontConstant.cairo,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                trailing!,
              ],
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withValues(alpha: 0.5),
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
          const SizedBox(height: 8),
          Row(
            children: [
              _ActionButton(icon: Icons.remove_rounded, onTap: onDecrement),
              Expanded(
                child: Center(
                  child: Text(
                    value,
                    style: getBoldStyle(
                      color: AppColors.primaryDark,
                      fontSize: FontSize.size14,
                      fontFamily: FontConstant.cairo,
                    ),
                  ),
                ),
              ),
              _ActionButton(icon: Icons.add_rounded, onTap: onIncrement),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.onTap});

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



