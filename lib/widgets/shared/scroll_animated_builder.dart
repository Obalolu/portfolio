import 'package:flutter/material.dart';
import 'package:portfolio/utils/app_animations.dart';

/// Widget that triggers animation when scrolled into view
class ScrollAnimateBuilder extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Offset slideOffset;
  final bool enabled;

  const ScrollAnimateBuilder({
    super.key,
    required this.child,
    this.duration = AppAnimations.medium,
    this.delay = Duration.zero,
    this.slideOffset = const Offset(0, 30),
    this.enabled = true,
  });

  @override
  State<ScrollAnimateBuilder> createState() => _ScrollAnimateBuilderState();
}

class _ScrollAnimateBuilderState extends State<ScrollAnimateBuilder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _hasAnimated = false;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppAnimations.easeOutCubic,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.slideOffset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppAnimations.easeOutCubic,
      ),
    );

    // Check visibility on first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkVisibility() {
    if (!widget.enabled || _hasAnimated) return;

    final RenderBox? renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero).dy;
    final size = renderBox.size.height;

    // Check if widget is in viewport (with some buffer)
    final viewportHeight = MediaQuery.of(context).size.height;
    if (position < viewportHeight - 100 && position + size > 0) {
      setState(() => _hasAnimated = true);
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          _checkVisibility();
        }
        return false;
      },
      child: Container(
        key: _key,
        child: !_hasAnimated
            ? Opacity(
                opacity: 0.0,
                child: widget.child,
              )
            : ClipRect(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: widget.child,
                  ),
                ),
              ),
      ),
    );
  }
}
