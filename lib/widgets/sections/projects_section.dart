import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/constants/content.dart';
import 'package:portfolio/models/project.dart';
import 'package:portfolio/utils/app_animations.dart';
import 'package:portfolio/utils/app_colors.dart';
import 'package:portfolio/utils/app_spacing.dart';
import 'package:portfolio/widgets/shared/section_title.dart';
import 'package:portfolio/widgets/shared/responsive_container.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

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
            number: '03',
            title: 'Featured Projects',
            subtitle: 'Some of the apps I\'ve built.',
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: AppSpacing.xl,
            runSpacing: AppSpacing.xl,
            children: AppContent.projects.asMap().entries.map((entry) {
              final index = entry.key;
              final project = entry.value;
              return ProjectCard(
                project: project,
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

class ProjectCard extends StatefulWidget {
  final Project project;
  final int index;

  const ProjectCard({
    super.key,
    required this.project,
    required this.index,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final accentColor = widget.project.accentColor ?? AppColors.primary;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: AppAnimations.fast,
        curve: AppAnimations.easeOut,
        transform: Matrix4.identity()..scaled(_isHovered ? 1.02 : 1.0, _isHovered ? 1.02 : 1.0, 1.0),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          border: Border.all(
            color: accentColor.withValues(alpha: _isHovered ? 0.5 : 0.3),
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.2),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: FadeInAnimation(
          delay: AppAnimations.staggerDelay(widget.index),
          child: Container(
            width: 420,
            padding: const EdgeInsets.all(AppSpacing.cardXL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Icon with hover pulse effect
                _buildAppIcon(accentColor),
                const SizedBox(height: 20),
                // Project Name
                Text(
                  widget.project.name,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                // Description
                Text(
                  widget.project.description,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 20),
                // Problem
                _buildInfoRow('Problem', widget.project.problem),
                const SizedBox(height: 8),
                // Solution
                _buildInfoRow('Solution', widget.project.solution),
                const SizedBox(height: 20),
                // Tech Stack
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.project.technologies.map((tech) {
                    return MouseRegion(
                      child: AnimatedContainer(
                        duration: AppAnimations.fast,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: _isHovered ? 0.25 : 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tech,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: accentColor,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                // Impact
                Container(
                  padding: const EdgeInsets.all(AppSpacing.cardSmall),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.trending_up,
                        color: AppColors.success,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.project.impact,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // CTA Button with fill hover effect
                _buildCTAButton(accentColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppIcon(Color accentColor) {
    return AnimatedContainer(
      duration: AppAnimations.medium,
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accentColor,
            accentColor.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        boxShadow: _isHovered
            ? [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          widget.project.name[0],
          style: GoogleFonts.jetBrainsMono(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildCTAButton(Color accentColor) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: AppAnimations.fast,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: _isHovered ? accentColor : Colors.transparent,
          border: Border.all(
            color: accentColor,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        ),
        child: Center(
          child: Text(
            'View Case Study',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _isHovered ? AppColors.textPrimary : accentColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(
            '$label:',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textTertiary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
