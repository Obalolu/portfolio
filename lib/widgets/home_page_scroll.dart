import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:portfolio/constants/content.dart';
import 'package:portfolio/utils/app_colors.dart';
import 'package:portfolio/utils/app_spacing.dart';
import 'package:portfolio/widgets/sections/about_section.dart';
import 'package:portfolio/widgets/sections/contact_section.dart';
import 'package:portfolio/widgets/sections/experience_section.dart';
import 'package:portfolio/widgets/sections/hero_section.dart';
import 'package:portfolio/widgets/sections/philosophy_section.dart';
import 'package:portfolio/widgets/sections/projects_section.dart';
import 'package:portfolio/widgets/sections/skills_section.dart';
import 'package:portfolio/widgets/shared/responsive_container.dart';
import 'package:portfolio/widgets/shared/responsive_navigation.dart';
import 'package:portfolio/widgets/shared/universal_interactive.dart';

// Option A: Single Page with Smooth Scrolling
class ScrollHomePage extends StatefulWidget {
  const ScrollHomePage({super.key});

  @override
  State<ScrollHomePage> createState() => _ScrollHomePageState();
}

class _ScrollHomePageState extends State<ScrollHomePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _philosophyKey = GlobalKey();
  final GlobalKey _experienceKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    // Scroll back to top when user pulls to refresh
    _scrollToHero();
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _scrollToHero() {
    setState(() {
      _currentNavIndex = -1; // Reset selection when going to hero
    });
    final context = _heroKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );
    }
  }

  void _scrollToSection(int index) {
    final keys = [
      _aboutKey,
      _skillsKey,
      _projectsKey,
      _philosophyKey,
      _experienceKey,
      _contactKey,
    ];

    if (index >= 0 && index < keys.length) {
      final context = keys[index].currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: 0.0,
        );
      }
    }
  }

  int _currentNavIndex = -1; // -1 means no section selected (e.g., on hero)

  final List<GlobalKey> _sectionKeys = [];

  @override
  void initState() {
    super.initState();
    _sectionKeys.addAll([
      _aboutKey,
      _skillsKey,
      _projectsKey,
      _philosophyKey,
      _experienceKey,
      _contactKey,
    ]);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrollOffset = _scrollController.offset;
    final screenHeight = MediaQuery.of(context).size.height;

    // Find which section is currently most visible
    int newIndex = -1;
    double maxVisibility = 0;

    for (int i = 0; i < _sectionKeys.length; i++) {
      final context = _sectionKeys[i].currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          final position = box.localToGlobal(Offset.zero);
          final sectionTop = position.dy;
          final sectionBottom = sectionTop + box.size.height;

          // Calculate how much of the section is visible
          final visibleTop = sectionTop.clamp(0.0, screenHeight);
          final visibleBottom = sectionBottom.clamp(0.0, screenHeight);
          final visibility = (visibleBottom - visibleTop).abs();

          if (visibility > maxVisibility) {
            maxVisibility = visibility;
            newIndex = i;
          }
        }
      }
    }

    if (newIndex != _currentNavIndex) {
      setState(() {
        _currentNavIndex = newIndex;
      });
    }
  }

  void _scrollToSectionWithIndex(int index) {
    setState(() {
      _currentNavIndex = index;
    });
    _scrollToSection(index);
  }

  List<NavigationItem> get _navigationItems => [
    NavigationItem(
      label: 'About',
      icon: Icons.person_outline,
      onTap: () => _scrollToSectionWithIndex(0),
      index: 0,
    ),
    NavigationItem(
      label: 'Skills',
      icon: Icons.code_outlined,
      onTap: () => _scrollToSectionWithIndex(1),
      index: 1,
    ),
    NavigationItem(
      label: 'Projects',
      icon: Icons.folder_outlined,
      onTap: () => _scrollToSectionWithIndex(2),
      index: 2,
    ),
    NavigationItem(
      label: 'Philosophy',
      icon: Icons.lightbulb_outline,
      onTap: () => _scrollToSectionWithIndex(3),
      index: 3,
    ),
    NavigationItem(
      label: 'Experience',
      icon: Icons.work_outline,
      onTap: () => _scrollToSectionWithIndex(4),
      index: 4,
    ),
    NavigationItem(
      label: 'Contact',
      icon: Icons.mail_outline,
      onTap: () => _scrollToSectionWithIndex(5),
      index: 5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = AppSpacing.isMobile(constraints.maxWidth);
        final isTablet = AppSpacing.isTablet(constraints.maxWidth);

        return Scaffold(
          backgroundColor: AppColors.background,
          drawer: isTablet
              ? NavigationDrawerWidget(
                  items: _navigationItems,
                  currentIndex: _currentNavIndex,
                  onLogoTap: _scrollToHero,
                  logoText: AppContent.name.split('\n')[0],
                )
              : null,
          body: RefreshIndicator(
            onRefresh: _onRefresh,
            color: AppColors.primary,
            backgroundColor: AppColors.surface,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // App Bar (appears on scroll) with constrained width
                SliverPersistentHeader(
                  pinned: true,
                  floating: true,
                  delegate: _NavDelegate(
                    scrollToHero: _scrollToHero,
                    scrollToSection: _scrollToSection,
                    navigationItems: isTablet ? _navigationItems : null,
                  ),
                ),
                // Content Sections
                SliverToBoxAdapter(key: _heroKey, child: const HeroSection()),
                SliverToBoxAdapter(key: _aboutKey, child: AboutSection()),
                SliverToBoxAdapter(key: _skillsKey, child: SkillsSection()),
                SliverToBoxAdapter(key: _projectsKey, child: ProjectsSection()),
                SliverToBoxAdapter(
                  key: _philosophyKey,
                  child: PhilosophySection(),
                ),
                SliverToBoxAdapter(
                  key: _experienceKey,
                  child: ExperienceSection(),
                ),
                SliverToBoxAdapter(key: _contactKey, child: ContactSection()),
                // Footer
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.center,
                    child: Text(
                      '© 2026 ${AppContent.name.split('\n')[0]}. Built with Flutter.',
                      style: TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: isMobile
              ? ResponsiveNavigation(
                  items: _navigationItems,
                  currentIndex: _currentNavIndex,
                  onLogoTap: _scrollToHero,
                  logoText: AppContent.name.split('\n')[0],
                )
              : null,
        );
      },
    );
  }
}

