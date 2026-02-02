import 'dart:async';
import 'package:flutter/material.dart';

class TimerController extends ValueNotifier<int> {
  Timer? _timer;
  bool isRunning = false;
  int initialSeconds = 1500;

  TimerController() : super(1500);

  void setInitialTime(int seconds) {
    if (!isRunning && initialSeconds != seconds) {
      initialSeconds = seconds;
      value = seconds;
      notifyListeners();
    }
  }

  void startTimer() {
    if (isRunning) return;
    isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (value > 0) {
        value--;
      } else {
        stopTimer();
      }
    });
    notifyListeners();
  }

  void stopTimer() {
    _timer?.cancel();
    isRunning = false;
    notifyListeners();
  }

  void resetTimer() {
    stopTimer();
    value = initialSeconds;
    notifyListeners();
  }

  String get timerString {
    int minutes = value ~/ 60;
    int seconds = value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get progress => value / initialSeconds;
}