import 'package:flutter/material.dart';
import '../models/task.dart';
import 'widgets/taskCard.dart';
import 'widgets/emptyTaskMessage.dart';

class HomePage extends StatelessWidget {
  final String userName;
  final List<Task> tasks;
  final void Function(Task) onToggleTask;
  final Function(String, String, TaskPriority) onAddTask;
  final void Function(Task) onDeleteTask;

  const HomePage({
    super.key,
    required this.userName,
    required this.tasks,
    required this.onToggleTask,
    required this.onAddTask,
    required this.onDeleteTask,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          Text(
            'Bonjour, $userName 👋',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Voici vos tâches ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
            ),
          ),

          const SizedBox(height: 24),

          Expanded(
            child: tasks.isEmpty
                ? const EmptyTaskMessage()
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskCard(
                        task: task,
                        index: index,
                        onToggleTask: onToggleTask,
                        onDeleteTask: onDeleteTask,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
