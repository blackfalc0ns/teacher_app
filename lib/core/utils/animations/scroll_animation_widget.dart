import 'package:flutter/material.dart';

/// Widget احترافي لعمل animations مع الـ scroll
class ScrollAnimationWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final double offset;
  final AnimationType animationType;
  final int delay;

  const ScrollAnimationWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOutCubic,
    this.offset = 50.0,
    this.animationType = AnimationType.fadeSlideUp,
    this.delay = 0,
  });

  @override
  State<ScrollAnimationWidget> createState() => _ScrollAnimationWidgetState();
}

class _ScrollAnimationWidgetState extends State<ScrollAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _slideAnimation = Tween<Offset>(
      begin: _getBeginOffset(),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    // Start animation after delay
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  Offset _getBeginOffset() {
    switch (widget.animationType) {
      case AnimationType.fadeSlideUp:
        return Offset(0, widget.offset / 50);
      case AnimationType.fadeSlideDown:
        return Offset(0, -widget.offset / 50);
      case AnimationType.fadeSlideLeft:
        return Offset(widget.offset / 50, 0);
      case AnimationType.fadeSlideRight:
        return Offset(-widget.offset / 50, 0);
      case AnimationType.fadeScale:
      case AnimationType.fade:
        return Offset.zero;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        Widget animatedChild = widget.child;

        switch (widget.animationType) {
          case AnimationType.fadeSlideUp:
          case AnimationType.fadeSlideDown:
          case AnimationType.fadeSlideLeft:
          case AnimationType.fadeSlideRight:
            animatedChild = SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: widget.child,
              ),
            );
            break;

          case AnimationType.fadeScale:
            animatedChild = ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: widget.child,
              ),
            );
            break;

          case AnimationType.fade:
            animatedChild = FadeTransition(
              opacity: _fadeAnimation,
              child: widget.child,
            );
            break;
        }

        return animatedChild;
      },
    );
  }
}

/// أنواع الـ animations المتاحة
enum AnimationType {
  fadeSlideUp,
  fadeSlideDown,
  fadeSlideLeft,
  fadeSlideRight,
  fadeScale,
  fade,
}

/// Widget لعمل staggered animations للـ sections
class StaggeredScrollAnimation extends StatelessWidget {
  final List<Widget> children;
  final int startDelay;
  final int itemDelay;
  final AnimationType animationType;

  const StaggeredScrollAnimation({
    super.key,
    required this.children,
    this.startDelay = 0,
    this.itemDelay = 100,
    this.animationType = AnimationType.fadeSlideUp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        children.length,
        (index) => ScrollAnimationWidget(
          delay: startDelay + (index * itemDelay),
          animationType: animationType,
          child: children[index],
        ),
      ),
    );
  }
}
