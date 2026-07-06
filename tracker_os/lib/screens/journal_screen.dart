import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import '../theme/app_theme.dart';
import '../widgets/neo_brutalist_container.dart';
import '../widgets/neo_brutalist_button.dart';
import '../models/journal_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  List<JournalEntryModel> _entries = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getStringList('journal_entries');
    if (mounted && entriesJson != null) {
      setState(() {
        _entries = entriesJson
            .map((e) => JournalEntryModel.fromJson(json.decode(e)))
            .toList();
        // Sort newest first
        _entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      });
    }
  }

  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final eJson = _entries.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('journal_entries', eJson);
  }

  void _showNewEntryDialog() {
    final textController = TextEditingController();
    List<XFile> pickedPhotos = [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppTheme.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(
                  color: AppTheme.border.withOpacity(0.5),
                  width: 1,
                ),
              ),
              title: Text(
                'NEW ENTRY',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: textController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'What did you do today?',
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    NeoBrutalistButton(
                      backgroundColor: AppTheme.surface,
                      onPressed: () async {
                        final List<XFile> images = await _picker.pickMultiImage();
                        if (images.isNotEmpty) {
                          setDialogState(() {
                            pickedPhotos.addAll(images);
                          });
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            pickedPhotos.isNotEmpty
                                ? Icons.check_circle
                                : Icons.add_a_photo,
                            color: pickedPhotos.isNotEmpty
                                ? AppTheme.primary
                                : Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            pickedPhotos.isNotEmpty
                                ? '${pickedPhotos.length} PHOTO(S)'
                                : 'ATTACH PHOTOS',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                NeoBrutalistButton(
                  backgroundColor: AppTheme.primary,
                  onPressed: () {
                    if (textController.text.isNotEmpty || pickedPhotos.isNotEmpty) {
                      setState(() {
                        _entries.insert(
                          0,
                          JournalEntryModel(
                            id: DateTime.now().toString(),
                            text: textController.text,
                            photoPaths: pickedPhotos.map((p) => p.path).toList(),
                            timestamp: DateTime.now(),
                          ),
                        );
                      });
                      _saveEntries();
                      Navigator.pop(context);
                    }
                  },
                  child: const Center(child: Text('SAVE ENTRY')),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('DAILY JOURNAL'),
        backgroundColor: Colors.transparent,
      ),
      body: _entries.isEmpty
          ? Center(
              child: Text(
                'No entries yet.Start journaling!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.onSurface.withOpacity(0.5),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final entry = _entries[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: NeoBrutalistContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat(
                            'EEEE, MMM d, yyyy - h:mm a',
                          ).format(entry.timestamp),
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(color: AppTheme.primary),
                        ),
                        const SizedBox(height: 12),
                        if (entry.text.isNotEmpty) ...[
                          Text(
                            entry.text,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 12),
                        ],
                        if (entry.photoPaths.isNotEmpty)
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: entry.photoPaths.length,
                              itemBuilder: (context, pIndex) {
                                final pPath = entry.photoPaths[pIndex];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black, width: 3),
                                    ),
                                    child: kIsWeb
                                        ? Image.network(
                                            pPath,
                                            fit: BoxFit.cover,
                                            width: 200,
                                          )
                                        : Image.file(
                                            File(pPath),
                                            fit: BoxFit.cover,
                                            width: 200,
                                          ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewEntryDialog,
        child: const Icon(Icons.edit),
      ),
    );
  }
}
