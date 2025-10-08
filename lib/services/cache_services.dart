import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const String _avatarUrlKey = 'user_avatar_url';

  Future<void> saveAvatarUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_avatarUrlKey, url);
  }

  Future<String?> getAvatarUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_avatarUrlKey);
  }

  Future<void> clearAvatarUrl() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_avatarUrlKey);
  }
}