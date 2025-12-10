import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final Box settingsBox;

  ThemeCubit({required this.settingsBox})
      : super(_getInitialTheme(settingsBox));

  static ThemeMode _getInitialTheme(Box box) {
    final isDark = box.get('isDarkMode', defaultValue: false) as bool;
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    settingsBox.put('isDarkMode', newMode == ThemeMode.dark);
    emit(newMode);
  }

  bool get isDarkMode => state == ThemeMode.dark;
}