import 'dart:async';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';

class GuruScreen extends StatefulWidget {
  const GuruScreen({super.key});

  @override
  State<GuruScreen> createState() => _GuruScreenState();
}

class _GuruScreenState extends State<GuruScreen> {
  final _controller = TextEditingController();
  String _response = '';
  StreamSubscription? _subscription;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Spiritual Guru')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Ask for wisdom...',
                border: OutlineInputBorder(),
                labelText: 'Your Question',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : () {
                if (_controller.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a question')),
                  );
                  return;
                }
                setState(() {
                  _response = '';
                  _isLoading = true;
                });
                final stream = OpenAI.instance.chat.createStream(
                  model: "gpt-3.5-turbo",
                  messages: [
                    OpenAIChatCompletionChoiceMessageModel(
                      content: [OpenAIChatCompletionChoiceMessageContentItemModel.text(
                        "Provide spiritual advice based on: ${_controller.text}. Focus on nature, purpose, and calming the mind.",
                      )],
                      role: OpenAIChatMessageRole.user,
                    ),
                  ],
                );
                _subscription = stream.listen(
                  (event) {
                    setState(() => _response += event.choices.first.delta.content?.first?.text ?? '');
                  },
                  onDone: () {
                    setState(() => _isLoading = false);
                    debugPrint('Insight complete');
                  },
                  onError: (e) {
                    setState(() {
                      _response = 'Error: $e';
                      _isLoading = false;
                    });
                  },
                );
              },
              icon: _isLoading ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ) : const Icon(Icons.lightbulb),
              label: Text(_isLoading ? 'Seeking...' : 'Seek Insight'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _response.isEmpty ? 'Your spiritual guidance will appear here...' : _response,
                    style: TextStyle(
                      fontSize: 16,
                      color: _response.isEmpty ? Colors.grey : Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _controller.dispose();
    super.dispose();
  }
}