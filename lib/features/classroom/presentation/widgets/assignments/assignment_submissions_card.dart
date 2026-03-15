import 'package:flutter/material.dart';
import '../../../data/models/classroom_model.dart';
import '../tracking/tracking_empty_card.dart';
import 'assignment_overview_tile.dart';

class AssignmentSubmissionsCard extends StatelessWidget {
  final List<ClassroomAssignment> assignments;
  final int selectedAssignmentIndex;
  final ValueChanged<int> onAssignmentSelected;

  const AssignmentSubmissionsCard({
    super.key,
    required this.assignments,
    required this.selectedAssignmentIndex,
    required this.onAssignmentSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (assignments.isEmpty) {
      return const TrackingEmptyCard(
        message: 'لا يوجد واجبات متاحة حالياً.',
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الواجبات المتاحة',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF04506E),
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            'اختر واجباً لعرض تفاصيل التسليمات.',
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 12),
          ...assignments.asMap().entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AssignmentOverviewTile(
                    assignment: entry.value,
                    selected: entry.key == selectedAssignmentIndex,
                    onTap: () => onAssignmentSelected(entry.key),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
