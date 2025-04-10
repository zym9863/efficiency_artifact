import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/gemini_model.dart';
import '../models/openrouter_model.dart';

// 定义 API 类型枚举
enum ApiType { gemini, openrouter }

class SettingsProvider with ChangeNotifier {
  final GeminiSettings _settings = GeminiSettings();
  final OpenRouterSettings _openrouterSettings = OpenRouterSettings();
  static const String _apiKeyPrefKey = 'gemini_api_key';
  static const String _openrouterApiKeyPrefKey = 'openrouter_api_key';
  static const String _themePrefKey = 'theme_mode';
  static const String _apiTypePrefKey = 'api_type'; // 新增 API 类型键名
  ThemeMode _themeMode = ThemeMode.system;
  ApiType _selectedApiType = ApiType.gemini; // 默认选择 Gemini

  GeminiSettings get settings => _settings;
  OpenRouterSettings get openrouterSettings => _openrouterSettings;
  ThemeMode get themeMode => _themeMode;
  ApiType get selectedApiType => _selectedApiType; // Getter for API type

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

    final savedOpenRouterApiKey = prefs.getString(_openrouterApiKeyPrefKey) ?? '';
    if (savedOpenRouterApiKey.isNotEmpty) {
      _openrouterSettings.apiKey = savedOpenRouterApiKey;
    }
    
    final savedThemeMode = prefs.getString(_themePrefKey);
    if (savedThemeMode != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == savedThemeMode,
        orElse: () => ThemeMode.system,
      );
    }

    final savedApiType = prefs.getString(_apiTypePrefKey);
    if (savedApiType != null) {
      _selectedApiType = ApiType.values.firstWhere(
        (type) => type.toString() == savedApiType,
        orElse: () => ApiType.gemini, // 默认回退到 Gemini
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

  Future<void> updateOpenRouterApiKey(String apiKey) async {
    _openrouterSettings.apiKey = apiKey;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_openrouterApiKeyPrefKey, apiKey);
    notifyListeners();
  }

  void updateOpenRouterSelectedModel(OpenRouterModel model) {
    _openrouterSettings.selectedModel = model;
    notifyListeners();
  }

  // 更新 API 类型
  Future<void> updateApiType(ApiType type) async {
    _selectedApiType = type;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiTypePrefKey, type.toString());
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
