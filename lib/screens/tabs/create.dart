import 'package:fazr/components/add_alert.dart';
import 'package:fazr/components/button.dart';
import 'package:fazr/components/custom_calendar.dart';
import 'package:fazr/components/input_field.dart';
import 'package:fazr/components/repeat_selector.dart';
import 'package:fazr/components/time_selector.dart';
import 'package:fazr/providers/task_provider.dart';
import 'package:fazr/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Create extends StatefulWidget {
  Create({super.key});

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  bool isLoading = false;
  // Create controllers for your input fields
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose the controllers when the widget is removed from the tree
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _selectStartDate(DateTime selectedDate) {
    context.read<TaskProvider>().setStartingDate(selectedDate);
  }

  void _selectStartTime(TimeOfDay startTime) {
    context.read<TaskProvider>().setStartTime(startTime);
  }

  void _selectEndTime(TimeOfDay endTime) {
    context.read<TaskProvider>().setEndTime(endTime);
  }

  void _setAlertAtStart(bool value) {
    context.read<TaskProvider>().setAlertAtStart(value);
  }

  void _setAlertAtEnd(bool value) {
    context.read<TaskProvider>().setAlertAtEnd(value);
  }

  void _createTask() async {
    final taskProvider = context.read<TaskProvider>();

    if (taskProvider.title.isEmpty || taskProvider.description.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSnackBar(
          context,
          SnackBarType.error,
          'Title and description cannot be empty.',
        );
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await taskProvider.createTask();
      _titleController.clear();
      _descriptionController.clear();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSnackBar(
          context,
          SnackBarType.success,
          'Task created successfully!',
        );
      });
    } catch (error) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSnackBar(context, SnackBarType.error, error.toString());
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Task',
                style: TextStyle(
                  color: colors.secondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 32,
                ),
              ),
              CustomCalendar(),
              Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Time',
                    style: TextStyle(
                      color: colors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TimeSelector(),
                ],
              ),
              Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Need alert ?',
                    style: TextStyle(
                      color: colors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AddAlert(),
                ],
              ),
              InputField(
                controller: _titleController,
                label: 'Title',
                hint: 'Enter the title',
                onChanged: (value) =>
                    context.read<TaskProvider>().setTitle(value),
              ),
              InputField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Enter the description',
                maxlines: 5,
                onChanged: (value) =>
                    context.read<TaskProvider>().setDescription(value),
              ),
              Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Repeat',
                    style: TextStyle(
                      color: colors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  RepeatSelector(),
                ],
              ),
              Button(
                label: 'Create Task',
                onTap: _createTask,
                borderRadius: 12,
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
