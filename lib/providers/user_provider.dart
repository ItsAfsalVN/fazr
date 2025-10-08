import 'package:fazr/services/cache_services.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/database_services.dart';
import '../services/storage_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  final CacheService _cacheService = CacheService();
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> syncUserOnAppStart(String userId) async {
    _isLoading = true;
    notifyListeners();

    _user = await getUserFromFireStore(userId);
    if (_user == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    final cachedUrl = await _cacheService.getAvatarUrl();
    if (cachedUrl != null) {
      _user = _user!.copyWith(avatar: cachedUrl);
    }

    final githubUrl = await getAvatarUrlFromGitHub(userId);

    if (githubUrl != null && githubUrl != _user!.avatar) {
      await updateUserAvatar(githubUrl);
    } else if (githubUrl != null && _user!.avatar == null) {
      await updateUserAvatar(githubUrl);
    } else {
      print("Local avatar is up-to-date.");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateUserAvatar(String newUrl) async {
    if (_user == null) return;

    _user = _user!.copyWith(avatar: newUrl);
    notifyListeners();

    await updateUserInFirestore(_user!.id, {'avatar': newUrl});
    await _cacheService.saveAvatarUrl(newUrl);
  }

  Future<void> updateUserName(String newFullName) async {
    if (_user == null) return;

    _user = _user!.copyWith(fullname: newFullName);
    notifyListeners();

    await updateUserInFirestore(_user!.id, {'fullname': newFullName});
  }

  void clearUser() {
    _user = null;
    _cacheService.clearAvatarUrl();
    notifyListeners();
  }

  void setUser(UserModel newUser) {
    _user = newUser;
    notifyListeners();
  }
}
