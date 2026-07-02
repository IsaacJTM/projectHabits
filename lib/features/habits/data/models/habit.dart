import 'package:flutter/material.dart';

class Habit {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final String goalDescription; // ej: "Meta diaria: 2.5 litros"
  final int currentStreak;
  final int longestStreak;
  final List<String> activeDays; // ['L','M','M','J','V','S','D']
  final TimeOfDay? reminderTime;
  final bool reminderEnabled;
  final bool completedToday;
 
  const Habit({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.goalDescription,
    required this.currentStreak,
    required this.longestStreak,
    required this.activeDays,
    this.reminderTime,
    this.reminderEnabled = true,
    this.completedToday = false,
  });
 
  Habit copyWith({bool? completedToday, int? currentStreak}) {
    return Habit(
      id: id,
      name: name,
      icon: icon,
      color: color,
      goalDescription: goalDescription,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak,
      activeDays: activeDays,
      reminderTime: reminderTime,
      reminderEnabled: reminderEnabled,
      completedToday: completedToday ?? this.completedToday,
    );
  }
}
 
/// Mock de datos para construir la UI mientras no existe el backend.
/// Reemplazar por una llamada real (dio + retrofit) en habits_repository.dart
final List<Habit> mockHabits = [
  Habit(
    id: '1',
    name: 'Beber Agua',
    icon: Icons.water_drop_rounded,
    color: const Color(0xFF20C9C2),
    goalDescription: 'Meta diaria: 2.5 litros',
    currentStreak: 12,
    longestStreak: 45,
    activeDays: const ['L', 'M', 'M', 'J', 'V', 'S', 'D'],
    completedToday: false,
  ),
  Habit(
    id: '2',
    name: 'Meditación',
    icon: Icons.self_improvement_rounded,
    color: const Color(0xFF8E2DE2),
    goalDescription: 'Meta diaria: 15 minutos',
    currentStreak: 15,
    longestStreak: 30,
    activeDays: const ['L', 'M', 'M', 'J', 'V'],
    completedToday: true,
  ),
  Habit(
    id: '3',
    name: 'Ejercicio',
    icon: Icons.fitness_center_rounded,
    color: const Color(0xFFFF4D6D),
    goalDescription: 'Meta diaria: 30 minutos',
    currentStreak: 4,
    longestStreak: 21,
    activeDays: const ['L', 'M', 'V'],
    completedToday: false,
  ),
  Habit(
    id: '4',
    name: 'Lectura',
    icon: Icons.menu_book_rounded,
    color: const Color(0xFFFFC542),
    goalDescription: 'Meta diaria: 20 páginas',
    currentStreak: 22,
    longestStreak: 22,
    activeDays: const ['L', 'M', 'M', 'J', 'V', 'S', 'D'],
    completedToday: true,
  ),
  Habit(
    id: '5',
    name: 'Creatividad',
    icon: Icons.palette_rounded,
    color: const Color(0xFF1ABC9C),
    goalDescription: 'Meta diaria: 1 página de diario',
    currentStreak: 0,
    longestStreak: 8,
    activeDays: const ['S', 'D'],
    completedToday: false,
  ),
];