class GeminiModel {
  final String id;
  final String name;

  GeminiModel({required this.id, required this.name});

  static List<GeminiModel> getAvailableModels() {
    return [
      GeminiModel(id: 'gemini-2.5-pro-exp-03-25', name: 'Gemini 2.5 Pro'),
      GeminiModel(id: 'gemini-2.0-flash-thinking-exp-01-21', name: 'Gemini 2.0 Flash Thinking'),
      GeminiModel(id: 'gemini-2.0-flash-001', name: 'Gemini 2.0 Flash'),
    ];
  }
}

class GeminiSettings {
  String apiKey;
  GeminiModel selectedModel;

  GeminiSettings({
    this.apiKey = '',
    GeminiModel? selectedModel,
  }) : selectedModel = selectedModel ?? GeminiModel.getAvailableModels().first;
}