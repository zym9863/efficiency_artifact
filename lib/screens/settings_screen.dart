import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/gemini_model.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _apiKeyController = TextEditingController();
  late SettingsProvider _settingsProvider;

  @override
  void initState() {
    super.initState();
    _settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    _apiKeyController.text = _settingsProvider.settings.apiKey;
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
              onChanged: (value) async {
                await _settingsProvider.updateApiKey(value);
              },
            ),
            const SizedBox(height: 24),
            const Text(
              '模型选择',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Consumer<SettingsProvider>(
              builder: (context, provider, child) {
                return Column(
                  children: GeminiModel.getAvailableModels().map((model) {
                    return RadioListTile<String>(
                      title: Text(model.name),
                      subtitle: Text(model.id),
                      value: model.id,
                      groupValue: provider.settings.selectedModel.id,
                      onChanged: (value) {
                        if (value != null) {
                          final selectedModel = GeminiModel.getAvailableModels()
                              .firstWhere((m) => m.id == value);
                          provider.updateSelectedModel(selectedModel);
                        }
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}