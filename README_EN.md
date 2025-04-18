[中文](README.md)

# AI Efficiency Tool

A Flutter-based AI efficiency tool that integrates both Gemini and OpenRouter APIs to help users utilize AI services more effectively.

## Key Features

- Multiple API Provider Support
  - Gemini API Integration with Multiple Model Support
    - gemini-2.5-pro-exp-03-25
    - gemini-2.5-flash-preview-04-17
  - OpenRouter API Integration 
    - DeepSeek V3 (DeepSeek)
  - Pollinations API integration (no API key required, supports multiple models)
    - openai-large (GPT 4.1 mini)
    - openai-reasoning (o4 mini)
    - gemini (Gemini 2.5 Flash)
- Prompt Management System
  - Create and save frequently used prompts
  - Manage prompt titles and content
  - Support for prompt link saving
  - Prompt search functionality
- Modern UI Interface
  - Material Design 3 language
  - Responsive layout
  - Markdown rendering support
  - Code block copying feature
- Theme Settings
  - Light theme support
  - Dark theme support
  - System theme following

## Technical Features

- Developed with Flutter framework, supporting cross-platform deployment
- Provider state management
- HTTP client integration
- Seamless switching between multiple API providers
- Local data persistence (SharedPreferences)
- Modular architecture design
  - services: API service encapsulation
  - models: Data model definitions
  - providers: State management
  - screens: Page UI
  - widgets: Reusable components

## Getting Started

1. Ensure Flutter development environment is installed
2. Clone the project code
3. Run the following command to install dependencies:
   ```bash
   flutter pub get
   ```
4. Configure API key (Gemini or OpenRouter) in settings
5. Run the application:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart            # Application entry
├── models/              # Data models
│   ├── gemini_model.dart
│   ├── openrouter_model.dart
│   └── prompt_model.dart
├── providers/           # State management
│   ├── prompt_provider.dart
│   └── settings_provider.dart
├── screens/             # Pages
│   ├── home_screen.dart
│   └── settings_screen.dart
├── services/            # Services
│   ├── gemini_service.dart
│   └── openrouter_service.dart
│   └── pollinations_service.dart
└── widgets/            # Components
    ├── custom_markdown_builder.dart
    └── prompt_list_widget.dart
```