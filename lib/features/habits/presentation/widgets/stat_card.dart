import 'package:apphabitsv01/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String value;
  final String label;
  const StatCard({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(value, style: Theme.of(context).textTheme.headlineSmall,),
            const SizedBox(height: 4),
            Text(label, style: Theme.of(context).textTheme.labelMedium,)
          ],
        ),
      ),
    );
  }
}