//Implementamos un escucha para que pueda hacer un redirect automatico

import 'package:apphabitsv01/core/widgets/main_shell.dart';
import 'package:apphabitsv01/features/auth/data/auth_repository.dart';
import 'package:apphabitsv01/features/auth/presentation/screens/login_screen.dart';
import 'package:apphabitsv01/features/habits/data/models/habit.dart';
import 'package:apphabitsv01/features/habits/presentation/screens/create_habit_screen.dart';
import 'package:apphabitsv01/features/habits/presentation/screens/habit_detail_screen.dart';
import 'package:apphabitsv01/features/habits/presentation/screens/home_screen.dart';
import 'package:apphabitsv01/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final _routerRefreshProvider = Provider<GoRouterRefreshStream>((ref){
  return GoRouterRefreshStream(ref.watch(authRepositoryProvider).authStateChanges);
});


final appRouterProvider = Provider<GoRouter>((ref){
  final refresh = ref.watch(_routerRefreshProvider);
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: refresh,
    redirect: (context, state){
      final isLoggedIn = ref.read(authRepositoryProvider).currentUser != null;
      final isOnLoged = state.matchedLocation == '/login';

      if(!isLoggedIn && !isOnLoged) return '/login';
      if(isLoggedIn && isOnLoged) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      //Para la navegación de (Home  / Perfil)
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ]
      ),
      GoRoute(
        path: '/create-habit',
        builder: (context, state) => const CreateHabitScreen(),
      ),
      GoRoute(
        path: '/habit/:id',
        builder: (context, state){
          final habit = state.extra as Habit;
          return HabitDetailScreen(habit: habit);
        },
      )
    ]
  );
});

class GoRouterRefreshStream extends ChangeNotifier{
  late final Stream<dynamic> _stream;
  GoRouterRefreshStream(Stream<dynamic> stream){
    notifyListeners();
    _stream = stream.asBroadcastStream();
    _stream.listen((_) => notifyListeners());
  }
}