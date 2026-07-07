import 'package:apphabitsv01/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _geeting(){
    final hour = DateTime.now().hour;
    if( hour < 12) return 'Bunos días';
    if(hour < 19) return 'Buenos tardes';
    return 'Buenas noches';
  }

  @override
  Widget build(BuildContext context) {
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
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('¡${_geeting()}, Isaac !', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text('Sigue así, estás dominando la semana.', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
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
                  '450',
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
                          Text('Progreso Diario', style: TextStyle(fontSize: 24, color: AppColors.primaryDark)),
                          SizedBox(height: 4),
                          Text('4 de 5 hábitos completados', style: TextStyle(fontSize: 16, color: AppColors.primaryDark))
                       ],
                      ),
                      Text('60%', style: TextStyle(fontSize: 40, color: AppColors.primaryDark, fontWeight: FontWeight.bold, height: 1))
                    ],
                  ),
                  SizedBox(height: 16),
                  LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(5),
                    value: 0.6,
                    backgroundColor: AppColors.border,
                    color: AppColors.primaryDark,
                    minHeight: 12,
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 18),
          Text('Tus Hábitos', style: TextStyle(fontSize: 25) ,)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/create-habit'),
        child: const Icon(Icons.add_rounded),
      ),
    );
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
}

