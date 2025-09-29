import 'package:cloud_firestore/cloud_firestore.dart';

class CompletedTask {
  final String taskId;
  final DateTime completionDate; 

  CompletedTask({required this.taskId, required this.completionDate});

  factory CompletedTask.fromFirestore(Map<String, dynamic> data) {
    return CompletedTask(
      taskId: data['taskId'] as String,
      completionDate: (data['completionDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'taskId': taskId,
      'completionDate': Timestamp.fromDate(completionDate),
    };
  }
}