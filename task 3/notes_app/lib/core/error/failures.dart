import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server failure occurred'});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache failure occurred'});
}

class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection'});
}

class SyncFailure extends Failure {
  const SyncFailure({super.message = 'Sync failure occurred'});
}