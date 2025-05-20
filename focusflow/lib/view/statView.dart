import 'package:flutter/material.dart';
import 'widgets/statCard.dart';

/*
 * Page affichant les statistiques de productivité de l'utilisateur.
 *
 * Cette vue présente un résumé des tâches, sessions, minutes de concentration
 * et autres données pertinentes sous forme de cartes.
 */
class StatsPage extends StatelessWidget {
  final Map<String, dynamic> stats;

  /*
   * Crée une instance de StatsPage.
   *
   * [stats] contient les données de productivité à afficher.
   */
  const StatsPage({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Statistiques',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Suivi de votre productivité',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  StatCard(
                    title: 'Tâches complétées',
                    value: stats['Tâches complétées'] ?? 0,
                    icon: Icons.task_alt,
                  ),
                  StatCard(
                    title: 'Tâches en cours',
                    value: stats['Tâches en cours'] ?? 0,
                    icon: Icons.pending_actions,
                  ),
                  StatCard(
                    title: 'Sessions de travail',
                    value: stats['Sessions de travail'] ?? 0,
                    icon: Icons.timer,
                  ),
                  StatCard(
                    title: 'Cycles Pomodoro',
                    value: stats['Cycles Pomodoro'] ?? 0,
                    icon: Icons.repeat,
                  ),
                  StatCard(
                    title: 'Minutes de concentration',
                    value: stats['Minutes de concentration'] ?? 0,
                    icon: Icons.access_time_filled,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
