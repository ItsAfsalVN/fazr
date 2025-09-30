// lib/components/task_card.dart

import 'package:fazr/components/edit_task_modal.dart';
import 'package:fazr/components/custom_progress_bar.dart';
import 'package:fazr/models/task_model.dart';
import 'package:fazr/providers/task_provider.dart';
import 'package:fazr/utils/show_snackbar.dart';
import 'package:fazr/utils/calculateProgress.dart';
import 'package:fazr/utils/format_time.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final DateTime selectedDate;
  final bool isCompleted;
  final bool isTaskFinished;

  const TaskCard({
    super.key,
    required this.task,
    required this.selectedDate,
    required this.isCompleted,
    required this.isTaskFinished,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return Dismissible(
      key: ValueKey(task.uid),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: colors.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Icon(Icons.delete, color: Colors.white, size: 32),
          ),
        ),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Delete Task'),
              content: const Text('Are you sure you want to delete this task?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  style: TextButton.styleFrom(foregroundColor: colors.error),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) async {
        try {
          await taskProvider.deleteTask(task.uid!);
          if (context.mounted) {
            showSnackBar(
              context,
              SnackBarType.success,
              'Task deleted successfully',
            );
          }
        } catch (e) {
          if (context.mounted) {
            showSnackBar(
              context,
              SnackBarType.error,
              'Failed to delete task: ${e.toString()}',
            );
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (BuildContext context) {
                return EditTaskModal(task: task);
              },
            ),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                spacing: 6,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          color: colors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                        ),
                      ),
                      Transform.scale(
                        scale: 1.3,
                        child: Checkbox(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          value: isCompleted,
                          side: BorderSide(color: colors.primary),
                          onChanged: (bool? newValue) {
                            if (newValue != null && task.uid != null) {
                              taskProvider.updateTaskCompletion(
                                task.uid!,
                                selectedDate,
                                newValue,
                                context,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Text(
                    task.description,
                    style: TextStyle(
                      color: colors.primary,
                      fontWeight: FontWeight.w300,
                      fontSize: 17,
                    ),
                  ),
                  CustomProgressBar(
                    value: calculateProgress(task),
                    startTime: formatTime(context, task.startTime),
                    endTime: formatTime(context, task.endTime),
                    isFinished: isTaskFinished,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
