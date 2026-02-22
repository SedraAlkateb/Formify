import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String PREFS_KEY_LS_USER_LOGGED_IN = "PREFS_KEY_LS_USER_LOGGED_IN";
const String PREFS_KEY_GAME_OR_SURVEY = "PREFS_KEY_GAME_OR_SURVEY";
const String PREFS_KEY_PASSWORD = "PREFS_KEY_PASSWORD";
const String PREFS_KEY_CONFERENCE_ID = "PREFS_KEY_CONFERENCE_ID";

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
  String startRoute=Routes.loginPage;
    if (isLog == 0) {
      startRoute = Routes.loginPage;
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
  Future<bool> setPassword(String password) async {
    await _sharedPreferences.setString(PREFS_KEY_PASSWORD, password);
    // reload();
    return true;
  }
  String? getPassword()  {
    return   _sharedPreferences.getString(PREFS_KEY_PASSWORD);

  }
  Future<bool> setConferenceId(int conferenceId) async {
    await _sharedPreferences.setInt(PREFS_KEY_CONFERENCE_ID, conferenceId);
    return true;
  }
  int? getConferenceId()  {
    return   _sharedPreferences.getInt(PREFS_KEY_CONFERENCE_ID);
  }
  int isGame() {
    return _sharedPreferences.getInt(
      PREFS_KEY_GAME_OR_SURVEY,
    ) ??
        0;
  }
  Future<bool> setGameORSurvey(int game) async {
    await _sharedPreferences.setInt(PREFS_KEY_GAME_OR_SURVEY, game);
    return true;
  }
  Future<void> signOut() async {
    await _sharedPreferences.remove(PREFS_KEY_LS_USER_LOGGED_IN);
    await _sharedPreferences.remove(PREFS_KEY_GAME_OR_SURVEY);
  }

  reload() async {
    await _sharedPreferences.reload();
  }
}
