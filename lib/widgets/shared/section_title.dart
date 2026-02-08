import 'package:flutter/material.dart';
import 'package:portfolio/utils/app_colors.dart';
import 'package:portfolio/utils/app_spacing.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionTitle extends StatelessWidget {
  final String number;
  final String title;
  final String? subtitle;

  const SectionTitle({
    super.key,
    required this.number,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = AppSpacing.getHorizontalPadding(constraints.maxWidth);

        return Padding(
          padding: EdgeInsets.only(left: horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    number,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary.withValues(alpha: 0.3),
                      height: 1,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.5),
                            AppColors.primary.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 12),
                Text(
                  subtitle!,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
