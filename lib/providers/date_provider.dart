import 'package:flutter/material.dart';

class DateProvider extends ChangeNotifier {
  DateTime _date = DateTime.now();

  DateTime get date => _date;

  void setDate(DateTime date) {
    _date = date;
    notifyListeners();
  }
}
