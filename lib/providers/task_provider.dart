import 'package:fazr/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart'; // Import this
import '../services/database_services.dart'; // Ensure this path is correct

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
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
  }

  List<TaskModel> get tasks => [..._tasks];
}