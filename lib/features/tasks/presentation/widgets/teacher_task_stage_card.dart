import 'package:flutter/material.dart';
import 'package:teacher_app/core/utils/constant/font_manger.dart';
import 'package:teacher_app/core/utils/constant/styles_manger.dart';
import 'package:teacher_app/core/utils/theme/app_colors.dart';
import 'package:teacher_app/features/tasks/data/models/teacher_task_model.dart';

class TeacherTaskStageCard extends StatelessWidget {
  final int index;
  final TeacherTaskStageModel stage;
  final VoidCallback? onApprove;
  final VoidCallback? onViewProof;

  const TeacherTaskStageCard({
    super.key,
    required this.index,
    required this.stage,
    this.onApprove,
    this.onViewProof,
  });

  @override
  Widget build(BuildContext context) {
    final stageColor = stage.isApproved
        ? AppColors.secondary
        : stage.isCompleted
        ? AppColors.info
        : AppColors.grey;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: stageColor.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: stageColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size10,
                      color: stageColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stage.title,
                      style: getBoldStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size12,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _stageStatusLabel(stage),
                      style: getMediumStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size9,
                        color: stageColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (stage.proofType != TeacherTaskProofType.none) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F9FC),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(
                    stage.proofType == TeacherTaskProofType.document
                        ? Icons.description_outlined
                        : Icons.image_outlined,
                    size: 16,
                    color: AppColors.primaryDark,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      stage.proofPath ?? 'تم رفع إثبات',
                      style: getRegularStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size9,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                  if (onViewProof != null)
                    TextButton(
                      onPressed: onViewProof,
                      child: const Text('عرض'),
                    ),
                ],
              ),
            ),
          ],
          if (stage.isCompleted && !stage.isApproved && onApprove != null) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.icon(
                onPressed: onApprove,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.info,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.verified_rounded, size: 16),
                label: Text(
                  'اعتماد المرحلة',
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size10,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _stageStatusLabel(TeacherTaskStageModel stage) {
    if (stage.isApproved) return 'تم اعتمادها من المعلم';
    if (stage.isCompleted) return 'مرفوعة وتحتاج اعتمادًا';
    return 'بانتظار تنفيذ الطالب';
  }
}
