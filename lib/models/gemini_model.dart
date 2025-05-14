// 定义推理深度枚举
enum ReasoningEffort {
  low,
  medium,
  high,
}

// 扩展枚举以获取字符串值
extension ReasoningEffortExtension on ReasoningEffort {
  String get value {
    switch (this) {
      case ReasoningEffort.low:
        return 'low';
      case ReasoningEffort.medium:
        return 'medium';
      case ReasoningEffort.high:
        return 'high';
    }
  }

  String get displayName {
    switch (this) {
      case ReasoningEffort.low:
        return '低';
      case ReasoningEffort.medium:
        return '中';
      case ReasoningEffort.high:
        return '高';
    }
  }
}

class GeminiModel {
  final String id;
  final String name;

  GeminiModel({required this.id, required this.name});

  static List<GeminiModel> getAvailableModels() {
    return [
      GeminiModel(id: 'gemini-2.5-flash-preview-04-17', name: 'Gemini 2.5 Flash'),
    ];
  }
}

class GeminiSettings {
  String apiKey;
  GeminiModel selectedModel;
  ReasoningEffort reasoningEffort;

  GeminiSettings({
    this.apiKey = '',
    GeminiModel? selectedModel,
    this.reasoningEffort = ReasoningEffort.low, // 默认为低推理深度
  }) : selectedModel = selectedModel ?? GeminiModel.getAvailableModels().first;
}