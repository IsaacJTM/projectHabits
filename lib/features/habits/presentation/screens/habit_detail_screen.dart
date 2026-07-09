import 'package:apphabitsv01/core/theme/app_colors.dart';
import 'package:apphabitsv01/features/auth/data/auth_repository.dart';
import 'package:apphabitsv01/features/habits/data/habits_provider.dart';
import 'package:apphabitsv01/features/habits/data/models/habit.dart';
import 'package:apphabitsv01/features/habits/presentation/screens/create_habit_screen.dart';
import 'package:apphabitsv01/features/habits/presentation/widgets/heatmap_calendar.dart';
import 'package:apphabitsv01/features/habits/presentation/widgets/stat_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HabitDetailScreen extends ConsumerWidget {
  final Habit habit; 
  const HabitDetailScreen({super.key, required this.habit});

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async{
     final confirmed = await showDialog<bool>(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text('ELIMINAR HÁBITO'),
        content: Text('¿Seguro que quiere elimninar ${habit.name} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), 
            child: const Text('Cancelar')
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), 
            child: const Text('Eliminar', style: TextStyle(color: AppColors.secondary),)
          ),
        ],
      )
    );
    if(confirmed == true && context.mounted){
      final uid = ref.read(authRepositoryProvider).currentUser!.uid;
      await ref.read(habitsRepositoryProvider).deleteHaibt(uid, habit.id);
      if(context.mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.read(authRepositoryProvider).currentUser!.uid;
    final heatmapAsync = ref.watch(_heatmapProvider((uid: uid, habitId: habit.id)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('DETALLE DE HÁBITO', style: TextStyle(color: Colors.grey),),
        actions: [
          PopupMenuButton(
            onSelected: (value){
              if(value == 'edit'){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CreateHabitScreen(existingHabit: habit)
                  ),
                );
              }else if( value == 'delete'){
                _confirmDelete(context, ref);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'edit', child: Text('Editar')),
              PopupMenuItem(value: 'delete', child: Text('Eliminar')),
            ]
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: habit.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(30)
                  ),
                  child: Icon(habit.icon, color: habit.color, size: 40,),
                ),
                const SizedBox(height: 16),
                Text(habit.name, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(habit.goalDescription, style: Theme.of(context).textTheme.bodyMedium)
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: StatCard(value: '${habit.currentStreak}',label: 'RACHA ACTUAL'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: StatCard(value: '${habit.longestStreak}',label: 'RACHA MÁS LARGA'),
              )
            ],
          ), 
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Historial', style: Theme.of(context).textTheme.titleMedium),
                      Text('Últimas 12 semanas', style: Theme.of(context).textTheme.bodyMedium)
                    ],
                  ), 
                  const SizedBox(height: 16),
                  heatmapAsync.when(
                    loading: () => const SizedBox(
                      height: 100, 
                      child: Center(
                        child: CircularProgressIndicator()
                      ),
                    ),
                    error: (e, est) => Text('No se pudo cargar el historial : $e'),
                    data: (data) => HeatmapCalendar(data: data, weeksToShow: 12)
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

final _heatmapProvider = StreamProvider.family<Map<DateTime, double>, ({String uid, String habitId})>((ref, param){
  return ref.watch(habitsRepositoryProvider).watchHeatmap(param.uid, param.habitId);
});