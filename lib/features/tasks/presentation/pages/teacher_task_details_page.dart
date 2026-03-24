import 'package:flutter/material.dart';
import 'package:teacher_app/core/utils/constant/font_manger.dart';
import 'package:teacher_app/core/utils/constant/styles_manger.dart';
import 'package:teacher_app/core/utils/theme/app_colors.dart';
import 'package:teacher_app/features/tasks/data/models/teacher_task_model.dart';
import 'package:teacher_app/features/tasks/presentation/widgets/teacher_task_stage_card.dart';
import 'package:teacher_app/features/tasks/presentation/widgets/teacher_tasks_scroll_configuration.dart';

class TeacherTaskDetailsPage extends StatefulWidget {
  final TeacherStudentTaskModel task;

  const TeacherTaskDetailsPage({super.key, required this.task});

  @override
  State<TeacherTaskDetailsPage> createState() => _TeacherTaskDetailsPageState();
}

class _TeacherTaskDetailsPageState extends State<TeacherTaskDetailsPage> {
  late TeacherStudentTaskModel _task;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pop(_task);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F9FC),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF6F9FC),
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(_task),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          title: Text(
            'تفاصيل المهمة',
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size16,
              color: AppColors.primaryDark,
            ),
          ),
        ),
        body: TeacherTasksScrollConfiguration(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _buildHeroCard(),
              const SizedBox(height: 14),
              _buildRewardCard(),
              const SizedBox(height: 14),
              _buildDescriptionCard(),
              const SizedBox(height: 14),
              Text(
                'مراحل التنفيذ والاعتماد',
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size13,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 10),
              ...List.generate(
                _task.stages.length,
                (index) => TeacherTaskStageCard(
                  index: index,
                  stage: _task.stages[index],
                  onViewProof: _task.stages[index].proofPath == null
                      ? null
                      : () => _showProofDialog(_task.stages[index]),
                  onApprove:
                      _task.stages[index].isCompleted &&
                          !_task.stages[index].isApproved
                      ? () => _approveStage(index)
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _task.title,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size17,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${_task.studentName} • ${_task.cycleClassLabel}',
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size10,
              color: AppColors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _task.progress,
                    minHeight: 8,
                    backgroundColor: AppColors.white.withValues(alpha: 0.15),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                '${(_task.progress * 100).round()}%',
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size11,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _heroMeta('المادة', _task.subjectName)),
              const SizedBox(width: 10),
              Expanded(
                child: _heroMeta(
                  'مراحل مكتملة',
                  '${_task.completedStagesCount}/${_task.stages.length}',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _heroMeta(
                  'بانتظار اعتماد',
                  _task.pendingApprovalsCount.toString(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroMeta(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size12,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size9,
              color: AppColors.white.withValues(alpha: 0.88),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardCard() {
    final rewardColor = _task.rewardType == TeacherTaskRewardType.financial
        ? const Color(0xFFF59E0B)
        : AppColors.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: rewardColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _task.rewardType == TeacherTaskRewardType.financial
                  ? Icons.payments_outlined
                  : Icons.workspace_premium_outlined,
              color: rewardColor,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _task.rewardType == TeacherTaskRewardType.financial
                      ? 'مكافأة مادية'
                      : 'مكافأة معنوية',
                  style: getRegularStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size10,
                    color: AppColors.grey,
                  ),
                ),
                Text(
                  _task.rewardValue,
                  style: getBoldStyle(
                    fontFamily: FontConstant.cairo,
                    fontSize: FontSize.size13,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'التسليم ${_task.dueDate.day}/${_task.dueDate.month}',
            style: getMediumStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size9,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'وصف المهمة',
            style: getBoldStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size12,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _task.description ?? 'بدون وصف إضافي.',
            style: getRegularStyle(
              fontFamily: FontConstant.cairo,
              fontSize: FontSize.size10,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _approveStage(int index) {
    final updatedStages = [..._task.stages];
    updatedStages[index] = updatedStages[index].copyWith(isApproved: true);
    final approved = updatedStages.where((stage) => stage.isApproved).length;
    final status = _deriveStatus(updatedStages);

    setState(() {
      _task = _task.copyWith(
        stages: updatedStages,
        status: status,
        progress: updatedStages.isEmpty
            ? 0
            : updatedStages.where((stage) => stage.isCompleted).length /
                  updatedStages.length,
      );
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم اعتماد المرحلة بنجاح.')));

    if (approved == updatedStages.length && updatedStages.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('اكتملت المهمة وتم اعتماد جميع مراحلها.')),
      );
    }
  }

  TeacherTaskStatus _deriveStatus(List<TeacherTaskStageModel> stages) {
    if (stages.isEmpty) return TeacherTaskStatus.pending;
    final allCompleted = stages.every((stage) => stage.isCompleted);
    final allApproved = stages.every(
      (stage) => !stage.requiresApproval || stage.isApproved,
    );
    final anyCompleted = stages.any((stage) => stage.isCompleted);
    final hasPendingApprovals = stages.any(
      (stage) =>
          stage.isCompleted && stage.requiresApproval && !stage.isApproved,
    );

    if (allCompleted && allApproved) return TeacherTaskStatus.completed;
    if (hasPendingApprovals) return TeacherTaskStatus.underReview;
    if (anyCompleted) return TeacherTaskStatus.inProgress;
    return TeacherTaskStatus.pending;
  }

  void _showProofDialog(TeacherTaskStageModel stage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(stage.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stage.proofType == TeacherTaskProofType.document
                  ? 'نوع الإثبات: مستند'
                  : 'نوع الإثبات: صورة',
            ),
            const SizedBox(height: 8),
            Text('الملف المرفوع: ${stage.proofPath ?? 'غير محدد'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}

