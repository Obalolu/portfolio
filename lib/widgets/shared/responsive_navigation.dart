import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/utils/app_animations.dart';
import 'package:portfolio/utils/app_colors.dart';
import 'package:portfolio/utils/app_spacing.dart';
import 'package:portfolio/widgets/shared/universal_interactive.dart';

/// Navigation item data structure
class NavigationItem {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final int index;

  const NavigationItem({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.index,
  });
}

/// A context-aware navigation component that adapts to different screen sizes:
/// - Mobile (< 640px): Bottom navigation bar
/// - Tablet (640-1024px): Hamburger menu drawer
/// - Desktop (> 1024px): Horizontal navigation bar (not included, use existing)
class ResponsiveNavigation extends StatefulWidget {
  final List<NavigationItem> items;
  final int currentIndex;
  final VoidCallback? onLogoTap;
  final String logoText;
  final bool showLogo;

  const ResponsiveNavigation({
    super.key,
    required this.items,
    this.currentIndex = 0,
    this.onLogoTap,
    required this.logoText,
    this.showLogo = true,
  });

  @override
  State<ResponsiveNavigation> createState() => _ResponsiveNavigationState();
}

class _ResponsiveNavigationState extends State<ResponsiveNavigation> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;

        if (screenWidth < AppSpacing.breakpointMobile) {
          // Mobile: Return just the bottom nav (header is handled separately)
          return _buildMobileBottomNav();
        } else if (screenWidth < AppSpacing.breakpointTablet) {
          // Tablet: Return drawer trigger button
          return _buildTabletDrawerTrigger();
        } else {
          // Desktop: Return empty (desktop nav is inline)
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildMobileBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: widget.items.map((item) {
              final isSelected = widget.currentIndex == item.index;
              return Expanded(
                child: UniversalInteractive(
                  onTap: item.onTap,
                  builder: (context, state) {
                    final isActive = state.isPressed || isSelected;
                    return AnimatedContainer(
                      duration: AppAnimations.fast,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Icon(
                          item.icon,
                          color: isActive
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          size: 24,
                        ),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTabletDrawerTrigger() {
    return UniversalInteractive(
      onTap: () {
        _scaffoldKey.currentState?.openDrawer();
      },
      builder: (context, state) {
        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: state.isHovered
                ? AppColors.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.menu,
            color: state.isHovered
                ? AppColors.primary
                : AppColors.textSecondary,
          ),
        );
      },
    );
  }
}

/// A navigation drawer widget for tablet view
class NavigationDrawerWidget extends StatelessWidget {
  final List<NavigationItem> items;
  final int currentIndex;
  final VoidCallback? onLogoTap;
  final String logoText;

  const NavigationDrawerWidget({
    super.key,
    required this.items,
    this.currentIndex = 0,
    this.onLogoTap,
    required this.logoText,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: UniversalInteractive(
                onTap: onLogoTap,
                builder: (context, state) {
                  return Text(
                    logoText,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: state.isHovered
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  );
                },
              ),
            ),
            Divider(color: AppColors.primary.withValues(alpha: 0.2), height: 1),
            // Navigation items
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = currentIndex == item.index;

                  return UniversalInteractive(
                    onTap: () {
                      item.onTap();
                      Navigator.of(context).pop();
                    },
                    builder: (context, state) {
                      final isActive = state.isHovered || isSelected;
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : (state.isHovered
                                    ? AppColors.primary.withValues(alpha: 0.05)
                                    : Colors.transparent),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary.withValues(alpha: 0.3)
                                : Colors.transparent,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              item.icon,
                              color: isActive
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              size: 20,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              item.label,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 15,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isActive
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A wrapper widget that provides the appropriate navigation scaffold
/// based on screen size
class ResponsiveNavigationScaffold extends StatefulWidget {
  final Widget body;
  final List<NavigationItem> navigationItems;
  final int currentIndex;
  final VoidCallback? onLogoTap;
  final String logoText;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;

  const ResponsiveNavigationScaffold({
    super.key,
    required this.body,
    required this.navigationItems,
    this.currentIndex = 0,
    this.onLogoTap,
    required this.logoText,
    this.appBar,
    this.floatingActionButton,
  });

  @override
  State<ResponsiveNavigationScaffold> createState() =>
      _ResponsiveNavigationScaffoldState();
}

class _ResponsiveNavigationScaffoldState
    extends State<ResponsiveNavigationScaffold> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < AppSpacing.breakpointMobile;
        final isTablet =
            constraints.maxWidth >= AppSpacing.breakpointMobile &&
            constraints.maxWidth < AppSpacing.breakpointTablet;

        // Build drawer for tablet
        Widget? drawer;
        if (isTablet) {
          drawer = NavigationDrawerWidget(
            items: widget.navigationItems,
            currentIndex: widget.currentIndex,
            onLogoTap: widget.onLogoTap,
            logoText: widget.logoText,
          );
        }

        // Build bottom nav for mobile
        Widget? bottomNav;
        if (isMobile) {
          bottomNav = ResponsiveNavigation(
            items: widget.navigationItems,
            currentIndex: widget.currentIndex,
            onLogoTap: widget.onLogoTap,
            logoText: widget.logoText,
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: widget.appBar,
          drawer: drawer,
          body: widget.body,
          bottomNavigationBar: bottomNav,
          floatingActionButton: widget.floatingActionButton,
        );
      },
    );
  }
}
