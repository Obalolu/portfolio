import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/constants/content.dart';
import 'package:portfolio/utils/app_animations.dart';
import 'package:portfolio/utils/app_colors.dart';
import 'package:portfolio/utils/app_spacing.dart';
import 'package:portfolio/widgets/shared/animated_widgets.dart';
import 'package:portfolio/widgets/shared/segmented_neon_avatar.dart';
import 'package:portfolio/widgets/shared/grid_background.dart';
import 'package:portfolio/widgets/shared/responsive_container.dart';
import 'package:portfolio/widgets/shared/shimmer_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: ResponsiveContainer(
        maxWidth: AppSpacing.maxWidthContent,
        child: GridBackground(
        child: Column(
          children: [
            const SizedBox(height: 48),
            // Profile and greeting
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting - fades in first
                      FadeInAnimation(
                        delay: const Duration(milliseconds: 100),
                        child: Text(
                          'Hello, I\'m',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 84,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Name - slides up with fade
                      FadeInAnimation(
                        delay: const Duration(milliseconds: 200),
                        slideOffset: const Offset(0, 20),
                        child: ShimmerText(
                          text: AppContent.name,
                          textStyle: GoogleFonts.jetBrainsMono(
                            fontSize: 108,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            height: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Tagline - fades in
                      FadeInAnimation(
                        delay: const Duration(milliseconds: 350),
                        child: Text(
                          AppContent.tagline,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 18,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeInAnimation(
                        delay: const Duration(milliseconds: 400),
                        child: Text(
                          AppContent.subtext,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 13,
                            color: AppColors.textTertiary,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // View CV Button + Social Icons - staggered pop in
                      Row(
                        children: [
                          ScaleInAnimation(
                            delay: const Duration(milliseconds: 650),
                            beginScale: 0.8,
                            child: _buildSecondaryButton('View CV'),
                          ),
                          const SizedBox(width: 20),
                          ScaleInAnimation(
                            delay: const Duration(milliseconds: 700),
                            beginScale: 0.5,
                            child: _buildSocialIcon(FontAwesomeIcons.github, AppContent.github, 'GitHub'),
                          ),
                          const SizedBox(width: 16),
                          ScaleInAnimation(
                            delay: const Duration(milliseconds: 750),
                            beginScale: 0.5,
                            child: _buildSocialIcon(FontAwesomeIcons.linkedin, AppContent.linkedin, 'LinkedIn'),
                          ),
                          const SizedBox(width: 16),
                          ScaleInAnimation(
                            delay: const Duration(milliseconds: 800),
                            beginScale: 0.5,
                            child: _buildSocialIcon(FontAwesomeIcons.xTwitter, AppContent.twitter, 'Twitter'),
                          ),
                          const SizedBox(width: 16),
                          ScaleInAnimation(
                            delay: const Duration(milliseconds: 850),
                            beginScale: 0.5,
                            child: _buildSocialIcon(FontAwesomeIcons.envelope, 'mailto:${AppContent.email}', 'Email'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 64),
                // Profile Picture - with segmented neon border animation
                SegmentedNeonAvatarBorder(
                  size: 500,
                  segmentCount: 12,
                  stroke: 4,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/avatar.png',
                        width: 500,
                        height: 500,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 64),
            // Stats Row - with count up animation
            Row(
              children: [
                Expanded(child: AnimatedStatCard(value: AppContent.yearsExp, label: 'Years Experience')),
                const SizedBox(width: 20),
                Expanded(child: AnimatedStatCard(value: AppContent.appsBuilt, label: 'Apps Built')),
                const SizedBox(width: 20),
                Expanded(child: AnimatedStatCard(value: AppContent.downloads, label: 'Downloads')),
                const SizedBox(width: 20),
                Expanded(child: AnimatedStatCard(value: AppContent.uptime, label: 'Uptime')),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildSecondaryButton(String text) {
    return _AnimatedSecondaryButton(text: text);
  }

  Widget _buildSocialIcon(IconData icon, String url, String tooltip) {
    return AnimatedSocialIcon(
      icon: icon,
      onTap: () => _launchUrl(url),
      tooltip: tooltip,
    );
  }

  void _launchUrl(String url) {
    debugPrint('Launch: $url');
  }
}

/// Animated secondary button with hover fill effect
class _AnimatedSecondaryButton extends StatefulWidget {
  final String text;

  const _AnimatedSecondaryButton({required this.text});

  @override
  State<_AnimatedSecondaryButton> createState() => _AnimatedSecondaryButtonState();
}

class _AnimatedSecondaryButtonState extends State<_AnimatedSecondaryButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: AppAnimations.fast,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          color: _isHovered ? AppColors.primary : Colors.transparent,
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          widget.text,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: _isHovered ? AppColors.background : AppColors.primary,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

/// Animated stat card with hover effect and count-up animation
class AnimatedStatCard extends StatefulWidget {
  final String value;
  final String label;

  const AnimatedStatCard({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  State<AnimatedStatCard> createState() => _AnimatedStatCardState();
}

class _AnimatedStatCardState extends State<AnimatedStatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: AppAnimations.fast,
        curve: AppAnimations.easeOut,
        transform: Matrix4.identity()..scaled(_isHovered ? 1.05 : 1.0, 1.0, 1.0),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: _isHovered ? 0.4 : 0.2),
            width: 1,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        padding: const EdgeInsets.all(AppSpacing.cardSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Count-up animation for the value (extract number)
            CountUpAnimation(
              end: int.parse(widget.value.replaceAll(RegExp(r'[^\d]'), '')),
              suffix: widget.value.contains('+') ? '+' : widget.value.contains('M') ? 'M+' : '',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.label,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
