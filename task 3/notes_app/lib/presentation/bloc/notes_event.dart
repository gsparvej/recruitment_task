import 'package:equatable/equatable.dart';
import '../../domain/entities/note.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotes extends NotesEvent {}

class AddNote extends NotesEvent {
  final String title;
  final String body;
  final int colorIndex;

  const AddNote({
    required this.title,
    required this.body,
    this.colorIndex = 0,
  });

  @override
  List<Object?> get props => [title, body, colorIndex];
}

class UpdateNoteEvent extends NotesEvent {
  final Note note;
  final String title;
  final String body;
  final int colorIndex;

  const UpdateNoteEvent({
    required this.note,
    required this.title,
    required this.body,
    required this.colorIndex,
  });

  @override
  List<Object?> get props => [note, title, body, colorIndex];
}

class DeleteNoteEvent extends NotesEvent {
  final String noteId;

  const DeleteNoteEvent(this.noteId);

  @override
  List<Object?> get props => [noteId];
}

class SyncNotesEvent extends NotesEvent {}

class FetchRemoteNotesEvent extends NotesEvent {}

class SearchNotes extends NotesEvent {
  final String query;

  const SearchNotes(this.query);

  @override
  List<Object?> get props => [query];
}