import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/notes_repository.dart';

enum ConnectivityStatus { online, offline }

class SyncCubit extends Cubit<ConnectivityStatus> {
  final NotesRepository repository;
  StreamSubscription? _subscription;

  SyncCubit({required this.repository}) : super(ConnectivityStatus.online) {
    _init();
  }

  void _init() {
    _subscription = repository.connectivityStream.listen((isConnected) {
      emit(isConnected ? ConnectivityStatus.online : ConnectivityStatus.offline);
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}