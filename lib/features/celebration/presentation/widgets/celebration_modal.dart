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
        )
      ],

    );
  }
}