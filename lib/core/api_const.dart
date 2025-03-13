import 'package:shared_preferences/shared_preferences.dart';

class ApiConst {
  static final isDebug = true;

  static final String apiKey = "";

  //static final String baseUrl = "http://3.115.85.31/";
  //static final String baseUrl = "http://192.168.100.203:8000/api";
  static final String baseUrl = "http://52.195.45.177/api";

  static final String LOCAL_LANGUAGE_KEY = "language";
  static final String LOCAL_DISCOUNT_NUMBER = "discount";
}

Future  getLocalDataofLanguage() async{
  SharedPreferences _sharePrefs = await SharedPreferences.getInstance();
  String? value = await _sharePrefs.getString(ApiConst.LOCAL_LANGUAGE_KEY);
  return value;
}
