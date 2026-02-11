import 'dart:io' show Directory, File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/constants/content.dart';
import 'package:portfolio/utils/app_animations.dart';
import 'package:portfolio/utils/app_colors.dart';
import 'package:portfolio/utils/app_spacing.dart';
import 'package:portfolio/utils/app_typography.dart';
import 'package:portfolio/widgets/shared/animated_widgets.dart';
import 'package:portfolio/widgets/shared/segmented_neon_avatar.dart';
import 'package:portfolio/widgets/shared/grid_background.dart';
import 'package:portfolio/widgets/shared/responsive_container.dart';
import 'package:portfolio/widgets/shared/shimmer_text.dart';
import 'package:portfolio/widgets/shared/universal_interactive.dart';
import 'package:portfolio/widgets/shared/viewport_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = AppSpacing.isMobile(constraints.maxWidth);
            final screenWidth = constraints.maxWidth;

            return GridBackground(
              child: Column(
                children: [
                  SizedBox(height: isMobile ? 32 : 48),
                  // Profile and greeting
                  isMobile
                      ? _buildMobileLayout(screenWidth)
                      : _buildDesktopLayout(),
                  SizedBox(height: isMobile ? 40 : 64),
                  // Stats - responsive layout
                  _buildStatsSection(isMobile),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
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
                    fontSize: AppTypography.heroDesktop,
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
                    fontSize: AppTypography.nameDesktop,
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
                    child: _buildSecondaryButton('View CV', AppContent.cvUrl),
                  ),
                  const SizedBox(width: 20),
                  ScaleInAnimation(
                    delay: const Duration(milliseconds: 700),
                    beginScale: 0.5,
                    child: _buildSocialIcon(
                      FontAwesomeIcons.github,
                      AppContent.github,
                      'GitHub',
                    ),
                  ),
                  const SizedBox(width: 16),
                  ScaleInAnimation(
                    delay: const Duration(milliseconds: 750),
                    beginScale: 0.5,
                    child: _buildSocialIcon(
                      FontAwesomeIcons.linkedin,
                      AppContent.linkedin,
                      'LinkedIn',
                    ),
                  ),
                  const SizedBox(width: 16),
                  ScaleInAnimation(
                    delay: const Duration(milliseconds: 800),
                    beginScale: 0.5,
                    child: _buildSocialIcon(
                      FontAwesomeIcons.xTwitter,
                      AppContent.twitter,
                      'Twitter',
                    ),
                  ),
                  const SizedBox(width: 16),
                  ScaleInAnimation(
                    delay: const Duration(milliseconds: 850),
                    beginScale: 0.5,
                    child: _buildSocialIcon(
                      FontAwesomeIcons.envelope,
                      'mailto:${AppContent.email}',
                      'Email',
                    ),
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
            decoration: const BoxDecoration(shape: BoxShape.circle),
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
    );
  }

  Widget _buildMobileLayout(double screenWidth) {
    return Column(
      children: [
        // Text content first on mobile
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting - fades in first
            FadeInAnimation(
              delay: const Duration(milliseconds: 100),
              child: Text(
                'Hello, I\'m',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: AppTypography.heroMobile,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Name - slides up with fade
            FadeInAnimation(
              delay: const Duration(milliseconds: 200),
              slideOffset: const Offset(0, 20),
              child: ShimmerText(
                text: AppContent.name,
                textStyle: GoogleFonts.jetBrainsMono(
                  fontSize: AppTypography.nameMobile,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  height: 1.1,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Tagline - fades in
            FadeInAnimation(
              delay: const Duration(milliseconds: 350),
              child: Text(
                AppContent.tagline,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 8),
            FadeInAnimation(
              delay: const Duration(milliseconds: 400),
              child: Text(
                AppContent.subtext,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12,
                  color: AppColors.textTertiary,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // View CV Button + Social Icons - wrapped for mobile
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ScaleInAnimation(
                  delay: const Duration(milliseconds: 650),
                  beginScale: 0.8,
                  child: _buildSecondaryButton('View CV', AppContent.cvUrl),
                ),
                ScaleInAnimation(
                  delay: const Duration(milliseconds: 700),
                  beginScale: 0.5,
                  child: _buildSocialIcon(
                    FontAwesomeIcons.github,
                    AppContent.github,
                    'GitHub',
                  ),
                ),
                ScaleInAnimation(
                  delay: const Duration(milliseconds: 750),
                  beginScale: 0.5,
                  child: _buildSocialIcon(
                    FontAwesomeIcons.linkedin,
                    AppContent.linkedin,
                    'LinkedIn',
                  ),
                ),
                ScaleInAnimation(
                  delay: const Duration(milliseconds: 800),
                  beginScale: 0.5,
                  child: _buildSocialIcon(
                    FontAwesomeIcons.xTwitter,
                    AppContent.twitter,
                    'Twitter',
                  ),
                ),
                ScaleInAnimation(
                  delay: const Duration(milliseconds: 850),
                  beginScale: 0.5,
                  child: _buildSocialIcon(
                    FontAwesomeIcons.envelope,
                    'mailto:${AppContent.email}',
                    'Email',
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 32),
        // Profile Picture - smaller on mobile, below text
        Center(
          child: SegmentedNeonAvatarBorder(
            size: 220,
            segmentCount: 12,
            stroke: 3,
            child: Container(
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/avatar.png',
                  width: 220,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(bool isMobile) {
    return FadeInAnimation(
      delay: const Duration(milliseconds: 900),
      child: isMobile
          ? Wrap(
              alignment: WrapAlignment.center,
              spacing: 24,
              runSpacing: 24,
              children: [
                _buildMinimalStat(AppContent.age, 'Age', isMobile),
                _buildMinimalStat(
                  AppContent.yearsExperience,
                  'Years of\nexperience',
                  isMobile,
                ),
                _buildMinimalStat(
                  AppContent.projectsWorked,
                  'Projects\nworked on',
                  isMobile,
                ),
                _buildMinimalStat(AppContent.coffees, 'Coffees', isMobile),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMinimalStat(AppContent.age, 'Age', isMobile),
                _buildMinimalStat(
                  AppContent.yearsExperience,
                  'Years of\nexperience',
                  isMobile,
                ),
                _buildMinimalStat(
                  AppContent.projectsWorked,
                  'Projects\nworked on',
                  isMobile,
                ),
                _buildMinimalStat(AppContent.coffees, 'Coffees', isMobile),
              ],
            ),
    );
  }

  Widget _buildSecondaryButton(String text, String url) {
    return _AnimatedSecondaryButton(text: text, url: url);
  }

  Widget _buildSocialIcon(IconData icon, String url, String tooltip) {
    return AnimatedSocialIcon(
      icon: icon,
      onTap: () => _launchUrl(url),
      tooltip: tooltip,
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await launcher.canLaunchUrl(uri)) {
      await launcher.launchUrl(
        uri,
        mode: launcher.LaunchMode.externalApplication,
      );
    } else {
      debugPrint('Could not launch: $url');
    }
  }

  Widget _buildMinimalStat(String value, String label, bool isMobile) {
    return Column(
      children: [
        _buildStatValue(value, isMobile),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.jetBrainsMono(
            fontSize: isMobile ? 12 : 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildStatValue(String value, bool isMobile) {
    final fontSize = isMobile
        ? AppTypography.statMobile
        : AppTypography.statDesktop;
    // Extract numeric portion and suffix for count-up animation
    final match = RegExp(r'^(\d+)(.*)$').firstMatch(value);
    if (match != null) {
      final numericValue = int.parse(match.group(1)!);
      final suffix = match.group(2) ?? '';
      return CountUpAnimation(
        end: numericValue,
        suffix: suffix,
        delay: const Duration(milliseconds: 1100),
        duration: const Duration(milliseconds: 2500),
        style: GoogleFonts.jetBrainsMono(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          height: 1,
        ),
      );
    }
    // Non-numeric values (like ∞) display as-is
    return Text(
      value,
      style: GoogleFonts.jetBrainsMono(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1,
      ),
    );
  }
}

/// Animated secondary button with hover fill effect
class _AnimatedSecondaryButton extends StatefulWidget {
  final String text;
  final String url;

  const _AnimatedSecondaryButton({required this.text, required this.url});

  @override
  State<_AnimatedSecondaryButton> createState() =>
      _AnimatedSecondaryButtonState();
}

class _AnimatedSecondaryButtonState extends State<_AnimatedSecondaryButton> {
  Future<void> _launchCV() async {
    if (widget.url.startsWith('http')) {
      final uri = Uri.parse(widget.url);
      if (await launcher.canLaunchUrl(uri)) {
        await launcher.launchUrl(
          uri,
          mode: launcher.LaunchMode.externalApplication,
        );
      }
    } else {
      // For local assets, load from root bundle
      await _launchLocalAsset();
    }
  }

  Future<void> _launchLocalAsset() async {
    try {
      if (kIsWeb) {
        // On web, open the PDF directly from assets
        await launcher.launchUrl(Uri.parse('assets/cv.pdf'));
      } else {
        // On mobile/desktop, load from root bundle and save to temp file
        final ByteData data = await rootBundle.load(widget.url);
        final directory = Directory.systemTemp;
        final file = File('${directory.path}/cv.pdf');
        await file.writeAsBytes(data.buffer.asUint8List(), flush: true);
        await launcher.launchUrl(
          Uri.file(file.path),
          mode: launcher.LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      debugPrint('Error launching CV: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return UniversalInteractive(
      onTap: _launchCV,
      builder: (context, state) {
        final isActive = state.isHovered || state.isPressed;
        return AnimatedContainer(
          duration: AppAnimations.fast,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            border: Border.all(color: AppColors.primary),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            widget.text,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isActive ? AppColors.background : AppColors.primary,
              letterSpacing: 0.5,
            ),
          ),
        );
      },
    );
  }
}
