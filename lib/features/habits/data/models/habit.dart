import 'package:apphabitsv01/core/util/icon_mapper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Habit {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final String goalDescription;
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
 
  /// Convierte el hábito a un Map listo para guardar en Firestore.
  /// completedToday NO se guarda aquí: vive en la subcolección `checkins`.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'iconKey': IconMapper.keyFor(icon),
      'colorValue': color.value,
      'goalDescription': goalDescription,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'activeDays': activeDays,
      'reminderHour': reminderTime?.hour,
      'reminderMinute': reminderTime?.minute,
      'reminderEnabled': reminderEnabled,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
 
  /// Reconstruye un Habit desde un documento de Firestore.
  /// [completedToday] se pasa aparte porque viene de la subcolección checkins.
  factory Habit.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc,
      {bool completedToday = false}) {
    final data = doc.data()!;
    final hour = data['reminderHour'] as int?;
    final minute = data['reminderMinute'] as int?;
    return Habit(
      id: doc.id,
      name: data['name'] as String? ?? '',
      icon: IconMapper.fromkey(data['iconKey'] as String? ?? 'more'),
      color: Color(data['colorValue'] as int? ?? 0xFF20C9C2),
      goalDescription: data['goalDescription'] as String? ?? '',
      currentStreak: data['currentStreak'] as int? ?? 0,
      longestStreak: data['longestStreak'] as int? ?? 0,
      activeDays: List<String>.from(data['activeDays'] as List? ?? []),
      reminderTime: (hour != null && minute != null)
          ? TimeOfDay(hour: hour, minute: minute)
          : null,
      reminderEnabled: data['reminderEnabled'] as bool? ?? false,
      completedToday: completedToday,
    );
  }
}