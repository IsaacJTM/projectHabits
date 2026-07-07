import 'package:flutter/material.dart';

class BadgeItem {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  const BadgeItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.color
  });
}

// Desbloqueo de Insegnias (badges)
//  - 'week_warrior'  -> al llegar a 7 días de racha en cualquier hábito
//  - 'century_club'  -> al llegar a 30 días de racha en cualquier hábito

const allBadges = [
  BadgeItem(
    id: 'week_warrior',
    name: 'Fast Start',
    icon: Icons.bolt_rounded,
    color: Color(0xFF20C9C2),
  ),
    BadgeItem(
    id: 'century_club',
    name: 'Century Club',
    icon: Icons.emoji_events_rounded,
    color: Color(0xFFFFC542),
  )
];