[中文](README.md)

# AI Efficiency Tool

A Flutter-based AI efficiency tool that integrates the Gemini API to help users utilize AI services more effectively.

## Key Features

- Gemini API Integration with Multiple Model Support
  - Gemini 2.5 Pro
  - Gemini 2.0 Flash Thinking
  - Gemini 2.0 Flash
- Prompt Management System
  - Create and save frequently used prompts
  - Manage prompt titles and content
  - Support for prompt link saving
- Modern UI Interface
  - Material Design 3 language
  - Responsive layout
  - Markdown rendering support

## Technical Features

- Developed with Flutter framework, supporting cross-platform deployment
- Provider state management
- HTTP client integration
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
4. Configure Gemini API key in settings
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
│   └── prompt_model.dart
├── providers/           # State management
│   ├── prompt_provider.dart
│   └── settings_provider.dart
├── screens/             # Pages
│   ├── home_screen.dart
│   └── settings_screen.dart
├── services/            # Services
│   └── gemini_service.dart
└── widgets/            # Components
    └── prompt_list_widget.dart
```