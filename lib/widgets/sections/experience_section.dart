import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/constants/content.dart';
import 'package:portfolio/models/experience.dart';
import 'package:portfolio/utils/app_colors.dart';
import 'package:portfolio/utils/app_spacing.dart';
import 'package:portfolio/widgets/shared/section_title.dart';
import 'package:portfolio/widgets/shared/responsive_container.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

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
            number: '05',
            title: 'Experience',
            subtitle: 'My professional journey so far.',
          ),
          const SizedBox(height: 40),
          ...AppContent.experience.asMap().entries.map((entry) {
            final index = entry.key;
            final exp = entry.value;
            return ExperienceItem(
              experience: exp,
              isLast: index == AppContent.experience.length - 1,
            );
          }),
        ],
      ),
      ),
    );
  }
}

class ExperienceItem extends StatelessWidget {
  final Experience experience;
  final bool isLast;

  const ExperienceItem({
    super.key,
    required this.experience,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline
          Column(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                  border: Border.all(
                    color: AppColors.background,
                    width: 3,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primary.withValues(alpha: 0.5),
                          AppColors.primary.withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 24),
          // Content
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 32),
              padding: const EdgeInsets.all(AppSpacing.cardXL),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          experience.company,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        experience.duration,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    experience.role,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (experience.location != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      experience.location!,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  ...experience.achievements.map((achievement) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 6, right: 12),
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              achievement,
                              style: GoogleFonts.jetBrainsMono(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                height: 1.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
