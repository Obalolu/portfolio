import 'package:flutter/material.dart';

class Project {
  final String name;
  final String description;
  final String problem;
  final String solution;
  final List<String> technologies;
  final String impact;
  final List<String> appStores;
  final Color? accentColor;

  const Project({
    required this.name,
    required this.description,
    required this.problem,
    required this.solution,
    required this.technologies,
    required this.impact,
    this.appStores = const [],
    this.accentColor,
  });
}
