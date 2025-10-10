import 'package:cloud_firestore/cloud_firestore.dart';

class CompletedTask {
  final String taskId;
  final DateTime completedDate;
  final String userId;

  CompletedTask({
    required this.taskId,
    required this.completedDate,
    required this.userId,
  });

  factory CompletedTask.fromFirestore(Map<String, dynamic> data) {
    return CompletedTask(
      taskId: data['taskId'] as String,
      completedDate: (data['completedDate'] as Timestamp).toDate(),
      userId: data['userId'] as String,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'taskId': taskId,
      'completedDate': Timestamp.fromDate(completedDate),
      'userId': userId,
    };
  }
}
