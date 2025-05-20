import 'package:flutter/material.dart';

/// Modèle représentant une tâche dans l'application.
/// Contient le titre, la description, l'état de complétion,
/// les dates de création et de complétion, ainsi qu'une priorité.
class Task {
  final String title;
  final String description;
  final TaskPriority priority;
  bool isCompleted;
  final DateTime creationDate;
  DateTime? completionDate;

  Task({
    required this.title,
    required this.description,
    required this.priority,
    required this.isCompleted,
    required this.creationDate,
    this.completionDate,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    TaskPriority parsePriority(dynamic value) {
      if (value is int) return TaskPriority.values[value];
      if (value is String) {
        switch (value.toLowerCase()) {
          case 'low':
            return TaskPriority.low;
          case 'medium':
            return TaskPriority.medium;
          case 'high':
            return TaskPriority.high;
        }
      }
      return TaskPriority.low; // fallback par défaut
    }

    return Task(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      creationDate:
          DateTime.tryParse(json['creationDate'] ?? '') ?? DateTime.now(),
      completionDate:
          json['completionDate'] != null
              ? DateTime.tryParse(json['completionDate'])
              : null,
      priority: parsePriority(json['priority']),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'isCompleted': isCompleted,
    'creationDate': creationDate.toIso8601String(),
    'completionDate': completionDate?.toIso8601String(),
    'priority':
        priority.index, // Assure-toi d'utiliser l'index ou une string constante
  };
}

/// Enumération représentant les niveaux de priorité d'une tâche.
enum TaskPriority { high, medium, low }

/// Extension ajoutant des propriétés utiles à [TaskPriority],
/// notamment un nom lisible et une couleur associée.
extension TaskPriorityExtension on TaskPriority {
  /// Retourne le nom lisible de la priorité.
  String get name {
    switch (this) {
      case TaskPriority.high:
        return 'Élevée';
      case TaskPriority.medium:
        return 'Moyenne';
      case TaskPriority.low:
        return 'Faible';
    }
  }

  /// Retourne une couleur liée à la priorité,
  /// utilisée pour l'affichage visuel dans l'interface.
  Color getColor(BuildContext context) {
    switch (this) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Theme.of(context).colorScheme.primary;
      case TaskPriority.low:
        return Colors.green;
    }
  }
}
