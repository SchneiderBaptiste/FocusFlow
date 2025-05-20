import 'package:flutter/material.dart';
import '../../models/task.dart';

class AddTaskDialog extends StatefulWidget {
  final Function(String, String, TaskPriority) onAdd;

  const AddTaskDialog({super.key, required this.onAdd});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  String _title = "";
  String _description = "";
  TaskPriority _priority = TaskPriority.medium;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: const Text("Ajouter une tâche", style: TextStyle(color: Colors.white)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) => _title = value,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Titre",
                hintText: "Titre de la tâche",
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              onChanged: (value) => _description = value,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Description",
                hintText: "Description de la tâche",
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TaskPriority>(
              value: _priority,
              dropdownColor: Theme.of(context).colorScheme.surface,
              decoration: const InputDecoration(
                labelText: "Priorité",
                labelStyle: TextStyle(color: Colors.white),
              ),
              items: TaskPriority.values.map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: priority.getColor(context),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(priority.name, style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _priority = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Annuler", style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            if (_title.isNotEmpty) {
              widget.onAdd(_title, _description, _priority);
              Navigator.pop(context);
            }
          },
          child: const Text("Ajouter", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}