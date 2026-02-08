import 'package:flutter/material.dart';
import 'package:portfolio/utils/app_spacing.dart';

/// A responsive container that provides:
/// - Dynamic horizontal padding based on screen width
/// - Optional max-width constraint for content
/// - Centered content on wide screens
///
/// Breakpoint strategy:
/// - < 640px (Mobile): 20px padding, no max width
/// - 640-1024px (Tablet): 32px padding, no max width
/// - 1024-1440px (Desktop): 48px padding, 1200px max width
/// - 1440-1920px (Large): 64px padding, 1200px max width
/// - > 1920px (Wide): 96px padding, 1200px max width
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final bool centerContent;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.centerContent = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final horizontalPadding = AppSpacing.getHorizontalPadding(screenWidth);

        if (maxWidth != null) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth!),
                child: child,
              ),
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: child,
        );
      },
    );
  }
}

/// A convenience widget that combines vertical padding with responsive horizontal layout
class ResponsiveSection extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final double verticalPadding;
  final Color? backgroundColor;

  const ResponsiveSection({
    super.key,
    required this.child,
    this.maxWidth,
    this.verticalPadding = AppSpacing.sectionVerticalDesktop,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: ResponsiveContainer(
        maxWidth: maxWidth,
        child: child,
      ),
    );
  }
}
