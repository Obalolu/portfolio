class SkillCategory {
  final String name;
  final List<Skill> skills;

  const SkillCategory({
    required this.name,
    required this.skills,
  });
}

class Skill {
  final String name;
  final String? icon;
  final int level; // 0-100

  const Skill({
    required this.name,
    this.icon,
    this.level = 80,
  });
}
