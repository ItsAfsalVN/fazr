import 'package:fazr/models/completed_Task_model.dart';
import 'package:flutter/material.dart';
import '../services/database_services.dart';

class CompletedTaskProvider extends ChangeNotifier {
  List<CompletedTask> _completedTasks = [];
  bool _isLoading = false;

  List<CompletedTask> get completedTasks => _completedTasks;
  bool get isLoading => _isLoading;

  Future<void> fetchCompletedTasks() async {
    _isLoading = true;
    notifyListeners();
    try {
      final querySnapshot = await fetchCompletedTasksFromFireStore();

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
          task.completedDate.isAtSameMomentAs(completionDate),
    );
    notifyListeners();
  }
}