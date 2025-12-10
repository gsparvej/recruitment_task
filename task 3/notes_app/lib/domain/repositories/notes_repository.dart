import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/note.dart';

abstract class NotesRepository {
  Future<Either<Failure, List<Note>>> getNotes();
  Future<Either<Failure, Note>> getNoteById(String id);
  Future<Either<Failure, Note>> createNote(Note note);
  Future<Either<Failure, Note>> updateNote(Note note);
  Future<Either<Failure, void>> deleteNote(String id);
  Future<Either<Failure, List<Note>>> syncNotes();
  Future<Either<Failure, Note>> syncNote(Note note);
  Future<Either<Failure, List<Note>>> fetchRemoteNotes();
  Stream<bool> get connectivityStream;
}