class _NavDelegate extends SliverPersistentHeaderDelegate {
  final VoidCallback scrollToHero;
  final Function(int) scrollToSection;
  final List<NavigationItem>? navigationItems;

  _NavDelegate({
    required this.scrollToHero,
    required this.scrollToSection,
    this.navigationItems,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = AppSpacing.isMobile(constraints.maxWidth);
        final isTablet = AppSpacing.isTablet(constraints.maxWidth);

        return Container(
          color: AppColors.background,
          child: ResponsiveContainer(
            maxWidth: 1200,
            child: isMobile
                ? _buildMobileHeader(scrollToHero)
                : (isTablet
                      ? _buildTabletHeader(context, scrollToHero)
                      : _buildDesktopHeader(scrollToHero, scrollToSection)),
          ),
        );
      },
    );
  }

  Widget _buildMobileHeader(VoidCallback scrollToHero) {
    return Container(
      height: 48,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: scrollToHero,
        child: Text(
          AppContent.name.split('\n')[0],
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildTabletHeader(BuildContext context, VoidCallback scrollToHero) {
    return Row(
      children: [
        // Menu button for drawer
        if (navigationItems != null)
          UniversalInteractive(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            builder: (context, state) {
              return Container(
                width: 44,
                height: 44,
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
          ),
        if (navigationItems != null) const SizedBox(width: 16),
        // Logo
        UniversalInteractive(
          onTap: scrollToHero,
          builder: (context, state) {
            return Text(
              AppContent.name.split('\n')[0],
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 22,
                color: state.isHovered
                    ? AppColors.primary
                    : AppColors.textPrimary,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDesktopHeader(
    VoidCallback scrollToHero,
    Function(int) scrollToSection,
  ) {
    return Row(
      children: [
        UniversalInteractive(
          onTap: scrollToHero,
          builder: (context, state) {
            return Text(
              AppContent.name.split('\n')[0],
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: state.isHovered
                    ? AppColors.primary
                    : AppColors.textPrimary,
              ),
            );
          },
        ),
        const Spacer(),
        Builder(
          builder: (context) {
            final state = context
                .findAncestorStateOfType<_ScrollHomePageState>();
            void navigateToSection(int index) {
              if (state != null) {
                state._scrollToSectionWithIndex(index);
              } else {
                scrollToSection(index);
              }
            }

            return Row(
              children: [
                _AnimatedNavButton(
                  label: 'About',
                  onTap: () => navigateToSection(0),
                  index: 0,
                  currentIndex: state?._currentNavIndex ?? -1,
                ),
                _AnimatedNavButton(
                  label: 'Skills',
                  onTap: () => navigateToSection(1),
                  index: 1,
                  currentIndex: state?._currentNavIndex ?? -1,
                ),
                _AnimatedNavButton(
                  label: 'Projects',
                  onTap: () => navigateToSection(2),
                  index: 2,
                  currentIndex: state?._currentNavIndex ?? -1,
                ),
                _AnimatedNavButton(
                  label: 'Philosophy',
                  onTap: () => navigateToSection(3),
                  index: 3,
                  currentIndex: state?._currentNavIndex ?? -1,
                ),
                _AnimatedNavButton(
                  label: 'Experience',
                  onTap: () => navigateToSection(4),
                  index: 4,
                  currentIndex: state?._currentNavIndex ?? -1,
                ),
                _AnimatedNavButton(
                  label: 'Contact',
                  onTap: () => navigateToSection(5),
                  index: 5,
                  currentIndex: state?._currentNavIndex ?? -1,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  @override
  double get maxExtent => 56;

  @override
  double get minExtent => 56;

  @override
  bool shouldRebuild(covariant _NavDelegate oldDelegate) => false;
}

class _AnimatedNavButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final int index;
  final int currentIndex;

  const _AnimatedNavButton({
    required this.label,
    required this.onTap,
    required this.index,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentIndex == index;
    return UniversalInteractive(
      onTap: onTap,
      builder: (context, state) {
        final isActive = state.isHovered || state.isPressed || isSelected;
        return Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isSelected ? 24 : 0,
                height: 2,
                color: AppColors.primary,
              ),
            ],
          ),
        );
      },
    );
  }
}
