import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class ColorPickerSheet extends StatelessWidget {
  final int selectedIndex;
  final bool isDarkMode;
  final Function(int) onColorSelected;

  const ColorPickerSheet({
    super.key,
    required this.selectedIndex,
    required this.isDarkMode,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = isDarkMode ? NoteColors.darkColors : NoteColors.colors;

    return Container(
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
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose Color',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: List.generate(colors.length, (index) {
                      final isSelected = index == selectedIndex;
                      return GestureDetector(
                        onTap: () => onColorSelected(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: colors[index],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.transparent,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: colors[index].withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: isSelected
                              ? Icon(
                            Icons.check_rounded,
                            color: isDarkMode
                                ? Colors.white
                                : Colors.black87,
                          )
                              : null,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}