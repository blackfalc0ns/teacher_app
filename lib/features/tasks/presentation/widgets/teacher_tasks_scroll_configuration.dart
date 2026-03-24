import 'package:flutter/material.dart';

class TeacherTasksScrollConfiguration extends StatelessWidget {
  final Widget child;

  const TeacherTasksScrollConfiguration({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const _TeacherTasksNoStretchBehavior(),
      child: child,
    );
  }
}

class _TeacherTasksNoStretchBehavior extends MaterialScrollBehavior {
  const _TeacherTasksNoStretchBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(
      parent: AlwaysScrollableScrollPhysics(),
    );
  }
}
