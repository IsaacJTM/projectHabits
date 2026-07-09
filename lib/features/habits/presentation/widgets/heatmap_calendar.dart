import 'package:apphabitsv01/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HeatmapCalendar extends StatelessWidget {
  final Map<DateTime, double>? data;
  final int weeksToShow;
  const HeatmapCalendar({super.key, required this.data, required this.weeksToShow});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final map = data ?? {};

    // Agrupar en columnas de semana (7 días cada una)
    final days = List.generate(
      weeksToShow * 7,
      (i) => today.subtract(Duration(days: (weeksToShow * 7 - 1) - i)),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Row(
        children: List.generate(weeksToShow, (week) {
          final weekDays = days.skip(week * 7).take(7).toList();
          return Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Column(
              children: weekDays.map((day) {
                final intensity = map[DateTime(day.year, day.month, day.day)] ?? 0.0;
                return Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _colorForIntensity(intensity),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }).toList(),
            ),
          );
        }),
      ),
    );
  }

  Color _colorForIntensity(double intensity) {
    final scale = AppColors.heatmapSale;
    final index = (intensity * (scale.length - 1)).round().clamp(0, scale.length - 1);
    return scale[index];
  }
}