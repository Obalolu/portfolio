import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/constants/content.dart';
import 'package:portfolio/utils/app_colors.dart';
import 'package:portfolio/utils/app_spacing.dart';
import 'package:portfolio/widgets/shared/section_title.dart';
import 'package:portfolio/widgets/shared/responsive_container.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

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
              number: '01',
              title: 'About Me',
              subtitle: 'A bit about who I am and what I do.',
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(AppSpacing.cardXXL),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
              ),
              child: Text(
                AppContent.about,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 17,
                  color: AppColors.textSecondary,
                  height: 1.9,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
