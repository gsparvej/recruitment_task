class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({this.message = 'Server error occurred', this.statusCode});

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

class CacheException implements Exception {
  final String message;

  CacheException({this.message = 'Cache error occurred'});

  @override
  String toString() => 'CacheException: $message';
}

class NetworkException implements Exception {
  final String message;

  NetworkException({this.message = 'Network error occurred'});

  @override
  String toString() => 'NetworkException: $message';
}

class SyncException implements Exception {
  final String message;
  final String? noteId;

  SyncException({this.message = 'Sync error occurred', this.noteId});

  @override
  String toString() => 'SyncException: $message (Note: $noteId)';
}