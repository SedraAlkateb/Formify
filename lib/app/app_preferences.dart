import 'package:formify/domain/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String PREFS_KEY_LS_USER_LOGGED_IN = "PREFS_KEY_LS_USER_LOGGED_IN";
const String PREFS_KEY_repId = "PREFS_KEY_repId";
const String PREFS_KEY_name = "PREFS_KEY_name";
const String PREFS_KEY_repType = "PREFS_KEY_repType";
const String PREFS_KEY_CITYID = "PREFS_KEY_CITYID";
const String PREFS_KEY_SampleCount = "PREFS_KEY_SampleCount";

class AppPreferences {
  final SharedPreferences _sharedPreferences;
  AppPreferences(this._sharedPreferences);

  // on board is logging
  Future<bool> setLoggedIn(LoginModel? loginModel) async {
    if(loginModel==null){
      return false;
    }
    await _sharedPreferences.setBool(PREFS_KEY_LS_USER_LOGGED_IN, true);
    await _sharedPreferences.setInt(PREFS_KEY_repId, loginModel.repId);
    await _sharedPreferences.setString(PREFS_KEY_name, loginModel.name);
    await _sharedPreferences.setString(PREFS_KEY_repType, loginModel.repType);
    await _sharedPreferences.setInt(PREFS_KEY_CITYID, loginModel.cityId);
    await _sharedPreferences.setInt(
        PREFS_KEY_SampleCount, loginModel.samplesCount);

    // reload();
    return true;
  }

  bool getUser() {
    bool isLogin =
        _sharedPreferences.getBool(PREFS_KEY_LS_USER_LOGGED_IN) ?? false;
    if (isLogin == false) {
      return false;
    } else {
      // UserInfo.cityId = _sharedPreferences.getInt(PREFS_KEY_CITYID) ?? -1;
      // UserInfo.repId = _sharedPreferences.getInt(PREFS_KEY_repId) ?? -1;
      // UserInfo.isLogging =
      //     _sharedPreferences.getBool(PREFS_KEY_LS_USER_LOGGED_IN) ?? false;
      // UserInfo.name = _sharedPreferences.getString(PREFS_KEY_name);
      // UserInfo.repType = _sharedPreferences.getString(PREFS_KEY_repType) ?? "";
      // UserInfo.samplesCount =
      //     _sharedPreferences.getInt(PREFS_KEY_SampleCount) ?? 0;
      return true;
    }
  }

  // Future<bool> isUserLoggedIn() async {
  //   return _sharedPreferences.getBool(PREFS_KEY_LS_USER_LOGGED_IN) ?? false;
  // }
/////////////////Token
/*
  Future<void> setToken(String token)async{
    _sharedPreferences.setString(PREFS_KEY_TOKEN,token );

  }
 */



  Future<void> signOut() async {
    await _sharedPreferences.remove(PREFS_KEY_LS_USER_LOGGED_IN);
    await _sharedPreferences.remove(PREFS_KEY_repId);
    await _sharedPreferences.remove(PREFS_KEY_repType);
    await _sharedPreferences.remove(PREFS_KEY_SampleCount);
    await _sharedPreferences.remove(PREFS_KEY_CITYID);
        await _sharedPreferences.remove(PREFS_KEY_name);

  }

  reload() async {
    await _sharedPreferences.reload();
  }
}
