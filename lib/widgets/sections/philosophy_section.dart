import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/constants/content.dart';
import 'package:portfolio/utils/app_animations.dart';
import 'package:portfolio/utils/app_colors.dart';
import 'package:portfolio/utils/app_spacing.dart';
import 'package:portfolio/widgets/shared/section_title.dart';
import 'package:portfolio/widgets/shared/responsive_container.dart';

class PhilosophySection extends StatelessWidget {
  const PhilosophySection({super.key});

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
            number: '04',
            title: 'Engineering Philosophy',
            subtitle: 'How I think about building software.',
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.lg,
            children: AppContent.philosophy.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return PhilosophyCard(
                item: item,
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

class PhilosophyCard extends StatefulWidget {
  final PhilosophyItem item;
  final int index;

  const PhilosophyCard({
    super.key,
    required this.item,
    required this.index,
  });

  @override
  State<PhilosophyCard> createState() => _PhilosophyCardState();
}

class _PhilosophyCardState extends State<PhilosophyCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _iconController;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );
    _iconAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _iconController,
        curve: AppAnimations.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _iconController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _iconController.reverse();
      },
      child: AnimatedContainer(
        duration: AppAnimations.fast,
        transform: Matrix4.identity()..scaled(_isHovered ? 1.03 : 1.0, _isHovered ? 1.03 : 1.0, 1.0),
        curve: AppAnimations.easeOut,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: _isHovered ? 0.2 : 0.1),
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: FadeInAnimation(
          delay: AppAnimations.staggerDelay(widget.index * 2),
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(AppSpacing.cardXL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                  ),
                  child: AnimatedBuilder(
                    animation: _iconAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 0.8 + (_iconAnimation.value * 0.2),
                        child: Icon(
                          widget.item.icon,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.item.title,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.item.description,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
