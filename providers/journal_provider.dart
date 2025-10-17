import 'dart:async';
import 'dart:io';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class JournalEntry {
  final int id;
  final String text;
  final DateTime date;

  JournalEntry({required this.id, required this.text, required this.date});
}

class JournalProvider extends ChangeNotifier {
  late Database _database;
  List<JournalEntry> _entries = [];

  JournalProvider() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'journals.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE journals(id INTEGER PRIMARY KEY, text TEXT, date TEXT)',
        );
      },
    );
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final List<Map<String, dynamic>> maps = await _database.query('journals');
    _entries = maps.map((map) {
      return JournalEntry(
        id: map['id'],
        text: map['text'],
        date: DateTime.parse(map['date']),
      );
    }).toList();
    notifyListeners();
  }

  Future<void> addEntry(String text) async {
    await _database.insert(
      'journals',
      {'text': text, 'date': DateTime.now().toIso8601String()},
    );
    _loadEntries();
  }

  List<JournalEntry> get entries => _entries;

  // AI: Analyze sentiment
  Future<String> analyzeSentiment(String entry) async {
    try {
      final systemMessage = OpenAIChatCompletionChoiceMessageModel(
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
            "Analyze this journal entry for sentiment: positive, negative (including self-pity), or neutral. If negative, suggest a spiritual reframe using nature analogies. Return as JSON: {'sentiment': 'value', 'reframe': 'suggestion'}",
          ),
        ],
        role: OpenAIChatMessageRole.system,
      );

      final userMessage = OpenAIChatCompletionChoiceMessageModel(
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(entry),
        ],
        role: OpenAIChatMessageRole.user,
      );

      final chatCompletion = await OpenAI.instance.chat.create(
        model: "gpt-3.5-turbo",
        messages: [systemMessage, userMessage],
        temperature: 0.7,
        maxTokens: 150,
      );

      return chatCompletion.choices.first.message.content?.first?.text ?? 'Error';
    } catch (e) {
      return 'Analysis failed: $e';
    }
  }

  // AI: Generate insight
  Future<String> generateInsight(String entry, {String? healthContext}) async {
    String prompt = "Based on this journal entry, provide a spiritual insight to stop self-pity, focus on life's purpose, and calm the mind. Use nature learnings. Entry: $entry.";
    if (healthContext != null) {
      prompt += " Health context: $healthContext.";
    }

    final completion = await OpenAI.instance.chat.create(
      model: "gpt-4o-mini",
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          content: [OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt)],
          role: OpenAIChatMessageRole.user,
        ),
      ],
      maxTokens: 200,
      temperature: 0.8,
    );

    return completion.choices.first.message.content?.first?.text ?? 'No insight generated.';
  }

  // Health Sync
  Future<String?> fetchHealthData() async {
    Health health = Health();
    bool authorized = await health.requestAuthorization([HealthDataType.HEART_RATE]);
    if (authorized) {
      List<HealthDataPoint> data = await health.getHealthDataFromTypes(
        DateTime.now().subtract(const Duration(days: 1)),
        DateTime.now(),
        [HealthDataType.HEART_RATE],
      );
      if (data.isNotEmpty) {
        return 'Heart rate average: ${data.last.value}';  // Simplified
      }
    }
    return null;
  }

  // Process entry with AI and health
  Future<String> processEntryWithAI(String entry) async {
    final healthContext = await fetchHealthData();
    final insight = await generateInsight(entry, healthContext: healthContext);
    return insight;
  }
}