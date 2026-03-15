import 'package:flutter/material.dart';

class TrackingEmptyCard extends StatelessWidget {
  final String message;

  const TrackingEmptyCard({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF6B7280),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
