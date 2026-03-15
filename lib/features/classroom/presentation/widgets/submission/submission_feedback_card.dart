import 'package:flutter/material.dart';

class SubmissionFeedbackCard extends StatelessWidget {
  final TextEditingController feedbackController;

  const SubmissionFeedbackCard({
    super.key,
    required this.feedbackController,
  });

  @override
  Widget build(BuildContext context) {
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
            'ملاحظات المعلم',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF04506E),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: feedbackController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'أضف ملاحظاتك هنا',
              filled: true,
              fillColor: const Color(0xFFF0F3F6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
