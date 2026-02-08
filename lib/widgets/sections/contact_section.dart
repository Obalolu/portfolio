import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/constants/content.dart';
import 'package:portfolio/utils/app_animations.dart';
import 'package:portfolio/utils/app_colors.dart';
import 'package:portfolio/utils/app_spacing.dart';
import 'package:portfolio/widgets/shared/section_title.dart';
import 'package:portfolio/widgets/shared/responsive_container.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

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
            number: '06',
            title: 'Get In Touch',
            subtitle: 'Let\'s build something together.',
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              // Message
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInAnimation(
                      child: Text(
                        AppContent.contactTitle,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    FadeInAnimation(
                      delay: const Duration(milliseconds: 100),
                      child: Text(
                        AppContent.contactSubtitle,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeInAnimation(
                      delay: const Duration(milliseconds: 200),
                      child: Text(
                        'I\'m currently open to new opportunities and interesting projects. Feel free to reach out!',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 15,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 64),
              // Contact Options
              Column(
                children: [
                  AnimatedContactButton(
                    icon: FontAwesomeIcons.envelope,
                    label: 'Email',
                    value: AppContent.email,
                    onTap: () => _launchUrl('mailto:${AppContent.email}'),
                    delay: const Duration(milliseconds: 300),
                  ),
                  const SizedBox(height: 12),
                  AnimatedContactButton(
                    icon: FontAwesomeIcons.linkedin,
                    label: 'LinkedIn',
                    value: 'linkedin.com/in/alexchen',
                    onTap: () => _launchUrl(AppContent.linkedin),
                    delay: const Duration(milliseconds: 400),
                  ),
                  const SizedBox(height: 12),
                  AnimatedContactButton(
                    icon: FontAwesomeIcons.github,
                    label: 'GitHub',
                    value: 'github.com/alexchen',
                    onTap: () => _launchUrl(AppContent.github),
                    delay: const Duration(milliseconds: 500),
                  ),
                  const SizedBox(height: 12),
                  AnimatedContactButton(
                    icon: FontAwesomeIcons.xTwitter,
                    label: 'Twitter',
                    value: '@alexchen_dev',
                    onTap: () => _launchUrl(AppContent.twitter),
                    delay: const Duration(milliseconds: 600),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  void _launchUrl(String url) {
    debugPrint('Launch: $url');
  }
}

class AnimatedContactButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final Duration delay;

  const AnimatedContactButton({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    this.delay = Duration.zero,
  });

  @override
  State<AnimatedContactButton> createState() => _AnimatedContactButtonState();
}

class _AnimatedContactButtonState extends State<AnimatedContactButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _rotateController;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );
    _rotateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _rotateController,
        curve: Curves.easeOut,
      ),
    );
    _rotateController.forward();
  }

  @override
  void dispose() {
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: FadeInAnimation(
        delay: widget.delay,
        child: AnimatedContainer(
          duration: AppAnimations.fast,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: _isHovered ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: _isHovered ? 0.4 : 0.2),
            ),
          ),
          child: Row(
            children: [
              AnimatedBuilder(
                animation: _rotateAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _isHovered ? 0.1 : 0,
                    child: Icon(
                      widget.icon,
                      color: AppColors.primary,
                      size: _isHovered ? 20 : 18,
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      color: AppColors.textTertiary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    widget.value,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
