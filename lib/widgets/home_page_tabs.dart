import 'package:flutter/material.dart';
import 'package:portfolio/utils/app_colors.dart';
import 'package:portfolio/widgets/sections/about_section.dart';
import 'package:portfolio/widgets/sections/contact_section.dart';
import 'package:portfolio/widgets/sections/experience_section.dart';
import 'package:portfolio/widgets/sections/hero_section.dart';
import 'package:portfolio/widgets/sections/philosophy_section.dart';
import 'package:portfolio/widgets/sections/projects_section.dart';
import 'package:portfolio/widgets/sections/skills_section.dart';

// Option B: Tab-Based Navigation
class TabHomePage extends StatefulWidget {
  const TabHomePage({super.key});

  @override
  State<TabHomePage> createState() => _TabHomePageState();
}

class _TabHomePageState extends State<TabHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'Alex Chen',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Home'),
            Tab(text: 'About'),
            Tab(text: 'Skills'),
            Tab(text: 'Projects'),
            Tab(text: 'Philosophy'),
            Tab(text: 'Experience'),
            Tab(text: 'Contact'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _TabWrapper(child: HeroSection()),
          _TabWrapper(child: AboutSection()),
          _TabWrapper(child: SkillsSection()),
          _TabWrapper(child: ProjectsSection()),
          _TabWrapper(child: PhilosophySection()),
          _TabWrapper(child: ExperienceSection()),
          _TabWrapper(child: ContactSection()),
        ],
      ),
    );
  }
}

class _TabWrapper extends StatelessWidget {
  final Widget child;

  const _TabWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: child,
    );
  }
}
