import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _prefs;
  
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call StorageService.init() first.');
    }
    return _prefs!;
  }

  // User preferences
  static Future<bool> setUserId(String userId) async {
    return await prefs.setString('user_id', userId);
  }

  static String? getUserId() {
    return prefs.getString('user_id');
  }

  static Future<bool> clearUserId() async {
    return await prefs.remove('user_id');
  }

  // App settings
  static Future<bool> setOnboardingCompleted() async {
    return await prefs.setBool('onboarding_completed', true);
  }

  static bool isOnboardingCompleted() {
    return prefs.getBool('onboarding_completed') ?? false;
  }

  // Search history
  static Future<bool> addSearchQuery(String query) async {
    List<String> searches = getSearchHistory();
    searches.remove(query); // Remove if exists
    searches.insert(0, query); // Add to beginning
    if (searches.length > 10) {
      searches = searches.take(10).toList(); // Keep only last 10
    }
    return await prefs.setStringList('search_history', searches);
  }

  static List<String> getSearchHistory() {
    return prefs.getStringList('search_history') ?? [];
  }

  static Future<bool> clearSearchHistory() async {
    return await prefs.remove('search_history');
  }

  // Clear all data
  static Future<bool> clearAll() async {
    return await prefs.clear();
  }
}