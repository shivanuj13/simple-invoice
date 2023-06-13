import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_invoice/data/models/user_model.dart';

class SharedPref {
  static late SharedPreferences pref;
  static Future<void> init() async {
    pref = await SharedPreferences.getInstance();
  }

  static UserModel? getUser() {
    String? user = pref.getString('user');
    if (user != null) {
      return UserModel.fromJson(user);
    }

    return null;
  }

  static void setUser(UserModel user) {
    pref.setString('user', user.toJson());
  }

  static Future<void> clearUser() async {
   await pref.remove('user');
  }

  static bool getTheme() {
    return pref.getBool('isDark') ?? false;
  }

  static setTheme(bool isDark) async {
    await pref.setBool('isDark', isDark);
  }
}
