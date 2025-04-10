class OpenRouterModel {
  final String id;
  final String name;
  final String provider;

  OpenRouterModel({
    required this.id,
    required this.name,
    required this.provider,
  });

  static List<OpenRouterModel> getAvailableModels() {
    return [
      OpenRouterModel(
        id: 'google/gemini-2.5-pro-exp-03-25:free',
        name: 'Gemini 2.5 Pro',
        provider: 'Google',
      ),
      OpenRouterModel(
        id: 'deepseek/deepseek-chat-v3-0324:free',
        name: 'DeepSeek V3',
        provider: 'DeepSeek',
      ),
    ];
  }
}

class OpenRouterSettings {
  String apiKey;
  OpenRouterModel selectedModel;

  OpenRouterSettings({
    this.apiKey = '',
    OpenRouterModel? selectedModel,
  }) : selectedModel = selectedModel ?? OpenRouterModel.getAvailableModels().first;
}