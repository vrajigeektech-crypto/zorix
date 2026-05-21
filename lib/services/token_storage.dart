import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String _keyIdToken = 'auth_id_token';

  Future<void> saveIdToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyIdToken, token);
  }

  Future<String?> getIdToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyIdToken);
  }

  Future<void> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyIdToken);
  }
}
