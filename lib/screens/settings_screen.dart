import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/gemini_model.dart';
import '../models/openrouter_model.dart';
import '../providers/settings_provider.dart'; // ApiType is implicitly imported
import '../services/pollinations_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Controllers should be managed within the build method when using Consumer
  // if their initial text depends on the provider state that might change.
  // However, for simple cases like API keys, initializing in initState is often fine.
  // Let's keep them here for now but be mindful if state management becomes complex.
  final _apiKeyController = TextEditingController();
  final _openrouterApiKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Access provider without listening here, Consumer will handle updates
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    _apiKeyController.text = settingsProvider.settings.apiKey;
    _openrouterApiKeyController.text = settingsProvider.openrouterSettings.apiKey;
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _openrouterApiKeyController.dispose(); // Dispose the new controller too
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // Use Consumer to rebuild parts of the UI when SettingsProvider notifies listeners
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          // Update text controllers if the provider's value changes
          // This ensures the text field reflects the latest saved key
          // Use addPostFrameCallback to avoid calling setState during build
          WidgetsBinding.instance.addPostFrameCallback((_) {
             if (mounted) { // Check if the widget is still in the tree
                if (_apiKeyController.text != settingsProvider.settings.apiKey) {
                  _apiKeyController.text = settingsProvider.settings.apiKey;
                  // Optionally move cursor to the end if needed
                  // _apiKeyController.selection = TextSelection.fromPosition(TextPosition(offset: _apiKeyController.text.length));
                }
                if (_openrouterApiKeyController.text != settingsProvider.openrouterSettings.apiKey) {
                  _openrouterApiKeyController.text = settingsProvider.openrouterSettings.apiKey;
                  // _openrouterApiKeyController.selection = TextSelection.fromPosition(TextPosition(offset: _openrouterApiKeyController.text.length));
                }
             }
          });

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView( // Use ListView for scrollable content
              children: [
                const Text(
                  'API 提供商选择',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // API Type Selection
                SegmentedButton<ApiType>(
                  segments: const <ButtonSegment<ApiType>>[
                    ButtonSegment<ApiType>(
                        value: ApiType.gemini, label: Text('Gemini')),
                    ButtonSegment<ApiType>(
                        value: ApiType.openrouter, label: Text('OpenRouter')),
                    ButtonSegment<ApiType>(
                        value: ApiType.pollinations, label: Text('Pollinations')),
                  ],
                  selected: <ApiType>{settingsProvider.selectedApiType},
                  onSelectionChanged: (Set<ApiType> newSelection) {
                    // Update the provider state when selection changes
                    settingsProvider.updateApiType(newSelection.first);
                  },
                  // Optional styling to make it wider
                   style: ButtonStyle(
                     visualDensity: VisualDensity.standard, // Adjust spacing if needed
                     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                     minimumSize: MaterialStateProperty.all(const Size(double.infinity, 48)), // Make wider
                   ),
                   showSelectedIcon: false, // Hide checkmark if desired
                ),
                const SizedBox(height: 24),

                // --- Conditional Gemini Settings ---
                if (settingsProvider.selectedApiType == ApiType.gemini) ...[
                  const Text(
                    'Gemini API 设置',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // Gemini API Key Field
                  TextField(
                    controller: _apiKeyController,
                    decoration: const InputDecoration(
                      labelText: 'Gemini API 密钥',
                      border: OutlineInputBorder(),
                      hintText: '请输入您的Gemini API密钥',
                    ),
                    obscureText: true, // Hide API key
                    onChanged: (value) {
                      // Update provider immediately on change
                      settingsProvider.updateApiKey(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  // Gemini Model Selection
                  DropdownButtonFormField<String>(
                    value: settingsProvider.settings.selectedModel.id,
                    decoration: const InputDecoration(
                      labelText: '选择 Gemini 模型',
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
                        settingsProvider.updateSelectedModel(model);
                      }
                    },
                  ),
                  const SizedBox(height: 32), // Spacing before next section
                ],

                // --- Conditional OpenRouter Settings ---
                if (settingsProvider.selectedApiType == ApiType.openrouter) ...[
                  const Text(
                    'OpenRouter API 设置',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // OpenRouter API Key Field
                  TextField(
                    controller: _openrouterApiKeyController,
                    decoration: const InputDecoration(
                      labelText: 'OpenRouter API 密钥',
                      hintText: '在此输入OpenRouter API密钥',
                      border: OutlineInputBorder(),
                    ),
                     obscureText: true, // Hide API key
                    onChanged: (value) {
                      settingsProvider.updateOpenRouterApiKey(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    enabled: false,
                    initialValue: OpenRouterModel.getAvailableModels().first.name,
                    decoration: const InputDecoration(
                      labelText: 'OpenRouter 模型',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 32), // Spacing before next section
                ],

                // --- Conditional Pollinations Settings ---
                if (settingsProvider.selectedApiType == ApiType.pollinations) ...[
                  const Text(
                    'Pollinations 设置',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: settingsProvider.pollinationsSelectedModelId ?? PollinationsModel.getAvailableModels().first.id,
                    decoration: const InputDecoration(
                      labelText: '选择模型',
                      border: OutlineInputBorder(),
                    ),
                    items: PollinationsModel.getAvailableModels()
                        .map((model) => DropdownMenuItem(
                              value: model.id,
                              child: Text(model.name),
                            ))
                        .toList(),
                    onChanged: (String? value) {
                      if (value != null) {
                        settingsProvider.updatePollinationsSelectedModelId(value);
                      }
                    },
                  ),
                  const SizedBox(height: 32),
                ],

                // --- Theme Settings ---
                const Text(
                  '主题设置',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // Theme selection RadioListTiles
                RadioListTile<ThemeMode>(
                  title: const Text('跟随系统'),
                  value: ThemeMode.system,
                  groupValue: settingsProvider.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      settingsProvider.updateThemeMode(value);
                    }
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('浅色主题'),
                  value: ThemeMode.light,
                  groupValue: settingsProvider.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      settingsProvider.updateThemeMode(value);
                    }
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('深色主题'),
                  value: ThemeMode.dark,
                  groupValue: settingsProvider.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      settingsProvider.updateThemeMode(value);
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
