import 'package:fazr/models/task_model.dart';
import 'package:flutter/material.dart';

class TaskProvider extends ChangeNotifier {
  List<TaskModel> _tasks = [];
  TaskModel _temporaryTask = TaskModel(
    uid: '', 
    title: '',
    description: '',
    startingDate: DateTime.now(),
    startTime: TimeOfDay.now(),
    endTime: TimeOfDay.now(),
    alertAtStart: false,
    alertAtEnd: false,
    repeat: "once"
  );

  String get title => _temporaryTask.title;
  String get description => _temporaryTask.description;
  DateTime get startingDate => _temporaryTask.startingDate;
  TimeOfDay get startTime => _temporaryTask.startTime;
  TimeOfDay get endTime => _temporaryTask.endTime;
  bool get alertAtStart => _temporaryTask.alertAtStart;
  bool get alertAtEnd => _temporaryTask.alertAtEnd;

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

  void setRepeat(String value){
    _temporaryTask = _temporaryTask.copyWith(repeat: value);
    notifyListeners();
  }

  List<TaskModel> get tasks => [..._tasks];
}