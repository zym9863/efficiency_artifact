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
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) => MaterialApp(
          title: 'AI效率神器',
          themeMode: settings.themeMode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
            fontFamily: 'Microsoft YaHei',
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              elevation: 2.0,
              titleTextStyle: const TextStyle(
                fontFamily: 'Microsoft YaHei',
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            cardTheme: CardTheme(
              elevation: 1.0,
              margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.tealAccent[700],
              foregroundColor: Colors.black87,
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
            fontFamily: 'Microsoft YaHei',
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.teal[700],
              foregroundColor: Colors.white,
              elevation: 2.0,
              titleTextStyle: const TextStyle(
                fontFamily: 'Microsoft YaHei',
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            cardTheme: CardTheme(
              elevation: 1.0,
              margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Colors.teal[700],
              foregroundColor: Colors.white,
            ),
          ),
          home: const HomeScreen(),
      ),
    ));
  }
}
