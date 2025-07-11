import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/gemini_model.dart';
import '../models/openrouter_model.dart';

 // 定义 API 类型枚举
enum ApiType { gemini, openrouter, pollinations }

class SettingsProvider with ChangeNotifier {
  final GeminiSettings _settings = GeminiSettings();
  final OpenRouterSettings _openrouterSettings = OpenRouterSettings();
  static const String _apiKeyPrefKey = 'gemini_api_key';
  static const String _geminiModelPrefKey = 'gemini_model_id'; // Gemini模型持久化键名
  static const String _openrouterApiKeyPrefKey = 'openrouter_api_key';
  static const String _openrouterModelPrefKey = 'openrouter_model_id';
  static const String _themePrefKey = 'theme_mode';
  static const String _apiTypePrefKey = 'api_type'; // 新增 API 类型键名
  static const String _reasoningEffortPrefKey = 'reasoning_effort'; // 推理深度键名
  ThemeMode _themeMode = ThemeMode.system;
  ApiType _selectedApiType = ApiType.gemini; // 默认选择 Gemini

  // Pollinations模型选择
  String? _pollinationsSelectedModelId;
  static const String _pollinationsModelPrefKey = 'pollinations_model_id';

  GeminiSettings get settings => _settings;
  OpenRouterSettings get openrouterSettings => _openrouterSettings;
  ThemeMode get themeMode => _themeMode;
  ApiType get selectedApiType => _selectedApiType; // Getter for API type
  String? get pollinationsSelectedModelId => _pollinationsSelectedModelId;

  // pollinations 不需要 Key，也无需特殊设置
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

    // 加载 Gemini 选中的模型
    final savedGeminiModelId = prefs.getString(_geminiModelPrefKey);
    if (savedGeminiModelId != null) {
      try {
        final model = GeminiModel.getAvailableModels()
            .firstWhere((model) => model.id == savedGeminiModelId);
        _settings.selectedModel = model;
      } catch (e) {
        // 如果找不到保存的模型，使用默认模型
        _settings.selectedModel = GeminiModel.getAvailableModels().first;
      }
    }

    final savedOpenRouterApiKey = prefs.getString(_openrouterApiKeyPrefKey) ?? '';
    if (savedOpenRouterApiKey.isNotEmpty) {
      _openrouterSettings.apiKey = savedOpenRouterApiKey;
    }

    // 加载 OpenRouter 选中的模型
    final savedOpenRouterModelId = prefs.getString(_openrouterModelPrefKey);
    if (savedOpenRouterModelId != null) {
      try {
        final model = OpenRouterModel.getAvailableModels()
            .firstWhere((model) => model.id == savedOpenRouterModelId);
        _openrouterSettings.selectedModel = model;
      } catch (e) {
        // 如果找不到保存的模型，使用默认模型
        _openrouterSettings.selectedModel = OpenRouterModel.getAvailableModels().first;
      }
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

    // Pollinations模型
    final savedPollinationsModelId = prefs.getString(_pollinationsModelPrefKey);
    if (savedPollinationsModelId != null) {
      _pollinationsSelectedModelId = savedPollinationsModelId;
    }

    // 加载推理深度设置
    final savedReasoningEffort = prefs.getString(_reasoningEffortPrefKey);
    if (savedReasoningEffort != null) {
      try {
        final effortEnum = ReasoningEffort.values.firstWhere(
          (effort) => effort.toString() == savedReasoningEffort,
          orElse: () => ReasoningEffort.low,
        );
        _settings.reasoningEffort = effortEnum;
      } catch (e) {
        // 如果解析失败，使用默认值
        _settings.reasoningEffort = ReasoningEffort.low;
      }
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

  Future<void> updateSelectedModel(GeminiModel model) async {
    _settings.selectedModel = model;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_geminiModelPrefKey, model.id);
    notifyListeners();
  }

  // Pollinations模型选择
  Future<void> updatePollinationsSelectedModelId(String modelId) async {
    _pollinationsSelectedModelId = modelId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pollinationsModelPrefKey, modelId);
    notifyListeners();
  }

  Future<void> updateOpenRouterApiKey(String apiKey) async {
    _openrouterSettings.apiKey = apiKey;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_openrouterApiKeyPrefKey, apiKey);
    notifyListeners();
  }

  Future<void> updateOpenRouterSelectedModel(OpenRouterModel model) async {
    _openrouterSettings.selectedModel = model;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_openrouterModelPrefKey, model.id);
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

  // 更新推理深度
  Future<void> updateReasoningEffort(ReasoningEffort effort) async {
    _settings.reasoningEffort = effort;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_reasoningEffortPrefKey, effort.toString());
    notifyListeners();
  }
}
