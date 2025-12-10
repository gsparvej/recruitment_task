import 'package:hive/hive.dart';
import '../../core/constants/app_constants.dart';
import '../../core/error/exceptions.dart';
import '../models/note_model.dart';

abstract class NotesLocalDataSource {
  Future<List<NoteModel>> getNotes();
  Future<NoteModel?> getNoteById(String id);
  Future<NoteModel> saveNote(NoteModel note);
  Future<void> deleteNote(String id);
  Future<List<NoteModel>> getPendingNotes();
  Future<void> clearAllNotes();
}

class NotesLocalDataSourceImpl implements NotesLocalDataSource {
  final Box<NoteModel> notesBox;

  NotesLocalDataSourceImpl({required this.notesBox});

  @override
  Future<List<NoteModel>> getNotes() async {
    try {
      final notes = notesBox.values.toList();
      notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return notes;
    } catch (e) {
      throw CacheException(message: 'Failed to get notes: $e');
    }
  }

  @override
  Future<NoteModel?> getNoteById(String id) async {
    try {
      return notesBox.get(id);
    } catch (e) {
      throw CacheException(message: 'Failed to get note: $e');
    }
  }

  @override
  Future<NoteModel> saveNote(NoteModel note) async {
    try {
      await notesBox.put(note.id, note);
      return note;
    } catch (e) {
      throw CacheException(message: 'Failed to save note: $e');
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    try {
      await notesBox.delete(id);
    } catch (e) {
      throw CacheException(message: 'Failed to delete note: $e');
    }
  }

  @override
  Future<List<NoteModel>> getPendingNotes() async {
    try {
      return notesBox.values
          .where((note) => note.syncStatusIndex != 0)
          .toList();
    } catch (e) {
      throw CacheException(message: 'Failed to get pending notes: $e');
    }
  }

  @override
  Future<void> clearAllNotes() async {
    try {
      await notesBox.clear();
    } catch (e) {
      throw CacheException(message: 'Failed to clear notes: $e');
    }
  }
}