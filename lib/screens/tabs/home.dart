import 'dart:async';
import 'package:fazr/components/category_select.dart';
import 'package:fazr/components/custom_progress_bar.dart';
import 'package:fazr/components/timeline_selector.dart';
import 'package:fazr/providers/date_provider.dart';
import 'package:fazr/providers/task_provider.dart';
import 'package:fazr/providers/completed_task_provider.dart'; // Import the new provider
import 'package:fazr/utils/format_time.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  // We no longer need this local variable
  // Map<String, bool> _completedTasks = {};

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().fetchAllTasks();
      // Fetch completed tasks when the page loads
      context.read<CompletedTaskProvider>().fetchCompletedTasks();
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<TaskProvider>().fetchAllTasks();
      context.read<CompletedTaskProvider>().fetchCompletedTasks();
    }
  }

  Future<void> _refreshTasks() async {
    await context.read<TaskProvider>().fetchAllTasks();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              // Use Column instead of Padding to have spacing
              // and remove the extra Column with 'spacing'
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Daily Tasks',
                        style: TextStyle(
                          color: colors.secondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 32,
                        ),
                      ),
                    ],
                  ),
                ),
                const TimelineSelector(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CategorySelect(),
                ),
              ],
            ),
            Expanded(
              // Add CompletedTaskProvider to the consumer
              child: Consumer3<TaskProvider, DateProvider, CompletedTaskProvider>(
                builder: (context, taskProvider, dateProvider, completedTaskProvider, child) {
                  final selectedDate = dateProvider.date;
                  final tasksForSelectedDate = taskProvider.getTasksForDate(
                    selectedDate,
                  );

                  return tasksForSelectedDate.isEmpty
                      ? const Center(child: Text('No tasks for this date'))
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: ListView.builder(
                            itemCount: tasksForSelectedDate.length,
                            itemBuilder: (context, index) {
                              final task = tasksForSelectedDate[index];

                              // Check if the current task is in the completed tasks list for the selected date
                              final bool isCompleted = completedTaskProvider.completedTasks.any(
                                (completedTask) => completedTask.taskId == task.uid && completedTask.completionDate.day == selectedDate.day,
                              );

                              return Container(
                                margin: EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Column(
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
                                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              value: isCompleted,
                                              side: BorderSide(
                                                color: colors.primary,
                                              ),
                                              onChanged: (bool? newValue) {
                                                if (newValue != null) {
                                                  // Use the provider to update the completion status
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
                                      // Your custom progress bar
                                      CustomProgressBar(
                                        value: .5, // You should calculate this value dynamically
                                        startTime: formatTime(
                                          context,
                                          task.startTime,
                                        ),
                                        endTime: formatTime(
                                          context,
                                          task.endTime,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}