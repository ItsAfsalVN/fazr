// lib/components/custom_progress_bar.dart

import 'package:flutter/material.dart';

class CustomProgressBar extends StatelessWidget {
  final double value;
  final String startTime;
  final String endTime;

  const CustomProgressBar({
    super.key,
    required this.value,
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
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

        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              height: 16,
              width: constraints.maxWidth * value.clamp(0.0, 1.0),
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
            );
          },
        ),

        Positioned(
          left: 6,
          child: Text(
            startTime,
            style: const TextStyle(
              color: Color(0xffD6E3DA),
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
              color: colors.primary,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
