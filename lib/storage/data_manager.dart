import 'package:shared_preferences/shared_preferences.dart';

class DataManager{

  void setValue(String key, dynamic value) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    if(value is int){
      sharedPreferences.setInt(key, value);
    } else if(value is String){
      sharedPreferences.setString(key, value);
    }
  }

  dynamic getValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    dynamic obj =  prefs.get(key);
    return obj;
  }

}

class StorageKeys {
  static const String highScore = "high_score";
  static const String score = "score";
}
