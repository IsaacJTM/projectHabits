import 'package:apphabitsv01/core/widgets/main_shell.dart';
import 'package:apphabitsv01/features/habits/data/models/habit.dart';
import 'package:apphabitsv01/features/habits/presentation/screens/create_habit_screen.dart';
import 'package:apphabitsv01/features/habits/presentation/screens/habit_detail_screen.dart';
import 'package:apphabitsv01/features/habits/presentation/screens/home_screen.dart';
import 'package:apphabitsv01/features/profile/presentation/screens/profile_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => HomeScreen(),
          ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => ProfileScreen(),
        )
      ]
    ),
    GoRoute(
      path: '/habit/:id',
      builder: (context, state) {
        final habit = state.extra as Habit;
        return HabitDetailScreen(habit: habit);
      },
    ),
    GoRoute(
      path: 'create-habit',
      builder: (context, state) => const CreateHabitScreen(),
    )
  ]
);