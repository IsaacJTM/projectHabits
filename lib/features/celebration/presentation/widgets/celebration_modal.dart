import 'package:apphabitsv01/core/theme/app_colors.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
Future<void> showCelebrationModal(
  BuildContext context,{
    required String title,
    required String message,
    required int streakDays,
    required int xpEarned
  }){
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Celebración',
      barrierColor: Colors.black38,
      transitionDuration: const Duration(microseconds: 300),
      pageBuilder: (context, anim1, anim2) => _CelebrationModal(
        title: title,
        message: message,
        streakDays: streakDays,
        xpEarned: xpEarned,
      ),
      transitionBuilder: (context, anim, secondaryAnim, child){
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
          child: FadeTransition(opacity: anim, child: child),
        );
      }
    );
  }

class _CelebrationModal extends StatefulWidget {
  final String title; 
  final String message;
  final int streakDays;
  final int xpEarned;
  const _CelebrationModal({
    required this.title,
    required this.message,
    required this.streakDays,
    required this.xpEarned
  });

  @override
  State<_CelebrationModal> createState() => _CelebrationModalState();
}

class _CelebrationModalState extends State<_CelebrationModal> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2))..play();
  }

  @override
  void dispose(){
    _confettiController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            numberOfParticles: 24,
            maxBlastForce: 18,
            minBlastForce: 6,
            gravity: 0.25,
            colors: [
              AppColors.primary,
              AppColors.secondary,
              AppColors.accentYellow
            ],
          ),
        ),
        Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 32),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark,
                    shape: BoxShape.circle
                  ),
                  child: Icon(Icons.local_activity, color: AppColors.surface, size: 32,),
                ),
                const SizedBox(height: 16),
                Text(widget.title, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                Text(
                  widget.message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ), 
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _textoValor('RACHA', '${widget.streakDays}', context),
                        const SizedBox(width: 6),
                        Text("|"),
                        const SizedBox(width: 6),
                        _textoValor('PUNTOS', '+ ${widget.xpEarned}', context)
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(), 
                    child: const Text('Continuar'),
                  ),
                )
              ],
            ),
          ),
        )
      ],

    );
  }
}

Widget _textoValor(String label, String value, BuildContext context){
  return Column(
    children: [
      Text(value, style: Theme.of(context).textTheme.titleMedium),
      Text(label, style: Theme.of(context).textTheme.titleMedium),
    ],
  );
}