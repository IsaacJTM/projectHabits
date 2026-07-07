import 'package:flutter/material.dart';

class IconMapper {
  static const Map<String, IconData> _icons = {
    'water_drop': Icons.water_drop_rounded,
    'run': Icons.directions_run_rounded,
    'book': Icons.menu_book_rounded,
    'fitness': Icons.fitness_center_rounded,
    'meditation': Icons.self_improvement_rounded,
    'palette': Icons.palette_rounded,
    'more': Icons.more_horiz_rounded,
  };

  static IconData fromkey(String key) => _icons[key] ?? Icons.star_rounded;

  static String keyFor(IconData icon){
    return _icons.entries
    .firstWhere((e) => e.value == icon, orElse: () => _icons.entries.first)
    .key;
  }

  static List<String> get allKeys => _icons.keys.toList();
  static List<IconData> get allIcons => _icons.values.toList();
}