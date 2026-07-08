import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

import 'package:apphabitsv01/features/auth/data/auth_repository.dart';
import 'package:apphabitsv01/features/habits/data/habits_repository.dart';
import 'package:apphabitsv01/features/habits/data/models/habit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart';

final habitsRepositoryProvider = Provider<HabitsRepository>((ref) => HabitsRepository());

//UID del usuario actual. Lanza si no  hay sesión 
//el reouter redirige a Login antes de llegar aquí.
final _uidProvider = Provider<String>((ref) {
  final user = ref.watch(authStateProvider).value;
  if(user == null) throw StateError('No hay usuario autenticado');
  return user.uid;
});


//Stream en tiempo real de los háitos del usuario (Home, Detalle, etc.)
final habitsProvider = StreamProvider<List<Habit>> ((ref) {
  final uid = ref.watch(_uidProvider);
  return ref.watch(habitsRepositoryProvider).watchHabits(uid);
});

//Marca/descarma el  check-in de hoy. Se llama desde el habitCard.
//Devuelve  el CheckInResult (para mostrar celebracion)
final toggleCheckInProvider = Provider((ref) {
  return (Habit habit){
    final uid = ref.read(_uidProvider);
    return ref.read(habitsRepositoryProvider).toggleCheckIn(uid, habit);
  };
});

//Resumen del usuario (nombre, xp, badges) leído en tiempo real desde firebase
//user/{uid}. Usado en HOme (racha total /XP) y en Perfil

class UserProfile{
  final String name;
  final int xp;
  final List<String> unlockedBadgeIds;

  const UserProfile({
    required this.name,
    required this.xp,
    required this.unlockedBadgeIds
  });

  int get level => (xp /1000).floor() + 1;
  int get xpIntolevel => xp % 1000;
  double get levelProgress => xpIntolevel / 1000;
}

final userProfileProvider = StreamProvider<UserProfile>((ref){
  final uid = ref.watch(_uidProvider);
  return FirebaseFirestore.instance.collection('users').doc(uid).snapshots().map((doc){
    final data = doc.data() ?? {};
    return UserProfile(
      name: data['name'] as String? ?? 'Usuario', 
      xp: data['xp'] as int? ?? 0, 
      unlockedBadgeIds: List<String>.from(data['unlockedbadgeIds'] as List? ?? []),
    );
  });
});