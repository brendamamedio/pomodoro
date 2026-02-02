class TaskModel {
  final String id;
  final String title;
  final bool isCompleted;
  final String userId;

  TaskModel({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'userId': userId,
      'createdAt': DateTime.now(),
    };
  }

  factory TaskModel.fromFirestore(String id, Map<String, dynamic> map) {
    return TaskModel(
      id: id,
      title: map['title'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      userId: map['userId'] ?? '',
    );
  }
}