import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:portfolio/utils/app_colors.dart';

/// A segmented circular border with complex multi-phase animation.
///
/// The border consists of arc segments that rotate, merge, split, and reverse
/// direction in a deterministic 21-second cycle. The animation feels organic
/// and intentional - like a living system rather than a looped spinner.
class SegmentedNeonAvatarBorder extends StatefulWidget {
  final Widget child;
  final double size;
  final Color segmentColor;
  final int segmentCount;
  final double stroke;
  final bool enableGlow;

  const SegmentedNeonAvatarBorder({
    super.key,
    required this.child,
    this.size = 120,
    this.segmentColor = AppColors.primary,
    this.segmentCount = 8,
    this.stroke = 2.5,
    this.enableGlow = false,
  }) : assert(segmentCount >= 4 && segmentCount <= 12,
            'segmentCount must be between 4 and 12');

  @override
  State<SegmentedNeonAvatarBorder> createState() =>
      _SegmentedNeonAvatarBorderState();
}

class _SegmentedNeonAvatarBorderState extends State<SegmentedNeonAvatarBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Segment> _segments;
  final _RotationAccumulator _rotationAccumulator = _RotationAccumulator();

  // Phase boundaries (21 second total cycle)
  static const double _phase1End = 2.5 / 21;  // CW Stable: 0 - 2.5s
  static const double _phase2End = 6.5 / 21;  // CW Fragmentation: 2.5 - 6.5s
  static const double _phase3End = 8.5 / 21;  // CW Deceleration: 6.5 - 8.5s
  static const double _phase4End = 9.0 / 21;  // Direction Inversion: 8.5 - 9s
  static const double _phase5End = 13.0 / 21; // CCW Reconstruction: 9 - 13s
  static const double _phase6End = 17.0 / 21; // CCW Fragmentation: 13 - 17s
  static const double _phase7End = 19.0 / 21; // CCW Deceleration: 17 - 19s
  // Loop Reset: 19 - 21s (ends at 1.0)

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 21),
      vsync: this,
    );

    _initializeSegments();
    _controller.repeat();
  }

  void _initializeSegments() {
    // Create segments with varying base sizes for organic appearance
    // Alternating pattern: small, large, small, large, etc.
    _segments = List.generate(
      widget.segmentCount,
      (index) {
        final angle = (2 * math.pi / widget.segmentCount) * index;
        // Alternate between small (~10°) and large (~25°) segments
        final isLarge = index % 2 == 0;
        final sweep = isLarge ? (math.pi / 7.2) : (math.pi / 18); // 25° vs 10°
        return _Segment(
          baseAngle: angle,
          baseSweep: sweep,
          phaseOffset: (2 * math.pi / widget.segmentCount) * index,
          index: index,
        );
      },
    );
  }

  @override
  void didUpdateWidget(SegmentedNeonAvatarBorder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.segmentCount != widget.segmentCount) {
      _initializeSegments();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _Phase _currentPhase(double value) {
    if (value < _phase1End) return _Phase.cwStable;
    if (value < _phase2End) return _Phase.cwFragmentation;
    if (value < _phase3End) return _Phase.cwDeceleration;
    if (value < _phase4End) return _Phase.directionInversion;
    if (value < _phase5End) return _Phase.ccwReconstruction;
    if (value < _phase6End) return _Phase.ccwFragmentation;
    if (value < _phase7End) return _Phase.ccwDeceleration;
    return _Phase.loopReset;
  }

  double _phaseStart(_Phase phase) {
    switch (phase) {
      case _Phase.cwStable:
        return 0.0;
      case _Phase.cwFragmentation:
        return _phase1End;
      case _Phase.cwDeceleration:
        return _phase2End;
      case _Phase.directionInversion:
        return _phase3End;
      case _Phase.ccwReconstruction:
        return _phase4End;
      case _Phase.ccwFragmentation:
        return _phase5End;
      case _Phase.ccwDeceleration:
        return _phase6End;
      case _Phase.loopReset:
        return _phase7End;
    }
  }

  double _phaseEnd(_Phase phase) {
    switch (phase) {
      case _Phase.cwStable:
        return _phase1End;
      case _Phase.cwFragmentation:
        return _phase2End;
      case _Phase.cwDeceleration:
        return _phase3End;
      case _Phase.directionInversion:
        return _phase4End;
      case _Phase.ccwReconstruction:
        return _phase5End;
      case _Phase.ccwFragmentation:
        return _phase6End;
      case _Phase.ccwDeceleration:
        return _phase7End;
      case _Phase.loopReset:
        return 1.0;
    }
  }

  _AnimationValues _computeValues(double controllerValue) {
    final phase = _currentPhase(controllerValue);
    final phaseStart = _phaseStart(phase);
    final phaseEnd = _phaseEnd(phase);
    final phaseDuration = phaseEnd - phaseStart;
    final phaseProgress = phaseDuration > 0
        ? (controllerValue - phaseStart) / phaseDuration
        : 0.0;

    final rotationAngle = _rotationAccumulator.update(controllerValue, phase);
    final morphIntensity = _calculateMorphIntensity(phase, phaseProgress);
    final rotationSpeed = _angularVelocityForPhase(phase);

    return _AnimationValues(
      rotationAngle: rotationAngle,
      morphIntensity: morphIntensity,
      phaseProgress: phaseProgress,
      phaseIndex: phase.index,
      rotationSpeed: rotationSpeed,
    );
  }

  double _calculateMorphIntensity(_Phase phase, double phaseProgress) {
    switch (phase) {
      case _Phase.cwStable:
      case _Phase.directionInversion:
        return 0.0;

      case _Phase.cwFragmentation:
      case _Phase.ccwFragmentation:
        // Much stronger morphing to create visible merge/split effect
        // Segments can expand 3-4x their base size
        return 2.5 * math.sin(phaseProgress * math.pi);

      case _Phase.cwDeceleration:
      case _Phase.ccwDeceleration:
        // Fade out morphing during deceleration
        return 0.5 * (1 - phaseProgress);

      case _Phase.ccwReconstruction:
        // Moderate morphing during reconstruction
        return 0.8 * math.sin(phaseProgress * math.pi * 0.5);

      case _Phase.loopReset:
        return 0.0;
    }
  }

  double _angularVelocityForPhase(_Phase phase) {
    switch (phase) {
      case _Phase.cwStable:
        return 4 * math.pi; // Fast clockwise
      case _Phase.cwFragmentation:
        return 3 * math.pi; // Slower clockwise with morph
      case _Phase.cwDeceleration:
        return 1 * math.pi; // Decelerating clockwise
      case _Phase.directionInversion:
        return 0.0; // Pause during direction change
      case _Phase.ccwReconstruction:
        return -2 * math.pi; // Counter-clockwise reconstruction
      case _Phase.ccwFragmentation:
        return -3 * math.pi; // Counter-clockwise with morph
      case _Phase.ccwDeceleration:
        return -1 * math.pi; // Decelerating counter-clockwise
      case _Phase.loopReset:
        return -0.5 * math.pi; // Final transition
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final values = _computeValues(_controller.value);
          return CustomPaint(
            painter: _SegmentedRingPainter(
              segments: _segments,
              values: values,
              color: widget.segmentColor,
              stroke: widget.stroke,
              enableGlow: widget.enableGlow,
              gapOffset: widget.size / 2 + widget.stroke + 4,
            ),
            child: ClipOval(
              child: SizedBox(
                width: widget.size,
                height: widget.size,
                child: widget.child,
              ),
            ),
          );
        },
      ),
    );
  }
}

