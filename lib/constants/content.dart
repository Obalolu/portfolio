import 'package:flutter/material.dart';
import 'package:portfolio/models/experience.dart';
import 'package:portfolio/models/project.dart';
import 'package:portfolio/models/skill.dart';

class AppContent {
  AppContent._();

  // Developer Info
  static const String name = 'Obalolu \nOkeowo';
  static const String tagline = 'Mobile Developer building fast, \nscalable apps for real users.';
  static const String subtext = 'Flutter • Firebase • Android & iOS • Web';
  static const String location = 'San Francisco, CA';

  // Stats
  static const String yearsExp = '5+';
  static const String appsBuilt = '20+';
  static const String downloads = '50M+';
  static const String uptime = '99.9%';

  // Social Links
  static const String github = 'https://github.com/alexchen';
  static const String linkedin = 'https://linkedin.com/in/alexchen';
  static const String twitter = 'https://twitter.com/alexchen_dev';
  static const String email = 'alex.chen@example.com';

  // About
  static const String about = '''
I'm a mobile developer who thinks beyond the code. I build apps that are fast, reliable, and delightful to use.

Over 5+ years, I've shipped fintech apps, productivity tools, and SaaS products used by millions. I care about clean architecture, performance optimization, and user experience.

I don't just write code — I solve problems.''';

  // Skills
  static const List<SkillCategory> skillCategories = [
    SkillCategory(
      name: 'Mobile Development',
      skills: [
        Skill(name: 'Flutter', level: 95),
        Skill(name: 'Dart', level: 90),
        Skill(name: 'Android', level: 85),
        Skill(name: 'iOS', level: 80),
      ],
    ),
    SkillCategory(
      name: 'Backend & APIs',
      skills: [
        Skill(name: 'Firebase', level: 90),
        Skill(name: 'REST APIs', level: 88),
        Skill(name: 'GraphQL', level: 75),
        Skill(name: 'Node.js', level: 70),
      ],
    ),
    SkillCategory(
      name: 'Architecture',
      skills: [
        Skill(name: 'Clean Architecture', level: 90),
        Skill(name: 'BLoC', level: 85),
        Skill(name: 'Riverpod', level: 88),
        Skill(name: 'Provider', level: 85),
      ],
    ),
    SkillCategory(
      name: 'DevOps & Tools',
      skills: [
        Skill(name: 'Git', level: 90),
        Skill(name: 'CI/CD', level: 85),
        Skill(name: 'Fastlane', level: 80),
      ],
    ),
    SkillCategory(
      name: 'Testing',
      skills: [
        Skill(name: 'Unit Tests', level: 85),
        Skill(name: 'Widget Tests', level: 82),
        Skill(name: 'Integration Tests', level: 78),
      ],
    ),
  ];

  // Projects
  static const List<Project> projects = [
    Project(
      name: 'FinTrack',
      description: 'Personal finance tracker that helps users manage expenses and investments.',
      problem: 'Users struggled to track finances across multiple accounts and platforms.',
      solution: 'Built a unified dashboard with bank API integration and insightful analytics.',
      technologies: ['Flutter', 'Firebase', 'Plaid API', 'FL Charts'],
      impact: '50K+ downloads, 4.8★ rating',
      appStores: ['App Store', 'Play Store'],
      accentColor: Color(0xFF10B981),
    ),
    Project(
      name: 'Mindful',
      description: 'Meditation and mindfulness app with personalized programs.',
      problem: 'Existing apps were too complex, expensive, and overwhelming for beginners.',
      solution: 'Created a simple, free app with guided sessions and progress tracking.',
      technologies: ['Flutter', 'Audio Streaming', 'In-app Purchases', 'Cloud Functions'],
      impact: '100K+ downloads, Featured on Play Store',
      appStores: ['App Store', 'Play Store'],
      accentColor: Color(0xFF8B5CF6),
    ),
    Project(
      name: 'TaskFlow',
      description: 'Team productivity app for task management and real-time collaboration.',
      problem: 'Teams needed seamless sync across devices with offline support.',
      solution: 'Implemented offline-first architecture with conflict resolution.',
      technologies: ['Flutter', 'Firestore', 'Cloud Functions', 'REST APIs'],
      impact: '10K+ active teams',
      appStores: ['Play Store'],
      accentColor: Color(0xFF3B82F6),
    ),
    Project(
      name: 'FitPulse',
      description: 'Fitness tracking app with custom workout plans and progress analytics.',
      problem: 'Generic workout plans don\'t work for everyone\'s unique fitness goals.',
      solution: 'Integrated ML-powered personalized workout routines.',
      technologies: ['Flutter', 'ML Kit', 'Google Fit API', 'HealthKit'],
      impact: '25K+ users, 4.6★ rating',
      appStores: ['App Store', 'Play Store'],
      accentColor: Color(0xFFF59E0B),
    ),
  ];

  // Philosophy
  static const List<PhilosophyItem> philosophy = [
    PhilosophyItem(
      title: 'Clean Architecture',
      description: 'Code is read more than written. I structure apps so they\'re easy to understand, test, and modify.',
      icon: Icons.account_tree,
    ),
    PhilosophyItem(
      title: 'Performance First',
      description: '60fps is non-negotiable. I profile, optimize, and eliminate jank before shipping.',
      icon: Icons.speed,
    ),
    PhilosophyItem(
      title: 'Error Handling',
      description: 'Things fail gracefully. Users should never see cryptic errors or experience crashes.',
      icon: Icons.shield,
    ),
    PhilosophyItem(
      title: 'Team Collaboration',
      description: 'I write code for humans, not machines. Clear naming, documentation, and communication.',
      icon: Icons.groups,
    ),
  ];

  // Experience
  static const List<Experience> experience = [
    Experience(
      company: 'TechCorp Inc.',
      role: 'Senior Mobile Engineer',
      duration: '2022–Present',
      location: 'San Francisco, CA',
      achievements: [
        'Led mobile team of 5 engineers',
        'Reduced app launch time by 60%',
        'Shipped 12+ features to production',
        'Implemented comprehensive testing suite',
      ],
    ),
    Experience(
      company: 'StartupXYZ',
      role: 'Mobile Developer',
      duration: '2020–2022',
      location: 'Remote',
      achievements: [
        'Built fintech app from scratch',
        'Integrated payment gateways (Stripe, Razorpay)',
        'Achieved 4.7★ App Store rating',
        '500K+ downloads across platforms',
      ],
    ),
    Experience(
      company: 'AgencyCo',
      role: 'Junior Developer',
      duration: '2019–2020',
      location: 'New York, NY',
      achievements: [
        'Delivered 15+ client projects',
        'Learned Flutter and clean architecture',
        'Collaborated with design teams',
      ],
    ),
  ];

  // Contact
  static const String contactTitle = 'Have an idea or a role in mind?';
  static const String contactSubtitle = 'Let\'s talk.';
}

class PhilosophyItem {
  final String title;
  final String description;
  final IconData icon;

  const PhilosophyItem({
    required this.title,
    required this.description,
    required this.icon,
  });
}
