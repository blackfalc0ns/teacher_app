import 'package:flutter/material.dart';
import '../../../data/models/classroom_model.dart';

class AssignmentOverviewTile extends StatelessWidget {
  final ClassroomAssignment assignment;
  final bool selected;
  final VoidCallback onTap;

  const AssignmentOverviewTile({
    super.key,
    required this.assignment,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF006D82).withValues(alpha: 0.08)
              : const Color(0xFFF0F3F6),
          borderRadius: BorderRadius.circular(14),
          border: selected
              ? Border.all(color: const Color(0xFF006D82), width: 2)
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    assignment.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? const Color(0xFF006D82)
                          : const Color(0xFF04506E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'تم التسليم: ${assignment.submittedCount}/${assignment.totalCount}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF006D82),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
