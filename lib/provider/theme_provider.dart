import 'package:flutter/material.dart';
import '../services/preferences_cache.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider({required bool initialDarkMode}) {
    _isDarkMode = initialDarkMode;
  }


  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();


    _saveThemePreference();
  }

  Future<void> _saveThemePreference() async {
    await PreferencesCache.instance.setDarkMode(_isDarkMode);
  }


  late final ThemeData _lightThemeData = ThemeData(
    fontFamily: 'SF Pro',
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFFFF8E7),
  );

  late final ThemeData _darkThemeData = ThemeData(
    fontFamily: 'SF Pro',
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF1A1A1A),
  );

  ThemeData get lightTheme => _lightThemeData;
  ThemeData get darkTheme => _darkThemeData;
}
