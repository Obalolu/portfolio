import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/models/skill.dart';
import 'package:portfolio/utils/app_animations.dart';
import 'package:portfolio/utils/app_colors.dart';
import 'package:portfolio/utils/app_spacing.dart';
import 'package:portfolio/widgets/shared/universal_interactive.dart';

/// Horizontal scrollable tab bar for filtering skills by category
class CategoryTabBar extends StatefulWidget {
  final SkillCategory selectedCategory;
  final ValueChanged<SkillCategory> onCategorySelected;

  const CategoryTabBar({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  State<CategoryTabBar> createState() => _CategoryTabBarState();
}

class _CategoryTabBarState extends State<CategoryTabBar> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = AppSpacing.isMobile(constraints.maxWidth);

        return Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Stack(
            children: [
              ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: SkillCategory.values.length,
                itemBuilder: (context, index) {
                  final category = SkillCategory.values[index];
                  final isSelected = category == widget.selectedCategory;

                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _CategoryTab(
                      category: category,
                      isSelected: isSelected,
                      onTap: () => widget.onCategorySelected(category),
                    ),
                  );
                },
              ),
              // Scroll indicators for mobile (gradient fades at edges)
              if (isMobile)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                AppColors.background,
                                AppColors.background.withValues(alpha: 0),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 20,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                AppColors.background.withValues(alpha: 0),
                                AppColors.background,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _CategoryTab extends StatefulWidget {
  final SkillCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryTab({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_CategoryTab> createState() => _CategoryTabState();
}

class _CategoryTabState extends State<_CategoryTab> {
  @override
  Widget build(BuildContext context) {
    return UniversalInteractive(
      onTap: widget.onTap,
      builder: (context, state) {
        final isActive =
            state.isHovered || state.isPressed || widget.isSelected;
        return AnimatedContainer(
          duration: AppAnimations.fast,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.primary
                : (state.isHovered
                      ? AppColors.surfaceLight
                      : Colors.transparent),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.primary
                  : AppColors.primary.withValues(
                      alpha: state.isHovered ? 0.3 : 0.15,
                    ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.category.displayName,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: widget.isSelected
                      ? AppColors.background
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
