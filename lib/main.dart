import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/settings_provider.dart';
import 'providers/prompt_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => PromptProvider()),
      ],
      child: MaterialApp(
        title: 'AI效率神器',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal, // 使用 Teal 作为种子颜色
            brightness: Brightness.light, // 可以明确指定亮度
          ),
          useMaterial3: true,
          fontFamily: 'Microsoft YaHei',
          appBarTheme: AppBarTheme( // 统一 AppBar 样式
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white, // 标题和图标颜色
            elevation: 2.0,
            titleTextStyle: const TextStyle(
              fontFamily: 'Microsoft YaHei',
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          cardTheme: CardTheme( // 统一 Card 样式
            elevation: 1.0,
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData( // FAB 样式
            backgroundColor: Colors.tealAccent[700],
            foregroundColor: Colors.black87,
          ),
          // 你可以根据需要添加更多组件的主题设置，例如 inputDecorationTheme, buttonTheme 等
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
