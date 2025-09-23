import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class CustomCalendar extends StatelessWidget {
  const CustomCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final taskProvider = context.watch<TaskProvider>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: colors.primary),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TableCalendar(
        headerStyle: HeaderStyle(
          titleTextStyle: TextStyle(
            color: colors.primary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          leftChevronIcon: Icon(
            Icons.keyboard_arrow_left_rounded,
            color: colors.primary,
          ),
          rightChevronIcon: Icon(
            Icons.keyboard_arrow_right_rounded,
            color: colors.primary,
          ),
          formatButtonDecoration: BoxDecoration(
            border: Border.all(color: colors.primary),
            borderRadius: BorderRadius.circular(12),
          ),
          formatButtonTextStyle: TextStyle(color: colors.primary),
        ),

        focusedDay: taskProvider.startingDate,
        firstDay: DateTime(2020, 1, 1),
        lastDay: DateTime(2030, 12, 31),

        selectedDayPredicate: (day) =>
            isSameDay(taskProvider.startingDate, day),

        onDaySelected: (selectedDay, focusedDay) {
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          if (selectedDay.isBefore(today)) {
            // Optional: Show a message to the user
            return;
          }

          context.read<TaskProvider>().setStartingDate(selectedDay);
        },

        calendarFormat: taskProvider.calendarFormat,
        availableCalendarFormats: const {
          CalendarFormat.month: 'Month',
          CalendarFormat.week: 'Week',
        },
        
        onFormatChanged: (format) {
          context.read<TaskProvider>().setCalendarFormat(format);
        },

        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: colors.primary),
          weekendStyle: TextStyle(color: colors.primary),
        ),

        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          defaultTextStyle: TextStyle(color: colors.primary),

          todayDecoration: BoxDecoration(
            color: colors.primary.withOpacity(.5),
            shape: BoxShape.circle,
          ),

          selectedDecoration: BoxDecoration(
            color: colors.primary,
            shape: BoxShape.circle,
          ),

          selectedTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),

          weekendTextStyle: TextStyle(color: colors.primary),
        ),
      ),
    );
  }
}