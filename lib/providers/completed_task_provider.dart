import 'package:fazr/models/completed_task_model.dart';
import 'package:fazr/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import '../services/database_services.dart';

class CompletedTaskProvider extends ChangeNotifier {
  List<CompletedTask> _completedTasks = [];
  bool _isLoading = false;

  List<CompletedTask> get completedTasks => _completedTasks;
  bool get isLoading => _isLoading;

  Future<void> fetchCompletedTasks(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    final userId = Provider.of<UserProvider>(context, listen: false).user?.id;

    if (userId == null) {
      _completedTasks = []; 
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final querySnapshot = await fetchCompletedTasksFromFireStore(userId);

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

  void removeCompletedTask(String taskId, DateTime completedDate) {
    _completedTasks.removeWhere(
      (task) =>
          task.taskId == taskId &&
          task.completedDate.isAtSameMomentAs(completedDate),
    );
    notifyListeners();
  }
}
