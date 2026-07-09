import 'package:apphabitsv01/core/theme/app_colors.dart';
import 'package:apphabitsv01/features/habits/data/models/habit.dart';
import 'package:flutter/material.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback? onToggle;
  final VoidCallback? onTap;
  
  const HabitCard({
    super.key, 
    required this.habit, 
    this.onToggle, 
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
     elevation: 1,
     color: Colors.white,
     child: Padding(
       padding: const EdgeInsets.symmetric(vertical: 8),
       child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: habit.color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(4)
          ),
          child: Icon(habit.icon, color: habit.color, size: 22,),
        ),
        title: Text(habit.name),
        subtitle: Row(children: [
            Icon(Icons.local_fire_department_rounded),
            SizedBox(width: 4),
            Text('${habit.currentStreak} racha')
          ],
        ),
        trailing: AnimatedSwitcher(
          duration: Duration(milliseconds: 250),
          transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
          child: GestureDetector(
            key: ValueKey(habit.completedToday),
            onTap: onTap,
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: habit.completedToday ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: habit.completedToday ? AppColors.primary : AppColors.border,
                  width: 2,
                ),
              ),
              child: habit.completedToday 
                ? const Icon(Icons.check_rounded, size: 18, color: Colors.white)
                : null
            ),
          ),
        ),
       ),
     ),
    );
  }
}