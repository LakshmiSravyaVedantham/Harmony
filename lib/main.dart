import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:spiritual_harmony_journal/env/env.dart';
import 'package:spiritual_harmony_journal/providers/journal_provider.dart';
import 'package:spiritual_harmony_journal/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp();  // If using Firebase for cloud features
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }
  
  OpenAI.apiKey = Env.apiKey;
  OpenAI.requestsTimeOut = const Duration(seconds: 60);
  OpenAI.showLogs = true;  // For debugging

  runApp(
    ChangeNotifierProvider(
      create: (context) => JournalProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spiritual Harmony Journal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white.withOpacity(0.9),
        appBarTheme: const AppBarTheme(
          elevation: 2,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}