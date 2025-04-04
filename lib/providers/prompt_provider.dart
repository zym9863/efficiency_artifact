import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/prompt_model.dart';

class PromptProvider with ChangeNotifier {
  List<Prompt> _prompts = [];
  List<Prompt> _filteredPrompts = [];
  static const String _promptsPrefKey = 'saved_prompts';
  String _searchQuery = '';

  // 获取所有prompts
  List<Prompt> get prompts => _searchQuery.isEmpty ? _prompts : _filteredPrompts;

  // 获取当前搜索关键词
  String get searchQuery => _searchQuery;

  PromptProvider() {
    _loadPrompts();
  }

  // 从SharedPreferences加载prompts
  Future<void> _loadPrompts() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPrompts = prefs.getStringList(_promptsPrefKey) ?? [];
    
    _prompts = savedPrompts
        .map((promptJson) => Prompt.fromJson(jsonDecode(promptJson)))
        .toList();
    
    _applySearch();
    notifyListeners();
  }

  // 保存prompts到SharedPreferences
  Future<void> _savePrompts() async {
    final prefs = await SharedPreferences.getInstance();
    final promptsJson = _prompts
        .map((prompt) => jsonEncode(prompt.toJson()))
        .toList();
    
    await prefs.setStringList(_promptsPrefKey, promptsJson);
  }

  // 添加新的prompt
  Future<void> addPrompt(Prompt prompt) async {
    _prompts.add(prompt);
    await _savePrompts();
    _applySearch();
    notifyListeners();
  }

  // 更新现有prompt
  Future<void> updatePrompt(Prompt updatedPrompt) async {
    final index = _prompts.indexWhere((p) => p.id == updatedPrompt.id);
    if (index != -1) {
      _prompts[index] = updatedPrompt;
      await _savePrompts();
      _applySearch();
      notifyListeners();
    }
  }

  // 删除prompt
  Future<void> deletePrompt(String id) async {
    _prompts.removeWhere((p) => p.id == id);
    await _savePrompts();
    _applySearch();
    notifyListeners();
  }

  // 搜索prompts
  void searchPrompts(String query) {
    _searchQuery = query;
    _applySearch();
    notifyListeners();
  }

  // 应用搜索过滤
  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredPrompts = [];
      return;
    }

    final lowercaseQuery = _searchQuery.toLowerCase();
    _filteredPrompts = _prompts.where((prompt) {
      return prompt.title.toLowerCase().contains(lowercaseQuery) ||
          prompt.content.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}