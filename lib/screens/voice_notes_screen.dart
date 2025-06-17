// lib/screens/voice_notes_screen.dart

import 'package:flutter/material.dart';
import 'package:voice_crm_ui_upgrade/widgets/VoiceNoteCard.dart'; // <--- Import VoiceNoteCard
import 'package:voice_crm_ui_upgrade/types/types.dart';             // <--- Import VoiceNote and VoiceNoteAction
import 'package:voice_crm_ui_upgrade/widgets/logo.dart'; // Logo
import 'package:isar/isar.dart';
import 'package:voice_crm_ui_upgrade/services/database_service.dart'; // <--- Import your database service


class MyVoiceNotesScreen extends StatefulWidget { // <--- CHANGE to StatefulWidget
  const MyVoiceNotesScreen({super.key});

  @override
  State<MyVoiceNotesScreen> createState() => _MyVoiceNotesScreenState();
}

class _MyVoiceNotesScreenState extends State<MyVoiceNotesScreen> {
  
  // Access the Isar instance through the service
  final Isar _isar = DatabaseService().isar; // <--- Access Isar via the service

  // This function would typically handle actions like deleting, transcribing, etc.
  // It receives the action type and the ID of the note.
  void _handleVoiceNoteAction(VoiceNoteAction action, int noteId) async {
    // In a real app, you would dispatch to a state management solution (e.g., Provider, BLoC, Riverpod)
    // or call an API/service here to perform the actual action.
    print('Performing action: "$action" on Voice Note ID: "$noteId"');

    // Retrieve the voice note from Isar
    // Ensure you convert the String noteId to the correct type for Isar's Id (int or String based on your Tag schema)
    // No need for int.parse(noteId) anymore, as noteId is already an int!
    //final voiceNote = await _isar.voiceNotes.filter().idEqualTo(int.parse(noteId)).findFirst(); // Assuming ID is int
     final voiceNote = await _isar.voiceNotes.filter().idEqualTo(noteId).findFirst();
     
    if (voiceNote == null) {
      print('Voice Note with ID $noteId not found.');
      return;
    }

    await _isar.writeTxn(() async {
      switch (action) {
        case VoiceNoteAction.delete:
          await _isar.voiceNotes.delete(voiceNote.id); // Delete from Isar
          print('Deleted voice note: ${voiceNote.id}');
          break;
        case VoiceNoteAction.transcribe:
          voiceNote.isTranscribed = !voiceNote.isTranscribed; // Toggle
          await _isar.voiceNotes.put(voiceNote); // Save changes
          print('Transcribing voice note: ${voiceNote.id}, now: ${voiceNote.isTranscribed}');
          break;
        case VoiceNoteAction.upload:
          voiceNote.isUploaded = !voiceNote.isUploaded; // Toggle
          await _isar.voiceNotes.put(voiceNote);
          print('Uploading voice note: ${voiceNote.id}, now: ${voiceNote.isUploaded}');
          break;
        case VoiceNoteAction.favorite:
          voiceNote.isFavorite = !voiceNote.isFavorite; // Toggle
          await _isar.voiceNotes.put(voiceNote);
          print('Marking voice note ${voiceNote.id} as favorite: ${voiceNote.isFavorite}');
          break;
        case VoiceNoteAction.unfavorite:
          voiceNote.isFavorite = false; // Explicitly unfavorite
          await _isar.voiceNotes.put(voiceNote);
          print('Removing voice note ${voiceNote.id} from favorites.');
          break;
        case VoiceNoteAction.tag:
          print('Adding tags to voice note: ${voiceNote.id}');
          // For adding/removing tags, you would usually navigate to a new screen
          // where the user can select/manage tags, then update voiceNote.tags
          // and save voiceNote again.

          // Note: If you add/remove tags in this function, you'll modify
          // voiceNote.clientTags.add(...) or voiceNote.contentTags.remove(...)
          // and then call await voiceNote.clientTags.save() / await voiceNote.contentTags.save()

          break;
      }
    });
    // You would then update your UI (e.g., if a note is deleted, it disappears)
    // This usually involves calling setState in a StatefulWidget that holds the list,
    // or updating your state management solution.
  }

  @override
  Widget build(BuildContext context) {
    // Instead of returning a Scaffold, return the content directly.
    // Use a Column to vertically stack the AppBar and the ListView.
     return Column(
      children: [
        AppBar(
          title: const Logo(size: LogoSize.small),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        Expanded(
          // Use StreamBuilder to listen for changes from Isar
          child: StreamBuilder<List<VoiceNote>>(
            stream: _isar.voiceNotes.where().watch(fireImmediately: true), // Watch all voice notes // <--- Use _isar from the service
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No voice notes found.'));
              }

              final voiceNotes = snapshot.data!;

              return ListView.builder(
                itemCount: voiceNotes.length,
                itemBuilder: (context, index) {
                  final voiceNote = voiceNotes[index];
                  // IMPORTANT: Eagerly load linked tags for display
                  // IsarLinks are lazily loaded by default.
                  //voiceNote.tags.loadSync(); // Load linked tags immediately
                  // Load both clientTags and contentTags
                  voiceNote.clientTags.loadSync();
                  voiceNote.contentTags.loadSync();

                  return VoiceNoteCard(
                    voiceNote: voiceNote,
                    onAction: _handleVoiceNoteAction,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}