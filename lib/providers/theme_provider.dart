import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_invoice/services/helpers/shared_pref.dart';

class ThemeNotifier extends Notifier<bool> {
  @override
  bool build() {
    return SharedPref.getTheme();
  }

  Future<void> toggleValue(bool isDark) async {
    await SharedPref.setTheme(isDark);
    state = SharedPref.getTheme();
  }
}

final themeProvider =
    NotifierProvider<ThemeNotifier, bool>(() => ThemeNotifier());
