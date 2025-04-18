[English](README_EN.md)

# AI效率神器

一个基于Flutter开发的AI效率工具，集成了Gemini和OpenRouter API，帮助用户更高效地使用AI服务。

## 主要功能

- 多API提供商支持
  - 集成Gemini API，支持多个模型选择
    - gemini-2.5-pro-exp-03-25
    - gemini-2.5-flash-preview-04-17
  - 集成OpenRouter API
    - DeepSeek V3 (DeepSeek)
  - 集成Pollinations API（无需API Key，支持多模型）
    - openai-large（GPT 4.1 mini）
    - openai-reasoning（o4 mini）
    - gemini（Gemini 2.5 Flash）
- 提示词管理系统
  - 支持创建和保存常用提示词
  - 提示词标题和内容管理
  - 支持提示词链接保存
  - 提示词搜索功能
- 现代化UI界面
  - Material Design 3设计语言
  - 响应式布局
  - 支持Markdown渲染
  - 代码块复制功能
- 主题设置
  - 支持浅色主题
  - 支持深色主题
  - 支持跟随系统设置

## 技术特点

- 使用Flutter框架开发，支持跨平台部署
- Provider状态管理
- HTTP客户端集成
- 多API提供商无缝切换
- 本地数据持久化（SharedPreferences）
- 模块化架构设计
  - services：API服务封装（Gemini、OpenRouter、Pollinations）
  - models：数据模型定义
  - providers：状态管理
  - screens：页面UI
  - widgets：可复用组件

## 开始使用

1. 确保已安装Flutter开发环境
2. 克隆项目代码
3. 运行以下命令安装依赖：
   ```bash
   flutter pub get
   ```
4. 在设置中配置API密钥（Gemini或OpenRouter）
5. 运行应用：
   ```bash
   flutter run
   ```

## 项目结构

```
lib/
├── main.dart            # 应用入口
├── models/              # 数据模型
│   ├── gemini_model.dart
│   ├── openrouter_model.dart
│   └── prompt_model.dart
├── providers/           # 状态管理
│   ├── prompt_provider.dart
│   └── settings_provider.dart
├── screens/             # 页面
│   ├── home_screen.dart
│   └── settings_screen.dart
├── services/            # 服务
│   ├── gemini_service.dart
│   ├── openrouter_service.dart
│   └── pollinations_service.dart
└── widgets/            # 组件
    ├── custom_markdown_builder.dart
    └── prompt_list_widget.dart
```
