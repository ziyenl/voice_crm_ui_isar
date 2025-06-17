
// types/types.dart (example structure)
import 'package:uuid/uuid.dart'; // Example for ID generation

/// Represents a voice note with its details and various statuses.
// Define your VoiceNote class
class VoiceNote {
  final String id;
  final String title;
  final String filePath;
  final int duration; // In seconds
  final DateTime dateRecorded;
  final String? transcription; // Optional transcription text
  final bool isFavorite;
  final bool isTranscribed;
  final bool isUploaded;
  final List<Tag> clientTags; // Tags assigned by the client
  final List<Tag> contentTags; // Tags derived from content

  VoiceNote({
    String? id,
    required this.title,
    required this.filePath,
    required this.duration,
    required this.dateRecorded,
    this.transcription,
    this.isFavorite = false,
    this.isTranscribed = false,
    this.isUploaded = false,
    this.clientTags = const [],
    this.contentTags = const [],
  }) : id = id ?? const Uuid().v4();

  // You might want a .copyWith method for immutability
  VoiceNote copyWith({
    String? id,
    String? title,
    String? filePath,
    int? duration,
    DateTime? dateRecorded,
    String? transcription,
    bool? isFavorite,
    bool? isTranscribed,
    bool? isUploaded,
    List<Tag>? clientTags,
    List<Tag>? contentTags,
  }) {
    return VoiceNote(
      id: id ?? this.id,
      title: title ?? this.title,
      filePath: filePath ?? this.filePath,
      duration: duration ?? this.duration,
      dateRecorded: dateRecorded ?? this.dateRecorded,
      transcription: transcription ?? this.transcription,
      isFavorite: isFavorite ?? this.isFavorite,
      isTranscribed: isTranscribed ?? this.isTranscribed,
      isUploaded: isUploaded ?? this.isUploaded,
      clientTags: clientTags ?? this.clientTags,
      contentTags: contentTags ?? this.contentTags,
    );
  }
}

/// Defines the possible actions that can be performed on a voice note.
enum VoiceNoteAction {
  transcribe,
  upload,
  tag,
  favorite,
  unfavorite,
  delete,
}

// lib/types/types.dart

/// Represents a tag with its properties.
class Tag {
  final String id;
  String name; // Or label depends on your consistent naming
  String color; // This needs to be the hex color string, e.g., '#RRGGBB'
  String type; // 'client' or 'content'

  Tag({
    required this.id,
    required this.name,
    required this.color,
    required this.type,
  });

  // Method to create a copy, useful for updates
  Tag copyWith({
    String? id,
    String? name,
    String? color,
    String? type,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      type: type ?? this.type,
    );
  }
}

/// Represents a tag filter.
class TagFilter {
  final String tagId;
  final String tagName;
  final String tagColor; // Stored as a hex string
  final String type; // 'client' or 'content'

  TagFilter({
    required this.tagId,
    required this.tagName,
    required this.tagColor,
    required this.type,
  });

  // Method for converting a TagFilter to a Map
  Map<String, dynamic> toJson() {
    return {
      'tagId': tagId,
      'tagName': tagName,
      'tagColor': tagColor,
      'type': type,
    };
  }
}