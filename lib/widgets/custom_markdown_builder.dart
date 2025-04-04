import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

class CustomMarkdownBuilder extends MarkdownElementBuilder {
  final BuildContext context;
  final TextStyle? codeStyle;
  final BoxDecoration? codeDecoration;

  CustomMarkdownBuilder({
    required this.context,
    this.codeStyle,
    this.codeDecoration,
  });

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    if (element.tag == 'code' && element.textContent.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: codeDecoration,
              child: SelectableText(
                element.textContent,
                style: codeStyle,
              ),
            ),
            Positioned(
              top: 4.0,
              right: 4.0,
              child: IconButton(
                icon: const Icon(Icons.copy, size: 20),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: element.textContent));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('代码已复制到剪贴板')),
                  );
                },
                tooltip: '复制代码',
                padding: const EdgeInsets.all(4.0),
                constraints: const BoxConstraints(),
                iconSize: 18,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }
    return null;
  }
}