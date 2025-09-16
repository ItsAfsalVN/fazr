import 'package:flutter/material.dart';

class AddAlert extends StatefulWidget {
  const AddAlert({super.key});

  @override
  State<AddAlert> createState() => _AddAlertState();
}

class _AddAlertState extends State<AddAlert> {
  bool alarmAtStart = false;
  bool alarmAtEnd = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      spacing: 12,
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
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 6,
                    children: [
                      Icon(Icons.alarm, color: colors.primary),
                      Text(
                        'At the start',
                        style: TextStyle(color: colors.primary),
                      ),
                    ],
                  ),
                  Checkbox(
                    side: BorderSide(color: colors.primary, width: 2),
                    value: alarmAtStart,
                    onChanged: (value) => setState(() {
                      alarmAtStart = value!;
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: colors.primary),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Row(
                    spacing: 6,
                    children: [
                      Icon(Icons.alarm, color: colors.primary),
                      Text(
                        'At the end',
                        style: TextStyle(color: colors.primary),
                      ),
                    ],
                  ),
                  Checkbox(
                    side: BorderSide(color: colors.primary, width: 2),
                    value: alarmAtEnd,
                    onChanged: (value) => setState(() {
                      alarmAtEnd = value!;
                    }),
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
