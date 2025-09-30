import 'package:fazr/models/task_model.dart';

double calculateProgress(TaskModel task) {
  final now = DateTime.now();
  final taskStart = DateTime(
    now.year,
    now.month,
    now.day,
    task.startTime.hour,
    task.startTime.minute,
  );
  final taskEnd = DateTime(
    now.year,
    now.month,
    now.day,
    task.endTime.hour,
    task.endTime.minute,
  );

  if (now.isBefore(taskStart)) {
    return 0.0;
  }
  if (now.isAfter(taskEnd)) {
    return 1.0;
  }

  final totalDuration = taskEnd.difference(taskStart).inSeconds;

  final elapsedDuration = now.difference(taskStart).inSeconds;

  return elapsedDuration / totalDuration;
}
