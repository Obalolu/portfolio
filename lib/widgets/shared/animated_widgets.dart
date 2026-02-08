import 'package:flutter/material.dart';
import 'package:portfolio/utils/app_animations.dart';
import 'package:portfolio/utils/app_colors.dart';
import 'package:portfolio/utils/app_spacing.dart';

/// Animated card with hover lift effect
class HoverCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double hoverScale;
  final double elevation;
  final Duration duration;
  final Color? hoverColor;

  const HoverCard({
    super.key,
    required this.child,
    this.onTap,
    this.hoverScale = 1.02,
    this.elevation = 0,
    this.duration = AppAnimations.fast,
    this.hoverColor,
  });

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: widget.duration,
        curve: AppAnimations.easeOut,
        transform: Matrix4.identity()..scaled(_isHovered ? widget.hoverScale : 1.0, 1.0, 1.0),
        decoration: BoxDecoration(
          color: _isHovered && widget.hoverColor != null ? widget.hoverColor : null,
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          child: widget.child,
        ),
      ),
    );
  }
}

/// Animated button with hover fill effect
class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool primary;
  final IconData? icon;
  final Duration duration;

  const AnimatedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.primary = true,
    this.icon,
    this.duration = AppAnimations.fast,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: widget.duration,
        curve: AppAnimations.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          gradient: widget.primary
              ? (_isHovered ? null : AppColors.primaryGradient)
              : null,
          color: widget.primary
              ? (_isHovered ? AppColors.primary : Colors.transparent)
              : (_isHovered ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent),
          border: Border.all(
            color: widget.primary ? AppColors.primary : AppColors.primary.withValues(alpha: 0.5),
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null) ...[
              Icon(
                widget.icon,
                color: widget.primary ? AppColors.textPrimary : AppColors.primary,
                size: 16,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              widget.text,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: widget.primary ? AppColors.textPrimary : AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Count-up animation for numbers
class CountUpAnimation extends StatefulWidget {
  final int end;
  final int start;
  final Duration duration;
  final String prefix;
  final String suffix;
  final TextStyle? style;

  const CountUpAnimation({
    super.key,
    required this.end,
    this.start = 0,
    this.duration = AppAnimations.countUp,
    this.prefix = '',
    this.suffix = '',
    this.style,
  });

  @override
  State<CountUpAnimation> createState() => _CountUpAnimationState();
}

class _CountUpAnimationState extends State<CountUpAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppAnimations.easeOutQuart,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final value = (widget.start + (widget.end - widget.start) * _animation.value).round();
        return Text(
          '${widget.prefix}$value${widget.suffix}',
          style: widget.style,
        );
      },
    );
  }
}

/// Progress bar with fill animation
class AnimatedProgressBar extends StatefulWidget {
  final double progress; // 0.0 to 1.0
  final Color? color;
  final double height;
  final Duration duration;
  final BorderRadius? borderRadius;

  const AnimatedProgressBar({
    super.key,
    required this.progress,
    this.color,
    this.height = 4,
    this.duration = const Duration(milliseconds: 800),
    this.borderRadius,
  });

  @override
  State<AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: widget.progress).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppAnimations.easeOutCubic,
      ),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return LinearProgressIndicator(
            value: _animation.value,
            backgroundColor: AppColors.surfaceLight,
            valueColor: AlwaysStoppedAnimation(widget.color ?? AppColors.primary),
            minHeight: widget.height,
          );
        },
      ),
    );
  }
}

/// Social icon with hover animation
class AnimatedSocialIcon extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String tooltip;

  const AnimatedSocialIcon({
    super.key,
    required this.icon,
    this.onTap,
    this.tooltip = '',
  });

  @override
  State<AnimatedSocialIcon> createState() => _AnimatedSocialIconState();
}

class _AnimatedSocialIconState extends State<AnimatedSocialIcon>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.15).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppAnimations.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: Tooltip(
        message: widget.tooltip,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(24),
          child: AnimatedContainer(
            duration: AppAnimations.fast,
            curve: AppAnimations.easeOut,
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _isHovered ? AppColors.primary : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: _isHovered ? 1.0 : 0.3),
              ),
            ),
            child: AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _isHovered ? _rotationAnimation.value * 6.28 : 0,
                  child: Icon(
                    widget.icon,
                    color: _isHovered ? AppColors.background : AppColors.primary,
                    size: _isHovered ? 22 : 20,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
