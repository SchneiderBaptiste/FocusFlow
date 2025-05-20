import 'package:flutter/material.dart';

/// Widget représentant une carte statistique affichant un titre, une valeur,
/// et une icône.
class StatCard extends StatelessWidget {
  final String title;
  final int value;
  final IconData icon;

  /// [StatCard] prend un [title], un [value] et une [icon].
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildIconContainer(context),
            const SizedBox(width: 16),
            _buildInfoSection(),
          ],
        ),
      ),
    );
  }

  /// Construit un conteneur décoratif autour de l’icône.
  Widget _buildIconContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
    );
  }

  /// Affiche le titre de la statistique et sa valeur numérique.
  Widget _buildInfoSection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
          ),
          const SizedBox(height: 4),
          Text(
            value.toString(),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
