import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors
  static const Color background = Color(0xFF0A0E1D);
  static const Color surface = Color(0xFF121826);
  static const Color surfaceLight = Color(0xFF1A2235);

  // Accent Colors
  static const Color primary = Color(0xFF10B981); // Emerald Green
  static const Color primaryDark = Color(0xFF059669);
  static const Color secondary = Color(0xFF6366F1); // Indigo

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textTertiary = Color(0xFF6B7280);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [background, surface],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
