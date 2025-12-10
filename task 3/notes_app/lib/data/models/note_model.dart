import 'package:hive/hive.dart';
import '../../domain/entities/note.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String body;

  @HiveField(3)
  final int colorIndex;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime updatedAt;

  @HiveField(6)
  final int syncStatusIndex;

  @HiveField(7)
  final int? serverId;

  @HiveField(8)
  final int userId;

  NoteModel({
    required this.id,
    required this.title,
    required this.body,
    this.colorIndex = 0,
    required this.createdAt,
    required this.updatedAt,
    this.syncStatusIndex = 1,
    this.serverId,
    this.userId = 1,
  });

  factory NoteModel.fromEntity(Note note) {
    return NoteModel(
      id: note.id,
      title: note.title,
      body: note.body,
      colorIndex: note.colorIndex,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
      syncStatusIndex: note.syncStatus.index,
      serverId: note.serverId,
      userId: note.userId,
    );
  }

  Note toEntity() {
    return Note(
      id: id,
      title: title,
      body: body,
      colorIndex: colorIndex,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: SyncStatus.values[syncStatusIndex],
      serverId: serverId,
      userId: userId,
    );
  }

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['localId'] ?? json['id'].toString(),
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      colorIndex: json['colorIndex'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      syncStatusIndex: json['syncStatus'] ?? 0,
      serverId: json['id'] is int ? json['id'] : null,
      userId: json['userId'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'userId': userId,
    };
  }

  NoteModel copyWith({
    String? id,
    String? title,
    String? body,
    int? colorIndex,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? syncStatusIndex,
    int? serverId,
    int? userId,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      colorIndex: colorIndex ?? this.colorIndex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatusIndex: syncStatusIndex ?? this.syncStatusIndex,
      serverId: serverId ?? this.serverId,
      userId: userId ?? this.userId,
    );
  }
}