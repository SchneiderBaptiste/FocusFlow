import 'package:flutter/material.dart';

/*
 * TimerControls affiche les boutons de contrôle du minuteur :
 * - Démarrer / Pause
 * - Réinitialiser
 * - Optionnellement : démarrer une pause longue
 */
class TimerControls extends StatelessWidget {
  final bool isRunning; // Indique si le timer est en cours
  final bool isBreak; // Indique si l’on est en pause
  final bool showLongBreakOption; // Affiche ou non le bouton de pause longue

  final VoidCallback onStart; // Callback pour démarrer le timer
  final VoidCallback onPause; // Callback pour mettre en pause
  final VoidCallback onReset; // Callback pour réinitialiser
  final VoidCallback onStartLongBreak; // Callback pour pause longue

  const TimerControls({
    super.key,
    required this.isRunning,
    required this.isBreak,
    required this.onStart,
    required this.onPause,
    required this.onReset,
    required this.showLongBreakOption,
    required this.onStartLongBreak,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Ligne de boutons principaux : Démarrer/Pause + Reset
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bouton de démarrage ou de pause selon l’état du timer
            ElevatedButton.icon(
              onPressed: isRunning ? onPause : onStart,
              icon: Icon(isRunning ? Icons.pause : Icons.play_arrow),
              label: Text(
                isRunning ? 'Pause' : 'Démarrer',
                style: const TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isRunning
                    ? Colors.amber[700]
                    : isBreak
                        ? Colors.green
                        : Colors.amber[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Bouton de réinitialisation
            IconButton(
              onPressed: onReset,
              icon: const Icon(Icons.refresh),
              iconSize: 30,
              color: Colors.grey,
            ),
          ],
        ),

        // Bouton pour démarrer une pause longue (affiché conditionnellement)
        if (showLongBreakOption)
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ElevatedButton.icon(
              onPressed: onStartLongBreak,
              icon: const Icon(Icons.king_bed),
              label: const Text('Pause longue (30 min)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
