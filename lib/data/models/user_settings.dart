class UserSettings {
  final int focusTime;
  final int shortBreak;
  final int longBreak;

  UserSettings({
    required this.focusTime,
    required this.shortBreak,
    required this.longBreak,
  });

  factory UserSettings.fromFirestore(Map<String, dynamic> data) {
    final settings = data['settings'] as Map<String, dynamic>? ?? {};
    return UserSettings(
      focusTime: settings['focusTime'] ?? 25,
      shortBreak: settings['shortBreak'] ?? 5,
      longBreak: settings['longBreak'] ?? 15,
    );
  }
}