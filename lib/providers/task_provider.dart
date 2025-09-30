import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fazr/models/completed_Task_model.dart';
import 'package:fazr/models/task_model.dart';
import 'package:fazr/providers/completed_task_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/database_services.dart';

class TaskProvider extends ChangeNotifier {
  List<TaskModel> _tasks = [];

  TaskModel _temporaryTask = TaskModel(
    uid: null,
    title: '',
    description: '',
    startingDate: DateTime.now(),
    startTime: TimeOfDay.now(),
    endTime: TimeOfDay.now(),
    alertAtStart: false,
    alertAtEnd: false,
    repeat: "once",
  );

  CalendarFormat _calendarFormat = CalendarFormat.month;

  // Getters
  String get title => _temporaryTask.title;
  String get description => _temporaryTask.description;
  DateTime get startingDate => _temporaryTask.startingDate;
  TimeOfDay get startTime => _temporaryTask.startTime;
  TimeOfDay get endTime => _temporaryTask.endTime;
  bool get alertAtStart => _temporaryTask.alertAtStart;
  bool get alertAtEnd => _temporaryTask.alertAtEnd;
  String get repeat => _temporaryTask.repeat;
  CalendarFormat get calendarFormat => _calendarFormat;
  List<TaskModel> get tasks => [..._tasks];

  void setTitle(String value) {
    _temporaryTask = _temporaryTask.copyWith(title: value);
    notifyListeners();
  }

  void setDescription(String value) {
    _temporaryTask = _temporaryTask.copyWith(description: value);
    notifyListeners();
  }

  void setStartingDate(DateTime? date) {
    if (date != null) {
      _temporaryTask = _temporaryTask.copyWith(startingDate: date);
      notifyListeners();
    }
  }

  void setStartTime(TimeOfDay? time) {
    if (time != null) {
      _temporaryTask = _temporaryTask.copyWith(startTime: time);
      notifyListeners();
    }
  }

  void setEndTime(TimeOfDay? time) {
    if (time != null) {
      _temporaryTask = _temporaryTask.copyWith(endTime: time);
      notifyListeners();
    }
  }

  void setAlertAtStart(bool value) {
    _temporaryTask = _temporaryTask.copyWith(alertAtStart: value);
    notifyListeners();
  }

  void setAlertAtEnd(bool value) {
    _temporaryTask = _temporaryTask.copyWith(alertAtEnd: value);
    notifyListeners();
  }

  void setRepeat(String value) {
    _temporaryTask = _temporaryTask.copyWith(repeat: value);
    notifyListeners();
  }

  void setCalendarFormat(CalendarFormat format) {
    _calendarFormat = format;
    notifyListeners();
  }

  Map<String, dynamic> toJson(TaskModel task) {
    return {
      'title': task.title,
      'description': task.description,
      'startingDate': task.startingDate.toIso8601String(),
      'startTime': '${task.startTime.hour}:${task.startTime.minute}',
      'endTime': '${task.endTime.hour}:${task.endTime.minute}',
      'alertAtStart': task.alertAtStart,
      'alertAtEnd': task.alertAtEnd,
      'repeat': task.repeat,
    };
  }

  Future<void> createTask() async {
    final jsonTask = toJson(_temporaryTask);

    try {
      final taskId = await createTaskInFireStore(jsonTask);
      final newTask = _temporaryTask.copyWith(uid: taskId);

      _tasks.add(newTask);

      _temporaryTask = TaskModel(
        uid: null,
        title: '',
        description: '',
        startingDate: DateTime.now(),
        startTime: TimeOfDay.now(),
        endTime: TimeOfDay.now(),
        alertAtStart: false,
        alertAtEnd: false,
        repeat: "once",
      );

      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> fetchAllTasks() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .get();

      _tasks = querySnapshot.docs.map((doc) {
        return TaskModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print("Error fetching tasks: $e");
    } finally {
      notifyListeners();
    }
  }

  List<TaskModel> getTasksForDate(DateTime targetDate) {
    List<TaskModel> tasksForDate = [];

    final normalizedTargetDate = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
    );

    for (var task in _tasks) {
      final normalizedStartingDate = DateTime(
        task.startingDate.year,
        task.startingDate.month,
        task.startingDate.day,
      );

      if (task.repeat == 'once') {
        if (normalizedStartingDate.isAtSameMomentAs(normalizedTargetDate)) {
          tasksForDate.add(task);
        }
      } else {
        if (normalizedStartingDate.isAfter(normalizedTargetDate)) {
          continue;
        }

        switch (task.repeat) {
          case 'daily':
            tasksForDate.add(task);
            break;

          case 'weekly':
            if (normalizedStartingDate.weekday ==
                normalizedTargetDate.weekday) {
              tasksForDate.add(task);
            }
            break;

          case 'monthly':
            if (normalizedStartingDate.day == normalizedTargetDate.day) {
              tasksForDate.add(task);
            }
            break;
        }
      }
    }
    return tasksForDate;
  }

  Future<void> updateTaskCompletion(
    String taskId,
    DateTime date,
    bool isCompleted,
    BuildContext context,
  ) async {
    final completedTaskProvider = Provider.of<CompletedTaskProvider>(
      context,
      listen: false,
    );

    try {
      if (isCompleted) {
        await FirebaseFirestore.instance.collection('completed_tasks').add({
          'taskId': taskId,
          'completionDate': Timestamp.fromDate(date),
        });

        completedTaskProvider.addCompletedTask(
          CompletedTask(taskId: taskId, completionDate: date),
        );
      } else {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('completed_tasks')
            .where('taskId', isEqualTo: taskId)
            .where('completionDate', isEqualTo: Timestamp.fromDate(date))
            .get();
        for (var doc in querySnapshot.docs) {
          await doc.reference.delete();
        }
        completedTaskProvider.removeCompletedTask(taskId, date);
      }
    } catch (e) {
      print("Error updating task completion: $e");
      throw e;
    }
  }

  Future<void> updateTask(String taskId) async {
    final jsonTask = toJson(_temporaryTask);

    try {
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .update(jsonTask);

      final taskIndex = _tasks.indexWhere((task) => task.uid == taskId);

      if (taskIndex != -1) {
        _tasks[taskIndex] = _temporaryTask.copyWith(uid: taskId);
      }

      _temporaryTask = TaskModel(
        uid: null,
        title: '',
        description: '',
        startingDate: DateTime.now(),
        startTime: TimeOfDay.now(),
        endTime: TimeOfDay.now(),
        alertAtStart: false,
        alertAtEnd: false,
        repeat: "once",
      );

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();

      _tasks.removeWhere((task) => task.uid == taskId);

      notifyListeners();
    } catch (e) {
      print("Error deleting task: $e");
      throw e;
    }
  }
}
