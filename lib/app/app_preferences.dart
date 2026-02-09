import 'package:shared_preferences/shared_preferences.dart';

const String PREFS_KEY_LS_USER_LOGGED_IN = "PREFS_KEY_LS_USER_LOGGED_IN";

class AppPreferences {
  final SharedPreferences _sharedPreferences;
  AppPreferences(this._sharedPreferences);
  int isLoggedIn() {
    return _sharedPreferences.getInt(
      PREFS_KEY_LS_USER_LOGGED_IN,
    ) ??
        0;
  }
  Future<bool> setLoggedIn(int log) async {
    await _sharedPreferences.setInt(PREFS_KEY_LS_USER_LOGGED_IN, log);
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
