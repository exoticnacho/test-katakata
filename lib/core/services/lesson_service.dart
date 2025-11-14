// lib/core/services/lesson_service.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
// FIX: Hapus data mock lama dan import data dari file baru
import 'package:katakata_app/core/data/mock_questions.dart';
import 'package:katakata_app/core/services/user_service.dart'; // Digunakan untuk mendapatkan level user

// Model untuk Soal (Tetap sama)
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

// Model untuk State Latihan (Tetap sama)
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

// StateNotifierProvider
final lessonProvider = StateNotifierProvider<LessonNotifier, LessonState>((ref) {
  // FIX: Passing ref ke LessonNotifier agar bisa mengakses userProvider
  return LessonNotifier(ref); 
});

class LessonNotifier extends StateNotifier<LessonState> {
  final Ref ref;

  LessonNotifier(this.ref) : super(_initialState(ref));

  // FIX: Fungsi statis untuk mendapatkan state awal berdasarkan Level User
  static LessonState _initialState(Ref ref) {
    // Dapatkan Level User saat ini (default ke Level 1 jika null)
    final currentLevel = ref.read(userProfileProvider)?.currentLevel ?? 1;
    
    // Pilih pertanyaan berdasarkan Level. Jika Level 5, ambil Level 5.
    // Jika level > 5 (misalnya 6, 7), kita ambil pertanyaan Level 5 sebagai fallback.
    final levelKey = questionsByLevel.containsKey(currentLevel) 
        ? currentLevel
        : (currentLevel > 5 ? 5 : 1); // Fallback ke Level 5 jika Level > 5
    
    final initialQuestions = questionsByLevel[levelKey] ?? level1Questions;

    return LessonState(
      questions: initialQuestions,
      currentIndex: 0,
      selectedOption: null,
      answerSubmitted: false,
      isCorrect: false,
      lessonCompleted: false,
    );
  }

  void selectAnswer(String option) {
    if (state.answerSubmitted) return; 

    final currentQuestion = state.questions[state.currentIndex];
    final isCorrect = option == currentQuestion.correctAnswer;
    
    state = state.copyWith(
      selectedOption: option,
      isCorrect: isCorrect,
    );
  }

  void submitAnswer() {
     if (state.selectedOption == null || state.answerSubmitted) return;
     
     state = state.copyWith(
        answerSubmitted: true,
     );
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
    // FIX: Menggunakan _initialState yang baru untuk reset yang benar
    state = _initialState(ref);
  }
}