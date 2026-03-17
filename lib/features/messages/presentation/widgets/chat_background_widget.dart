import 'package:flutter/material.dart';
import 'dart:math';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatBackgroundWidget extends StatelessWidget {
  const ChatBackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF9F9F9),
      child: Opacity(
        opacity: 0.05, // Very faint gray outline look
        child: CustomPaint(
          painter: _EducationalPatternPainter(),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _EducationalPatternPainter extends CustomPainter {
  final List<IconData> icons = [
    Icons.calculate_outlined,
    Icons.functions_outlined,
    Icons.menu_book_outlined,
    Icons.auto_stories_outlined,
    Icons.edit_note_outlined,
    Icons.school_outlined,
    Icons.science_outlined,
    Icons.biotech_outlined,
    Icons.public_outlined,
    Icons.explore_outlined,
    Icons.lightbulb_outline,
    Icons.psychology_outlined,
    Icons.schedule_outlined,
    Icons.access_time_outlined,
    Icons.computer_outlined,
    Icons.laptop_chromebook_outlined,
    Icons.attach_file_outlined,
    Icons.push_pin_outlined,
    Icons.history_edu_outlined,
    Icons.draw_outlined,
    Icons.brush_outlined,
    Icons.straighten_outlined,
    Icons.architecture_outlined,
    Icons.pie_chart_outline,
    Icons.insert_chart_outlined,
    Icons.translate_outlined,
    Icons.layers_outlined,
    Icons.rule_outlined,
    Icons.dataset_outlined,
    Icons.bookmarks_outlined,
    FontAwesomeIcons.bookOpen,
    FontAwesomeIcons.graduationCap,
    FontAwesomeIcons.ruler,
    FontAwesomeIcons.pencil,
    FontAwesomeIcons.pen,
    FontAwesomeIcons.eraser,
    FontAwesomeIcons.compassDrafting,
    FontAwesomeIcons.calculator,
    FontAwesomeIcons.globe,
    FontAwesomeIcons.microscope,
    FontAwesomeIcons.atom,
    FontAwesomeIcons.flask,
    FontAwesomeIcons.brain,
    FontAwesomeIcons.clock,
    FontAwesomeIcons.paperclip,
    FontAwesomeIcons.thumbtack,
    FontAwesomeIcons.map,
    FontAwesomeIcons.diagramProject,
    FontAwesomeIcons.chartPie,
    FontAwesomeIcons.chartColumn,
    FontAwesomeIcons.language,
    FontAwesomeIcons.noteSticky,
    FontAwesomeIcons.school,
    FontAwesomeIcons.book,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    const double spacing = 45.0; // Denser than before
    const double iconSize = 24.0;

    final int rows = (size.height / spacing).ceil() + 2;
    final int cols = (size.width / spacing).ceil() + 2;

    final random = Random(42); // Seeded for consistent pattern

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        // Offset odd rows for staggered grid, add noise
        final double noiseX = (random.nextDouble() - 0.5) * 10;
        final double noiseY = (random.nextDouble() - 0.5) * 10;
        final double offsetX =
            c * spacing + (r % 2 == 0 ? 0 : spacing / 2) - 20 + noiseX;
        final double offsetY = r * spacing - 20 + noiseY;

        final icon = icons[random.nextInt(icons.length)];
        final angle = (random.nextDouble() - 0.5) * pi / 1.5;

        TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
        textPainter.text = TextSpan(
          text: String.fromCharCode(icon.codePoint),
          style: TextStyle(
            fontSize: iconSize,
            fontFamily: icon.fontFamily,
            package: icon.fontPackage,
            color: Colors.black,
          ),
        );
        textPainter.layout();

        canvas.save();
        canvas.translate(
          offsetX + textPainter.width / 2,
          offsetY + textPainter.height / 2,
        );
        canvas.rotate(angle);
        textPainter.paint(
          canvas,
          Offset(-textPainter.width / 2, -textPainter.height / 2),
        );
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
