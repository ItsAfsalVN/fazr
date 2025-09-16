import 'package:flutter/material.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'History',
              style: TextStyle(
                color: colors.secondary,
                fontWeight: FontWeight.w600,
                fontSize: 32,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 16,
                  children: [
                    Row(
                      spacing: 8,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: colors.primary,
                          ),
                        ),
                        Text(
                          'Completed',
                          style: TextStyle(color: colors.primary),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 8,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: colors.error,
                          ),
                        ),
                        Text(
                          'Completed',
                          style: TextStyle(color: colors.primary),
                        ),
                      ],
                    ),
                  ],
                ),
                Icon(Icons.history, color: colors.primary, size: 32),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
