import 'package:fazr/models/completed_task_model.dart';
import 'package:fazr/models/task_model.dart';
import 'package:fazr/providers/completed_task_provider.dart';
import 'package:fazr/utils/set_alarm_instance.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/database_services.dart';

class TaskProvider extends ChangeNotifier {
  List<TaskModel> _tasks = [];
  bool _isLoading = false;

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
    rrule: "",
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

  Future<void> createTask(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      final rruleString = _generateRruleString();
      _temporaryTask = _temporaryTask.copyWith(rrule: rruleString);

      final jsonTask = _temporaryTask.toJson();
      final taskId = await createTaskInFireStore(jsonTask);
      final newTask = _temporaryTask.copyWith(uid: taskId);
      await scheduleNextTaskAlarm(newTask);

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
        rrule: '',
      );
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllTasks() async {
    _isLoading = true;
    notifyListeners();
    try {
      final querySnapshot = await fetchAllTasksFromFireStore();
      _tasks = querySnapshot.docs.map((doc) {
        return TaskModel.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print("Error fetching tasks: $e");
    } finally {
      _isLoading = false;
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
    final task = _tasks.firstWhere(
      (t) => t.uid == taskId,
      orElse: () => _temporaryTask,
    );

    try {
      if (isCompleted) {
        await addCompletedTaskInFireStore(taskId, date);
        completedTaskProvider.addCompletedTask(
          CompletedTask(taskId: taskId, completedDate: date),
        );

        await createOrUpdateHistoryRecord(
          taskId: taskId,
          taskTitle: task.title,
          instanceDate: date,
          status: 'completed',
        );
      } else {
        await deleteCompletedTaskFromFireStore(taskId, date);
        completedTaskProvider.removeCompletedTask(taskId, date);

        await createOrUpdateHistoryRecord(
          taskId: taskId,
          taskTitle: task.title,
          instanceDate: date,
          status: 'missed',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTask(BuildContext context, String taskId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final rruleString = _generateRruleString();
      _temporaryTask = _temporaryTask.copyWith(rrule: rruleString);
      final updatedTask = _temporaryTask.copyWith(uid: taskId);

      await updateTaskInFireStore(taskId, updatedTask.toJson());
      await scheduleNextTaskAlarm(updatedTask);

      final taskIndex = _tasks.indexWhere((task) => task.uid == taskId);
      if (taskIndex != -1) {
        _tasks[taskIndex] = updatedTask;
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
        rrule: "",
      );
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTask(String taskId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await deleteTaskFromFireStore(taskId);
      _tasks.removeWhere((task) => task.uid == taskId);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
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
    print("Generating missing history...");
    _isLoading = true;
    notifyListeners();

    final today = DateTime.now();
    final yesterday = DateTime(
      today.year,
      today.month,
      today.day,
    ).subtract(const Duration(days: 1));

    final completedInstances = completedTasks.map((c) {
      final dateKey = DateTime(
        c.completedDate.year,
        c.completedDate.month,
        c.completedDate.day,
      );
      return '${c.taskId}_${dateKey.toIso8601String()}';
    }).toSet();

    for (int i = 0; i < 30; i++) {
      final dateToCheck = yesterday.subtract(Duration(days: i));
      final tasksForDay = getTasksForDate(dateToCheck);

      for (final task in tasksForDay) {
        if (DateTime(
          task.startingDate.year,
          task.startingDate.month,
          task.startingDate.day,
        ).isAfter(dateToCheck)) {
          continue;
        }

        bool recordExists = await doesHistoryRecordExist(
          task.uid!,
          dateToCheck,
        );

        if (!recordExists) {
          final normalizedDate = DateTime(
            dateToCheck.year,
            dateToCheck.month,
            dateToCheck.day,
          );
          final instanceKey = '${task.uid}_${normalizedDate.toIso8601String()}';
          final status = completedInstances.contains(instanceKey)
              ? 'completed'
              : 'missed';

          print(
            'Creating "${status}" record for ${task.title} on $dateToCheck',
          );
          await createHistoryRecordInFirestore(
            taskId: task.uid!,
            taskTitle: task.title,
            instanceDate: dateToCheck,
            status: status,
          );
        }
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  String _generateRruleString() {
    switch (_temporaryTask.repeat) {
      case 'daily':
        return 'RRULE:FREQ=DAILY';
      case 'weekly':
        return 'RRULE:FREQ=WEEKLY';
      case 'monthly':
        return 'RRULE:FREQ=MONTHLY';
      case 'once':
      default:
        return '';
    }
  }
}
