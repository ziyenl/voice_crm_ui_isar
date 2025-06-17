// lib/services/database_service.dart

import 'package:isar/isar.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:voice_crm_ui_upgrade/types/types.dart'; // Import your generated Isar types


// Import your custom path service
import 'package:voice_crm_ui_upgrade/services/my_path_service.dart'; // <--- ADD THIS IMPORT
import 'dart:io'; // Keep this for Directory.exists()/create() checks on non-web platforms


class DatabaseService {
  late Isar _isar; // Private instance of Isar // Declare a global Isar instance (or manage with Provider/Riverpod)

  // Getter to access the Isar instance
  Isar get isar => _isar;

  // Singleton pattern for the DatabaseService
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  /// Initializes the Isar database.
  /// This should be called once when the application starts.
  Future<void> init() async {
    if (Isar.instanceNames.isNotEmpty) {
      // If Isar is already open (e.g., hot restart), don't open again
      _isar = Isar.getInstance()!;
      return;
    }

    // final dir = await getApplicationSupportDirectory();
    // _isar = await Isar.open(
    //   [VoiceNoteSchema, TagSchema], // Include all your collection schemas
    //   directory: dir.path,
    //   name: "my_voice_crm_db", // Optional: A name for your database
    //   inspector: true, // Enable Isar Inspector for debugging
    // );

     // Use your custom path service to get the directory based on the platform
    final pathService = getMyPathService(); // Get the platform-specific service
    final dirPath = await pathService.getDbDirectory(); // Get the directory path

    final schemas = [VoiceNoteSchema, TagSchema]; // Include all your collection schemas

    if (dirPath.isNotEmpty) {
      // This branch executes on mobile/desktop where a valid path is returned
      final directory = Directory(dirPath);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      _isar = await Isar.open(
        schemas,
        directory: dirPath, // Use the path for non-web platforms
        name: "my_voice_crm_db", // Optional: A name for your database
        inspector: true, // Enable Isar Inspector for debugging
      );
    } else {
       // THIS BLOCK IS FOR WEB where dirPath IS EMPTY (from my_path_service_web.dart)
      // For Isar 3.1.0 (which your pubspec.lock confirms you're using),
      // the 'directory' parameter is REQUIRED even for web.
      // You must explicitly pass 'null' for the directory on web.
      _isar = await Isar.open(
        schemas,
        directory: "", // <--- THIS IS THE CRUCIAL LINE FOR WEB/ISAR 3.1.0
        name: "my_voice_crm_db", // You can still specify a name for web
        inspector: true,
      );
    }

    // Optional: Populate mock data if the database is empty on first launch
    await _populateMockDataIfEmpty();
  }

  /// Optional: Populates the database with mock data if it's currently empty.
  Future<void> _populateMockDataIfEmpty() async {
    // Check if tags collection is empty
    if (await _isar.tags.count() == 0) {
      await _isar.writeTxn(() async {
        // Create and save mock tags
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

        // Create voice notes and link them to tags
        // Make sure to retrieve the persisted Tag objects after saving them
        // to correctly establish links, or manually assign their IDs.
        // For simplicity here, we're using the direct Tag objects after putAll.
        // In a real scenario, if tags were created elsewhere, you'd fetch them
        // by ID.

        // Retrieve persisted tags to ensure correct linking if IDs are auto-generated
        // (IsarLinks work best with objects that have been put into the database)
        // final retrievedTag1 = await _isar.tags.get(tag1.id);
        // final retrievedTag5 = await _isar.tags.get(tag5.id);
        // final retrievedTag6 = await _isar.tags.get(tag6.id);
        // final retrievedTag2 = await _isar.tags.get(tag2.id);
        // final retrievedTag7 = await _isar.tags.get(tag7.id);
        // final retrievedTag3 = await _isar.tags.get(tag3.id);

        final note1 = VoiceNote.create(
          title: 'Meeting Recap - Project Evergreen',
          filePath: '/storage/emulated/0/audio/meeting_evergreen.m4a',
          duration: 320,
          dateRecorded: DateTime(2025, 5, 28, 14, 15),
          transcription: "Key points from the meeting: we need to finalize the budget by next Friday, assign tasks for phase two, and schedule a follow-up with the client by end of next week. John will prepare the initial draft.",
           // Pass the tags to the new constructor parameters
          initialClientTags: [clientTagJane],
          initialContentTags: [contentTagProject, contentTagBudget],
          isFavorite: true,
          isTranscribed: true,
          isUploaded: true,
        );
        // note1.tags.add(tag1); // Link tags
        // note1.tags.add(tag5);
        // note1.tags.add(tag6);

        // note1.tags.add(retrievedTag1!); // Link tags
        // note1.tags.add(retrievedTag5!);
        // note1.tags.add(retrievedTag6!);

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
        // note2.tags.add(tag2);
        // note2.tags.add(tag7);
        // note2.tags.add(retrievedTag2!);
        // note2.tags.add(retrievedTag7!);

        final note3 = VoiceNote.create(
          title: 'Client Call - Feedback Session',
          filePath: '/storage/emulated/0/audio/client_feedback.aac',
          duration: 480,
          dateRecorded: DateTime(2025, 6, 5, 10, 0),
          transcription: "The client provided positive feedback on the design mockups but requested a minor adjustment to the color scheme and a review of the onboarding flow. They also inquired about future feature possibilities.",
          initialClientTags: [clientTagWork, clientTagClient], // Example: multiple client tags
          initialContentTags: [], // No content tags for this one
          isFavorite: false,
          isTranscribed: true,
          isUploaded: false,
        );
        // note3.tags.add(tag3);
        // note3.tags.add(retrievedTag3!);

        //await _isar.voiceNotes.putAll([note1, note2, note3]); // Save notes
        // After putting the notes, save the links to establish the relationships
        // await note1.tags.save(); // Save links
        // await note2.tags.save();
        // await note3.tags.save();

        await _isar.voiceNotes.putAll([note1, note2, note3]);
        // IMPORTANT: Save each IsarLinks collection separately
        await note1.clientTags.save();
        await note1.contentTags.save();
        await note2.clientTags.save();
        await note2.contentTags.save();
        await note3.clientTags.save();
        await note3.contentTags.save();
      });
    }
  }

  /// Closes the Isar database.
  /// Call this when the app is terminating, though often not strictly necessary in Flutter.
  Future<void> close() async {
    await _isar.close();
  }

  // Tag Management Methods

  // Stream to get all tags, useful for a tag management screen or selection
  Stream<List<Tag>> getTagsStream() {
    return _isar.tags.where().watch(fireImmediately: true);
  }

  // Method to add a new tag
  Future<void> addTag(Tag tag) async {
    await _isar.writeTxn(() async {
      // Isar's put method will either insert a new object or update an existing one
      // if an ID is provided. With autoIncrement, it always inserts unless ID is manually set.
      await _isar.tags.put(tag);
    });
  }

  // Method to delete a tag by its ID
  Future<void> deleteTag(int tagId) async {
    await _isar.writeTxn(() async {
      await _isar.tags.delete(tagId);
    });
  }

  // Method to get a single tag by its ID
  Future<Tag?> getTagById(int id) async {
    return await _isar.tags.get(id);
  }

  // Method to get a single tag by its name (useful for checking uniqueness or retrieving existing)
  Future<Tag?> getTagByName(String name) async {
    return await _isar.tags.filter().nameEqualTo(name, caseSensitive: false).findFirst();
  }

}