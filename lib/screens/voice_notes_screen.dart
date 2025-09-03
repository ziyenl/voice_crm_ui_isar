// lib/screens/voice_notes_screen.dart

import 'package:flutter/material.dart';
import 'package:voice_crm_ui_upgrade/widgets/VoiceNoteCard.dart'; 
import 'package:voice_crm_ui_upgrade/types/types.dart';             
import 'package:voice_crm_ui_upgrade/widgets/logo.dart'; 
import 'package:isar/isar.dart';
import 'package:voice_crm_ui_upgrade/services/database_service.dart'; 


class MyVoiceNotesScreen extends StatefulWidget { 
  const MyVoiceNotesScreen({super.key});

  @override
  State<MyVoiceNotesScreen> createState() => _MyVoiceNotesScreenState();
}

class _MyVoiceNotesScreenState extends State<MyVoiceNotesScreen> {
  
  final Isar _isar = DatabaseService().isar; 

  void _handleVoiceNoteAction(VoiceNoteAction action, int noteId) async {
    print('Performing action: "$action" on Voice Note ID: "$noteId"');

    //final voiceNote = await _isar.voiceNotes.filter().idEqualTo(int.parse(noteId)).findFirst(); 
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
          voiceNote.isTranscribed = !voiceNote.isTranscribed; 
          await _isar.voiceNotes.put(voiceNote); // Save changes
          print('Transcribing voice note: ${voiceNote.id}, now: ${voiceNote.isTranscribed}');
          break;
        case VoiceNoteAction.upload:
          voiceNote.isUploaded = !voiceNote.isUploaded; 
          await _isar.voiceNotes.put(voiceNote);
          print('Uploading voice note: ${voiceNote.id}, now: ${voiceNote.isUploaded}');
          break;
        case VoiceNoteAction.favorite:
          voiceNote.isFavorite = !voiceNote.isFavorite; 
          await _isar.voiceNotes.put(voiceNote);
          print('Marking voice note ${voiceNote.id} as favorite: ${voiceNote.isFavorite}');
          break;
        case VoiceNoteAction.unfavorite:
          voiceNote.isFavorite = false; 
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
  }

  @override
  Widget build(BuildContext context) {
     return Column(
      children: [
        AppBar(
          title: const Logo(size: LogoSize.small),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        Expanded(
          child: StreamBuilder<List<VoiceNote>>(
            stream: _isar.voiceNotes.where().watch(fireImmediately: true), 
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
