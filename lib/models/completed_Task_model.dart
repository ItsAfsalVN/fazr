import 'package:cloud_firestore/cloud_firestore.dart';

class CompletedTask {
  final String taskId;
  final DateTime completedDate; // Renamed for consistency

  CompletedTask({required this.taskId, required this.completedDate});

  factory CompletedTask.fromFirestore(Map<String, dynamic> data) {
    return CompletedTask(
      taskId: data['taskId'] as String,
      completedDate: (data['completedDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'taskId': taskId,
      'completedDate': Timestamp.fromDate(completedDate),
    };
  }
}