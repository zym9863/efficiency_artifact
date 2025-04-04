import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/gemini_model.dart';

class SettingsProvider with ChangeNotifier {
  final GeminiSettings _settings = GeminiSettings();
  static const String _apiKeyPrefKey = 'gemini_api_key';

  GeminiSettings get settings => _settings;

  SettingsProvider() {
    _loadSettings();
  }

  // 从SharedPreferences加载设置
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final savedApiKey = prefs.getString(_apiKeyPrefKey) ?? '';
    if (savedApiKey.isNotEmpty) {
      _settings.apiKey = savedApiKey;
      notifyListeners();
    }
  }

  // 更新并保存API Key
  Future<void> updateApiKey(String apiKey) async {
    _settings.apiKey = apiKey;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyPrefKey, apiKey);
    notifyListeners();
  }

  void updateSelectedModel(GeminiModel model) {
    _settings.selectedModel = model;
    notifyListeners();
  }
}