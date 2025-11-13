// lib/features/lesson/lesson_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katakata_app/core/constants/colors.dart';
import 'package:katakata_app/core/services/lesson_service.dart';
import 'package:katakata_app/core/services/user_service.dart';
import 'package:katakata_app/widgets/custom_button.dart';
import 'package:katakata_app/widgets/mascot_widget.dart';

class LessonScreen extends ConsumerWidget {
  const LessonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonState = ref.watch(lessonProvider);
    final lessonNotifier = ref.read(lessonProvider.notifier);
    
    final currentQuestion = lessonState.questions[lessonState.currentIndex];

    if (lessonState.lessonCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (ModalRoute.of(context)?.isCurrent == true) {
          _showLevelUpModal(context, ref);
        }
      });
      return const Scaffold(backgroundColor: KataKataColors.offWhite);
    }

    return Scaffold(
      backgroundColor: KataKataColors.offWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Latihan',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: KataKataColors.charcoal,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (lessonState.currentIndex + 1) / lessonState.questions.length,
              backgroundColor: KataKataColors.charcoal.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation(KataKataColors.kuningCerah),
              minHeight: 8,
            ),
            const SizedBox(height: 20),
            Text(
              currentQuestion.text,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: KataKataColors.charcoal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ...List.generate(
              currentQuestion.options.length,
              (index) {
                final option = currentQuestion.options[index];
                final isSelected = lessonState.selectedOption == option;
                final isCorrect = option == currentQuestion.correctAnswer;
                
                // Logika Warna
                Color buttonColor = KataKataColors.offWhite;
                if (lessonState.answerSubmitted) {
                    if (isCorrect) {
                        buttonColor = Colors.green.shade400; 
                    } else if (isSelected) {
                        buttonColor = Colors.red.shade400; 
                    }
                } else if (isSelected) {
                    buttonColor = KataKataColors.kuningCerah.withOpacity(0.7);
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: ElevatedButton(
                    onPressed: lessonState.answerSubmitted
                        ? null
                        : () => lessonNotifier.selectAnswer(option),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: KataKataColors.charcoal, width: 2),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      children: [
                        // PERBAIKAN ASET: Mengganti Icon standar dengan Image.asset
                        Image.asset(
                          'assets/images/icon_lesson_option.png',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          option,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: KataKataColors.charcoal,
                          ),
                        ),
                        const Spacer(),
                        if (lessonState.answerSubmitted && isCorrect)
                          // PERBAIKAN ASET: Maskot kecil di jawaban benar
                          const MascotWidget(size: 24, assetName: 'mascot_lesson.png'), 
                      ],
                    ),
                  ),
                );
              },
            ),
            const Spacer(),
            if (lessonState.answerSubmitted)
              KataKataButton(
                text: lessonState.currentIndex < lessonState.questions.length - 1 ? 'Lanjut' : 'Selesai',
                onPressed: () {
                  if (lessonState.isCorrect) {
                     ref.read(userProfileProvider.notifier).addXp(10);
                  }
                  lessonNotifier.nextQuestion();
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showLevelUpModal(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        // PERBAIKAN: Pastikan ini dipanggil saat modal pertama kali muncul
        ref.read(userProfileProvider.notifier).addXp(50);
        ref.read(lessonProvider.notifier).resetLesson();

        return AlertDialog(
          backgroundColor: KataKataColors.offWhite,
          title: Center(
            child: Text(
              'Latihan Selesai!',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: KataKataColors.charcoal,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // PERBAIKAN ASET: Maskot utama di modal
              const MascotWidget(size: 64, assetName: 'mascot_main.png'), 
              const SizedBox(height: 20),
              Text(
                'Kamu telah menyelesaikan latihan ini.\nBonus total +50 XP!',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: KataKataColors.charcoal,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // PERBAIKAN ASET: Icon XP/Streak
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/icon_streak.png', width: 28, height: 28),
                  const SizedBox(width: 8),
                   Text(
                    '+50 XP',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: KataKataColors.kuningCerah,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Image.asset('assets/images/icon_streak.png', width: 28, height: 28),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.go('/home');
              },
              child: Text(
                'Kembali ke Beranda',
                style: GoogleFonts.poppins(
                  color: KataKataColors.pinkCeria,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}