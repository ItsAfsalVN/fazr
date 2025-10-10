import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryModel {
  final String taskId;
  final String taskTitle;
  final DateTime instanceDate;
  final String status; 
  final String userId;

  HistoryModel({
    required this.taskId,
    required this.taskTitle,
    required this.instanceDate,
    required this.status,
    required this.userId
  });

  factory HistoryModel.fromFirestore(Map<String, dynamic> data) {
    return HistoryModel(
      taskId: data['taskId'],
      taskTitle: data['taskTitle'],
      instanceDate: (data['instanceDate'] as Timestamp).toDate(),
      status: data['status'],
      userId: data['userId']
    );
  }
}