enum _Phase {
  cwStable,
  cwFragmentation,
  cwDeceleration,
  directionInversion,
  ccwReconstruction,
  ccwFragmentation,
  ccwDeceleration,
  loopReset,
}

class _AnimationValues {
  final double rotationAngle;
  final double morphIntensity;
  final double phaseProgress;
  final int phaseIndex;
  final double rotationSpeed;

  _AnimationValues({
    required this.rotationAngle,
    required this.morphIntensity,
    required this.phaseProgress,
    required this.phaseIndex,
    required this.rotationSpeed,
  });
}

class _Segment {
  final double baseAngle;
  final double baseSweep;
  final double phaseOffset;
  final int index;

  _Segment({
    required this.baseAngle,
    required this.baseSweep,
    required this.phaseOffset,
    required this.index,
  });

  _SegmentRenderState compute(
    double rotation,
    double morphIntensity,
    double time,
  ) {
    // Primary morph: segments expand and contract significantly
    // This creates the merge effect when adjacent segments grow into gaps
    final morphFactor = math.sin(time * 1.8 + phaseOffset);

    // Each segment responds differently to morph based on its index
    // Even-indexed segments (large) expand more, odd-indexed (small) contract
    final indexModifier = index % 2 == 0 ? 1.0 : -0.5;

    // Calculate sweep with dramatic expansion capability
    final expansion = baseSweep * morphIntensity * morphFactor * indexModifier;
    final sweep = baseSweep + expansion;

    // Slight angular drift for organic feel
    final angleDrift = morphIntensity * 0.15 * math.cos(time * 0.8 + phaseOffset);
    final angle = baseAngle + rotation + angleDrift;

    // Allow segments to expand up to 4x base size for merging, shrink to 20% for splitting
    final minSweep = baseSweep * 0.2;
    final maxSweep = baseSweep * 4.0;

    return _SegmentRenderState(
      angle: angle,
      sweep: sweep.clamp(minSweep, maxSweep),
    );
  }
}

