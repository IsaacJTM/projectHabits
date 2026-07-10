import 'package:flutter/material.dart';

class BadgeItem {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final bool isActive;

  const BadgeItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.isActive
  });
}

// Desbloqueo de Insegnias (badges)
//  - 'week_warrior'  -> al llegar a 7 días de racha en cualquier hábito
//  - 'century_club'  -> al llegar a 30 días de racha en cualquier hábito
//  - start_easy --> al llegar a los 2 meses

const allBadges = [
  BadgeItem(
    id: 'week_warrior',
    name: 'Fast Start',
    icon: Icons.rocket_launch_rounded,
    color: Color(0xFF20C9C2),
    isActive: false,
  ),
    BadgeItem(
    id: 'century_club',
    name: 'Century Club',
    icon: Icons.military_tech_rounded,
    color: Color(0xFFFFC542),
    isActive: false,
  ),
  BadgeItem(
    id: "start_easy",
    name: "Early Bird", 
    icon: Icons.star_rounded,
    color:  Color(0xFFFFE082), 
    isActive: false
  ),
];