// lib/providers/user_provider.dart

import 'package:fazr/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  void setUser(UserModel newUser) {
    _user = newUser;
    notifyListeners();
  }

  void updateUserAvatar(String avatarUrl) {
    if (_user != null) {
      _user = _user!.copyWith(avatar: avatarUrl);
      notifyListeners();
    }
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}