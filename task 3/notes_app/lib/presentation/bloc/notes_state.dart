import 'package:equatable/equatable.dart';
import '../../domain/entities/note.dart';

abstract class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object?> get props => [];
}

class NotesInitial extends NotesState {}

class NotesLoading extends NotesState {}

class NotesLoaded extends NotesState {
  final List<Note> notes;
  final List<Note>? filteredNotes;
  final String? searchQuery;
  final bool isSyncing;
  final String? message;

  const NotesLoaded({
    required this.notes,
    this.filteredNotes,
    this.searchQuery,
    this.isSyncing = false,
    this.message,
  });

  List<Note> get displayNotes => filteredNotes ?? notes;

  int get pendingCount => notes.where((n) => n.syncStatus == SyncStatus.pending).length;

  @override
  List<Object?> get props => [notes, filteredNotes, searchQuery, isSyncing, message];
}

class NotesError extends NotesState {
  final String message;

  const NotesError(this.message);

  @override
  List<Object?> get props => [message];
}