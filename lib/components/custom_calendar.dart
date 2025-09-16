import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatefulWidget {
  const CustomCalendar({super.key});

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: colors.primary),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TableCalendar(
        focusedDay: _focusedDay,
        firstDay: DateTime(2020, 1, 1),
        lastDay: DateTime(2030, 12, 31),

        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),

        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },

        calendarFormat: _calendarFormat,

        availableCalendarFormats: {
          CalendarFormat.month: 'Month',
          CalendarFormat.week: 'Week',
        },

        onFormatChanged: (format) => setState(() {
          _calendarFormat = format;
        }),

        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: colors.primary),
          weekendStyle: TextStyle(color: colors.primary),
        ),

        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          defaultTextStyle: TextStyle(color: colors.primary),

          todayDecoration: BoxDecoration(
            color: colors.primary.withValues(alpha: .5),
            shape: BoxShape.circle,
          ),

          selectedDecoration: BoxDecoration(
            color: colors.primary,
            shape: BoxShape.circle,
          ),

          selectedTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),

          weekendTextStyle: TextStyle(color: colors.primary),
        ),
      ),
    );
  }
}
