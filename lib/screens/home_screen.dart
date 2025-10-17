import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/journal_provider.dart';
import 'journal_screen.dart';
import 'nature_screen.dart';
import 'guru_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<JournalProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Spiritual Harmony Journal')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('New Journal Entry'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JournalScreen())),
          ),
          ListTile(
            title: const Text('Nature Scan'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NatureScreen())),
          ),
          ListTile(
            title: const Text('Spiritual Guru'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GuruScreen())),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Recent Entries:'),
          ),
          ...provider.entries.map((entry) => ListTile(
                leading: const Icon(Icons.book, color: Colors.green),
                title: Text(
                  entry.text.length > 50 ? '${entry.text.substring(0, 50)}...' : entry.text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${entry.date.day}/${entry.date.month}/${entry.date.year} at ${entry.date.hour}:${entry.date.minute.toString().padLeft(2, '0')}',
                ),
              )),
        ],
      ),
    );
  }
}