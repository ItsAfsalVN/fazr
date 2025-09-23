import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class TimeSelector extends StatelessWidget {
  const TimeSelector({super.key});

  int get12HourFormat(int hour) {
    if (hour == 0) return 12;
    if (hour > 12) return hour - 12;
    return hour;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final taskProvider = context.watch<TaskProvider>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () async {
            final TimeOfDay? selectedTime = await showTimePicker(
              context: context,
              initialTime: taskProvider.startTime,
            );
            if (selectedTime != null) {
              context.read<TaskProvider>().setStartTime(selectedTime);
            }
          },
          child: Row(
            children: [
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: colors.primary),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                    child: Text(
                      get12HourFormat(taskProvider.startTime.hour)
                          .toString()
                          .padLeft(2, '0'),
                      style: TextStyle(
                        color: colors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: colors.primary),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                    child: Text(
                      taskProvider.startTime.minute.toString().padLeft(2, '0'),
                      style: TextStyle(
                        color: colors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: colors.primary,
                  border: Border.all(color: colors.primary),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    taskProvider.startTime.format(context).split(' ').last,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Container(
            height: 4,
            width: 10,
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            final TimeOfDay? selectedTime = await showTimePicker(
              context: context,
              initialTime: taskProvider.endTime,
            );
            if (selectedTime != null) {
              context.read<TaskProvider>().setEndTime(selectedTime);
            }
          },
          child: Row(
            children: [
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: colors.primary),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                    child: Text(
                      get12HourFormat(taskProvider.endTime.hour)
                          .toString()
                          .padLeft(2, '0'),
                      style: TextStyle(
                        color: colors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: colors.primary),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                    child: Text(
                      taskProvider.endTime.minute.toString().padLeft(2, '0'),
                      style: TextStyle(
                        color: colors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: colors.primary,
                  border: Border.all(color: colors.primary),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    taskProvider.endTime.format(context).split(' ').last,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}