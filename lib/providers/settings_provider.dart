import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/gemini_model.dart';

class SettingsProvider with ChangeNotifier {
  final GeminiSettings _settings = GeminiSettings();
  static const String _apiKeyPrefKey = 'gemini_api_key';
  static const String _themePrefKey = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.system;

  GeminiSettings get settings => _settings;
  ThemeMode get themeMode => _themeMode;

  SettingsProvider() {
    _loadSettings();
  }

  // 从SharedPreferences加载设置
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final savedApiKey = prefs.getString(_apiKeyPrefKey) ?? '';
    if (savedApiKey.isNotEmpty) {
      _settings.apiKey = savedApiKey;
    }
    
    final savedThemeMode = prefs.getString(_themePrefKey);
    if (savedThemeMode != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == savedThemeMode,
        orElse: () => ThemeMode.system,
      );
    }
    notifyListeners();
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

  // 更新主题模式
  Future<void> updateThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themePrefKey, mode.toString());
    notifyListeners();
  }
}