import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/prompt_model.dart';
import '../providers/prompt_provider.dart';

class PromptListWidget extends StatefulWidget {
  final Function(String) onPromptSelected;

  const PromptListWidget({Key? key, required this.onPromptSelected}) : super(key: key);

  @override
  State<PromptListWidget> createState() => _PromptListWidgetState();
}

class _PromptListWidgetState extends State<PromptListWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 搜索框
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: '搜索提示词...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  Provider.of<PromptProvider>(context, listen: false).searchPrompts('');
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onChanged: (value) {
              Provider.of<PromptProvider>(context, listen: false).searchPrompts(value);
            },
          ),
        ),
        
        // 添加新提示词按钮
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('新建提示词'),
                  onPressed: () => _showPromptDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 8),
        
        // 提示词列表
        Expanded(
          child: Consumer<PromptProvider>(
            builder: (context, promptProvider, child) {
              final prompts = promptProvider.prompts;
              
              if (prompts.isEmpty) {
                return const Center(
                  child: Text('没有保存的提示词，点击上方按钮添加'),
                );
              }
              
              return ListView.builder(
                itemCount: prompts.length,
                itemBuilder: (context, index) {
                  final prompt = prompts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: ListTile(
                      title: Text(
                        prompt.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        prompt.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => widget.onPromptSelected(prompt.content),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (prompt.link != null)
                            IconButton(
                              icon: const Icon(Icons.link, color: Colors.green),
                              onPressed: () {
                                String url = prompt.link!;
                                if (!url.startsWith('http://') && !url.startsWith('https://')) {
                                  url = 'https://' + url;
                                }
                                launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)
                                  .catchError((error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('无法打开链接：${error.toString()}'))
                                    );
                                  });
                              },
                            ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showPromptDialog(context, prompt),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDelete(context, prompt),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // 显示添加/编辑提示词的对话框
  void _showPromptDialog(BuildContext context, [Prompt? existingPrompt]) {
    final titleController = TextEditingController(text: existingPrompt?.title ?? '');
    final contentController = TextEditingController(text: existingPrompt?.content ?? '');
    final linkController = TextEditingController(text: existingPrompt?.link ?? '');
    final isEditing = existingPrompt != null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? '编辑提示词' : '添加新提示词'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: '标题',
                  hintText: '输入提示词标题',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: '内容',
                  hintText: '输入提示词内容',
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: linkController,
                decoration: const InputDecoration(
                  labelText: '链接',
                  hintText: '输入相关资源链接（可选）',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              final title = titleController.text.trim();
              final content = contentController.text.trim();
              
              if (title.isEmpty || content.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('标题和内容不能为空')),
                );
                return;
              }
              
              final promptProvider = Provider.of<PromptProvider>(context, listen: false);
              
              if (isEditing) {
                // 更新现有提示词
                final updatedPrompt = existingPrompt!.copyWith(
                  title: title,
                  content: content,
                  link: linkController.text.trim().isNotEmpty ? linkController.text.trim() : null,
                );
                promptProvider.updatePrompt(updatedPrompt);
              } else {
                // 添加新提示词
                final newPrompt = Prompt(
                  id: const Uuid().v4(),
                  title: title,
                  content: content,
                  link: linkController.text.trim().isNotEmpty ? linkController.text.trim() : null,
                );
                promptProvider.addPrompt(newPrompt);
              }
              
              Navigator.pop(context);
            },
            child: Text(isEditing ? '更新' : '添加'),
          ),
        ],
      ),
    );
  }

  // 确认删除提示词
  void _confirmDelete(BuildContext context, Prompt prompt) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除提示词 "${prompt.title}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<PromptProvider>(context, listen: false).deletePrompt(prompt.id);
              Navigator.pop(context);
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}