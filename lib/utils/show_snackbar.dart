
import 'package:flutter/material.dart';

enum SnackBarType {
  success,
  error,
  info
}

void showSnackBar(BuildContext context, SnackBarType type, String message) {
  Color backgroundColor;
  IconData icon;

  switch (type) {
    case SnackBarType.success:
      backgroundColor = Colors.green;
      icon = Icons.check_circle_outline;
      break;
    case SnackBarType.error:
      backgroundColor = Colors.red;
      icon = Icons.error_outline;
      break;
    case SnackBarType.info:
      backgroundColor = Colors.blue;
      icon = Icons.info_outline;
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis, 
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
    ),
  );
}