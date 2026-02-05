import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryModel {
  final String id;
  final String taskId;
  final String taskTitle;
  final int durationMinutes;
  final String type;
  final DateTime completedAt;

  HistoryModel({
    required this.id,
    required this.taskId,
    required this.taskTitle,
    required this.durationMinutes,
    required this.type,
    required this.completedAt,
  });

  factory HistoryModel.fromFirestore(String id, Map<String, dynamic> data) {
    return HistoryModel(
      id: id,
      taskId: data['taskId'] ?? '',
      taskTitle: data['taskTitle'] ?? 'Tarefa removida',
      durationMinutes: data['durationMinutes'] ?? 0,
      type: data['type'] ?? 'focus',
      completedAt: (data['completedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}