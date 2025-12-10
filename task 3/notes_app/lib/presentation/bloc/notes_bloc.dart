import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/note.dart';
import '../../domain/usecases/create_note.dart';
import '../../domain/usecases/delete_note.dart';
import '../../domain/usecases/get_notes.dart';
import '../../domain/usecases/sync_notes.dart';
import '../../domain/usecases/update_note.dart';
import 'notes_event.dart';
import 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final GetNotes getNotes;
  final CreateNote createNote;
  final UpdateNote updateNote;
  final DeleteNote deleteNote;
  final SyncNotes syncNotes;
  final FetchRemoteNotes fetchRemoteNotes;

  NotesBloc({
    required this.getNotes,
    required this.createNote,
    required this.updateNote,
    required this.deleteNote,
    required this.syncNotes,
    required this.fetchRemoteNotes,
  }) : super(NotesInitial()) {
    on<LoadNotes>(_onLoadNotes);
    on<AddNote>(_onAddNote);
    on<UpdateNoteEvent>(_onUpdateNote);
    on<DeleteNoteEvent>(_onDeleteNote);
    on<SyncNotesEvent>(_onSyncNotes);
    on<FetchRemoteNotesEvent>(_onFetchRemoteNotes);
    on<SearchNotes>(_onSearchNotes);
  }

  Future<void> _onLoadNotes(LoadNotes event, Emitter<NotesState> emit) async {
    emit(NotesLoading());

    final result = await getNotes();

    result.fold(
          (failure) => emit(NotesError(failure.message)),
          (notes) => emit(NotesLoaded(notes: notes)),
    );
  }

  Future<void> _onAddNote(AddNote event, Emitter<NotesState> emit) async {
    final currentState = state;
    if (currentState is! NotesLoaded) return;

    final note = Note(
      id: const Uuid().v4(),
      title: event.title,
      body: event.body,
      colorIndex: event.colorIndex,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      syncStatus: SyncStatus.pending,
    );

    // Optimistic update
    emit(NotesLoaded(
      notes: [note, ...currentState.notes],
      message: 'Note created',
    ));

    final result = await createNote(note);

    result.fold(
          (failure) {
        emit(NotesLoaded(
          notes: currentState.notes,
          message: 'Failed to create note: ${failure.message}',
        ));
      },
          (createdNote) {
        final updatedNotes = [
          createdNote,
          ...currentState.notes,
        ];
        emit(NotesLoaded(notes: updatedNotes, message: 'Note synced'));
      },
    );
  }

  Future<void> _onUpdateNote(
      UpdateNoteEvent event,
      Emitter<NotesState> emit,
      ) async {
    final currentState = state;
    if (currentState is! NotesLoaded) return;

    final updatedNote = event.note.copyWith(
      title: event.title,
      body: event.body,
      colorIndex: event.colorIndex,
      updatedAt: DateTime.now(),
      syncStatus: SyncStatus.pending,
    );

    // Optimistic update
    final updatedNotes = currentState.notes.map((n) {
      return n.id == updatedNote.id ? updatedNote : n;
    }).toList();

    emit(NotesLoaded(notes: updatedNotes, message: 'Note updated'));

    final result = await updateNote(updatedNote);

    result.fold(
          (failure) {
        emit(NotesLoaded(
          notes: updatedNotes,
          message: 'Saved locally, will sync when online',
        ));
      },
          (syncedNote) {
        final syncedNotes = updatedNotes.map((n) {
          return n.id == syncedNote.id ? syncedNote : n;
        }).toList();
        emit(NotesLoaded(notes: syncedNotes, message: 'Note synced'));
      },
    );
  }

  Future<void> _onDeleteNote(
      DeleteNoteEvent event,
      Emitter<NotesState> emit,
      ) async {
    final currentState = state;
    if (currentState is! NotesLoaded) return;

    final noteToDelete = currentState.notes.firstWhere(
          (n) => n.id == event.noteId,
    );

    // Optimistic update
    final updatedNotes = currentState.notes
        .where((n) => n.id != event.noteId)
        .toList();

    emit(NotesLoaded(notes: updatedNotes, message: 'Note deleted'));

    final result = await deleteNote(event.noteId);

    result.fold(
          (failure) {
        emit(NotesLoaded(
          notes: [noteToDelete, ...updatedNotes],
          message: 'Failed to delete: ${failure.message}',
        ));
      },
          (_) {
        // Already deleted
      },
    );
  }

  Future<void> _onSyncNotes(
      SyncNotesEvent event,
      Emitter<NotesState> emit,
      ) async {
    final currentState = state;
    if (currentState is! NotesLoaded) return;

    emit(NotesLoaded(notes: currentState.notes, isSyncing: true));

    final result = await syncNotes();

    result.fold(
          (failure) {
        emit(NotesLoaded(
          notes: currentState.notes,
          isSyncing: false,
          message: 'Sync failed: ${failure.message}',
        ));
      },
          (syncedNotes) {
        emit(NotesLoaded(
          notes: syncedNotes,
          isSyncing: false,
          message: 'All notes synced',
        ));
      },
    );
  }

  Future<void> _onFetchRemoteNotes(
      FetchRemoteNotesEvent event,
      Emitter<NotesState> emit,
      ) async {
    final currentState = state;

    if (currentState is NotesLoaded) {
      emit(NotesLoaded(notes: currentState.notes, isSyncing: true));
    } else {
      emit(NotesLoading());
    }

    final result = await fetchRemoteNotes();

    result.fold(
          (failure) {
        if (currentState is NotesLoaded) {
          emit(NotesLoaded(
            notes: currentState.notes,
            isSyncing: false,
            message: failure.message,
          ));
        } else {
          // Load local notes instead
          add(LoadNotes());
        }
      },
          (notes) {
        emit(NotesLoaded(
          notes: notes,
          isSyncing: false,
          message: 'Notes fetched from server',
        ));
      },
    );
  }

  void _onSearchNotes(SearchNotes event, Emitter<NotesState> emit) {
    final currentState = state;
    if (currentState is! NotesLoaded) return;

    if (event.query.isEmpty) {
      emit(NotesLoaded(notes: currentState.notes));
      return;
    }

    final query = event.query.toLowerCase();
    final filteredNotes = currentState.notes.where((note) {
      return note.title.toLowerCase().contains(query) ||
          note.body.toLowerCase().contains(query);
    }).toList();

    emit(NotesLoaded(
      notes: currentState.notes,
      filteredNotes: filteredNotes,
      searchQuery: event.query,
    ));
  }
}