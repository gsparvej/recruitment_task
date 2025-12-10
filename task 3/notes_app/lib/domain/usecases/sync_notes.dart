import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/note.dart';
import '../repositories/notes_repository.dart';

class SyncNotes {
  final NotesRepository repository;

  SyncNotes(this.repository);

  Future<Either<Failure, List<Note>>> call() async {
    return await repository.syncNotes();
  }
}

class SyncSingleNote {
  final NotesRepository repository;

  SyncSingleNote(this.repository);

  Future<Either<Failure, Note>> call(Note note) async {
    return await repository.syncNote(note);
  }
}

class FetchRemoteNotes {
  final NotesRepository repository;

  FetchRemoteNotes(this.repository);

  Future<Either<Failure, List<Note>>> call() async {
    return await repository.fetchRemoteNotes();
  }
}