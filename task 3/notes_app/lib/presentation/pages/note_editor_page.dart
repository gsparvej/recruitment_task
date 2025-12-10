import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/entities/note.dart';
import '../bloc/notes_bloc.dart';
import '../bloc/notes_event.dart';
import '../widgets/color_picker.dart';

class NoteEditorPage extends StatefulWidget {
  final Note? note;

  const NoteEditorPage({super.key, this.note});

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  late int _selectedColorIndex;
  bool _hasChanges = false;

  bool get isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _bodyController = TextEditingController(text: widget.note?.body ?? '');
    _selectedColorIndex = widget.note?.colorIndex ?? 0;

    _titleController.addListener(_onTextChanged);
    _bodyController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = NoteColors.getColor(_selectedColorIndex, isDark);

    return PopScope(
      canPop: !_hasChanges,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        final shouldSave = await _showSaveDialog();
        if (shouldSave == true) {
          _saveNote();
        }
        if (mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          leading: IconButton(
            onPressed: () => _handleBack(),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          actions: [
            IconButton(
              onPressed: _showColorPicker,
              icon: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: NoteColors.getColor(_selectedColorIndex, isDark),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? Colors.white54 : Colors.black26,
                    width: 2,
                  ),
                ),
              ),
            ),
            if (isEditing)
              IconButton(
                onPressed: _deleteNote,
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            IconButton(
              onPressed: _saveNote,
              icon: const Icon(Icons.check_rounded),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isEditing) ...[
                Row(
                  children: [
                    _buildSyncStatusChip(widget.note!.syncStatus),
                    const Spacer(),
                    Text(
                      DateFormatter.formatFullDate(widget.note!.updatedAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              TextField(
                controller: _titleController,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: isDark ? Colors.white38 : Colors.black38,
                    fontWeight: FontWeight.bold,
                  ),
                  border: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                ),
                maxLines: null,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _bodyController,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Start writing...',
                  hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                  border: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                ),
                maxLines: null,
                minLines: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSyncStatusChip(SyncStatus status) {
    IconData icon;
    Color color;
    String text;

    switch (status) {
      case SyncStatus.synced:
        icon = Icons.cloud_done_rounded;
        color = Colors.green;
        text = 'Synced';
        break;
      case SyncStatus.pending:
        icon = Icons.cloud_upload_rounded;
        color = Colors.orange;
        text = 'Pending';
        break;
      case SyncStatus.failed:
        icon = Icons.cloud_off_rounded;
        color = Colors.red;
        text = 'Failed';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showColorPicker() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ColorPickerSheet(
        selectedIndex: _selectedColorIndex,
        isDarkMode: isDark,
        onColorSelected: (index) {
          setState(() {
            _selectedColorIndex = index;
            _hasChanges = true;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<bool?> _showSaveDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save changes?'),
        content: const Text('You have unsaved changes. Do you want to save them?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Discard'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _handleBack() async {
    if (_hasChanges) {
      final shouldSave = await _showSaveDialog();
      if (shouldSave == true) {
        _saveNote();
      }
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();

    if (title.isEmpty && body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note is empty')),
      );
      return;
    }

    if (isEditing) {
      context.read<NotesBloc>().add(UpdateNoteEvent(
        note: widget.note!,
        title: title.isEmpty ? 'Untitled' : title,
        body: body,
        colorIndex: _selectedColorIndex,
      ));
    } else {
      context.read<NotesBloc>().add(AddNote(
        title: title.isEmpty ? 'Untitled' : title,
        body: body,
        colorIndex: _selectedColorIndex,
      ));
    }

    Navigator.pop(context);
  }

  void _deleteNote() {
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
              context.read<NotesBloc>().add(DeleteNoteEvent(widget.note!.id));
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close editor
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