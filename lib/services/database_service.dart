// lib/services/database_service.dart

import 'package:isar/isar.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:voice_crm_ui_upgrade/types/types.dart'; 


// Import your custom path service
import 'package:voice_crm_ui_upgrade/services/my_path_service.dart'; 
import 'dart:io';


class DatabaseService {
  late Isar _isar; // Private instance of Isar // Declare a global Isar instance (or manage with Provider/Riverpod)

  Isar get isar => _isar;

  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<void> init() async {
    if (Isar.instanceNames.isNotEmpty) {
      _isar = Isar.getInstance()!;
      return;
    }

    final pathService = getMyPathService(); 
    final dirPath = await pathService.getDbDirectory(); 

    final schemas = [VoiceNoteSchema, TagSchema]; 

    if (dirPath.isNotEmpty) {
      final directory = Directory(dirPath);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      _isar = await Isar.open(
        schemas,
        directory: dirPath, 
        name: "my_voice_crm_db", 
        inspector: true, 
      );
    } else {
      _isar = await Isar.open(
        schemas,
        directory: "", 
        name: "my_voice_crm_db", 
        inspector: true,
      );
    }

    await _populateMockDataIfEmpty();
  }

  Future<void> _populateMockDataIfEmpty() async {
    if (await _isar.tags.count() == 0) {
      await _isar.writeTxn(() async {
        final clientTagJane = Tag.create(name: 'Jane Smith', color: '#5B9DF9', type: 'client');
        final clientTagPersonal = Tag.create(name: 'Personal', color: '#FFD700', type: 'client');
        final clientTagWork = Tag.create(name: 'Work', color: '#A9A9A9', type: 'client');
        final clientTagClient = Tag.create(name: 'Client', color: '#8A2BE2', type: 'client');

        final contentTagProject = Tag.create(name: 'Project Evergreen', color: '#32CD32', type: 'content');
        final contentTagBudget = Tag.create(name: 'Budget', color: '#FF4500', type: 'content');
        final contentTagMeditation = Tag.create(name: 'Meditation', color: '#6A5ACD', type: 'content');
        final contentTagProductivity = Tag.create(name: 'Productivity', color: '#FF69B4', type: 'content');

        await _isar.tags.putAll([
          clientTagJane, clientTagPersonal, clientTagWork, clientTagClient,
          contentTagProject, contentTagBudget, contentTagMeditation, contentTagProductivity,
        ]);


        final note1 = VoiceNote.create(
          title: 'Meeting Recap - Project Evergreen',
          filePath: '/storage/emulated/0/audio/meeting_evergreen.m4a',
          duration: 320,
          dateRecorded: DateTime(2025, 5, 28, 14, 15),
          transcription: "Key points from the meeting: we need to finalize the budget by next Friday, assign tasks for phase two, and schedule a follow-up with the client by end of next week. John will prepare the initial draft.",
          initialClientTags: [clientTagJane],
          initialContentTags: [contentTagProject, contentTagBudget],
          isFavorite: true,
          isTranscribed: true,
          isUploaded: true,
        );

        final note2 = VoiceNote.create(
          title: 'New App Idea - Meditation Timer',
          filePath: '/storage/emulated/0/audio/app_idea_meditation.wav',
          duration: 185,
          dateRecorded: DateTime(2025, 6, 1, 9, 30),
          transcription: null,
          initialClientTags: [clientTagPersonal],
          initialContentTags: [contentTagMeditation],
          isFavorite: false,
          isTranscribed: false,
          isUploaded: false,
        );

        final note3 = VoiceNote.create(
          title: 'Client Call - Feedback Session',
          filePath: '/storage/emulated/0/audio/client_feedback.aac',
          duration: 480,
          dateRecorded: DateTime(2025, 6, 5, 10, 0),
          transcription: "The client provided positive feedback on the design mockups but requested a minor adjustment to the color scheme and a review of the onboarding flow. They also inquired about future feature possibilities.",
          initialClientTags: [clientTagWork, clientTagClient], 
          initialContentTags: [], 
          isFavorite: false,
          isTranscribed: true,
          isUploaded: false,
        );
      

        await _isar.voiceNotes.putAll([note1, note2, note3]);
        await note1.clientTags.save();
        await note1.contentTags.save();
        await note2.clientTags.save();
        await note2.contentTags.save();
        await note3.clientTags.save();
        await note3.contentTags.save();
      });
    }
  }

  Future<void> close() async {
    await _isar.close();
  }

  Stream<List<Tag>> getTagsStream() {
    return _isar.tags.where().watch(fireImmediately: true);
  }

  Future<void> addTag(Tag tag) async {
    await _isar.writeTxn(() async {
      await _isar.tags.put(tag);
    });
  }
  
  Future<void> deleteTag(int tagId) async {
    await _isar.writeTxn(() async {
      await _isar.tags.delete(tagId);
    });
  }

  Future<Tag?> getTagById(int id) async {
    return await _isar.tags.get(id);
  }

  Future<Tag?> getTagByName(String name) async {
    return await _isar.tags.filter().nameEqualTo(name, caseSensitive: false).findFirst();
  }

}
