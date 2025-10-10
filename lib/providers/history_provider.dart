import 'package:fazr/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/history_model.dart';
import '../services/database_services.dart';

class HistoryProvider extends ChangeNotifier {
  List<HistoryModel> _history = [];
  bool _isLoading = false;

  List<HistoryModel> get history => _history;
  bool get isLoading => _isLoading;

  Future<void> fetchHistory(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    final userId = Provider.of<UserProvider>(context, listen: false).user?.id;
    if (userId == null) {
      _history = [];
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final querySnapshot = await fetchHistoryFromFirestore(userId);
      _history = querySnapshot.docs.map((doc) {
        return HistoryModel.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
      _history.sort((a, b) => b.instanceDate.compareTo(a.instanceDate));
    } catch (e) {
      print("Error fetching history: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearHistory(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    final userId = Provider.of<UserProvider>(context, listen: false).user?.id;
    if (userId == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      await clearAllHistoryInFirestore(userId);
      _history.clear();
    } catch (e) {
      print("Error clearing history: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
