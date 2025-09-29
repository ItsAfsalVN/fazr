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

  // If the task has not started yet or has already ended
  if (now.isBefore(taskStart)) {
    return 0.0;
  }
  if (now.isAfter(taskEnd)) {
    return 1.0;
  }

  // Calculate the total duration of the task
  final totalDuration = taskEnd.difference(taskStart).inMinutes;

  // Calculate the time elapsed since the task started
  final elapsedDuration = now.difference(taskStart).inMinutes;

  // Calculate the progress as a percentage (value between 0.0 and 1.0)
  return elapsedDuration / totalDuration;
}
