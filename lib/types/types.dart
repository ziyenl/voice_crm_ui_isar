import 'package:isar/isar.dart'; // Import Isar annotations
// ... other imports like uuid

// Make sure your Tag class is also a collection or embedded
// For tags, since they are part of VoiceNote, they can be embedded
// if they are *only* used within VoiceNote and not as standalone entities
// that you query independently. If you want to query tags globally,
// make Tag its own collection. Let's make Tag an independent Collection for now,
// as it seems like you might want to manage a global list of tags.

part 'types.g.dart'; // <--- IMPORTANT: Add this line for Isar code generation

@collection // Mark Tag as an Isar Collection
class Tag {
  Id id = Isar.autoIncrement; // Auto-incrementing primary key for Isar
  // Or, if you want to use your existing String ID:
  // @Id()
  // String id = Uuid().v4(); // Make sure to generate one if not provided

  // Define an index on the name for faster lookup
  @Index(unique: true, replace: true) // Ensure tag names are unique
  late String name;
  late String color; // Stored as a hex string
  late String type; // 'client', 'content', 'user-defined' etc.

  // No-arg constructor for Isar
  Tag();

  // Your original constructor (you can keep it for convenience when creating new Tag objects)
  Tag.create({
    // Notice: no 'id' parameter here if it's auto-increment or
    // if you intend to set it after creation for new objects.
    // If you explicitly want to pass it for existing objects, it might be
    // part of an optional named parameter.
    required this.name, 
    required this.color, 
    required this.type
    }) {
    // If you use UUID for id, uncomment the line below.
    // Make sure to import 'package:uuid/uuid.dart'; if you use it.
    // id = Uuid().v4();
    // If using String ID:
    // @Id()
    // late String id; // Make sure to assign this when creating a new VoiceNote
  }

  // Optional: copyWith method for easy updating of existing tags
  Tag copyWith({
    String? name,
    String? color,
    String? type,
  }) {
    return Tag.create(
      name: name ?? this.name,
      color: color ?? this.color,
      type: type ?? this.type,
    )..id = this.id; // Crucially, assign the existing ID
  }

  // If you want to explicitly pass an ID for existing tags (e.g., when editing),
  // you might have a factory constructor or an optional parameter like this:
  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag.create(
      name: map['name'],
      color: map['color'],
      type: map['type'],
      // id: map['id'], // If your map includes ID
    )..id = map['id']; // You'd assign it directly to the field
  }

  // Optional: fromJson/toJson for network operations, copyWith, etc.
}


@collection // Mark VoiceNote as an Isar Collection
class VoiceNote {
  Id id = Isar.autoIncrement; // Use Isar's auto-incrementing ID as primary key
  // Or if you want to use your existing String ID:
  // @Id()
  // late String id; // Make sure to assign this when creating a new VoiceNote

  late String title;
  late String filePath; // Path to the audio file
  late int duration; // Duration in seconds
  late DateTime dateRecorded;
  String? transcription; // Nullable
  late bool isFavorite;
  late bool isTranscribed;
  late bool isUploaded;

  // For relationships: Use IsarLinks to establish a many-to-many relationship
  // or a one-to-many relationship with Tags.
  // This will store the IDs of the linked Tags.
  //final tags = IsarLinks<Tag>(); // Use a single list for all tags
  final clientTags = IsarLinks<Tag>();
  final contentTags = IsarLinks<Tag>();
  // You might want to categorize tags (client vs content) within your UI
  // or add a 'tagType' property to the Tag class itself.
  // For simplicity, let's just use one 'tags' link.

  // No-arg constructor for Isar
  VoiceNote();

  // Your original constructor (you can keep it for convenience when creating new VoiceNote objects)
  // Update the constructor to accept separate lists of initial tags
  VoiceNote.create({
    required this.title,
    required this.filePath,
    required this.duration,
    required this.dateRecorded,
    this.transcription,
    //List<Tag> initialTags = const [], // Accept initial tags
    List<Tag> initialClientTags = const [], // New parameter
    List<Tag> initialContentTags = const [], // New parameter
    this.isFavorite = false,
    this.isTranscribed = false,
    this.isUploaded = false,
  }) {
    // If you use UUID for id, uncomment the line below.
    // id = Uuid().v4(); // Assign a new UUID if not using Isar.autoIncrement
    // tags.addAll(initialTags); // Add initial tags to the IsarLinks
       // Assign initial tags to their respective IsarLinks
    clientTags.addAll(initialClientTags);
    contentTags.addAll(initialContentTags);
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