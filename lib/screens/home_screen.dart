import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../widgets/custom_markdown_builder.dart';
import '../providers/settings_provider.dart';
import '../services/gemini_service.dart';
import '../services/openrouter_service.dart';
import '../widgets/prompt_list_widget.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _response = '';
  bool _isLoading = false;
  late GeminiService _geminiService;
  late OpenRouterService _openrouterService;

  @override
  void initState() {
    super.initState();
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    _geminiService = GeminiService(settings: settingsProvider.settings);
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  String? _selectedSystemPrompt;

  Future<void> _sendMessage() async {
    final input = _inputController.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    // 更新服务实例以获取最新设置
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    _geminiService = GeminiService(settings: settingsProvider.settings);
    _openrouterService = OpenRouterService(settings: settingsProvider.openrouterSettings);

    try {
      // 优先使用Gemini API
      try {
        final response = await _geminiService.sendMessage(
          input,
          systemPrompt: _selectedSystemPrompt,
        );
        setState(() {
          _response = response;
          _isLoading = false;
        });
      } catch (geminiError) {
        // 如果Gemini API调用失败且OpenRouter API密钥已配置，尝试使用OpenRouter服务
        if (settingsProvider.openrouterSettings.apiKey.isNotEmpty) {
          final response = await _openrouterService.sendMessage(
            input,
            systemPrompt: _selectedSystemPrompt,
          );
          setState(() {
            _response = response;
            _isLoading = false;
          });
        } else {
          throw geminiError; // 如果OpenRouter也不可用，抛出原始错误
        }
      }
    } catch (e) {
      setState(() {
        _response = '发生错误: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 获取当前主题以便后续使用
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 预先计算颜色以尝试解决 Linter 警告
    final systemPromptBgColor = colorScheme.primaryContainer.withOpacity(0.3);
    final systemPromptBorderColor = colorScheme.primary.withOpacity(0.5);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI效率神器'),
        // 移除 backgroundColor 以应用 AppBarTheme
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // 左侧输入区域
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      maxLines: null,
                      expands: true,
                      decoration: const InputDecoration(
                        hintText: '请输入您的问题...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _sendMessage,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('发送'),
                  ),
                ],
              ),
            ),
          ),
          // 右侧内容区域 - Prompt列表
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.5), // 使用主题颜色作为背景，并降低透明度
                border: Border( // 使用主题分隔线颜色
                  left: BorderSide(color: theme.dividerColor, width: 1),
                ),
              ),
              child: Column(
                children: [
                  // 显示当前选中的系统提示词
                  if (_selectedSystemPrompt != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.only(bottom: 8.0),
                      decoration: BoxDecoration(
                        color: systemPromptBgColor, // 使用预先计算的颜色
                        borderRadius: BorderRadius.circular(8.0), // 统一圆角
                        border: Border.all(color: systemPromptBorderColor), // 使用预先计算的颜色
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text( // 移除此处的 const
                                '当前系统提示词：',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onPrimaryContainer, // 确保文本颜色对比度
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.close, size: 16, color: colorScheme.onPrimaryContainer), // 确保图标颜色对比度
                                onPressed: () {
                                  setState(() {
                                    _selectedSystemPrompt = null;
                                  });
                                },
                              ),
                            ],
                          ),
                          Text(
                            _selectedSystemPrompt!,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  // AI响应区域
                  if (_response.isNotEmpty)
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        margin: const EdgeInsets.only(bottom: 16.0),
                        decoration: BoxDecoration(
                          color: colorScheme.surface, // 使用主题表面颜色
                          borderRadius: BorderRadius.circular(12.0), // 统一圆角 (与CardTheme一致)
                          border: Border.all(color: colorScheme.outlineVariant), // 使用主题轮廓颜色
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.refresh),
                                    tooltip: '重新生成',
                                    onPressed: _isLoading ? null : _regenerateResponse,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.copy),
                                    tooltip: '复制内容',
                                    onPressed: _response.isEmpty ? null : () => _copyToClipboard(_response),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.select_all),
                                    tooltip: '选择文本',
                                    onPressed: _response.isEmpty ? null : () => _showTextSelection(_response),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: MarkdownBody(
                                  data: _response,
                                  selectable: true,
                                  builders: {
                                    'code': CustomMarkdownBuilder(
                                      context: context,
                                      codeStyle: TextStyle(
                                        fontFamily: 'monospace',
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                      codeDecoration: BoxDecoration(
                                        color: colorScheme.surfaceVariant,
                                        borderRadius: BorderRadius.circular(4.0),
                                        border: Border.all(color: colorScheme.outlineVariant),
                                      ),
                                    ),
                                  },
                                  styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                                    codeblockPadding: const EdgeInsets.all(8.0),
                                    codeblockDecoration: BoxDecoration(
                                      color: colorScheme.surfaceVariant,
                                      borderRadius: BorderRadius.circular(4.0),
                                      border: Border.all(color: colorScheme.outlineVariant),
                                    ),
                                    code: TextStyle(
                                      fontFamily: 'monospace',
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                    h1: theme.textTheme.headlineMedium,
                                    h2: theme.textTheme.titleLarge,
                                    h3: theme.textTheme.titleMedium,
                                    // 移除 TextStyle 中无效的 padding 和 border
                                    blockquote: TextStyle(
                                      color: colorScheme.onSurface.withOpacity(0.7), // 使用主题颜色并调整透明度
                                      fontStyle: FontStyle.italic,
                                      backgroundColor: colorScheme.surfaceVariant.withOpacity(0.2), // 轻微背景
                                      // TODO: Consider using blockquotePadding and blockquoteDecoration in MarkdownStyleSheet for better control
                                    ),
                                  ),
                                  onTapLink: (text, href, title) {
                                    if (href != null) {
                                      // 这里可以添加打开链接的逻辑
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('链接: $href')),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // 提示词列表
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : PromptListWidget(
                            onPromptSelected: (promptContent) {
                              setState(() {
                                // 设置系统提示词而不是填充输入框
                                _selectedSystemPrompt = promptContent;
                                
                                // 如果有用户输入，自动发送请求
                                if (_inputController.text.trim().isNotEmpty) {
                                  _sendMessage();
                                }
                              });
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 复制内容到剪贴板
  void _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('内容已复制到剪贴板')),
    );
  }

  void _showTextSelection(String text) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择文本'),
        content: SingleChildScrollView(
          child: SelectableText(text),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  // 重新生成回答
  Future<void> _regenerateResponse() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _geminiService.regenerateResponse();
      setState(() {
        _response = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _response = '发生错误: $e';
        _isLoading = false;
      });
    }
  }
}
