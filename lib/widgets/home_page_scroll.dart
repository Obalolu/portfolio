import 'package:flutter/material.dart';
import 'package:portfolio/utils/app_colors.dart';
import 'package:portfolio/widgets/sections/about_section.dart';
import 'package:portfolio/widgets/sections/contact_section.dart';
import 'package:portfolio/widgets/sections/experience_section.dart';
import 'package:portfolio/widgets/sections/hero_section.dart';
import 'package:portfolio/widgets/sections/philosophy_section.dart';
import 'package:portfolio/widgets/sections/projects_section.dart';
import 'package:portfolio/widgets/sections/skills_section.dart';
import 'package:portfolio/widgets/shared/responsive_container.dart';

// Option A: Single Page with Smooth Scrolling
class ScrollHomePage extends StatelessWidget {
  const ScrollHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          // App Bar (appears on scroll) with constrained width
          SliverPersistentHeader(
            pinned: true,
            floating: true,
            delegate: _NavDelegate(
              scrollToSection: (index) => _scrollToSection(index, scrollController),
            ),
          ),
          // Content Sections
          const SliverToBoxAdapter(child: HeroSection()),
          SliverToBoxAdapter(child: AboutSection()),
          SliverToBoxAdapter(child: SkillsSection()),
          SliverToBoxAdapter(child: ProjectsSection()),
          SliverToBoxAdapter(child: PhilosophySection()),
          SliverToBoxAdapter(child: ExperienceSection()),
          SliverToBoxAdapter(child: ContactSection()),
          // Footer
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.center,
              child: Text(
                '© 2026 Alex Chen. Built with Flutter.',
                style: TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _scrollToSection(int index, ScrollController controller) {
    // Simple scroll - in production, you'd calculate actual section positions
    controller.animateTo(
      index * 500.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}

class _NavDelegate extends SliverPersistentHeaderDelegate {
  final Function(int) scrollToSection;

  _NavDelegate({required this.scrollToSection});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.background,
      child: ResponsiveContainer(
        maxWidth: 1200,
        child: Row(
          children: [
            const Text(
              'Alex Chen',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            _AnimatedNavButton(
              label: 'About',
              onTap: () => scrollToSection(0),
            ),
            _AnimatedNavButton(
              label: 'Skills',
              onTap: () => scrollToSection(1),
            ),
            _AnimatedNavButton(
              label: 'Projects',
              onTap: () => scrollToSection(2),
            ),
            _AnimatedNavButton(
              label: 'Contact',
              onTap: () => scrollToSection(5),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 56;

  @override
  double get minExtent => 56;

  @override
  bool shouldRebuild(covariant _NavDelegate oldDelegate) => false;
}

class _AnimatedNavButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _AnimatedNavButton({
    required this.label,
    required this.onTap,
  });

  @override
  State<_AnimatedNavButton> createState() => _AnimatedNavButtonState();
}

class _AnimatedNavButtonState extends State<_AnimatedNavButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        height: 40,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: widget.onTap,
              child: Text(
                widget.label,
                style: TextStyle(
                  color: _isHovered ? AppColors.primary : AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: _isHovered ? 24 : 0,
              height: 2,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
