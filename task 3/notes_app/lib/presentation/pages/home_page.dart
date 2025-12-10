import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/note.dart';
import '../bloc/notes_bloc.dart';
import '../bloc/notes_event.dart';
import '../bloc/notes_state.dart';
import '../bloc/sync_cubit.dart';
import '../bloc/theme_cubit.dart';
import '../widgets/note_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/sync_indicator.dart';
import 'note_editor_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    context.read<NotesBloc>().add(LoadNotes());
    // Fetch remote notes on initial load
    context.read<NotesBloc>().add(FetchRemoteNotesEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context, isDark),
            const SyncIndicator(),
            Expanded(
              child: BlocConsumer<NotesBloc, NotesState>(
                listener: (context, state) {
                  if (state is NotesLoaded && state.message != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message!),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is NotesLoading) {
                    return _buildLoadingState();
                  }

                  if (state is NotesError) {
                    return _buildErrorState(state.message);
                  }

                  if (state is NotesLoaded) {
                    if (state.displayNotes.isEmpty) {
                      return EmptyState(
                        isSearching: state.searchQuery?.isNotEmpty ?? false,
                      );
                    }
                    return _buildNotesList(state.displayNotes, isDark);
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openNoteEditor(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Note'),
      ).animate().scale(delay: 300.ms, duration: 300.ms),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              if (!_isSearching) ...[
                Text(
                  'NoteSync',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                _buildSyncButton(),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    setState(() => _isSearching = true);
                  },
                  icon: const Icon(Icons.search_rounded),
                ),
                IconButton(
                  onPressed: () {
                    setState(() => _isGridView = !_isGridView);
                  },
                  icon: Icon(
                    _isGridView
                        ? Icons.view_list_rounded
                        : Icons.grid_view_rounded,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.read<ThemeCubit>().toggleTheme();
                  },
                  icon: Icon(
                    isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  ),
                ),
              ] else ...[
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search notes...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _isSearching = false);
                          context.read<NotesBloc>().add(const SearchNotes(''));
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ),
                    onChanged: (value) {
                      context.read<NotesBloc>().add(SearchNotes(value));
                    },
                  ),
                ),
              ],
            ],
          ),
          if (!_isSearching) ...[
            const SizedBox(height: 8),
            BlocBuilder<NotesBloc, NotesState>(
              builder: (context, state) {
                if (state is NotesLoaded) {
                  final pendingCount = state.pendingCount;
                  if (pendingCount > 0) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.sync_rounded,
                            size: 16,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$pendingCount pending sync',
                            style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSyncButton() {
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        final isSyncing = state is NotesLoaded && state.isSyncing;

        return IconButton(
          onPressed: isSyncing
              ? null
              : () {
            context.read<NotesBloc>().add(SyncNotesEvent());
          },
          icon: isSyncing
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : const Icon(Icons.sync_rounded),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Loading notes...',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              context.read<NotesBloc>().add(LoadNotes());
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesList(List<Note> notes, bool isDark) {
    if (_isGridView) {
      return MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return NoteCard(
            note: notes[index],
            onTap: () => _openNoteEditor(context, note: notes[index]),
            onDelete: () => _deleteNote(context, notes[index].id),
            isDarkMode: isDark,
          ).animate().fadeIn(
            delay: Duration(milliseconds: 50 * index),
            duration: 300.ms,
          );
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: NoteCard(
            note: notes[index],
            onTap: () => _openNoteEditor(context, note: notes[index]),
            onDelete: () => _deleteNote(context, notes[index].id),
            isDarkMode: isDark,
            isListView: true,
          ).animate().fadeIn(
            delay: Duration(milliseconds: 50 * index),
            duration: 300.ms,
          ),
        );
      },
    );
  }

  void _openNoteEditor(BuildContext context, {Note? note}) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            NoteEditorPage(note: note),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
      ),
    );
  }

  void _deleteNote(BuildContext context, String noteId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<NotesBloc>().add(DeleteNoteEvent(noteId));
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}