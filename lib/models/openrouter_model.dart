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
        id: 'deepseek/deepseek-chat-v3-0324:free',
        name: 'DeepSeek V3',
        provider: 'DeepSeek',
      ),
      OpenRouterModel(
        id: 'deepseek/deepseek-r1-0528:free',
        name: 'DeepSeek R1',
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
