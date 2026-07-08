import 'package:apphabitsv01/core/router/app_router.dart';
import 'package:apphabitsv01/core/theme/app_theme.dart';
import 'package:apphabitsv01/features/auth/presentation/screens/login_screen.dart';
import 'package:apphabitsv01/features/habits/presentation/screens/home_screen.dart';
import 'package:apphabitsv01/features/habits/presentation/widgets/habit_card.dart';
import 'package:apphabitsv01/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);


  runApp(
    const ProviderScope(
      child: HabitsApp() 
      )
    );
}

class HabitsApp extends ConsumerWidget {
  const HabitsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
        title: 'App Hábitos',
        debugShowCheckedModeBanner: false,
        routerConfig: router,
    );
  }
}