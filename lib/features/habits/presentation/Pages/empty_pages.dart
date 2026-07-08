import 'package:apphabitsv01/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class EmptyPages extends StatelessWidget {
  final VoidCallback onCreate;
  const EmptyPages({super.key, required this.onCreate});


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(23),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.spa_rounded, size: 64, color: AppColors.primary),
            const SizedBox(height: 16,),
            Text('Aún no tienes hábitos',
            style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Crea tu primer hábito y empieza a construir tu racha hoy mismo',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onCreate, 
              child: const Text('Crear tu primer hábito'),
            )
          ],
        ),
      
      ),
    );
  }
}