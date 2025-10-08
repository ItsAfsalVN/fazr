import 'package:fazr/models/history_model.dart';
import 'package:fazr/providers/completed_task_provider.dart';
import 'package:fazr/providers/history_provider.dart';
import 'package:fazr/providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final taskProvider = context.read<TaskProvider>();
      final completedProvider = context.read<CompletedTaskProvider>();
      final historyProvider = context.read<HistoryProvider>();

      await taskProvider.generateMissingHistory(
        completedProvider.completedTasks,
      );
      await historyProvider.fetchHistory();
    });
  }

  Future<void> _onClearHistory() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History?'),
        content: const Text(
          'This will permanently clear all history records. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await context.read<HistoryProvider>().clearHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Consumer<HistoryProvider>(
            builder: (context, historyProvider, child) {
              if (historyProvider.isLoading &&
                  historyProvider.history.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              final now = DateTime.now();
              final todayAtMidnight = DateTime(now.year, now.month, now.day);

              final pastHistory = historyProvider.history.where((item) {
                final itemDate = DateTime(
                  item.instanceDate.year,
                  item.instanceDate.month,
                  item.instanceDate.day,
                );
                return itemDate.isBefore(todayAtMidnight);
              }).toList();

              final Map<DateTime, List<HistoryModel>> groupedHistory = {};
              for (final item in pastHistory) {
                final dateKey = DateTime(
                  item.instanceDate.year,
                  item.instanceDate.month,
                  item.instanceDate.day,
                );
                if (!groupedHistory.containsKey(dateKey)) {
                  groupedHistory[dateKey] = [];
                }
                groupedHistory[dateKey]!.add(item);
              }

              final sortedDates = groupedHistory.keys.toList()
                ..sort((a, b) => b.compareTo(a));

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'History',
                    style: TextStyle(
                      color: colors.secondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // --- FIX: This Row widget has been properly structured ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: colors.primary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Completed',
                                style: TextStyle(color: colors.secondary),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: colors.error,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Missed',
                                style: TextStyle(color: colors.secondary),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete_sweep_outlined,
                          color: colors.secondary,
                          size: 32,
                        ),
                        tooltip: 'Clear History',
                        onPressed: _onClearHistory,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (groupedHistory.isEmpty)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.task_alt,
                              size: 56,
                              color: colors.primary.withOpacity(0.5),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No history found',
                              style: TextStyle(
                                color: colors.primary.withOpacity(0.7),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: sortedDates.length,
                        itemBuilder: (context, index) {
                          final date = sortedDates[index];
                          final itemsForDate = groupedHistory[date]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                ),
                                child: Text(
                                  DateFormat.yMMMMd().format(date),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: colors.primary,
                                  ),
                                ),
                              ),
                              Divider(color: colors.primary),
                              ...itemsForDate.map((item) {
                                return Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: item.status == 'completed'
                                        ? colors.primary
                                        : colors.error,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    item.taskTitle,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              }).toList(),
                              const SizedBox(height: 16),
                            ],
                          );
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
