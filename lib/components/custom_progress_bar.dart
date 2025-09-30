// lib/components/custom_progress_bar.dart

import 'package:flutter/material.dart';

class CustomProgressBar extends StatelessWidget {
  final double value;
  final String startTime;
  final String endTime;
  final bool isFinished;

  const CustomProgressBar({
    super.key,
    required this.value,
    required this.startTime,
    required this.endTime,
    required this.isFinished,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final backgroundColor = isFinished ? colors.error : colors.primary;

    return LayoutBuilder(
      builder: (context, constraints) {
        final progressWidth = constraints.maxWidth * value.clamp(0.0, 1.0);
        final startTextCovered = progressWidth > 44;
        final endTextCovered = progressWidth > (constraints.maxWidth - 44);

        final startTextColor = startTextCovered
            ? const Color(0xffD6E3DA)
            : backgroundColor;
        final endTextColor = endTextCovered
            ? const Color(0xffD6E3DA)
            : backgroundColor;

        return Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              height: 16,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xffD6E3DA),
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            Container(
              height: 16,
              width: progressWidth,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            Positioned(
              left: 6,
              child: Text(
                startTime,
                style: TextStyle(
                  color: startTextColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),

            Positioned(
              right: 6,
              child: Text(
                endTime,
                style: TextStyle(
                  color: endTextColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
