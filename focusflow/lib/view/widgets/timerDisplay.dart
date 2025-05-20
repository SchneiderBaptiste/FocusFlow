import 'package:flutter/material.dart';

/*
 * TimerDisplay affiche le minuteur Pomodoro ou de pause,
 * avec une animation circulaire et des indications contextuelles.
 */
class TimerDisplay extends StatelessWidget {
  final bool isBreak; // Indique s'il s'agit d'une pause
  final int remainingSeconds; // Temps restant en secondes
  final int consecutivePomodoros; // Nombre de Pomodoros consécutifs terminés
  final int pomodoroTime; // Durée d'un Pomodoro
  final int shortBreakTime; // Durée d'une pause courte
  final int longBreakTime; // Durée d'une pause longue

  const TimerDisplay({
    super.key,
    required this.isBreak,
    required this.remainingSeconds,
    required this.consecutivePomodoros,
    required this.pomodoroTime,
    required this.shortBreakTime,
    required this.longBreakTime,
  });

  // Formate les secondes en minutes:secondes (ex: 04:09)
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remaining = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remaining.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Titre principal : pause ou Pomodoro
        Text(
          isBreak ? 'Temps de pause' : 'Pomodoro Timer',
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        // Sous-titre avec indication de durée
        Text(
          isBreak
              ? 'Détendez-vous pendant ${remainingSeconds == longBreakTime ? '30' : '5'} minutes'
              : 'Concentrez-vous pendant 25 minutes',
          style: TextStyle(fontSize: 16, color: Colors.grey[400]),
        ),

        const SizedBox(height: 16),

        // Affiche le cycle Pomodoro si on n’est pas en pause
        if (consecutivePomodoros > 0 && !isBreak)
          Chip(
            label: Text(
              'Cycle $consecutivePomodoros/4',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            avatar: const Icon(Icons.repeat),
          ),

        const SizedBox(height: 40),

        // Cercle contenant l'animation et le timer
        Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
            border: Border.all(
              color: isBreak ? Colors.green : Theme.of(context).colorScheme.primary,
              width: 4,
            ),
          ),
          child: Stack(
            children: [
              // Animation de progression circulaire
              Center(
                child: SizedBox(
                  width: 240,
                  height: 240,
                  child: CircularProgressIndicator(
                    value: isBreak
                        ? 1 - (remainingSeconds / (remainingSeconds == longBreakTime ? longBreakTime : shortBreakTime))
                        : 1 - (remainingSeconds / pomodoroTime),
                    strokeWidth: 8,
                    backgroundColor: Colors.grey[800],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isBreak ? Colors.green : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),

              // Temps restant et label (Focus/Pause)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _formatTime(remainingSeconds),
                      style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isBreak ? 'Pause' : 'Focus',
                      style: TextStyle(
                        fontSize: 18,
                        color: isBreak ? Colors.green : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
