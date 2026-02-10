# Portfolio

A modern, responsive portfolio website built with Flutter, showcasing projects, skills, and professional experience.

## Live Demo

Check out the live site at [obalolu.dev](https://portfolio-seven-azure-67.vercel.app/)

## Features

- **Responsive Design**: Optimized for mobile, tablet, and desktop devices
- **Smooth Navigation**: Scroll-based navigation with animated transitions
- **Interactive UI**: Hover effects, animations, and touch-friendly interactions
- **Dark Theme**: Modern dark theme with emerald green accents
- **Project Showcase**: Featured projects with images, descriptions, and tech stacks
- **Skills Display**: Categorized skills with proficiency levels
- **Experience Timeline**: Professional journey with achievements
- **Contact Section**: Easy ways to connect via social media and email

## Tech Stack

- **Framework**: Flutter 3
- **Language**: Dart
- **Fonts**: JetBrains Mono (monospace)
- **Icons**: FontAwesome

## Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Obalolu/portfolio.git
```

2. Navigate to the project directory:
```bash
cd portfolio
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
# Web
flutter run -d chrome

# Mobile (requires connected device/emulator)
flutter run
```

## Building for Production

### Web

```bash
flutter build web --release
```

The build output will be in the `build/web` directory.

## Project Structure

```
lib/
├── constants/          # App content and data
├── models/             # Data models (Project, Skill, Experience)
├── utils/              # Utilities (colors, spacing, typography, animations)
├── widgets/
    ├── sections/       # Page sections (Hero, About, Skills, etc.)
    └── shared/         # Reusable widgets
└── main.dart           # App entry point
```

## Sections

1. **Hero**: Introduction with profile image and key stats
2. **About**: Personal background and development philosophy
3. **Skills**: Technical expertise with categorized display
4. **Projects**: Featured projects with detailed descriptions
5. **Philosophy**: Engineering principles and approach
6. **Experience**: Professional work history
7. **Contact**: Social links and contact information

## Contact

- **Email**: obaokemoney@gmail.com
- **GitHub**: [obalolu](https://github.com/obalolu)
- **LinkedIn**: [in/obalolu](https://linkedin.com/in/obalolu)
- **Twitter**: [@treedee07](https://twitter.com/treedee07)

## License

This project is open source and available under the MIT License.
