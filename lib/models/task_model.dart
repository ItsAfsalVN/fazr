import 'package:flutter/material.dart';

class TaskModel {
  final String? uid;
  final String title;
  final String description;
  final DateTime startingDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final bool alertAtStart;
  final bool alertAtEnd;
  final String repeat;

  TaskModel({
    this.uid,
    required this.title,
    required this.description,
    required this.startingDate,
    required this.startTime,
    required this.endTime,
    required this.alertAtStart,
    required this.alertAtEnd,
    required this.repeat
  });

  // The copyWith method
  TaskModel copyWith({
    String? uid,
    String? title,
    String? description,
    DateTime? startingDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    bool? alertAtStart,
    bool? alertAtEnd,
    String? repeat
  }) {
    return TaskModel(
      uid: uid ?? this.uid,
      title: title ?? this.title,
      description: description ?? this.description,
      startingDate: startingDate ?? this.startingDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      alertAtStart: alertAtStart ?? this.alertAtStart,
      alertAtEnd: alertAtEnd ?? this.alertAtEnd,
      repeat: repeat ?? this.repeat
    );
  }
}