/// App-wide spacing constants based on 8px grid system
class AppSpacing {
  AppSpacing._();

  // Base spacing unit
  static const double unit = 8.0;

  // Spacing scale
  static const double xs = 4.0;   // 0.5x
  static const double sm = 8.0;   // 1x
  static const double md = 16.0;  // 2x
  static const double lg = 24.0;  // 3x
  static const double xl = 32.0;  // 4x
  static const double xxl = 48.0; // 6x
  static const double xxxl = 64.0; // 8x
  static const double huge = 96.0; // 12x

  // Section padding
  static const double sectionHorizontalMobile = 20.0;
  static const double sectionHorizontalDesktop = 32.0;
  static const double sectionVerticalMobile = 64.0;
  static const double sectionVerticalDesktop = 96.0;

  // Card padding
  static const double cardSmall = 20.0;
  static const double cardLarge = 24.0;
  static const double cardXL = 28.0;
  static const double cardXXL = 36.0;

  // Border radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusFull = 9999.0;

  // Responsive breakpoints
  static const double breakpointMobile = 640.0;
  static const double breakpointTablet = 1024.0;
  static const double breakpointDesktop = 1440.0;
  static const double breakpointWide = 1920.0;

  // Max content widths
  static const double maxWidthContent = 1200.0;
  static const double maxWidthNarrow = 900.0;

  // Responsive horizontal padding by breakpoint
  static double getHorizontalPadding(double screenWidth) {
    if (screenWidth < breakpointMobile) return sectionHorizontalMobile; // 20
    if (screenWidth < breakpointTablet) return sectionHorizontalDesktop; // 32
    if (screenWidth < breakpointDesktop) return xxl; // 48
    if (screenWidth < breakpointWide) return xxxl; // 64
    return huge; // 96 - extra wide screens get generous margins
  }
}
