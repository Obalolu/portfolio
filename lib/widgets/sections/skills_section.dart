import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/constants/content.dart';
import 'package:portfolio/models/skill.dart';
import 'package:portfolio/utils/app_animations.dart';
import 'package:portfolio/utils/app_colors.dart';
import 'package:portfolio/utils/app_spacing.dart';
import 'package:portfolio/widgets/shared/animated_widgets.dart';
import 'package:portfolio/widgets/shared/section_title.dart';
import 'package:portfolio/widgets/shared/responsive_container.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sectionVerticalDesktop,
      ),
      child: ResponsiveContainer(
        maxWidth: AppSpacing.maxWidthContent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            number: '02',
            title: 'Skills & Expertise',
            subtitle: 'Technologies and tools I work with.',
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.lg,
            children: AppContent.skillCategories.asMap().entries.map((entry) {
              final index = entry.key;
              final category = entry.value;
              return SkillCategoryCard(
                category: category,
                index: index,
              );
            }).toList(),
          ),
        ],
      ),
      ),
    );
  }
}

class SkillCategoryCard extends StatefulWidget {
  final SkillCategory category;
  final int index;

  const SkillCategoryCard({
    super.key,
    required this.category,
    required this.index,
  });

  @override
  State<SkillCategoryCard> createState() => _SkillCategoryCardState();
}

class _SkillCategoryCardState extends State<SkillCategoryCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: AppAnimations.fast,
        transform: Matrix4.identity()..scaled(_isHovered ? 1.02 : 1.0, 1.0, 1.0),
        curve: AppAnimations.easeOut,
        child: FadeInAnimation(
          delay: AppAnimations.staggerDelay(widget.index * 2),
          child: Container(
            width: 340,
            padding: const EdgeInsets.all(AppSpacing.cardXL),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: _isHovered ? 0.3 : 0.1),
              ),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.category.name,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 20),
                ...widget.category.skills.map((skill) => SkillBarItem(skill: skill)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SkillBarItem extends StatelessWidget {
  final Skill skill;

  const SkillBarItem({
    super.key,
    required this.skill,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                skill.name,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${skill.level}%',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Animated progress bar
          AnimatedProgressBar(
            progress: skill.level / 100,
            color: AppColors.primary,
            height: 4,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}
