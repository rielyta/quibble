import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screen/login_screen.dart';
import 'provider/theme_provider.dart';
import 'services/preferences_cache.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await PreferencesCache.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(
        initialDarkMode: PreferencesCache.instance.isDarkMode,
      ),
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
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const LoginScreen(),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: child!,
            );
          },
        );
      },
    );
  }
}
