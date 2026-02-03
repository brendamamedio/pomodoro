import 'dart:async';
import 'package:flutter/material.dart';
import '../data/models/task_model.dart';

enum TimerMode { focus, shortBreak, longBreak }

class TimerController extends ValueNotifier<int> {
  static final TimerController _instance = TimerController._internal();
  factory TimerController() => _instance;
  TimerController._internal() : super(1500);

  Timer? _timer;
  bool isRunning = false;

  int focusSeconds = 1500;
  int shortBreakSeconds = 300;
  int longBreakSeconds = 900;
  int longBreakInterval = 4;
  int completedPomodoros = 0;

  TimerMode currentMode = TimerMode.focus;
  TaskModel? selectedTask;

  void loadSettings(Map<String, dynamic> globalSettings, {TaskModel? task}) {
    if (task != null) selectedTask = task;

    focusSeconds = (globalSettings['focusTime'] ?? 25) * 60;
    shortBreakSeconds = (globalSettings['shortBreak'] ?? 5) * 60;
    longBreakSeconds = (globalSettings['longBreak'] ?? 15) * 60;
    longBreakInterval = globalSettings['longBreakInterval'] ?? 4;

    if (value == 0 && !isRunning) {
      resetToMode(currentMode);
    }
  }

  void _handleTimerFinish() {
    stopTimer();

    if (currentMode == TimerMode.focus) {
      completedPomodoros++;

      if (completedPomodoros % longBreakInterval == 0) {
        currentMode = TimerMode.longBreak;
        value = longBreakSeconds;
      } else {
        currentMode = TimerMode.shortBreak;
        value = shortBreakSeconds;
      }
    } else {
      currentMode = TimerMode.focus;
      value = focusSeconds;
    }
    notifyListeners();
  }

  void resetToMode(TimerMode mode) {
    currentMode = mode;
    if (mode == TimerMode.focus) {
      value = focusSeconds;
    } else if (mode == TimerMode.shortBreak) {
      value = shortBreakSeconds;
    } else {
      value = longBreakSeconds;
    }
    notifyListeners();
  }

  void startTimer() {
    if (isRunning) return;
    isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (value > 0) {
        value--;
      } else {
        _handleTimerFinish();
      }
    });
    notifyListeners();
  }

  void stopTimer() {
    _timer?.cancel();
    isRunning = false;
    notifyListeners();
  }

  void resetTimer() => resetToMode(currentMode);

  String get timerString {
    int minutes = value ~/ 60;
    int seconds = value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get progress {
    int total = (currentMode == TimerMode.focus)
        ? focusSeconds
        : (currentMode == TimerMode.shortBreak ? shortBreakSeconds : longBreakSeconds);
    return value / (total > 0 ? total : 1);
  }
}