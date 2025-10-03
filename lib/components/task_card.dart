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

class TaskCard extends StatefulWidget {
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
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _isDismissed = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    if (_isDismissed) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: colors.error,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20.0),
              child: const Icon(Icons.delete, color: Colors.white, size: 32),
            ),
          ),
          Dismissible(
            key: ValueKey(widget.task.uid),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) async {
              if (widget.task.repeat != 'once') {
                final result = await showDialog<String>(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text('Delete Task'),
                      content: const Text(
                        'This is a recurring task. What would you like to delete?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop('cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop('instance'),
                          child: const Text('This Instance'),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop('all'),
                          style: TextButton.styleFrom(
                            foregroundColor: colors.error,
                          ),
                          child: const Text('All Instances'),
                        ),
                      ],
                    );
                  },
                );

                if (result == 'instance') {
                  setState(() {
                    _isDismissed = true;
                  });

                  try {
                    await taskProvider.deleteTaskInstance(
                      widget.task.uid!,
                      widget.selectedDate,
                    );
                    if (mounted) {
                      showSnackBar(
                        context,
                        SnackBarType.success,
                        'Task instance deleted successfully',
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      setState(() {
                        _isDismissed = false;
                      });
                      showSnackBar(
                        context,
                        SnackBarType.error,
                        'Failed to delete task instance: ${e.toString()}',
                      );
                    }
                  }
                  return true;
                } else if (result == 'all') {
                  setState(() {
                    _isDismissed = true;
                  });

                  try {
                    await taskProvider.deleteTask(widget.task.uid!);
                    if (mounted) {
                      showSnackBar(
                        context,
                        SnackBarType.success,
                        'Task deleted successfully',
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      setState(() {
                        _isDismissed = false;
                      });
                      showSnackBar(
                        context,
                        SnackBarType.error,
                        'Failed to delete task: ${e.toString()}',
                      );
                    }
                  }
                  return true;
                } else {
                  return false;
                }
              } else {
                final result = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text('Delete Task'),
                      content: const Text(
                        'Are you sure you want to delete this task?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(true),
                          style: TextButton.styleFrom(
                            foregroundColor: colors.error,
                          ),
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );

                if (result == true) {
                  setState(() {
                    _isDismissed = true;
                  });

                  try {
                    await taskProvider.deleteTask(widget.task.uid!);
                    if (mounted) {
                      showSnackBar(
                        context,
                        SnackBarType.success,
                        'Task deleted successfully',
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      setState(() {
                        _isDismissed = false;
                      });
                      showSnackBar(
                        context,
                        SnackBarType.error,
                        'Failed to delete task: ${e.toString()}',
                      );
                    }
                  }
                }

                return result ?? false;
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    blurStyle: BlurStyle.normal,
                    color: const Color.fromARGB(255, 218, 218, 218),
                    offset: Offset(0, 0),
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext context) {
                      return EditTaskModal(task: widget.task);
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
                              widget.task.title,
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
                                value: widget.isCompleted,
                                side: BorderSide(color: colors.primary),
                                onChanged: (bool? newValue) {
                                  if (newValue != null &&
                                      widget.task.uid != null) {
                                    taskProvider.updateTaskCompletion(
                                      widget.task.uid!,
                                      widget.selectedDate,
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
                          widget.task.description,
                          style: TextStyle(
                            color: colors.primary,
                            fontWeight: FontWeight.w300,
                            fontSize: 17,
                          ),
                        ),
                        CustomProgressBar(
                          value: calculateProgress(widget.task),
                          startTime: formatTime(context, widget.task.startTime),
                          endTime: formatTime(context, widget.task.endTime),
                          isFinished: widget.isTaskFinished,
                          selectedDate: widget.selectedDate,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
