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
    final DateTime todayMidnight = DateTime(today.year, today.month, today.day);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
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
              headerProps: EasyHeaderProps(showHeader: false),
              initialDate: todayMidnight,
              itemBuilder: (context, date, isSelected, onTap) {
                final bool isToday =
                    date.day == todayMidnight.day &&
                    date.month == todayMidnight.month &&
                    date.year == todayMidnight.year;

                return InkWell(
                  onTap: onTap,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colors.primary
                          : (isToday
                                ? colors.primary.withAlpha(128)
                                : Colors.white),
                      border: Border.all(color: colors.primary),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('E').format(date).toUpperCase(),
                            style: TextStyle(
                              color: isSelected || isToday
                                  ? Colors.white
                                  : colors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            date.day.toString(),
                            style: TextStyle(
                              height: .8,
                              color: isSelected || isToday
                                  ? Colors.white
                                  : colors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 32,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CategorySelect(),
            ),
          ],
        ),
      ),
    );
  }
}
