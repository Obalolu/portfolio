import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/utils/app_colors.dart';
import 'package:portfolio/widgets/home_page_scroll.dart';
import 'package:portfolio/widgets/home_page_tabs.dart';

// Choose navigation style:
// - Use ScrollHomePage() for single-page scroll (Option A)
// - Use TabHomePage() for tab-based navigation (Option B)

void main() async {
  // Initialize Flutter bindings before loading fonts
  WidgetsFlutterBinding.ensureInitialized();

  // Preload Google Fonts before rendering the app to prevent font flashing
  await GoogleFonts.pendingFonts([
    GoogleFonts.jetBrainsMono(),
  ]);

  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alex Chen - Mobile Developer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          background: AppColors.background,
        ),
        textTheme: GoogleFonts.jetBrainsMonoTextTheme(
          ThemeData.dark().textTheme,
        ),
        scaffoldBackgroundColor: AppColors.background,
      ),
      // CHANGE THIS LINE TO SWITCH NAVIGATION:
      // Option A: Scroll-based navigation (default)
      home: const ScrollHomePage(),
      // Option B: Tab-based navigation
      // home: const TabHomePage(),
    );
  }
}
