// lib/features/lesson/lesson_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katakata_app/core/constants/colors.dart';
import 'package:katakata_app/core/services/lesson_service.dart';
import 'package:katakata_app/core/services/user_service.dart'; // Tambahkan ini untuk addXp
import 'package:katakata_app/widgets/custom_button.dart'; // Tambahkan ini
import 'package:katakata_app/widgets/mascot_widget.dart'; // Tambahkan ini

class LessonScreen extends ConsumerWidget {
  const LessonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonState = ref.watch(lessonProvider);
    final lessonNotifier = ref.read(lessonProvider.notifier);

    if (lessonState.lessonCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showLevelUpModal(context, ref);
      });
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
              backgroundColor: KataKataColors.charcoal.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation(KataKataColors.kuningCerah),
              minHeight: 8,
            ),
            const SizedBox(height: 20),
            Text(
              lessonState.questions[lessonState.currentIndex].text,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: KataKataColors.charcoal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ...List.generate(
              lessonState.questions[lessonState.currentIndex].options.length,
              (index) {
                final option = lessonState.questions[lessonState.currentIndex].options[index];
                final isSelected = lessonState.selectedOption == option;
                final isCorrect = option == lessonState.questions[lessonState.currentIndex].correctAnswer;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: ElevatedButton(
                    onPressed: lessonState.answerSubmitted
                        ? null
                        : () => lessonNotifier.selectAnswer(option),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lessonState.answerSubmitted
                          ? (isCorrect
                              ? KataKataColors.kuningCerah.withValues(alpha: 0.3)
                              : isSelected
                                  ? KataKataColors.charcoal.withValues(alpha: 0.1)
                                  : null)
                          : null,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.book_outlined,
                          color: KataKataColors.charcoal,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          option,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: KataKataColors.charcoal,
                          ),
                        ),
                        if (lessonState.answerSubmitted && isCorrect)
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const MascotWidget(size: 24), // Tambahkan const
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            if (lessonState.answerSubmitted)
              // Hapus const karena onPressed akan diisi
              KataKataButton(
                text: lessonState.currentIndex < lessonState.questions.length - 1 ? 'Lanjut' : 'Selesai',
                onPressed: () {
                  // Tambah XP jika benar
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
      builder: (context) {
        ref.read(lessonProvider.notifier).resetLesson(); // Reset lesson state

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
              const MascotWidget(size: 64), // Tambahkan const
              const SizedBox(height: 20),
              Text(
                'Kamu telah menyelesaikan latihan ini.',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: KataKataColors.charcoal,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                '+50 XP',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: KataKataColors.kuningCerah,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Kembali ke Home
              },
              child: Text(
                'Tutup',
                style: GoogleFonts.poppins(
                  color: KataKataColors.pinkCeria,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}