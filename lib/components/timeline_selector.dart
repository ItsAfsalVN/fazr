import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fazr/providers/date_provider.dart';

class TimelineSelector extends StatelessWidget {
  const TimelineSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final dateProvider = Provider.of<DateProvider>(
      context,
    ); // Remove listen: false
    final date = DateTime.now();
    final today = DateTime(date.year, date.month, date.day);

    return EasyDateTimeLine(
      initialDate: today,
      onDateChange: (selectedDate) {
        dateProvider.setDate(selectedDate);
      },
      dayProps: EasyDayProps(
        height: 90,
        dayStructure: DayStructure.dayStrDayNum,
        inactiveDayStyle: DayStyle(
          dayNumStyle: TextStyle(
            color: colors.primary,
            fontSize: 32,
            fontWeight: FontWeight.w600,
          ),
          dayStrStyle: TextStyle(
            color: colors.primary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.primary),
          ),
        ),
        activeDayStyle: DayStyle(
          dayNumStyle: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w600,
          ),
          dayStrStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: colors.primary,
            border: Border.all(color: colors.primary),
          ),
        ),
        todayStyle: DayStyle(
          dayNumStyle: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w600,
          ),
          dayStrStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: .7),
            border: Border.all(color: colors.primary.withValues(alpha: .7)),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      headerProps: const EasyHeaderProps(showHeader: false),
    );
  }
}
