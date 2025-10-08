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
      _history.sort((a, b) => b.instanceDate.compareTo(a.instanceDate));
    } catch(e) {
      print("Error fetching history: $e");
    }
    finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearHistory() async {
    _isLoading = true;
    notifyListeners();
    try {
      await clearAllHistoryInFirestore(); 
      _history.clear();
    } catch(e) {
      print("Error clearing history: $e");
    }
    finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}