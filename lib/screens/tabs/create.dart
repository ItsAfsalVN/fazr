import 'package:fazr/components/custom_calendar.dart';
import 'package:fazr/components/input_field.dart';
import 'package:fazr/components/time_selector.dart';
import 'package:flutter/material.dart';

class Create extends StatelessWidget {
  const Create({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SingleChildScrollView(
        child: Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
            child: Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Task',
                  style: TextStyle(
                    color: colors.secondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 32,
                  ),
                ),
                CustomCalendar(),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Time',
                      style: TextStyle(
                        color: colors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    TimeSelector(),
                  ],
                ),
                InputField(label: 'Title', hint: 'Enter the title'),
                InputField(
                  label: 'Description',
                  hint: 'Enter the description',
                  maxlines: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
