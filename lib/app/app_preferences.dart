import 'package:shared_preferences/shared_preferences.dart';
const String PREFS_KEY_LS_USER_LOGGED_IN = "PREFS_KEY_LS_USER_LOGGED_IN";

class AppPreferences {
  final SharedPreferences _sharedPreferences;
  AppPreferences(this._sharedPreferences);

  Future<bool> setLoggedIn() async {
    await _sharedPreferences.setBool(PREFS_KEY_LS_USER_LOGGED_IN, true);
    // reload();
    return true;
  }
  Future<void> signOut() async {
    await _sharedPreferences.remove(PREFS_KEY_LS_USER_LOGGED_IN);
  }
  reload() async {
    await _sharedPreferences.reload();
  }
}
