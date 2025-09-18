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
    context.read<TaskProvider>().setAlertAtStart(value);
  }

  void _onTitleChanged(String value) {
    context.read<TaskProvider>().setTitle(value);
  }

  void _onDescriptionChanged(String value) {
    context.read<TaskProvider>().setDescription(value);
  }

  void _onRepeatChanged(String value) {
    context.read<TaskProvider>().setRepeat(value);
  }

  void _createTask() {
    setState(() {
      isLoading = true;
    });
    try {
      context.read<TaskProvider>().createTask();
    } catch (error) {
      showSnackBar(context, SnackBarType.error, error.toString());
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
              CustomCalendar(
                onDateSelected: _selectStartDate,
                intialDateSelected: DateTime.now(),
              ),

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

                  TimeSelector(
                    onStartTimeSelected: _selectStartTime,
                    onEndTimeSelected: _selectEndTime,
                  ),
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
                  AddAlert(
                    onStartAlertSelected: _setAlertAtStart,
                    onEndAlertSelected: _setAlertAtEnd,
                  ),
                ],
              ),
              InputField(
                label: 'Title',
                hint: 'Enter the title',
                onChanged: _onTitleChanged,
              ),
              InputField(
                label: 'Description',
                hint: 'Enter the description',
                maxlines: 5,
                onChanged: _onDescriptionChanged,
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
                  RepeatSelector(onRepeatSelected: _onRepeatChanged),
                ],
              ),
              Button(
                label: 'Create Task',
                onTap: _createTask,
                borderRadius: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
