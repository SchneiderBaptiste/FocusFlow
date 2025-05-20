import 'package:flutter/material.dart';
import '../../models/task.dart';

/*
 * TaskCard affiche une tâche sous forme de carte avec :
 * - un bouton pour la marquer comme terminée
 * - un indicateur de priorité
 * - une possibilité de suppression par glissement (swipe)
 * - un affichage extensible avec description et date de complétion
 */
class TaskCard extends StatelessWidget {
  final Task task; // La tâche à afficher
  final int index; // L’index de la tâche dans la liste (non utilisé ici)
  final void Function(Task) onToggleTask; // Marquer comme complétée/incomplète
  final void Function(Task) onDeleteTask; // Supprimer la tâche

  const TaskCard({
    super.key,
    required this.task,
    required this.index,
    required this.onToggleTask,
    required this.onDeleteTask,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Dismissible(
        // Suppression de la tâche avec effet de glissement vers la gauche
        key: Key(task.title + DateTime.now().toString()),
        background: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) => onDeleteTask(task),

        // Contenu de la carte extensible
        child: ExpansionTile(
          // Icône de complétion entourée d’un cercle coloré selon la priorité
          leading: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: task.priority.getColor(context),
                width: 2,
              ),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                color: task.isCompleted
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
                size: 24,
              ),
              onPressed: () => onToggleTask(task),
            ),
          ),

          // Titre et indicateur visuel de priorité
          title: Row(
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                    color: task.isCompleted ? Colors.grey : Colors.white,
                  ),
                ),
              ),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: task.priority.getColor(context),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),

          // Infos complémentaires : priorité et date de création
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Priorité: ${task.priority.name}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
                Text(
                  'Ajouté le ${_formatDate(task.creationDate)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              ],
            ),
          ),

          // Contenu déroulant : description + date de complétion (si terminée)
          children: [
            if (task.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Description:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      task.description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[300]),
                    ),

                    if (task.isCompleted && task.completionDate != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Complété le ${_formatDate(task.completionDate!)}',
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Formate une date en jj/mm/aaaa
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
