import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:fazr/components/category_select.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatelessWidget {
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final DateTime today = DateTime.now();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Daily Tasks',
                style: TextStyle(
                  color: colors.secondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 32,
                ),
              ),
            ),
            EasyDateTimeLine(
              initialDate: today,
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
                    border: Border.all(
                      color: colors.primary.withValues(alpha: .7),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              headerProps: const EasyHeaderProps(showHeader: false),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CategorySelect(),
            ),
          ],
        ),
      ),
    );
  }
}
