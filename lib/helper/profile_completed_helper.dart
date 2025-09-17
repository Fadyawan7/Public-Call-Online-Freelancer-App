import 'package:shared_preferences/shared_preferences.dart';

class ProfileHelper {
  static const String _profileCompletedKey = 'profileCompleted';

  static Future<void> setProfileCompleted(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_profileCompletedKey, value);
  }

  static Future<bool> isProfileCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_profileCompletedKey) ?? false;
  }
}