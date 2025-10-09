import 'dart:async';
import 'package:fazr/components/category_select.dart';
import 'package:fazr/components/task_card.dart';
import 'package:fazr/components/timeline_selector.dart';
import 'package:fazr/models/task_model.dart';
import 'package:fazr/providers/date_provider.dart';
import 'package:fazr/providers/task_provider.dart';
import 'package:fazr/providers/completed_task_provider.dart';
import 'package:fazr/utils/request_permissions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  Timer? _timer;
  String _selectedCategory = 'All';

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
    requestPermissions();
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

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
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
                const SizedBox(height: 16),
                const TimelineSelector(),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CategorySelect(
                    selectedCategory: _selectedCategory,
                    onCategorySelected: _onCategorySelected,
                  ),
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
                          final allTasksForDate = taskProvider.getTasksForDate(
                            selectedDate,
                          );

                          bool isTaskCompleted(TaskModel task) {
                            final normalizedSelectedDate = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                            );
                            return completedTaskProvider.completedTasks.any((
                              completedTask,
                            ) {
                              final normalizedCompletedDate = DateTime(
                                completedTask.completedDate.year,
                                completedTask.completedDate.month,
                                completedTask.completedDate.day,
                              );
                              return completedTask.taskId == task.uid &&
                                  normalizedCompletedDate.isAtSameMomentAs(
                                    normalizedSelectedDate,
                                  );
                            });
                          }

                          final List<TaskModel> filteredTasks;
                          if (_selectedCategory == 'Completed') {
                            filteredTasks = allTasksForDate
                                .where(isTaskCompleted)
                                .toList();
                          } else if (_selectedCategory == 'Incomplete') {
                            filteredTasks = allTasksForDate
                                .where((task) => !isTaskCompleted(task))
                                .toList();
                          } else {
                            filteredTasks = allTasksForDate;
                          }

                          return filteredTasks.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.task_alt,
                                        size: 56,
                                        color: colors.primary.withValues(
                                          alpha: .5,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'No tasks for this date',
                                        style: TextStyle(
                                          color: colors.primary.withValues(
                                            alpha: .7,
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
                                    itemCount: filteredTasks.length,
                                    itemBuilder: (context, index) {
                                      final task = filteredTasks[index];
                                      final bool isCompleted = isTaskCompleted(
                                        task,
                                      );

                                      final bool isTaskFinished = DateTime.now()
                                          .isAfter(
                                            DateTime(
                                              selectedDate.year,
                                              selectedDate.month,
                                              selectedDate.day,
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
