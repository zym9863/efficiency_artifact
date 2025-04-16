import 'dart:convert';
import 'package:http/http.dart' as http;

class PollinationsService {
  final String baseUrl = 'https://api.pollinations.ai';
  // 无需API key

  String? _lastMessage;
  String? _lastSystemPrompt;

  PollinationsService();

  Future<String> sendMessage(String message, {String? systemPrompt}) async {
    _lastMessage = message;
    _lastSystemPrompt = systemPrompt;
    try {
      final messages = <Map<String, String>>[];
      if (systemPrompt != null && systemPrompt.isNotEmpty) {
        messages.add({'role': 'system', 'content': systemPrompt});
      }
      messages.add({'role': 'user', 'content': message});
      final response = await http.post(
        Uri.parse('https://text.pollinations.ai/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'openai-large',
          'messages': messages,
          'private': true,
        }),
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return '请求失败: ${response.statusCode} - ${utf8.decode(response.bodyBytes)}';
      }
    } catch (e) {
      return '发生错误: $e';
    }
  }

  Future<String> regenerateResponse() async {
    if (_lastMessage == null) {
      return '没有可重新生成的内容';
    }
    return sendMessage(_lastMessage!, systemPrompt: _lastSystemPrompt);
  }
}
