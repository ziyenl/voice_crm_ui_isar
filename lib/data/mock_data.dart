// lib/data/mock_data.dart

import 'package:voice_crm_ui_upgrade/types/types.dart';

// Mock client tags
final List<Tag> mockTags = [
  // Tag(id: '1', name: 'Jane Smith', color: '#5B9DF9', type: 'client'),
  // Tag(id: '2', name: 'Alex Johnson', color: '#A18CD1', type: 'client'),
  // Tag(id: '3', name: 'Mark Williams', color: '#F97316', type: 'client'),
  // Tag(id: '4', name: 'Sarah Miller', color: '#10B981', type: 'client'),
  // Tag(id: '5', name: 'Important', color: '#EF4444', type: 'content'),
  // Tag(id: '6', name: 'Follow-up', color: '#F59E0B', type: 'content'),
  // Tag(id: '7', name: 'Completed', color: '#10B981', type: 'content'),
  // Tag(id: '8', name: 'Legal', color: '#6366F1', type: 'content'),
  // Tag(id: '9', name: 'Personal', color: '#EC4899', type: 'content'),
];

/// Retrieves a [Tag] object by its [id] from the mock data.
/// Returns null if the tag is not found.
/// Helper function to retrieve a Tag by ID (ensure it handles null safely if ID might not exist)
Tag? getTagById(String tagId) {
  try {
    return mockTags.firstWhere((tag) => tag.id == tagId );
  } catch (e) {
    return null; // Return null if tag is not found
  }
  // return mockTags.firstWhere((tag) => tag.id == id, orElse: () => null);
}

/// Helper function to get client tags from mock data.
List<Tag> getClientTags() {
  return mockTags.where((tag) => tag.type == 'client').toList();
}

/// Helper function to get content tags from mock data.
List<Tag> getContentTags() {
  return mockTags.where((tag) => tag.type == 'content').toList();
}

// --- Mock Voice Note Data ---
// --- Example VoiceNote Data ---
// In a real application, you would fetch this data from an API,
// a local database, or a state management store.
final List<VoiceNote> mockVoiceNotes = [
  // VoiceNote(
  //   id: 'note_001',
  //   title: 'Meeting Recap - Project Evergreen',
  //   filePath: '/storage/emulated/0/audio/meeting_evergreen.m4a',
  //   duration: 320, // 5 minutes 20 seconds
  //   dateRecorded: DateTime(2025, 5, 28, 14, 15),
  //   transcription: "Key points from the meeting: we need to finalize the budget by next Friday, assign tasks for phase two, and schedule a follow-up with the client by end of next week. John will prepare the initial draft.",
  //   clientTags: [getTagById('1')!], //['Work', 'Meeting'],
  //   contentTags: [getTagById('5')!, getTagById('6')!], //['Project Evergreen', 'Budget', 'Tasks'],
  //   isFavorite: true,
  //   isTranscribed: true,
  //   isUploaded: true,
  // ),
  // VoiceNote(
  //   id: 'note_002',
  //   title: 'New App Idea - Meditation Timer',
  //   filePath: '/storage/emulated/0/audio/app_idea_meditation.wav',
  //   duration: 185, // 3 minutes 5 seconds
  //   dateRecorded: DateTime(2025, 6, 1, 9, 30),
  //   transcription: null, // This note is not transcribed
  //   clientTags: [getTagById('2')!], //['Personal', 'Ideas'],
  //   contentTags: [getTagById('7')!], //['Meditation', 'Productivity'],
  //   isFavorite: false,
  //   isTranscribed: false, // Important: This will make it un-expandable
  //   isUploaded: false,
  // ),
  // VoiceNote(
  //   id: 'note_003',
  //   title: 'Client Call - Feedback Session',
  //   filePath: '/storage/emulated/0/audio/client_feedback.aac',
  //   duration: 480, // 8 minutes 0 seconds
  //   dateRecorded: DateTime(2025, 6, 5, 10, 0),
  //   transcription: "The client provided positive feedback on the design mockups but requested a minor adjustment to the color scheme and a review of the onboarding flow. They also inquired about future feature possibilities.",
  //   clientTags: [getTagById('3')!], //['Work', 'Client'],
  //   contentTags: [],  //['Feedback', 'Design'], // Assuming no content tags for this example
  //   isFavorite: false,
  //   isTranscribed: true,
  //   isUploaded: false, // Not yet uploaded
  // ),
];