class _SegmentRenderState {
  final double angle;
  final double sweep;

  _SegmentRenderState({
    required this.angle,
    required this.sweep,
  });
}

class _RotationAccumulator {
  double totalAngle = 0.0;
  double previousValue = 0.0;

  double update(double controllerValue, _Phase phase) {
    final delta = controllerValue - previousValue;
    previousValue = controllerValue;

    // Handle loop reset (1.0 -> 0.0 transition)
    final effectiveDelta = delta < 0 ? delta + 1.0 : delta;

    // Apply angular velocity for current phase
    final velocity = _velocityForPhase(phase);
    totalAngle += effectiveDelta * velocity * 21; // Scale by total duration

    return totalAngle;
  }

  double _velocityForPhase(_Phase phase) {
    switch (phase) {
      case _Phase.cwStable:
        return 1.0;
      case _Phase.cwFragmentation:
        return 0.75;
      case _Phase.cwDeceleration:
        return 0.25;
      case _Phase.directionInversion:
        return 0.0;
      case _Phase.ccwReconstruction:
        return -0.5;
      case _Phase.ccwFragmentation:
        return -0.75;
      case _Phase.ccwDeceleration:
        return -0.25;
      case _Phase.loopReset:
        return -0.125;
    }
  }
}

class _SegmentedRingPainter extends CustomPainter {
  final List<_Segment> segments;
  final _AnimationValues values;
  final Color color;
  final double stroke;
  final bool enableGlow;
  final double gapOffset;

  _SegmentedRingPainter({
    required this.segments,
    required this.values,
    required this.color,
    required this.stroke,
    required this.enableGlow,
    required this.gapOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // Inner baseline circle (slightly inside the animated segments)
    final baselineRadius = (size.width / 2) + 4;
    // Outer animated segments radius
    final segmentsRadius = (size.width / 2) + 12;

    // Draw inner baseline circle first
    final baselinePaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
      center,
      baselineRadius,
      baselinePaint,
    );

    // Now draw the animated segments
    final paint = Paint()
      ..color = color
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (enableGlow) {
      paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    }

    // Calculate time for morphing (use rotation angle as time base)
    final time = values.rotationAngle * 0.5;

    for (final segment in segments) {
      final state = segment.compute(
        values.rotationAngle,
        values.morphIntensity,
        time,
      );

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: segmentsRadius),
        state.angle,
        state.sweep,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SegmentedRingPainter old) {
    return old.values.rotationAngle != values.rotationAngle ||
        old.values.morphIntensity != values.morphIntensity ||
        old.color != color ||
        old.stroke != stroke ||
        old.enableGlow != enableGlow;
  }
}
