import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/entities/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final bool isDarkMode;
  final bool isListView;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
    required this.isDarkMode,
    this.isListView = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = NoteColors.getColor(note.colorIndex, isDarkMode);
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subtitleColor = isDarkMode ? Colors.white70 : Colors.black54;

    return GestureDetector(
      onTap: onTap,
      onLongPress: () {
        _showOptionsMenu(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title.isEmpty ? 'Untitled' : note.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                      maxLines: isListView ? 1 : 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildSyncIcon(),
                ],
              ),
              if (note.body.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  note.body,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: subtitleColor,
                  ),
                  maxLines: isListView ? 2 : 6,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: subtitleColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormatter.formatDate(note.updatedAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSyncIcon() {
    IconData icon;
    Color color;

    switch (note.syncStatus) {
      case SyncStatus.synced:
        icon = Icons.cloud_done_rounded;
        color = Colors.green;
        break;
      case SyncStatus.pending:
        icon = Icons.cloud_upload_rounded;
        color = Colors.orange;
        break;
      case SyncStatus.failed:
        icon = Icons.cloud_off_rounded;
        color = Colors.red;
        break;
    }

    return Icon(icon, size: 16, color: color);
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.edit_rounded),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  onTap();
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete_rounded,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  'Delete',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onDelete();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}