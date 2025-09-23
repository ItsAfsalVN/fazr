import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class RepeatSelector extends StatelessWidget {
  final List<String> _repeats = ["Once", "Daily", "Weekly", "Monthly"];
  RepeatSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    // Watch the TaskProvider for the current repeat value.
    final selectedRepeat = context.watch<TaskProvider>().repeat;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: colors.primary),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _repeats.map((repeat) {
            final isSelected = selectedRepeat == repeat.toLowerCase();
            final backgroundColor = isSelected ? colors.primary : Colors.white;
            final textColor = isSelected ? Colors.white : colors.primary;

            return GestureDetector(
              onTap: () {
                // Update the provider state directly.
                context.read<TaskProvider>().setRepeat(repeat.toLowerCase());
              },
              child: Container(
                width: 80,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Center(
                    child: Text(repeat, style: TextStyle(color: textColor)),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
