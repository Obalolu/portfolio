import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/utils/app_animations.dart';
import 'package:portfolio/utils/app_colors.dart';

/// A unified interactive widget that handles both mouse hover (desktop)
/// and touch interactions (mobile) with proper state management and haptic feedback.
///
/// Usage:
/// ```dart
/// UniversalInteractive(
///   onTap: () => doSomething(),
///   builder: (context, state) => Container(
///     color: state.isHovered || state.isPressed
///       ? AppColors.primary
///       : AppColors.surface,
///     child: Text('Click me'),
///   ),
/// )
/// ```
class UniversalInteractive extends StatefulWidget {
  final Widget Function(BuildContext context, InteractionState state) builder;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enableHapticFeedback;
  final bool maintainState;
  final HitTestBehavior behavior;

  const UniversalInteractive({
    super.key,
    required this.builder,
    this.onTap,
    this.onLongPress,
    this.enableHapticFeedback = true,
    this.maintainState = false,
    this.behavior = HitTestBehavior.translucent,
  });

  @override
  State<UniversalInteractive> createState() => _UniversalInteractiveState();
}

class InteractionState {
  final bool isHovered;
  final bool isPressed;
  final bool hasFocus;

  const InteractionState({
    this.isHovered = false,
    this.isPressed = false,
    this.hasFocus = false,
  });

  bool get isActive => isHovered || isPressed;
}

class _UniversalInteractiveState extends State<UniversalInteractive> {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _hasFocus = false;

  InteractionState get _state => InteractionState(
    isHovered: _isHovered,
    isPressed: _isPressed,
    hasFocus: _hasFocus,
  );

  void _handleTap() {
    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
    widget.onTap?.call();
  }

  void _handleLongPress() {
    if (widget.enableHapticFeedback) {
      HapticFeedback.mediumImpact();
    }
    widget.onLongPress?.call();
  }

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      onShowFocusHighlight: (hasFocus) {
        setState(() => _hasFocus = hasFocus);
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) {
          setState(() {
            _isHovered = false;
            _isPressed = false;
          });
        },
        child: GestureDetector(
          behavior: widget.behavior,
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: _handleTap,
          onLongPress: widget.onLongPress != null ? _handleLongPress : null,
          child: widget.builder(context, _state),
        ),
      ),
    );
  }
}

/// A pre-built interactive card widget that uses UniversalInteractive
/// and provides common hover/touch effects like scale and elevation.
class InteractiveCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double hoverScale;
  final double pressedScale;
  final Duration duration;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? hoverColor;
  final List<BoxShadow>? shadow;
  final List<BoxShadow>? hoverShadow;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const InteractiveCard({
    super.key,
    required this.child,
    this.onTap,
    this.hoverScale = 1.02,
    this.pressedScale = 0.98,
    this.duration = AppAnimations.fast,
    this.borderRadius,
    this.backgroundColor,
    this.hoverColor,
    this.shadow,
    this.hoverShadow,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return UniversalInteractive(
      onTap: onTap,
      builder: (context, state) {
        final scale = state.isPressed
            ? pressedScale
            : (state.isHovered ? hoverScale : 1.0);

        return AnimatedContainer(
          duration: duration,
          curve: AppAnimations.easeOut,
          margin: margin,
          padding: padding,
          transform: Matrix4.identity()..scale(scale),
          decoration: BoxDecoration(
            color: state.isHovered && hoverColor != null
                ? hoverColor
                : backgroundColor ?? AppColors.surface,
            borderRadius: borderRadius ?? BorderRadius.circular(12),
            boxShadow: state.isHovered && hoverShadow != null
                ? hoverShadow
                : shadow,
          ),
          child: child,
        );
      },
    );
  }
}

/// A pre-built interactive button widget with consistent styling
class InteractiveButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isPrimary;
  final double? width;
  final double? height;

  const InteractiveButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isPrimary = true,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return UniversalInteractive(
      onTap: onPressed,
      builder: (context, state) {
        final isActive = state.isHovered || state.isPressed;

        return AnimatedContainer(
          duration: AppAnimations.fast,
          width: width,
          height: height ?? 48,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: isPrimary
                ? (isActive
                      ? AppColors.primary.withValues(alpha: 0.9)
                      : AppColors.primary)
                : (isActive
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.transparent),
            border: Border.all(
              color: isPrimary
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: isPrimary ? Colors.white : AppColors.primary,
                  size: 16,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: TextStyle(
                  color: isPrimary ? Colors.white : AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
