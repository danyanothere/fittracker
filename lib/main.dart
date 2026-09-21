import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() => runApp(const FitTrackApp());

class FitTrackApp extends StatelessWidget {
  const FitTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // зелёный seed под спортивный домен, вся палитра выводится отсюда
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.w600),
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
