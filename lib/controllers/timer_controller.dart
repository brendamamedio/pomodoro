import 'dart:async';
import 'package:flutter/material.dart';
import '../data/models/task_model.dart';

enum TimerMode { focus, shortBreak, longBreak }

class TimerController extends ChangeNotifier {
  static final TimerController _instance = TimerController._internal();
  factory TimerController() => _instance;
  TimerController._internal();

  Timer? _timer;
  TimerMode currentMode = TimerMode.focus;

  int _value = 1500;
  int _focusSeconds = 1500;
  int _shortBreakSeconds = 300;
  int _longBreakSeconds = 900;
  int _longBreakInterval = 4;
  int _completedPomodoros = 0;

  bool _isRunning = false;
  TaskModel? _selectedTask;

  int get value => _value;
  int get focusSeconds => _focusSeconds;
  int get shortBreakSeconds => _shortBreakSeconds;
  int get longBreakSeconds => _longBreakSeconds;
  int get longBreakInterval => _longBreakInterval;
  int get completedPomodoros => _completedPomodoros;
  bool get isRunning => _isRunning;
  TaskModel? get selectedTask => _selectedTask;

  set completedPomodoros(int val) {
    _completedPomodoros = val;
    notifyListeners();
  }

  set selectedTask(TaskModel? task) {
    _selectedTask = task;
    notifyListeners();
  }

  double get progress {
    int total = currentMode == TimerMode.focus
        ? _focusSeconds
        : (currentMode == TimerMode.shortBreak ? _shortBreakSeconds : _longBreakSeconds);
    return 1.0 - (_value / total);
  }

  String get timerString {
    int minutes = _value ~/ 60;
    int seconds = _value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void updateSettings({
    required int focusMin,
    required int shortMin,
    required int longMin,
    required int interval,
  }) {
    _focusSeconds = focusMin * 60;
    _shortBreakSeconds = shortMin * 60;
    _longBreakSeconds = longMin * 60;
    _longBreakInterval = interval;

    if (!_isRunning) {
      _resetToMode(currentMode);
    }
    notifyListeners();
  }

  void startTimer() {
    if (_isRunning) return;
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_value > 0) {
        _value--;
        notifyListeners();
      } else {
        _handleTimerFinished();
      }
    });
    notifyListeners();
  }

  void stopTimer() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void resetTimer() {
    stopTimer();
    _resetToMode(currentMode);
    notifyListeners();
  }

  void _resetToMode(TimerMode mode) {
    currentMode = mode;
    switch (mode) {
      case TimerMode.focus:
        _value = _focusSeconds;
        break;
      case TimerMode.shortBreak:
        _value = _shortBreakSeconds;
        break;
      case TimerMode.longBreak:
        _value = _longBreakSeconds;
        break;
    }
  }

  void _handleTimerFinished() {
    stopTimer();
    if (currentMode == TimerMode.focus) {
      _completedPomodoros++;
      if (_completedPomodoros % _longBreakInterval == 0) {
        _resetToMode(TimerMode.longBreak);
      } else {
        _resetToMode(TimerMode.shortBreak);
      }
    } else {
      _resetToMode(TimerMode.focus);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void clearSelectedTask() {
    _selectedTask = null;
    notifyListeners();
  }
}