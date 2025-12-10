import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'NoteSync';
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String notesEndpoint = '/posts';

  static const String notesBoxName = 'notes_box';
  static const String settingsBoxName = 'settings_box';
  static const String syncQueueBoxName = 'sync_queue_box';

  static const Duration syncRetryDelay = Duration(seconds: 30);
  static const int maxRetryAttempts = 3;
}

class NoteColors {
  static const List<Color> colors = [
    Color(0xFFFFFFFF), // White
    Color(0xFFFFF3E0), // Orange Light
    Color(0xFFE3F2FD), // Blue Light
    Color(0xFFE8F5E9), // Green Light
    Color(0xFFFCE4EC), // Pink Light
    Color(0xFFF3E5F5), // Purple Light
    Color(0xFFFFFDE7), // Yellow Light
    Color(0xFFE0F7FA), // Cyan Light
    Color(0xFFFFEBEE), // Red Light
    Color(0xFFE8EAF6), // Indigo Light
  ];

  static const List<Color> darkColors = [
    Color(0xFF2D2D2D), // Dark Gray
    Color(0xFF3E2723), // Brown Dark
    Color(0xFF1A237E), // Blue Dark
    Color(0xFF1B5E20), // Green Dark
    Color(0xFF880E4F), // Pink Dark
    Color(0xFF4A148C), // Purple Dark
    Color(0xFFF57F17), // Yellow Dark
    Color(0xFF006064), // Cyan Dark
    Color(0xFFB71C1C), // Red Dark
    Color(0xFF283593), // Indigo Dark
  ];

  static int getColorIndex(Color color) {
    int index = colors.indexWhere((c) => c.value == color.value);
    if (index == -1) {
      index = darkColors.indexWhere((c) => c.value == color.value);
    }
    return index == -1 ? 0 : index;
  }

  static Color getColor(int index, bool isDarkMode) {
    final colorList = isDarkMode ? darkColors : colors;
    if (index >= 0 && index < colorList.length) {
      return colorList[index];
    }
    return colorList[0];
  }
}