import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rrule/rrule.dart';
import 'package:fazr/models/task_model.dart';

@pragma('vm:entry-point')
void alarmCallback(int id, Map<String, dynamic> params) async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();

    final taskId = params['taskId'] as String?;
    final alertType = params['alertType'] as String?;

    print("Task ID: $taskId, Alert Type: $alertType");
  } catch (e) {
    print("Error in alarm callback: $e");
  }
}

Future<void> scheduleNextTaskAlarm(TaskModel task) async {
  final int startAlarmId = task.uid!.hashCode;
  final int endAlarmId = (task.uid! + '_end').hashCode;

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

  final DateTime originalStartDateAsUtc = originalStartDateLocal.toUtc();

  final allInstances = recurrenceRule.getInstances(
    start: originalStartDateAsUtc,
  );

  final now = DateTime.now();
  final futureInstances = allInstances.where(
    (instance) => instance.toLocal().isAfter(now),
  );

  if (futureInstances.isEmpty) {
    print("No future instances for task '${task.title}'.");
    return;
  }

  final DateTime nextStartTimeLocal = futureInstances.first.toLocal();

  if (task.alertAtStart) {
    final success = await AndroidAlarmManager.oneShotAt(
      nextStartTimeLocal,
      startAlarmId,
      alarmCallback,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
      params: {'taskId': task.uid!, 'alertType': 'start'},
    );
    print("Alarm scheduled: $success");
  }

  if (task.alertAtEnd) {
    final DateTime nextEndTimeLocal = DateTime(
      nextStartTimeLocal.year,
      nextStartTimeLocal.month,
      nextStartTimeLocal.day,
      task.endTime.hour,
      task.endTime.minute,
    );

    if (nextEndTimeLocal.isAfter(nextStartTimeLocal)) {
      final success = await AndroidAlarmManager.oneShotAt(
        nextEndTimeLocal,
        endAlarmId,
        alarmCallback,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true,
        params: {'taskId': task.uid!, 'alertType': 'end'},
      );
      print("End alarm scheduled: $success");
    }
  }
}
