// lib/core/services/lesson_service.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Model untuk Soal
class Question {
  final String id;
  final String text;
  final List<String> options;
  final String correctAnswer;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswer,
  });
}

// Data dummy untuk latihan (nanti bisa dari API/Firebase)
final List<Question> mockQuestions = [
  Question(
    id: '1',
    text: 'Bagaimana mengajukan \'terima kasih\' dalam bahasa Spanyol?',
    options: ['Hola', 'Adiós', 'Gracias'],
    correctAnswer: 'Gracias',
  ),
  Question(
    id: '2',
    text: 'Apa arti \'Hola\' dalam bahasa Indonesia?',
    options: ['Selamat tinggal', 'Terima kasih', 'Halo'],
    correctAnswer: 'Halo',
  ),
  Question(
    id: '3',
    text: 'Kata \'Gato\' dalam bahasa Spanyol berarti?',
    options: ['Anjing', 'Kucing', 'Burung'],
    correctAnswer: 'Kucing',
  ),
];

// Model untuk State Latihan
class LessonState {
  final List<Question> questions;
  final int currentIndex;
  final String? selectedOption;
  final bool answerSubmitted;
  final bool isCorrect;
  final bool lessonCompleted;

  LessonState({
    required this.questions,
    required this.currentIndex,
    this.selectedOption,
    required this.answerSubmitted,
    required this.isCorrect,
    required this.lessonCompleted,
  });

  // Method untuk membuat salinan (copy) state dengan nilai baru
  LessonState copyWith({
    List<Question>? questions,
    int? currentIndex,
    String? selectedOption,
    bool? answerSubmitted,
    bool? isCorrect,
    bool? lessonCompleted,
  }) {
    return LessonState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedOption: selectedOption ?? this.selectedOption,
      answerSubmitted: answerSubmitted ?? this.answerSubmitted,
      isCorrect: isCorrect ?? this.isCorrect,
      lessonCompleted: lessonCompleted ?? this.lessonCompleted,
    );
  }
}

// StateNotifierProvider untuk mengelola state latihan
final lessonProvider = StateNotifierProvider<LessonNotifier, LessonState>((ref) {
  return LessonNotifier();
});

class LessonNotifier extends StateNotifier<LessonState> {
  LessonNotifier() : super(
    LessonState(
      questions: mockQuestions,
      currentIndex: 0,
      selectedOption: null,
      answerSubmitted: false,
      isCorrect: false,
      lessonCompleted: false,
    )
  );

  void selectAnswer(String option) {
    if (state.answerSubmitted) return; // Jangan proses jika jawaban sudah dikirim

    final currentQuestion = state.questions[state.currentIndex];
    final isCorrect = option == currentQuestion.correctAnswer;

    state = state.copyWith(
      selectedOption: option,
      answerSubmitted: true,
      isCorrect: isCorrect,
    );

    // Logika untuk menambah XP akan dipindahkan ke screen
  }

  void nextQuestion() {
    if (state.currentIndex < state.questions.length - 1) {
      state = state.copyWith(
        currentIndex: state.currentIndex + 1,
        selectedOption: null,
        answerSubmitted: false,
        isCorrect: false,
      );
    } else {
      // Selesai semua soal
      state = state.copyWith(
        lessonCompleted: true,
      );
    }
  }

  void resetLesson() {
    state = LessonState(
      questions: mockQuestions,
      currentIndex: 0,
      selectedOption: null,
      answerSubmitted: false,
      isCorrect: false,
      lessonCompleted: false,
    );
  }
}