// lib/core/services/lesson_service.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:katakata_app/core/data/mock_questions.dart';
import 'package:katakata_app/core/services/user_service.dart';

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
final lessonProvider = StateNotifierProvider.family<LessonNotifier, LessonState, int>((ref, stageNumber) { 
  return LessonNotifier(ref, stageNumber); 
});

class LessonNotifier extends StateNotifier<LessonState> {
  final Ref ref;
  final int stageNumber;

  LessonNotifier(this.ref, this.stageNumber) : super(_initialState(ref, stageNumber));

  // UBAH _initialState untuk menerima stageNumber dan menghitung Level & Stage
  static LessonState _initialState(Ref ref, int continuousStageNumber) {
    // Hitung Level berdasarkan Stage: (continuousStageNumber - 1) / 10 + 1
    final currentLevel = ((continuousStageNumber - 1) ~/ 10) + 1;
    // Hitung Stage Lokal: (continuousStageNumber - 1) % 10 + 1
    final localStage = ((continuousStageNumber - 1) % 10) + 1;

    // Fallback ke Level 6 jika StageNumber terlalu tinggi
    final levelKey = questionsByLevelAndStage.containsKey(currentLevel) 
        ? currentLevel
        : 6; 
    
    final stageMap = questionsByLevelAndStage[levelKey]!;
    
    // Ambil pertanyaan berdasarkan Stage Lokal
    final initialQuestions = stageMap.containsKey(localStage)
        ? stageMap[localStage]!
        : stageMap[1]!; // Fallback ke Stage 1 jika ada kesalahan stage lokal

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
    state = _initialState(ref, stageNumber); // <-- GUNAKAN stageNumber
  }
}