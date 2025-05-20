import 'package:flutter/material.dart';
import '../models/task.dart';
import 'widgets/addTask.dart';
import '../service/jsonbinService.dart';
import 'homeView.dart';
import 'timerView.dart';
import 'statView.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Task> tasks = [];
  Map<String, dynamic> stats = {};
  String userName = '';
  int _selectedIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final data = await JsonbinService().fetchData();
    print("JSON reçu : $data");
    setState(() {
      userName = data['userName'] ?? 'Utilisateur';
      tasks =
          (data['tasks'] as List)
              .map((taskJson) => Task.fromJson(taskJson))
              .toList();
      stats = data['stats'] ?? {};
      setDefaultsIfMissing(); // 👈 Ajout ici
      sortTasksByPriority();
      isLoading = false;
    });
  }

  void setDefaultsIfMissing() {
    stats['Tâches complétées'] ??= tasks.where((t) => t.isCompleted).length;
    stats['Tâches en cours'] ??= tasks.where((t) => !t.isCompleted).length;
    stats['Sessions de travail'] ??= 0;
    stats['Cycles Pomodoro'] ??= 0;
    stats['Minutes de concentration'] ??= 0;
  }

  void sortTasksByPriority() {
    tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
  }

  void toggleTaskCompletion(Task task) async {
    setState(() {
      final wasCompleted = task.isCompleted;
      task.isCompleted = !task.isCompleted;
      task.completionDate = task.isCompleted ? DateTime.now() : null;

      if (task.isCompleted && !wasCompleted) {
        stats['Tâches complétées'] = (stats['Tâches complétées'] ?? 0) + 1;
        stats['Tâches en cours'] = (stats['Tâches en cours'] ?? 0) - 1; 
      } else if (!task.isCompleted && wasCompleted) {
        stats['Tâches complétées'] = (stats['Tâches complétées'] ?? 0) - 1;
        stats['Tâches en cours'] = (stats['Tâches en cours'] ?? 0) + 1; 
      }

      if ((stats['Tâches complétées'] ?? 0) < 0) stats['Tâches complétées'] = 0;
      if ((stats['Tâches en cours'] ?? 0) < 0) stats['Tâches en cours'] = 0;
    });

    try {
      await JsonbinService().saveTasksAndStats(
        tasks: tasks.map((t) => t.toJson()).toList(),
        stats: stats,
        userName: userName,
      );
      print("Tâche et stats mises à jour dans jsonbin");
    } catch (e) {
      print("Erreur de sauvegarde : $e");
    }
  }

  void addNewTask(
    String title,
    String description,
    TaskPriority priority,
  ) async {
    setState(() {
      tasks.add(
        Task(
          title: title,
          description: description,
          priority: priority,
          isCompleted: false,
          creationDate: DateTime.now(),
        ),
      );
      sortTasksByPriority();

      stats['Tâches en cours'] = (stats['Tâches en cours'] ?? 0) + 1;
    });

    try {
      await JsonbinService().saveTasksAndStats(
        tasks: tasks.map((t) => t.toJson()).toList(),
        stats: stats,
        userName: userName,
      );
      print("Nouvelle tâche sauvegardée !");
    } catch (e) {
      print("Erreur lors de la sauvegarde de la nouvelle tâche : $e");
    }
  }

  void deleteTask(Task task) async {
    setState(() {
      tasks.removeWhere((t) => t.title == task.title);
    });

    try {
      await JsonbinService().deleteTask(
        binId: JsonbinService().binId,
        userName: userName,
        stats: stats,
        taskTitle: task.title,
      );
      print("Tâche supprimée !");
    } catch (e) {
      print("Erreur de suppression : $e");
    }
  }

  void incrementPomodoroCount() async {
    setState(() {
      stats["Cycles Pomodoro"] = (stats["Cycles Pomodoro"] ?? 0) + 1;
      stats["Sessions de travail"] = (stats["Sessions de travail"] ?? 0) + 1;
      stats["Minutes de concentration"] =
          (stats["Minutes de concentration"] ?? 0) + 25;
    });

    try {
      await JsonbinService().saveTasksAndStats(
        tasks: tasks.map((t) => t.toJson()).toList(),
        stats: stats,
        userName: userName,
      );
      print("Stats mises à jour après un Pomodoro !");
    } catch (e) {
      print("Erreur de sauvegarde après Pomodoro : $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final List<Widget> pages = [
      HomePage(
        userName: userName,
        tasks: tasks,
        onToggleTask: toggleTaskCompletion,
        onAddTask: addNewTask,
        onDeleteTask: deleteTask,
      ),
      TimerPage(onPomodoroCompleted: incrementPomodoroCount),
      StatsPage(stats: stats),
    ];

    return Scaffold(
      body: SafeArea(child: pages[_selectedIndex]),
      floatingActionButton:
          _selectedIndex == 0
              ? FloatingActionButton(
                onPressed:
                    () => showDialog(
                      context: context,
                      builder: (_) => AddTaskDialog(onAdd: addNewTask),
                    ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: const Icon(Icons.add),
              )
              : null,
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Tâches'),
        BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Minuteur'),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Statistiques',
        ),
      ],
    );
  }
}
