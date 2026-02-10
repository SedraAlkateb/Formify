import 'package:formify/presentation/resources/routes_manager.dart';
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
  String routLogin(){
  int  isLog=_sharedPreferences.getInt(
      PREFS_KEY_LS_USER_LOGGED_IN,
    )??0;
  String startRoute=Routes.onboarding;
    if (isLog == 0) {
      startRoute = Routes.onboarding;
    } else if (isLog == 1) {
      startRoute = Routes.home;
    } else if (isLog == 2) {
      startRoute = Routes.showConference;
    } else if (isLog == 3) {
      startRoute = Routes.showConference;
    }
    return startRoute;
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
