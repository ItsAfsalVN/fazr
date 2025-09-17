import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatefulWidget {
  final Function(DateTime)? onDateSelected;
  final DateTime intialDateSelected;
  const CustomCalendar({super.key, this.onDateSelected, required this.intialDateSelected});

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();

@override
  void initState() {
    super.initState();
    _selectedDay = widget.intialDateSelected;
  }
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

        focusedDay: _focusedDay,
        firstDay: DateTime(2020, 1, 1),
        lastDay: DateTime(2030, 12, 31),

        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),

        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          if (widget.onDateSelected != null) {
            widget.onDateSelected!(selectedDay);
          }
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
