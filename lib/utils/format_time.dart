import 'package:flutter/material.dart';

String formatTime(BuildContext context, TimeOfDay time) {
  final MaterialLocalizations localizations = MaterialLocalizations.of(context);
  return localizations.formatTimeOfDay(time);
}
