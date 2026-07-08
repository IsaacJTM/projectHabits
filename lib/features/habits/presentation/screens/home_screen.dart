import 'package:apphabitsv01/core/theme/app_colors.dart';
import 'package:apphabitsv01/features/celebration/presentation/widgets/celebration_modal.dart';
import 'package:apphabitsv01/features/habits/data/habits_provider.dart';
import 'package:apphabitsv01/features/habits/data/models/habit.dart';
import 'package:apphabitsv01/features/habits/presentation/Pages/empty_pages.dart';
import 'package:apphabitsv01/features/habits/presentation/widgets/habit_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _geeting(){
    final hour = DateTime.now().hour;
    if( hour < 12) return 'Bunos días';
    if(hour < 19) return 'Buenos tardes';
    return 'Buenas noches';
  }

  Future<void> _handleToggle(
    BuildContext context,
    WidgetRef ref,
    Habit habit
  ) async {
    final result = await ref.read(toggleCheckInProvider)(habit);
    if(result != null && context.mounted){
      showCelebrationModal(
        context,
        title: '¡Increible!',
        message: 'Haz mantenido tu racha de ${result.newStreak} días seguidos de ${habit.name}',
        streakDays: result.newStreak,
        xpEarned: result.xpEarned
      );
    }

  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitAsync = ref.watch(habitsProvider);
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: Colors.white, size: 25),
                  ),
                  const SizedBox(width: 8),
                  const Text("Isaac", style: TextStyle(color: AppColors.primaryDark),),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(Icons.notifications_none_rounded),
                )
              ],
      ),
      body:  habitAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stado) => Center(child: Text('Error cargando hábitos: $error')),
        data: (habits) {
          final completed = habits.where((habit) => habit.completedToday).length;
          final progress = habits.isEmpty ? 0.0 : completed / habits.length;
          final userName = profileAsync.value?.name ?? '';


          if(habits.isEmpty){
            return EmptyPages(onCreate: () =>context.push('/create-habit'));
          }

          return ListView(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('¡${_geeting()}${userName.isNotEmpty ? ", $userName" : "" }!', 
                    style: Theme.of(context).textTheme.headlineSmall),
                    SizedBox(height: 8),
                    Text('Sigue así, estás dominando la semana.', 
                    style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child:_cardPrimary(
                      Icons.local_fire_department,
                      AppColors.secondary,
                      'RACHA',
                      '12',
                      'días'
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _cardPrimary(
                      Icons.stars_sharp,
                      AppColors.accentYellow,
                      'XP HOY',
                      '${profileAsync.value?.xp ?? 0}',
                      'pts'
                    ),
                  )
                ],
              ),
              SizedBox(height: 18),
              Card(
                color: AppColors.primaryLight,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Text('Progreso Diario', style: Theme.of(context).textTheme.titleMedium),
                              SizedBox(height: 4),
                              Text('$completed de ${habits.length} hábitos completados', style: TextStyle(fontSize: 16, color: AppColors.primaryDark))
                          ],
                          ),
                          Text('${(progress*100).round()}%', 
                          style: TextStyle(fontSize: 40, color: AppColors.primaryDark, fontWeight: FontWeight.bold, height: 1))
                        ],
                      ),
                      SizedBox(height: 16),
                      LinearProgressIndicator(
                        borderRadius: BorderRadius.circular(5),
                        value: progress,
                        backgroundColor: AppColors.border,
                        color: AppColors.primaryDark,
                        minHeight: 12,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 18),
              Text('Tus Hábitos', 
              style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),

              ...habits.map(
                (habit) => HabitCard(
                  habit: habit,
                  onTap: () => context.push('/habit/${habit.id}', extra: habit),
                  onToggle: () => _handleToggle(context, ref, habit),
                ),
              ),
            ],
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.surface,
        onPressed: () => context.push('/create-habit'),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}

  Widget _cardPrimary(
    IconData icon,
    Color iconColor,
    String valor,
    String numero,
    String label
  ){
    return Card(
      child: Padding(
                padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(icon, color: iconColor),
                          Text(valor, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text(numero, style: TextStyle(fontSize: 40)),
                          SizedBox(width: 8),
                          Text(label, style: TextStyle(fontSize: 16),)
                      ],)
                    ],
                  ),
       ),
    );
  }


