import 'package:apphabitsv01/core/theme/app_colors.dart';
import 'package:apphabitsv01/features/auth/data/auth_repository.dart';
import 'package:apphabitsv01/features/habits/data/habits_provider.dart';
import 'package:apphabitsv01/features/habits/data/models/badge_item.dart';
import 'package:apphabitsv01/features/habits/data/models/habit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final habitsAsync = ref.watch(habitsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('APP HABIT'),
        actions: [
          IconButton(
            onPressed: () => ref.read(authRepositoryProvider).signOut(), 
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Cerrar sesión',
          )
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (profile){
          final habits = habitsAsync.value ?? [];
          final longestStreak = habits.isEmpty 
                ? 0
                : habits.map((habit) => habit.longestStreak).reduce((a, b) => a > b ? a:b);
          
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 36,
                      backgroundColor: AppColors.primaryLight,
                      child: Icon(Icons.person_rounded, size: 36, color: AppColors.primary),
                    ),
                    const SizedBox(height: 12),
                    Text(profile.name, style: Theme.of(context).textTheme.headlineSmall),
                    Text('Nivel ${profile.level}', style: Theme.of(context).textTheme.bodyMedium,),
                    const SizedBox(height: 24),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Siguiente Nivel : ${profile.xpIntolevel} / 1000 XP'),
                          Text('${(profile.levelProgress * 100).round()} %')
                        ],
                      ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                        borderRadius: BorderRadius.circular(5),
                        value: profile.levelProgress,
                        backgroundColor: AppColors.border,
                        color: AppColors.primaryDark,
                        minHeight: 12,
                      )
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  _starCard(
                      Icons.bolt_rounded, 
                      '${habits.length}', 
                      'HÁBITOS ACTIVOS',
                      AppColors.primaryDark,
                      context
                  ),

                  const SizedBox(width: 8),

                   _starCard(
                      Icons.stars_rounded, 
                      '$longestStreak', 
                      'RACHA MÁS LARGA', 
                      AppColors.secondary,
                      context
                  )
                ]
              ),
              const SizedBox(height: 16),
              Text('Logros e Insignias', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Wrap(
                spacing: 30,
                runSpacing: 20,
                alignment: WrapAlignment.start,
                children: allBadges.map((badge){
                      return _widgetBadge(badge, context);
                  }).toList(),
              ),
            ],
          );
        }, 
        error: (e, estado) => Center(child: Text('Error : $e')), 

      ),
    );
  }
}

Widget _starCard (IconData icon, String value, String label, Color colorIcon, BuildContext context){
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color:  colorIcon),
          Text(value, style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: colorIcon)),
          Text(label, style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    ),
  );
}

Widget _widgetBadge(BadgeItem badge, BuildContext context){
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 85,
        height: 85,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: badge.isActive ? badge.color.withOpacity(0.2) : const Color(0xFFF0F0F0),
          border: Border.all(
            color: badge.isActive ? badge.color : const Color(0xFFD0D0D0),
            width: 2
          ),
        ),
        child: Icon(
          badge.icon,
          color: badge.isActive ? badge.color : const Color(0xFFD0D0D0),
          size: 44,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        badge.name,
        style: Theme.of(context).textTheme.bodyMedium,
      )
    ],
  );
}