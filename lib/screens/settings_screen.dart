import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/gemini_model.dart';
import '../models/openrouter_model.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _apiKeyController = TextEditingController();
  final _openrouterApiKeyController = TextEditingController();
  late SettingsProvider _settingsProvider;

  @override
  void initState() {
    super.initState();
    _settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    _apiKeyController.text = _settingsProvider.settings.apiKey;
    _openrouterApiKeyController.text = _settingsProvider.openrouterSettings.apiKey;
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'API设置',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _apiKeyController,
              decoration: const InputDecoration(
                labelText: 'API密钥',
                border: OutlineInputBorder(),
                hintText: '请输入您的Gemini API密钥',
              ),
              onChanged: (value) {
                _settingsProvider.updateApiKey(value);
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _settingsProvider.settings.selectedModel.id,
              decoration: const InputDecoration(
                labelText: '选择Gemini模型',
                border: OutlineInputBorder(),
              ),
              items: GeminiModel.getAvailableModels()
                  .map((model) => DropdownMenuItem(
                        value: model.id,
                        child: Text(model.name),
                      ))
                  .toList(),
              onChanged: (String? value) {
                if (value != null) {
                  final model = GeminiModel.getAvailableModels()
                      .firstWhere((model) => model.id == value);
                  _settingsProvider.updateSelectedModel(model);
                }
              },
            ),
            const SizedBox(height: 32),
            
            // OpenRouter API设置
            const Text(
              'OpenRouter API设置',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _openrouterApiKeyController,
              decoration: const InputDecoration(
                labelText: 'OpenRouter API密钥',
                hintText: '在此输入OpenRouter API密钥',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _settingsProvider.updateOpenRouterApiKey(value);
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _settingsProvider.openrouterSettings.selectedModel.id,
              decoration: const InputDecoration(
                labelText: '选择OpenRouter模型',
                border: OutlineInputBorder(),
              ),
              items: OpenRouterModel.getAvailableModels()
                  .map((model) => DropdownMenuItem(
                        value: model.id,
                        child: Text('${model.name} (${model.provider})'),
                      ))
                  .toList(),
              onChanged: (String? value) {
                if (value != null) {
                  final model = OpenRouterModel.getAvailableModels()
                      .firstWhere((model) => model.id == value);
                  _settingsProvider.updateOpenRouterSelectedModel(model);
                }
              },
            ),
            const SizedBox(height: 24),
            const Text(
              '主题设置',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Consumer<SettingsProvider>(
              builder: (context, provider, child) {
                return Column(
                  children: [
                    RadioListTile<ThemeMode>(
                      title: const Text('跟随系统'),
                      value: ThemeMode.system,
                      groupValue: provider.themeMode,
                      onChanged: (value) {
                        if (value != null) {
                          provider.updateThemeMode(value);
                        }
                      },
                    ),
                    RadioListTile<ThemeMode>(
                      title: const Text('浅色主题'),
                      value: ThemeMode.light,
                      groupValue: provider.themeMode,
                      onChanged: (value) {
                        if (value != null) {
                          provider.updateThemeMode(value);
                        }
                      },
                    ),
                    RadioListTile<ThemeMode>(
                      title: const Text('深色主题'),
                      value: ThemeMode.dark,
                      groupValue: provider.themeMode,
                      onChanged: (value) {
                        if (value != null) {
                          provider.updateThemeMode(value);
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}