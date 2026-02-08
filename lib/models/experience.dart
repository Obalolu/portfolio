class Experience {
  final String company;
  final String role;
  final String duration;
  final List<String> achievements;
  final String? location;

  const Experience({
    required this.company,
    required this.role,
    required this.duration,
    required this.achievements,
    this.location,
  });
}
