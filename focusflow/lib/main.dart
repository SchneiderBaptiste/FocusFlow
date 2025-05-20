import 'package:flutter/material.dart';
import 'models/task.dart';
import 'view/mainView.dart';

void main() {
  runApp(const MyApp());
}

/*
 * Widget racine de l'application ToDo.
 *
 * Configure le thème global, désactive la bannière de debug
 * et définit l'écran d'accueil via MainScreen.
 */
class MyApp extends StatelessWidget {
  /*
   * Constructeur de MyApp.
   */
  const MyApp({super.key});

  /*
   * Construit l'application avec un thème sombre personnalisé
   * et retourne le widget principal [MaterialApp].
   */
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF6E5CB6),
        scaffoldBackgroundColor: const Color(0xFF2A2A2A),
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF6E5CB6),
          secondary: const Color(0xFF8B77D9),
          surface: const Color(0xFF333333),
          background: const Color(0xFF2A2A2A),
        ),
      ),
      home: const MainScreen(),
    );
  }
}
