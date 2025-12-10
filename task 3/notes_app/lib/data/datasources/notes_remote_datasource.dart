import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';
import '../../core/error/exceptions.dart';
import '../models/note_model.dart';

abstract class NotesRemoteDataSource {
  Future<List<NoteModel>> fetchNotes();
  Future<NoteModel> createNote(NoteModel note);
  Future<NoteModel> updateNote(NoteModel note);
  Future<void> deleteNote(int serverId);
}

class NotesRemoteDataSourceImpl implements NotesRemoteDataSource {
  final http.Client client;

  NotesRemoteDataSourceImpl({required this.client});

  @override
  Future<List<NoteModel>> fetchNotes() async {
    try {
      final response = await client
          .get(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.notesEndpoint}'),
      )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => NoteModel.fromJson(json))
            .take(20) // Limit to 20 notes for demo
            .toList();
      } else {
        throw ServerException(
          message: 'Failed to fetch notes',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException(message: 'Network error: $e');
    }
  }

  @override
  Future<NoteModel> createNote(NoteModel note) async {
    try {
      final response = await client
          .post(
        Uri.parse('${AppConstants.baseUrl}${AppConstants.notesEndpoint}'),
        headers: {'Content-type': 'application/json; charset=UTF-8'},
        body: json.encode(note.toJson()),
      )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return note.copyWith(
          serverId: responseData['id'],
          syncStatusIndex: 0,
        );
      } else {
        throw ServerException(
          message: 'Failed to create note',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException(message: 'Network error: $e');
    }
  }

  @override
  Future<NoteModel> updateNote(NoteModel note) async {
    try {
      final serverId = note.serverId ?? 1;
      final response = await client
          .put(
        Uri.parse(
            '${AppConstants.baseUrl}${AppConstants.notesEndpoint}/$serverId'),
        headers: {'Content-type': 'application/json; charset=UTF-8'},
        body: json.encode({
          ...note.toJson(),
          'id': serverId,
        }),
      )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return note.copyWith(syncStatusIndex: 0);
      } else {
        throw ServerException(
          message: 'Failed to update note',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException(message: 'Network error: $e');
    }
  }

  @override
  Future<void> deleteNote(int serverId) async {
    try {
      final response = await client
          .delete(
        Uri.parse(
            '${AppConstants.baseUrl}${AppConstants.notesEndpoint}/$serverId'),
      )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Failed to delete note',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException(message: 'Network error: $e');
    }
  }
}