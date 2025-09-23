import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class AddAlert extends StatelessWidget {
  const AddAlert({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final taskProvider = context.watch<TaskProvider>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: colors.primary),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.alarm, color: colors.primary),
                      const SizedBox(width: 6),
                      Text(
                        'At the start',
                        style: TextStyle(color: colors.primary),
                      ),
                    ],
                  ),
                  Checkbox(
                    side: BorderSide(color: colors.primary, width: 2),
                    value: taskProvider.alertAtStart,
                    onChanged: (value) {
                      context.read<TaskProvider>().setAlertAtStart(value!);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: colors.primary),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.alarm, color: colors.primary),
                      const SizedBox(width: 6),
                      Text(
                        'At the end',
                        style: TextStyle(color: colors.primary),
                      ),
                    ],
                  ),
                  Checkbox(
                    side: BorderSide(color: colors.primary, width: 2),
                    value: taskProvider.alertAtEnd,
                    onChanged: (value) {
                      context.read<TaskProvider>().setAlertAtEnd(value!);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
