import 'package:flutter/material.dart';
import 'package:teacher_app/core/utils/common/custom_button.dart';
import '../../../../schedule/data/model/schedule_model.dart';
import '../../../data/models/classroom_model.dart';
import '../../pages/assignment_submission_page.dart';

class SelectedSubmissionAction extends StatelessWidget {
  final ClassroomAssignment assignment;
  final AssignmentSubmission? selectedSubmission;
  final ScheduleModel item;
  final ValueChanged<AssignmentSubmission> onSubmissionUpdated;

  const SelectedSubmissionAction({
    super.key,
    required this.assignment,
    required this.selectedSubmission,
    required this.item,
    required this.onSubmissionUpdated,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedSubmission == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        onPressed: () async {
          final updatedSubmission = await Navigator.of(context)
              .push<AssignmentSubmission>(
                MaterialPageRoute(
                  builder: (_) => AssignmentSubmissionPage(
                    item: item,
                    assignment: assignment,
                    submission: selectedSubmission!,
                  ),
                ),
              );

          if (updatedSubmission != null) {
            onSubmissionUpdated(updatedSubmission);
          }
        },

        text:
            selectedSubmission!.status ==
                AssignmentSubmissionStatus.notSubmitted
            ? 'عرض حالة الطالب'
            : 'عرض الحل والتصحيح اليدوي',
      ),
    );
  }
}
