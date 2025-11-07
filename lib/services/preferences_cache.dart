import 'package:shared_preferences/shared_preferences.dart';


class PreferencesCache {
  static PreferencesCache? _instance;
  static PreferencesCache get instance {
    if (_instance == null) {
      throw StateError('PreferencesCache must be initialized first');
    }
    return _instance!;
  }

  late final SharedPreferences _prefs;

  bool? _isDarkMode;
  String? _username;
  String? _statsJson;

  PreferencesCache._(this._prefs) {
    _loadCache();
  }


  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _instance = PreferencesCache._(prefs);
  }

  void _loadCache() {
    _isDarkMode = _prefs.getBool('isDarkMode');
    _username = _prefs.getString('name');
    _statsJson = _prefs.getString('quiz_stats');
  }


  bool get isDarkMode => _isDarkMode ?? false;

  String? get username => _username;

  String? get statsJson => _statsJson;


  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    await _prefs.setBool('isDarkMode', value);
  }

  Future<void> setUsername(String value) async {
    _username = value;
    await _prefs.setString('name', value);
  }

  Future<void> setStats(String json) async {
    _statsJson = json;
    await _prefs.setString('quiz_stats', json);
  }


  Future<void> clear() async {
    _isDarkMode = null;
    _username = null;
    _statsJson = null;
    await _prefs.clear();
  }


  SharedPreferences get prefs => _prefs;
}
