import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageUtils {
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setString(String key, String value) async {
    if (_preferences == null) await init();
    return _preferences!.setString(key, value);
  }

  static String? getString(String key) {
    if (_preferences == null) {
      // You might want to handle this more robustly, e.g., throw an error or return a default.
      print("Warning: SharedPreferences not initialized. Call init() first.");
      return null;
    }
    return _preferences!.getString(key);
  }
  static Future setToken(String token) async {
    if (_preferences == null) await init();
    _preferences!.setString("token", token);
  }
  static Future<String?> getToken() async {
    if (_preferences == null) await init();
    return _preferences!.getString("token");
  }
  // --- Bool Operations ---
  static Future<bool> setBool(String key, bool value) async {
    if (_preferences == null) await init();
    return _preferences!.setBool(key, value);
  }
  static Future<void> setFirstTime() async {
    if (_preferences == null) await init();
    _preferences!.setBool("firstTime", true);
  }
  static Future<bool> getFirstTime() async {
    if (_preferences == null) await init();
    return await _preferences!.getBool("firstTime") ?? false; // Default to true if not set
  }
  static Future<void> setLogined() async {
    if (_preferences == null) await init();
    _preferences!.setBool("setLogined", true);
  }
  static Future<bool> getLogined() async {
    if (_preferences == null) await init();
    return await _preferences!.getBool("setLogined") ?? false; // Default to true if not set
  }
  static Future<void> setLoginedDoctor() async {
    if (_preferences == null) await init();
    _preferences!.setBool("setLoginedDoctor", true);
  }
  static Future<bool> getLoginedDoctor() async {
    if (_preferences == null) await init();
    return await _preferences!.getBool("setLoginedDoctor") ?? false; // Default to true if not set
  }
  static Future<void> setLoginedPharmacy() async {
    if (_preferences == null) await init();
    _preferences!.setBool("setLoginedPharmacy", true);
  }
  static Future<bool> getLoginedPharmacy() async {
    if (_preferences == null) await init();
    return await _preferences!.getBool("setLoginedPharmacy") ?? false; // Default to true if not set
  }
  static Future<bool> getBool(String key) async {
    if (_preferences == null) await init();
    return _preferences!.getBool(key)?? false;
  }

  // --- Int Operations ---
  static Future<bool> setInt(String key, int value) async {
    if (_preferences == null) await init();
    return _preferences!.setInt(key, value);
  }

  static int? getInt(String key) {
    if (_preferences == null) {
      print("Warning: SharedPreferences not initialized. Call init() first.");
      return null;
    }
    return _preferences!.getInt(key);
  }

  // --- Double Operations ---
  static Future<bool> setDouble(String key, double value) async {
    if (_preferences == null) await init();
    return _preferences!.setDouble(key, value);
  }

  static double? getDouble(String key) {
    if (_preferences == null) {
      print("Warning: SharedPreferences not initialized. Call init() first.");
      return null;
    }
    return _preferences!.getDouble(key);
  }

  // --- String List Operations ---
  static Future<bool> setStringList(String key, List<String> value) async {
    if (_preferences == null) await init();
    return _preferences!.setStringList(key, value);
  }

  static List<String>? getStringList(String key) {
    if (_preferences == null) {
      print("Warning: SharedPreferences not initialized. Call init() first.");
      return null;
    }
    return _preferences!.getStringList(key);
  }

  // --- Remove Operations ---
  static Future<bool> remove(String key) async {
    if (_preferences == null) await init();
    return _preferences!.remove(key);
  }

  // --- Clear All Data ---
  static Future<bool> clear() async {
    if (_preferences == null) await init();
    print("data cleared");
    return await _preferences!.clear();
  }

  // Check if a key exists
  static bool containsKey(String key) {
    if (_preferences == null) {
      print("Warning: SharedPreferences not initialized. Call init() first.");
      return false;
    }
    return _preferences!.containsKey(key);
  }

  // Get all keys
  static Set<String> getKeys() {
    if (_preferences == null) {
      print("Warning: SharedPreferences not initialized. Call init() first.");
      return {};
    }
    return _preferences!.getKeys();
  }
  static deleteUser(){
    remove("setLogined");
    remove("setLoginedDoctor");
    remove("setLoginedPharmacy");
    remove("token");
  }
  static Future<bool> setLanguage(String value) async {
    if (_preferences == null) await init();
    return _preferences!.setString("language", value);
  }

  static String? getLanguage() {
    if (_preferences == null) {
      print("Warning: SharedPreferences not initialized. Call init() first.");
      return null;
    }
    print("Language=${_preferences!.getString("language")}");
    return _preferences!.getString("language");
  }
}