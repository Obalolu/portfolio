import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/models/skill.dart';
import 'package:portfolio/utils/app_animations.dart';
import 'package:portfolio/utils/app_colors.dart';
import 'package:portfolio/widgets/shared/proficiency_dots.dart';
import 'package:portfolio/widgets/shared/universal_interactive.dart';
import 'package:portfolio/widgets/shared/viewport_animations.dart';

/// Horizontal pill-shaped skill card with icon, name, and proficiency dots
class SkillPill extends StatefulWidget {
  final Skill skill;
  final Duration delay;

  const SkillPill({super.key, required this.skill, this.delay = Duration.zero});

  @override
  State<SkillPill> createState() => _SkillPillState();
}

class _SkillPillState extends State<SkillPill> {
  @override
  Widget build(BuildContext context) {
    return ViewportFadeIn(
      delay: widget.delay,
      child: UniversalInteractive(
        builder: (context, state) {
          final isActive = state.isHovered || state.isPressed;
          return AnimatedContainer(
            duration: AppAnimations.fast,
            curve: AppAnimations.easeOut,
            transform: Matrix4.identity()..scale(isActive ? 1.05 : 1.0),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: AppColors.primary.withValues(
                  alpha: isActive ? 0.4 : 0.15,
                ),
              ),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.skill.icon, color: AppColors.primary, size: 16),
                const SizedBox(width: 10),
                Text(
                  widget.skill.name,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 12),
                ProficiencyDots(level: widget.skill.proficiency),
              ],
            ),
          );
        },
      ),
    );
  }
}
