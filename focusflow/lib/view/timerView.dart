import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/timerDisplay.dart';
import 'widgets/timerControls.dart';

/*
 * Page de minuterie pour le mode Pomodoro.
 *
 * Cette page affiche le temps restant, contrôle la logique du chronomètre
 * et gère les transitions entre travail, pause courte et pause longue.
 */
class TimerPage extends StatefulWidget {
  final Function onPomodoroCompleted;

  /*
   * Crée une instance de TimerPage.
   *
   * [onPomodoroCompleted] est une fonction appelée après chaque Pomodoro.
   */
  const TimerPage({super.key, required this.onPomodoroCompleted});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  static const int pomodoroTime = 25 * 60;
  static const int shortBreakTime = 5 * 60;
  static const int longBreakTime = 30 * 60;

  int _remainingSeconds = pomodoroTime;
  Timer? _timer;
  bool _isRunning = false;
  bool _isBreak = false;
  int _consecutivePomodoros = 0;
  bool _showLongBreakOption = false;

  /*
   * Libère les ressources en annulant le timer actif.
   */
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /*
   * Démarre le minuteur si ce n'est pas déjà le cas.
   */
  void _startTimer() {
    if (_isRunning) return;
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          _isRunning = false;
          _handleTimerCompletion();
        }
      });
    });
  }

  /*
   * Met en pause le minuteur actif.
   */
  void _pauseTimer() {
    if (!_isRunning) return;
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  /*
   * Réinitialise le minuteur à la durée initiale
   * en fonction de l'état (travail ou pause).
   */
  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = _isBreak ? shortBreakTime : pomodoroTime;
      _isRunning = false;
    });
  }

  /*
   * Gère la fin d'un cycle (travail ou pause).
   */
  void _handleTimerCompletion() {
    HapticFeedback.heavyImpact();
    final wasBreak = _isBreak;
    _showNotification(wasBreak);

    if (wasBreak) {
      setState(() {
        _isBreak = false;
        _remainingSeconds = pomodoroTime;
      });
      _showSnackBar(
        'Retour au travail !',
        Theme.of(context).colorScheme.primary,
      );
    } else {
      widget.onPomodoroCompleted();
      _consecutivePomodoros++;

      if (_consecutivePomodoros == 4) {
        setState(() => _showLongBreakOption = true);
        _showLongBreakDialog();
      } else {
        setState(() {
          _isBreak = true;
          _remainingSeconds = shortBreakTime;
        });
        _startBreakTimer();
      }
    }
  }

  /*
   * Lance le minuteur pour une pause.
   */
  void _startBreakTimer() => _startTimer();

  /*
   * Affiche une notification contextuelle (SnackBar).
   */
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /*
   * Affiche une boîte de dialogue à la fin d'un cycle.
   */
  void _showNotification(bool wasBreak) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(wasBreak ? 'Fin de la pause!' : 'Pomodoro terminé!'),
          content: Text(
            wasBreak
                ? 'Il est temps de se remettre au travail!'
                : 'Vous avez travaillé pendant 25 minutes. Prenez une courte pause!',
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /*
   * Affiche une boîte de dialogue pour proposer une pause longue
   * après 4 Pomodoros consécutifs.
   */
  void _showLongBreakDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Félicitations!'),
          content: const Text(
            'Vous avez terminé 4 cycles Pomodoro! Souhaitez-vous prendre une pause plus longue de 30 minutes?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _isBreak = true;
                  _remainingSeconds = shortBreakTime;
                  _consecutivePomodoros = 0;
                  _showLongBreakOption = false;
                });
                _startBreakTimer();
              },
              child: const Text('Pause courte (5 min)'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _isBreak = true;
                  _remainingSeconds = longBreakTime;
                  _consecutivePomodoros = 0;
                  _showLongBreakOption = false;
                });
                _startBreakTimer();
              },
              child: const Text('Pause longue (30 min)'),
            ),
          ],
        );
      },
    );
  }

  /*
   * Construit l'interface de la page Pomodoro avec l'affichage du temps
   * et les contrôles de démarrage, pause et réinitialisation.
   */
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TimerDisplay(
              isBreak: _isBreak,
              remainingSeconds: _remainingSeconds,
              consecutivePomodoros: _consecutivePomodoros,
              pomodoroTime: pomodoroTime,
              shortBreakTime: shortBreakTime,
              longBreakTime: longBreakTime,
            ),
            const SizedBox(height: 60),
            TimerControls(
              isRunning: _isRunning,
              isBreak: _isBreak,
              showLongBreakOption: _showLongBreakOption,
              onStart: _startTimer,
              onPause: _pauseTimer,
              onReset: _resetTimer,
              onStartLongBreak: () {
                setState(() {
                  _isBreak = true;
                  _remainingSeconds = longBreakTime;
                  _consecutivePomodoros = 0;
                  _showLongBreakOption = false;
                });
                _startBreakTimer();
              },
            ),
          ],
        ),
      ),
    );
  }
}
