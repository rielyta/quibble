import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screen/login_screen.dart';
import 'provider/theme_provider.dart';

void main() async {
  // Pastikan Flutter binding initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load theme preference sebelum app start
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(initialDarkMode: isDarkMode),
      child: const QuibbleApp(),
    ),
  );
}

class QuibbleApp extends StatelessWidget {
  const QuibbleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Quibble',
          debugShowCheckedModeBanner: false,
          // REMOVE showPerformanceOverlay in production
          // showPerformanceOverlay: true,
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const EnterScreen(),
          // Tambahkan untuk optimasi route transitions
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0), // Prevent text scaling issues
              ),
              child: child!,
            );
          },
        );
      },
    );
  }
}