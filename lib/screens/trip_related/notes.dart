import 'package:flutter/material.dart';
import '../../constants/text_styles.dart';
import '../../components/button_primary.dart';
import '../../services/notes_service.dart';

class NotesPage extends StatefulWidget {
  final Map<String, dynamic>? trip;

  const NotesPage({Key? key, this.trip}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late TextEditingController _notesController;
  bool _isSaving = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
    _loadNote();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadNote() async {
    try {
      final tripId = widget.trip?['tripId'] ?? 0;
      print('DEBUG: Loading note for tripId: $tripId');
      print('DEBUG: Trip data: ${widget.trip}');
      
      final noteText = await NotesService.getNote(tripId);
      print('DEBUG: Loaded note text: "$noteText"');
      
      if (mounted) {
        setState(() {
          _notesController.text = noteText;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading note: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveNote() async {
    if (_notesController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez écrire une note'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final tripId = widget.trip?['tripId'] ?? 0;
      await NotesService.saveNote(tripId, _notesController.text);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Note enregistrée avec succès'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notes du voyage',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Vos notes',
                    style: TextStyles.h2,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Écrivez vos impressions, observations et souvenirs de ce voyage',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Grand input de texte
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _notesController,
                        maxLines: null,
                        expands: true,
                        enabled: !_isSaving,
                        decoration: InputDecoration(
                          hintText: 'Écrivez vos notes ici...',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16.0),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.6,
                        ),
                        textAlignVertical: TextAlignVertical.top,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Bouton enregistrer
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ButtonPrimary(
                      label: _isSaving ? 'Enregistrement...' : 'Enregistrer',
                      onPressed: _isSaving ? () {} : () => _saveNote(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
