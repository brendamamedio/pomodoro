import 'dart:async';
import 'package:flutter/material.dart';

enum TimerMode { focus, shortBreak, longBreak }

class TimerController extends ValueNotifier<int> {
  Timer? _timer;
  bool isRunning = false;

  int focusSeconds = 1500;
  int shortBreakSeconds = 300;
  int longBreakSeconds = 900;

  int longBreakInterval = 4;
  int completedPomodoros = 0;

  TimerMode currentMode = TimerMode.focus;

  TimerController() : super(1500);

  void updateSettings({
    required int focusMin,
    required int shortMin,
    required int longMin,
    required int interval,
  }) {
    focusSeconds = focusMin * 60;
    shortBreakSeconds = shortMin * 60;
    longBreakSeconds = longMin * 60;
    longBreakInterval = interval;

    if (!isRunning) {
      resetToMode(currentMode);
    }
  }

  void resetToMode(TimerMode mode) {
    currentMode = mode;
    switch (mode) {
      case TimerMode.focus:
        value = focusSeconds;
        break;
      case TimerMode.shortBreak:
        value = shortBreakSeconds;
        break;
      case TimerMode.longBreak:
        value = longBreakSeconds;
        break;
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

  void stopTimer() {
    _timer?.cancel();
    isRunning = false;
    notifyListeners();
  }

  void resetTimer() {
    stopTimer();
    resetToMode(currentMode);
  }

  String get timerString {
    int minutes = value ~/ 60;
    int seconds = value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get progress {
    int total;
    if (currentMode == TimerMode.focus) {
      total = focusSeconds;
    } else if (currentMode == TimerMode.shortBreak) {
      total = shortBreakSeconds;
    } else {
      total = longBreakSeconds;
    }
    return value / (total > 0 ? total : 1);
  }
}