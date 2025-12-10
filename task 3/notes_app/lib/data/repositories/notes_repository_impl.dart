import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/notes_local_datasource.dart';
import '../datasources/notes_remote_datasource.dart';
import '../models/note_model.dart';

class NotesRepositoryImpl implements NotesRepository {
  final NotesLocalDataSource localDataSource;
  final NotesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NotesRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Note>>> getNotes() async {
    try {
      final notes = await localDataSource.getNotes();
      return Right(notes.map((e) => e.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Note>> getNoteById(String id) async {
    try {
      final note = await localDataSource.getNoteById(id);
      if (note != null) {
        return Right(note.toEntity());
      } else {
        return const Left(CacheFailure(message: 'Note not found'));
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Note>> createNote(Note note) async {
    try {
      final noteModel = NoteModel.fromEntity(note);

      // Save locally first
      await localDataSource.saveNote(noteModel);

      // Try to sync if online
      if (await networkInfo.isConnected) {
        try {
          final syncedNote = await remoteDataSource.createNote(noteModel);
          await localDataSource.saveNote(syncedNote);
          return Right(syncedNote.toEntity());
        } catch (_) {
          // If sync fails, return local note with pending status
          return Right(note.copyWith(syncStatus: SyncStatus.pending));
        }
      }

      return Right(note.copyWith(syncStatus: SyncStatus.pending));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Note>> updateNote(Note note) async {
    try {
      final noteModel = NoteModel.fromEntity(
        note.copyWith(
          updatedAt: DateTime.now(),
          syncStatus: SyncStatus.pending,
        ),
      );

      // Save locally first
      await localDataSource.saveNote(noteModel);

      // Try to sync if online
      if (await networkInfo.isConnected) {
        try {
          final syncedNote = await remoteDataSource.updateNote(noteModel);
          await localDataSource.saveNote(syncedNote);
          return Right(syncedNote.toEntity());
        } catch (_) {
          return Right(noteModel.toEntity());
        }
      }

      return Right(noteModel.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNote(String id) async {
    try {
      final note = await localDataSource.getNoteById(id);

      await localDataSource.deleteNote(id);

      // Try to delete on server if synced
      if (await networkInfo.isConnected && note?.serverId != null) {
        try {
          await remoteDataSource.deleteNote(note!.serverId!);
        } catch (_) {
          // Ignore server delete errors
        }
      }

      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> syncNotes() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final pendingNotes = await localDataSource.getPendingNotes();

      for (final note in pendingNotes) {
        try {
          NoteModel syncedNote;
          if (note.serverId == null) {
            syncedNote = await remoteDataSource.createNote(note);
          } else {
            syncedNote = await remoteDataSource.updateNote(note);
          }
          await localDataSource.saveNote(syncedNote);
        } catch (_) {
          // Mark as failed if sync fails
          await localDataSource.saveNote(
            note.copyWith(syncStatusIndex: 2),
          );
        }
      }

      final notes = await localDataSource.getNotes();
      return Right(notes.map((e) => e.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(SyncFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> syncNote(Note note) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final noteModel = NoteModel.fromEntity(note);
      NoteModel syncedNote;

      if (note.serverId == null) {
        syncedNote = await remoteDataSource.createNote(noteModel);
      } else {
        syncedNote = await remoteDataSource.updateNote(noteModel);
      }

      await localDataSource.saveNote(syncedNote);
      return Right(syncedNote.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(SyncFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> fetchRemoteNotes() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final remoteNotes = await remoteDataSource.fetchNotes();

      // Save remote notes locally
      for (final note in remoteNotes) {
        final existingNote = await localDataSource.getNoteById(note.id);
        if (existingNote == null) {
          await localDataSource.saveNote(note);
        }
      }

      final notes = await localDataSource.getNotes();
      return Right(notes.map((e) => e.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(SyncFailure(message: e.toString()));
    }
  }

  @override
  Stream<bool> get connectivityStream => networkInfo.onConnectivityChanged;
}