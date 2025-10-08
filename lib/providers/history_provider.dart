import 'package:flutter/material.dart';
import '../models/history_model.dart';
import '../services/database_services.dart';

class HistoryProvider extends ChangeNotifier {
  List<HistoryModel> _history = [];
  bool _isLoading = false;

  List<HistoryModel> get history => _history;
  bool get isLoading => _isLoading;

  Future<void> fetchHistory() async {
    _isLoading = true;
    notifyListeners();
    try {
      final querySnapshot = await fetchHistoryFromFirestore();
      _history = querySnapshot.docs.map((doc) {
        return HistoryModel.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
      // Sort by date, newest first
      _history.sort((a, b) => b.instanceDate.compareTo(a.instanceDate));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearHistory() async {
    _isLoading = true;
    notifyListeners();
    try {
      // Simple and clean: just delete all documents.
      await clearAllHistoryInFirestore(); 
      _history.clear();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}