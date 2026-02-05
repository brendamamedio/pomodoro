class TaskModel {
  final String id;
  final String title;
  final bool isCompleted;
  final int totalPomodoros;
  int completedPomodoros;
  final String userId;

  TaskModel({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.totalPomodoros = 1,
    this.completedPomodoros = 0,
    required this.userId,
  });

  factory TaskModel.fromFirestore(String id, Map<String, dynamic> data) {
    return TaskModel(
      id: id,
      title: data['title'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
      totalPomodoros: data['totalPomodoros'] is int
          ? data['totalPomodoros']
          : int.tryParse(data['totalPomodoros']?.toString() ?? '1') ?? 1,
      completedPomodoros: data['completedPomodoros'] is int
          ? data['completedPomodoros']
          : int.tryParse(data['completedPomodoros']?.toString() ?? '0') ?? 0,
      userId: data['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'totalPomodoros': totalPomodoros,
      'completedPomodoros': completedPomodoros,
      'userId': userId,
    };
  }

  TaskModel copyWith({
    String? title,
    bool? isCompleted,
    int? totalPomodoros,
    int? completedPomodoros,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      totalPomodoros: totalPomodoros ?? this.totalPomodoros,
      completedPomodoros: completedPomodoros ?? this.completedPomodoros,
      userId: userId,
    );
  }
}