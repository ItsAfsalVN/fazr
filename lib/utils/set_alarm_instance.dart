import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:fazr/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rrule/rrule.dart';
import 'package:fazr/models/task_model.dart';

@pragma('vm:entry-point')
void alarmCallback(int id, Map<String, dynamic> params) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  await NotificationService().initNotifications();
  final String title = params['title'] as String;
  final String body = params['body'] as String;
  NotificationService().showNotification(title: title, body: body);
  print("Notification shown: $title - $body");
}

Future<void> scheduleNextTaskAlarm(TaskModel task) async {
  final int startAlarmId = task.uid!.hashCode;
  final int endAlarmId = ('${task.uid!}_end').hashCode;

  await AndroidAlarmManager.cancel(startAlarmId);
  await AndroidAlarmManager.cancel(endAlarmId);

  if (task.rrule.isEmpty) {
    print("Task '${task.title}' has no repeat rule. No alarms set.");
    return;
  }

  final recurrenceRule = RecurrenceRule.fromString(task.rrule);
  final DateTime originalStartDateLocal = DateTime(
    task.startingDate.year,
    task.startingDate.month,
    task.startingDate.day,
    task.startTime.hour,
    task.startTime.minute,
  );

  final allInstances = recurrenceRule.getInstances(
    start: originalStartDateLocal.toUtc(),
  );

  final futureInstances = allInstances.where(
    (instance) => instance.toLocal().isAfter(DateTime.now()),
  );

  if (futureInstances.isEmpty) {
    print("No future instances for task '${task.title}'.");
    return;
  }

  final DateTime nextStartTimeLocal = futureInstances.first.toLocal();

  if (task.alertAtStart) {
    print("Scheduling START alarm for '${task.title}' at $nextStartTimeLocal");
    await AndroidAlarmManager.oneShotAt(
      nextStartTimeLocal,
      startAlarmId,
      alarmCallback,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
      params: {
        'title': task.title,
        'body': 'Your task "${task.title}" is starting now.',
      },
    );
  }

  if (task.alertAtEnd) {
    DateTime nextEndTimeLocal = DateTime(
      nextStartTimeLocal.year,
      nextStartTimeLocal.month,
      nextStartTimeLocal.day,
      task.endTime.hour,
      task.endTime.minute,
    );

    final startTimeInMinutes = task.startTime.hour * 60 + task.startTime.minute;
    final endTimeInMinutes = task.endTime.hour * 60 + task.endTime.minute;

    if (endTimeInMinutes <= startTimeInMinutes) {
      nextEndTimeLocal = nextEndTimeLocal.add(const Duration(days: 1));
    }

    if (nextEndTimeLocal.isAfter(DateTime.now())) {
      print("Scheduling END alarm for '${task.title}' at $nextEndTimeLocal");
      await AndroidAlarmManager.oneShotAt(
        nextEndTimeLocal,
        endAlarmId,
        alarmCallback,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true,
        params: {
          'title': task.title,
          'body': 'Your task "${task.title}" has ended.',
        },
      );
    }
  }
}
