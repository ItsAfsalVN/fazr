import 'package:cloud_firestore/cloud_firestore.dart';
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
  final List<String>? deletedInstances; 
  final String rrule;
  final String userId;


  TaskModel({
    this.uid,
    required this.title,
    required this.description,
    required this.startingDate,
    required this.startTime,
    required this.endTime,
    required this.alertAtStart,
    required this.alertAtEnd,
    required this.repeat,
    required this.rrule,
    required this.userId,
    this.deletedInstances,
  });

  factory TaskModel.fromJson(String id, Map<String, dynamic> data) {
    return TaskModel(
      uid: id,
      title: data['title'] as String,
      description: data['description'] as String,
      startingDate: (data['startingDate'] is Timestamp)
          ? (data['startingDate'] as Timestamp).toDate()
          : DateTime.parse(data['startingDate'] as String),
      startTime: TimeOfDay(
        hour: int.parse(data['startTime'].split(':')[0]),
        minute: int.parse(data['startTime'].split(':')[1]),
      ),
      endTime: TimeOfDay(
        hour: int.parse(data['endTime'].split(':')[0]),
        minute: int.parse(data['endTime'].split(':')[1]),
      ),
      alertAtStart: data['alertAtStart'] as bool,
      alertAtEnd: data['alertAtEnd'] as bool,
      repeat: data['repeat'] as String,
      rrule: data['rrule'] as String,
      userId: data['userId'] as String,
      deletedInstances: data['deletedInstances'] != null
          ? List<String>.from(data['deletedInstances'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'startingDate': Timestamp.fromDate(startingDate),
      'startTime': '${startTime.hour}:${startTime.minute}',
      'endTime': '${endTime.hour}:${endTime.minute}',
      'alertAtStart': alertAtStart,
      'alertAtEnd': alertAtEnd,
      'repeat': repeat,
      'rrule' : rrule,
      'userId' : userId,
      'deletedInstances': deletedInstances ?? [],
    };
  }

  TaskModel copyWith({
    String? uid,
    String? title,
    String? description,
    DateTime? startingDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    bool? alertAtStart,
    bool? alertAtEnd,
    String? repeat,
    String? rrule,
    String? userId,
    List<String>? deletedInstances,
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
      repeat: repeat ?? this.repeat,
      rrule: rrule ?? this.rrule,
      userId: userId ?? this.userId,
      deletedInstances: deletedInstances ?? this.deletedInstances,
    );
  }
}