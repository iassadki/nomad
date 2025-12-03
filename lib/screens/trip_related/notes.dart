import 'package:flutter/material.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

// Ajoutez cette classe qui manque :
class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: const Center(child: Text('Page des notes')),
    );
  }
}
