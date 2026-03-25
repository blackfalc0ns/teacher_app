import 'package:flutter/material.dart';
import 'package:teacher_app/core/utils/constant/font_manger.dart';
import 'package:teacher_app/core/utils/constant/styles_manger.dart';
import 'package:teacher_app/core/utils/theme/app_colors.dart';
import 'package:teacher_app/features/tasks/data/models/teacher_task_model.dart';

class TeacherTaskStagesCard extends StatelessWidget {
  final List<TeacherTaskStageModel> stages;
  final VoidCallback onAddStage;
  final void Function(int index) onRemoveStage;
  final void Function(int index, TeacherTaskStageModel stage) onStageChanged;

  const TeacherTaskStagesCard({
    super.key,
    required this.stages,
    required this.onAddStage,
    required this.onRemoveStage,
    required this.onStageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lightGrey.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.list_alt_rounded,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'مراحل تنفيذ المهمة',
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size14,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
              InkWell(
                onTap: onAddStage,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.add_rounded,
                        color: AppColors.primary,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'إضافة',
                        style: getBoldStyle(
                          fontFamily: FontConstant.cairo,
                          fontSize: FontSize.size11,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(
            stages.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F9FC),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.lightGrey.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: getBoldStyle(
                                fontFamily: FontConstant.cairo,
                                fontSize: FontSize.size9,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'بيانات المرحلة',
                            style: getBoldStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: FontSize.size10,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                        if (stages.length > 1)
                          InkWell(
                            onTap: () => onRemoveStage(index),
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              color: AppColors.errorRed,
                              size: 18,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: stages[index].title,
                      style: getMediumStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size13,
                      ),
                      onChanged: (value) => onStageChanged(
                        index,
                        stages[index].copyWith(title: value),
                      ),
                      decoration: _inputDecoration(
                        'عنوان المرحلة (مثلاً: التحضير، التنفيذ...)',
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<TeacherTaskProofType>(
                      initialValue: stages[index].proofType,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size13,
                        color: AppColors.primaryDark,
                      ),
                      onChanged: (value) {
                        if (value == null) return;
                        onStageChanged(
                          index,
                          stages[index].copyWith(proofType: value),
                        );
                      },
                      decoration: _inputDecoration(
                        'نوع الإثبات المطلوب من الطالب',
                      ),
                      items: [
                        DropdownMenuItem(
                          value: TeacherTaskProofType.image,
                          child: Text(
                            'صورة توثيقية',
                            style: getSemiBoldStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: FontSize.size13,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: TeacherTaskProofType.document,
                          child: Text(
                            'مستند أو ملف',
                            style: getSemiBoldStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: FontSize.size13,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: TeacherTaskProofType.none,
                          child: Text(
                            'لا يوجد إثبات',
                            style: getSemiBoldStyle(
                              fontFamily: FontConstant.cairo,
                              fontSize: FontSize.size13,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: getSemiBoldStyle(
        fontFamily: FontConstant.cairo,
        fontSize: FontSize.size12,
        color: AppColors.grey,
      ),
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFEDF2F7), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1),
      ),
    );
  }
}
