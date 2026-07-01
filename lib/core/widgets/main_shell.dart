import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  int _indexFormLocation(String location){
    //if(location.startsWith('/stats')) return 1;
    if(location.startsWith('/profile')) return 1;
    //if(location.startsWith('/settings')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _indexFormLocation(location);
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value){
          switch (value){
            case 0: 
              context.go('/home');
              break;
            case 1:
              context.go('/profile');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home_rounded)
          ),
          BottomNavigationBarItem(
            label: 'Perfil',
            icon: Icon(Icons.person_rounded)
          ),
        ],
      ),
    );
  }
}