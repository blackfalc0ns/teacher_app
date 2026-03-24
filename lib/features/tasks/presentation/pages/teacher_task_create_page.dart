import 'package:flutter/material.dart';
import 'package:teacher_app/core/utils/constant/font_manger.dart';
import 'package:teacher_app/core/utils/constant/styles_manger.dart';
import 'package:teacher_app/core/utils/theme/app_colors.dart';
import 'package:teacher_app/features/tasks/data/models/teacher_task_model.dart';
import 'package:teacher_app/features/tasks/presentation/widgets/create/teacher_task_basics_card.dart';
import 'package:teacher_app/features/tasks/presentation/widgets/create/teacher_task_stages_card.dart';
import 'package:teacher_app/features/tasks/presentation/widgets/teacher_tasks_scroll_configuration.dart';

class TeacherTaskCreatePage extends StatefulWidget {
  final TeacherTaskDashboardModel dashboard;

  const TeacherTaskCreatePage({super.key, required this.dashboard});

  @override
  State<TeacherTaskCreatePage> createState() => _TeacherTaskCreatePageState();
}

class _TeacherTaskCreatePageState extends State<TeacherTaskCreatePage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _rewardController = TextEditingController();

  String? _selectedClassId;
  String? _selectedStudentId;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 3));
  TeacherTaskRewardType _rewardType = TeacherTaskRewardType.moral;
  late List<TeacherTaskStageModel> _stages;

  @override
  void initState() {
    super.initState();
    _stages = const [
      TeacherTaskStageModel(
        id: 'stage-1',
        title: '',
        proofType: TeacherTaskProofType.image,
      ),
    ];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _rewardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F9FC),
        surfaceTintColor: Colors.transparent,
        title: Text(
          'إسناد مهمة جديدة',
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
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.tips_and_updates_outlined,
                    color: AppColors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'أنشئ مهمة فردية لطالب محدد، ثم قسّمها إلى مراحل واضحة مع إثبات مناسب لكل مرحلة ومكافأة محفزة.',
                      style: getMediumStyle(
                        fontFamily: FontConstant.cairo,
                        fontSize: FontSize.size12,
                        color: AppColors.white.withValues(alpha: 0.95),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            TeacherTaskBasicsCard(
              titleController: _titleController,
              descriptionController: _descriptionController,
              rewardController: _rewardController,
              classes: widget.dashboard.assignedClasses,
              students: widget.dashboard.students,
              selectedClassId: _selectedClassId,
              selectedStudentId: _selectedStudentId,
              rewardType: _rewardType,
              onClassChanged: (value) => setState(() {
                _selectedClassId = value;
                _selectedStudentId = null;
              }),
              onStudentChanged: (value) =>
                  setState(() => _selectedStudentId = value),
              onRewardTypeChanged: (value) => setState(
                () => _rewardType = value ?? TeacherTaskRewardType.moral,
              ),
              dueDate: _dueDate,
              onPickDueDate: _pickDueDate,
            ),
            const SizedBox(height: 14),
            TeacherTaskStagesCard(
              stages: _stages,
              onAddStage: _addStage,
              onRemoveStage: _removeStage,
              onStageChanged: (index, stage) =>
                  setState(() => _stages[index] = stage),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _submit,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              icon: const Icon(Icons.assignment_turned_in_outlined, size: 18),
              label: Text(
                'إسناد المهمة',
                style: getBoldStyle(
                  fontFamily: FontConstant.cairo,
                  fontSize: FontSize.size11,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );

    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  void _addStage() {
    setState(() {
      _stages = [
        ..._stages,
        TeacherTaskStageModel(
          id: 'stage-${_stages.length + 1}',
          title: '',
          proofType: TeacherTaskProofType.image,
        ),
      ];
    });
  }

  void _removeStage(int index) {
    setState(() {
      _stages = [..._stages]..removeAt(index);
    });
  }

  void _submit() {
    TeacherTaskClassOption? selectedClass;
    for (final item in widget.dashboard.assignedClasses) {
      if (item.id == _selectedClassId) {
        selectedClass = item;
        break;
      }
    }

    TeacherTaskStudentModel? selectedStudent;
    for (final item in widget.dashboard.students) {
      if (item.id == _selectedStudentId) {
        selectedStudent = item;
        break;
      }
    }

    final validStages = _stages
        .where((stage) => stage.title.trim().isNotEmpty)
        .toList();

    if (_titleController.text.trim().isEmpty ||
        selectedClass == null ||
        selectedStudent == null ||
        _rewardController.text.trim().isEmpty ||
        validStages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('أكمل البيانات الأساسية والمراحل قبل الإسناد.'),
        ),
      );
      return;
    }

    final createdTask = TeacherStudentTaskModel(
      id: 'task-${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      source: TeacherTaskSource.teacher,
      status: TeacherTaskStatus.pending,
      rewardType: _rewardType,
      rewardValue: _rewardController.text.trim(),
      progress: 0,
      dueDate: _dueDate,
      subjectName: selectedClass.subjectName,
      classId: selectedClass.id,
      cycleName: selectedClass.cycleName,
      gradeName: selectedClass.gradeName,
      sectionName: selectedClass.sectionName,
      studentId: selectedStudent.id,
      studentName: selectedStudent.name,
      stages: validStages.asMap().entries.map((entry) {
        return entry.value.copyWith(id: 'stage-${entry.key + 1}');
      }).toList(),
    );

    Navigator.of(context).pop(createdTask);
  }
}
