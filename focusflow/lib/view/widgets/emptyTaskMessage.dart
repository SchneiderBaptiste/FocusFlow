import 'package:flutter/material.dart';

/// Widget affiché lorsqu’il n’y a aucune tâche à afficher.
/// Affiche une icône et un message au centre de l’écran.
class EmptyTaskMessage extends StatelessWidget {
  const EmptyTaskMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icône illustrative
          Icon(
            Icons.check_circle_outline,
            size: 60,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),

          // Message d'information
          Text(
            "Aucune tâche pour le moment",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
