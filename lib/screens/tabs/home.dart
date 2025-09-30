import 'dart:async';
import 'package:fazr/components/category_select.dart';
import 'package:fazr/components/custom_progress_bar.dart';
import 'package:fazr/components/edit_task_modal.dart';
import 'package:fazr/components/task_card.dart';
import 'package:fazr/components/timeline_selector.dart';
import 'package:fazr/providers/date_provider.dart';
import 'package:fazr/providers/task_provider.dart';
import 'package:fazr/providers/completed_task_provider.dart'; // Import the new provider
import 'package:fazr/utils/calculateProgress.dart';
import 'package:fazr/utils/format_time.dart';
import 'package:fazr/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().fetchAllTasks();
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
              spacing: 16,
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
              child:
                  Consumer3<TaskProvider, DateProvider, CompletedTaskProvider>(
                    builder:
                        (
                          context,
                          taskProvider,
                          dateProvider,
                          completedTaskProvider,
                          child,
                        ) {
                          final selectedDate = dateProvider.date;
                          final tasksForSelectedDate = taskProvider
                              .getTasksForDate(selectedDate);

                          return tasksForSelectedDate.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.task_alt,
                                        size: 56,
                                        color: colors.primary.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'No tasks for this date',
                                        style: TextStyle(
                                          color: colors.primary.withValues(
                                            alpha: 0.7,
                                          ),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                  ),
                                  child: ListView.builder(
                                    itemCount: tasksForSelectedDate.length,
                                    itemBuilder: (context, index) {
                                      final task = tasksForSelectedDate[index];

                                      final bool isCompleted =
                                          completedTaskProvider.completedTasks
                                              .any(
                                                (completedTask) =>
                                                    completedTask.taskId ==
                                                        task.uid &&
                                                    completedTask
                                                            .completionDate
                                                            .day ==
                                                        selectedDate.day,
                                              );

                                      final bool isTaskFinished = DateTime.now()
                                          .isAfter(
                                            DateTime(
                                              DateTime.now().year,
                                              DateTime.now().month,
                                              DateTime.now().day,
                                              task.endTime.hour,
                                              task.endTime.minute,
                                            ),
                                          );

                                      return TaskCard(
                                        task: task,
                                        selectedDate: selectedDate,
                                        isCompleted: isCompleted,
                                        isTaskFinished: isTaskFinished,
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
