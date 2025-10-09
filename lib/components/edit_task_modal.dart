import 'package:fazr/components/add_alert.dart';
import 'package:fazr/components/button.dart';
import 'package:fazr/components/custom_calendar.dart';
import 'package:fazr/components/input_field.dart';
import 'package:fazr/components/repeat_selector.dart';
import 'package:fazr/components/time_selector.dart';
import 'package:fazr/models/task_model.dart';
import 'package:fazr/providers/task_provider.dart';
import 'package:fazr/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditTaskModal extends StatefulWidget {
  final TaskModel task;

  const EditTaskModal({super.key, required this.task});

  @override
  State<EditTaskModal> createState() => _EditTaskModalState();
}

class _EditTaskModalState extends State<EditTaskModal> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(
      text: widget.task.description,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final taskProvider = context.read<TaskProvider>();
      taskProvider.setTitle(widget.task.title);
      taskProvider.setDescription(widget.task.description);
      taskProvider.setStartTime(widget.task.startTime);
      taskProvider.setEndTime(widget.task.endTime);
      taskProvider.setStartingDate(widget.task.startingDate);
      taskProvider.setAlertAtStart(widget.task.alertAtStart);
      taskProvider.setAlertAtEnd(widget.task.alertAtEnd);
      taskProvider.setRepeat(widget.task.repeat);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateTask() async {
    final taskProvider = context.read<TaskProvider>();

    if (taskProvider.title.isEmpty || taskProvider.description.isEmpty) {
      showSnackBar(
        context,
        SnackBarType.error,
        'Title and description cannot be empty.',
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await taskProvider.updateTask(context, widget.task.uid!);

      if (mounted) {
        Navigator.pop(context);
        showSnackBar(
          context,
          SnackBarType.success,
          'Task updated successfully!',
        );
      }
    } catch (error) {
      if (mounted) {
        showSnackBar(context, SnackBarType.error, error.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xffEDEFF4),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Edit Task',
                style: TextStyle(
                  color: colors.secondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 16),
              CustomCalendar(),
              const SizedBox(height: 16),

              Text(
                'Change timings',
                style: TextStyle(
                  color: colors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),

              TimeSelector(),
              const SizedBox(height: 16),

              Text(
                'Change alerts',
                style: TextStyle(
                  color: colors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              AddAlert(),
              const SizedBox(height: 16),

              InputField(
                controller: _titleController,
                label: 'Title',
                hint: 'Enter title',
                onChanged: (value) =>
                    context.read<TaskProvider>().setTitle(value),
              ),
              const SizedBox(height: 16),

              InputField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Enter description',
                maxlines: 5,
                onChanged: (value) =>
                    context.read<TaskProvider>().setDescription(value),
              ),
              const SizedBox(height: 16),

              Text(
                'Change repeat modes',
                style: TextStyle(
                  color: colors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              RepeatSelector(),
              const SizedBox(height: 16),

              Button(
                label: 'Update task',
                onTap: _updateTask,
                borderRadius: 12,
                isLoading: isLoading,
              ),
            ],
          ),
        );
      },
    );
  }
}
