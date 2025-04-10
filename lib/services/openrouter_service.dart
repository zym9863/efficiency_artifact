import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/openrouter_model.dart';

class OpenRouterService {
  final String baseUrl = 'https://openrouter.ai/api/v1';
  final OpenRouterSettings settings;
  
  // 保存最后一次请求的消息和系统提示词，用于重新生成
  String? _lastMessage;
  String? _lastSystemPrompt;

  OpenRouterService({required this.settings});

  Future<String> sendMessage(String message, {String? systemPrompt}) async {
    if (settings.apiKey.isEmpty) {
      return '请先在设置中配置OpenRouter API密钥';
    }
    
    // 保存当前消息和系统提示词，用于可能的重新生成
    _lastMessage = message;
    _lastSystemPrompt = systemPrompt;

    try {
      // 准备消息列表
      final messages = <Map<String, String>>[];
      
      // 如果有系统提示词，添加为系统消息
      if (systemPrompt != null && systemPrompt.isNotEmpty) {
        messages.add({'role': 'system', 'content': systemPrompt});
      }
      
      // 添加用户消息
      messages.add({'role': 'user', 'content': message});
      
      final response = await http.post(
        Uri.parse('$baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${settings.apiKey}',
          'HTTP-Referer': 'https://github.com/zym9863/efficiency_artifact',
          'X-Title': 'Efficiency Artifact',
        },
        body: jsonEncode({
          'model': settings.selectedModel.id,
          'messages': messages,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return '请求失败: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      return '发生错误: $e';
    }
  }
  
  /// 使用上一次的消息和系统提示词重新生成回答
  Future<String> regenerateResponse() async {
    // 检查是否有上一次的消息
    if (_lastMessage == null) {
      return '没有可重新生成的内容';
    }
    
    // 使用保存的消息和系统提示词重新发送请求
    return sendMessage(_lastMessage!, systemPrompt: _lastSystemPrompt);
  }
}