import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/journal_provider.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final _controller = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Journal Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: 'Reflect on your day...',
                  border: OutlineInputBorder(),
                  labelText: 'Journal Entry',
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : () async {
                  final entry = _controller.text.trim();
                  if (entry.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please write something first')),
                    );
                    return;
                  }
                  setState(() => _isLoading = true);
                  try {
                    final provider = Provider.of<JournalProvider>(context, listen: false);
                    await provider.addEntry(entry);
                    final insight = await provider.processEntryWithAI(entry);
                    setState(() => _isLoading = false);
                    if (!mounted) return;
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Spiritual Insight'),
                        content: SingleChildScrollView(child: Text(insight)),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                    _controller.clear();
                  } catch (e) {
                    setState(() => _isLoading = false);
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                },
                icon: _isLoading ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                ) : const Icon(Icons.save),
                label: Text(_isLoading ? 'Processing...' : 'Save & Get Insight'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}