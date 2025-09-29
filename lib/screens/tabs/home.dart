import 'dart:async';
import 'package:fazr/components/category_select.dart';
import 'package:fazr/components/custom_progress_bar.dart';
import 'package:fazr/components/timeline_selector.dart';
import 'package:fazr/providers/date_provider.dart';
import 'package:fazr/providers/task_provider.dart';
import 'package:fazr/utils/format_time.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  // Use a Map to store the completion state for each task locally
  Map<String, bool> _completedTasks = {};

  // You will still need the Timer for real-time progress bar updates
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().fetchAllTasks();
    });
    // Start a timer to refresh the UI every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel(); // Cancel the timer
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<TaskProvider>().fetchAllTasks();
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
              child: Consumer2<TaskProvider, DateProvider>(
                builder: (context, taskProvider, dateProvider, child) {
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

                              final bool isCompleted =
                                  _completedTasks[task.uid] ?? false;

                              return Container(
                                margin: EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6),
                                  child: Column(
                                    spacing: 12,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              value: isCompleted,

                                              side: BorderSide(
                                                color: colors.primary,
                                              ),
                                              onChanged: (bool? newValue) {
                                                if (newValue != null) {
                                                  setState(() {
                                                    _completedTasks[task.uid!] =
                                                        newValue;
                                                  });
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
                                        value: .5,
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
