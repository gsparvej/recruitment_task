import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum SyncStatus {
  synced,
  pending,
  failed,
}

class Note extends Equatable {
  final String id;
  final String title;
  final String body;
  final int colorIndex;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SyncStatus syncStatus;
  final int? serverId;
  final int userId;

  const Note({
    required this.id,
    required this.title,
    required this.body,
    this.colorIndex = 0,
    required this.createdAt,
    required this.updatedAt,
    this.syncStatus = SyncStatus.pending,
    this.serverId,
    this.userId = 1,
  });

  Note copyWith({
    String? id,
    String? title,
    String? body,
    int? colorIndex,
    DateTime? createdAt,
    DateTime? updatedAt,
    SyncStatus? syncStatus,
    int? serverId,
    int? userId,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      colorIndex: colorIndex ?? this.colorIndex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      serverId: serverId ?? this.serverId,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    body,
    colorIndex,
    createdAt,
    updatedAt,
    syncStatus,
    serverId,
    userId,
  ];
}