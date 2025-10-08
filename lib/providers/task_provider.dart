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
      rethrow;
    }
  }

  Future<void> fetchAllTasks() async {
    try {
      final querySnapshot = await fetchAllTasksFromFireStore();

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
    final dateKey = normalizedTargetDate.toIso8601String().split('T')[0];

    for (var task in _tasks) {
      if (task.deletedInstances?.contains(dateKey) ?? false) {
        continue;
      }

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
        await addCompletedTaskInFireStore(taskId, date);
        completedTaskProvider.addCompletedTask(
          CompletedTask(taskId: taskId, completedDate: date),
        );
      } else {
        final querySnapshot = await getCompletedTaskFromFireStore(taskId, date);
        for (var doc in querySnapshot.docs) {
          await deleteCompletedTaskFromFireStore(doc.id);
        }
        completedTaskProvider.removeCompletedTask(taskId, date);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTask(String taskId) async {
    final jsonTask = toJson(_temporaryTask);

    try {
      await updateTaskInFireStore(taskId, jsonTask);

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
      rethrow;
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await deleteTaskFromFireStore(taskId);
      _tasks.removeWhere((task) => task.uid == taskId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTaskInstance(String taskId, DateTime date) async {
    try {
      final dateKey = date.toIso8601String().split('T')[0];
      await deleteInstanceInFireStore(taskId, date);

      final taskIndex = _tasks.indexWhere((t) => t.uid == taskId);
      if (taskIndex != -1) {
        final task = _tasks[taskIndex];
        final updatedDeletedInstances = List<String>.from(
          task.deletedInstances ?? [],
        )..add(dateKey);

        _tasks[taskIndex] = task.copyWith(
          deletedInstances: updatedDeletedInstances,
        );
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> generateMissingHistory(
  List<CompletedTask> completedTasks,
) async {
  try {
    final tasks = _tasks;
    final today = DateTime.now();
    final yesterday = DateTime(
      today.year,
      today.month,
      today.day,
    ).subtract(const Duration(days: 1));

    for (final task in tasks) {
      // startingDate is already a DateTime, no need to parse
      DateTime currentDate = DateTime(
        task.startingDate.year,
        task.startingDate.month,
        task.startingDate.day,
      );

      // For 'once' tasks, only check the starting date
      if (task.repeat == 'once') {
        if (currentDate.isBefore(yesterday) ||
            currentDate.isAtSameMomentAs(yesterday)) {
          final dateKey = currentDate.toIso8601String().split('T')[0];
          final isDeleted = task.deletedInstances?.contains(dateKey) ?? false;

          if (!isDeleted) {
            final wasCompleted = completedTasks.any(
              (completed) =>
                  completed.taskId == task.uid &&
                  completed.completedDate.year == currentDate.year &&
                  completed.completedDate.month == currentDate.month &&
                  completed.completedDate.day == currentDate.day,
            );

            await createHistoryRecordInFirestore(
              taskId: task.uid!,
              taskTitle: task.title,
              instanceDate: currentDate,
              status: wasCompleted ? 'completed' : 'missed',
            );
          }
        }
        continue;
      }

      // For recurring tasks (daily, weekly, monthly)
      while (currentDate.isBefore(yesterday) ||
          currentDate.isAtSameMomentAs(yesterday)) {
        final dateKey = currentDate.toIso8601String().split('T')[0];
        final isDeleted = task.deletedInstances?.contains(dateKey) ?? false;

        if (!isDeleted) {
          bool shouldCreateHistory = false;

          // Check if this date matches the repeat pattern
          switch (task.repeat) {
            case 'daily':
              shouldCreateHistory = true;
              break;

            case 'weekly':
              if (task.startingDate.weekday == currentDate.weekday) {
                shouldCreateHistory = true;
              }
              break;

            case 'monthly':
              if (task.startingDate.day == currentDate.day) {
                shouldCreateHistory = true;
              }
              break;
          }

          if (shouldCreateHistory) {
            final wasCompleted = completedTasks.any(
              (completed) =>
                  completed.taskId == task.uid &&
                  completed.completedDate.year == currentDate.year &&
                  completed.completedDate.month == currentDate.month &&
                  completed.completedDate.day == currentDate.day,
            );

            await createHistoryRecordInFirestore(
              taskId: task.uid!,
              taskTitle: task.title,
              instanceDate: currentDate,
              status: wasCompleted ? 'completed' : 'missed',
            );
          }
        }

        // Move to next day
        currentDate = currentDate.add(const Duration(days: 1));
      }
    }
  } catch (e) {
    print('Error generating missing history: $e');
  }
}
}
