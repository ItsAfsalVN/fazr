import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fazr/models/completed_Task_model.dart';
import 'package:flutter/material.dart';

class CompletedTaskProvider extends ChangeNotifier {
  List<CompletedTask> _completedTasks = [];
  bool _isLoading = false;

  List<CompletedTask> get completedTasks => _completedTasks;
  bool get isLoading => _isLoading;

  Future<void> fetchCompletedTasks() async {
    _isLoading = true;
    notifyListeners();
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('completed_tasks')
          .get();

      _completedTasks = querySnapshot.docs.map((doc) {
        return CompletedTask.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (error) {
      print("Error fetching completed tasks: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addCompletedTask(CompletedTask completedTask) {
    _completedTasks.add(completedTask);
    notifyListeners();
  }

  void removeCompletedTask(String taskId, DateTime completionDate) {
    _completedTasks.removeWhere(
      (task) =>
          task.taskId == taskId &&
          task.completionDate.isAtSameMomentAs(completionDate),
    );
    notifyListeners();
  }
}
