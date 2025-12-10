import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'core/constants/app_constants.dart';
import 'core/network/network_info.dart';
import 'data/datasources/notes_local_datasource.dart';
import 'data/datasources/notes_remote_datasource.dart';
import 'data/models/note_model.dart';
import 'data/repositories/notes_repository_impl.dart';
import 'domain/repositories/notes_repository.dart';
import 'domain/usecases/create_note.dart';
import 'domain/usecases/delete_note.dart';
import 'domain/usecases/get_notes.dart';
import 'domain/usecases/sync_notes.dart';
import 'domain/usecases/update_note.dart';
import 'presentation/bloc/notes_bloc.dart';
import 'presentation/bloc/sync_cubit.dart';
import 'presentation/bloc/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());

  // Hive Boxes
  final notesBox = await Hive.openBox<NoteModel>(AppConstants.notesBoxName);
  final settingsBox = await Hive.openBox(AppConstants.settingsBoxName);

  sl.registerLazySingleton<Box<NoteModel>>(() => notesBox);
  sl.registerLazySingleton<Box>(() => settingsBox, instanceName: 'settings');

  // Core
  sl.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImpl(connectivity: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<NotesLocalDataSource>(
        () => NotesLocalDataSourceImpl(notesBox: sl()),
  );
  sl.registerLazySingleton<NotesRemoteDataSource>(
        () => NotesRemoteDataSourceImpl(client: sl()),
  );

  // Repository
  sl.registerLazySingleton<NotesRepository>(
        () => NotesRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetNotes(sl()));
  sl.registerLazySingleton(() => CreateNote(sl()));
  sl.registerLazySingleton(() => UpdateNote(sl()));
  sl.registerLazySingleton(() => DeleteNote(sl()));
  sl.registerLazySingleton(() => SyncNotes(sl()));
  sl.registerLazySingleton(() => FetchRemoteNotes(sl()));

  // Blocs
  sl.registerFactory(
        () => NotesBloc(
      getNotes: sl(),
      createNote: sl(),
      updateNote: sl(),
      deleteNote: sl(),
      syncNotes: sl(),
      fetchRemoteNotes: sl(),
    ),
  );

  sl.registerFactory(
        () => SyncCubit(repository: sl()),
  );

  sl.registerFactory(
        () => ThemeCubit(settingsBox: sl<Box>(instanceName: 'settings')),
  );
}