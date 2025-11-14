// lib/core/services/user_service.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:katakata_app/core/services/auth_service.dart';

// Model untuk Data Profil User
class UserProfile {
  final String name;
  final int streak;
  final int totalWordsTaught;
  final int currentLevel;
  final int xp;
  final bool isLevelingUp; 

  UserProfile({
    required this.name,
    required this.streak,
    required this.totalWordsTaught,
    required this.currentLevel,
    required this.xp,
    this.isLevelingUp = false, 
  });

  UserProfile copyWith({
    String? name,
    int? streak,
    int? totalWordsTaught,
    int? currentLevel,
    int? xp,
    bool? isLevelingUp, 
  }) {
    return UserProfile(
      name: name ?? this.name,
      streak: streak ?? this.streak,
      totalWordsTaught: totalWordsTaught ?? this.totalWordsTaught,
      currentLevel: currentLevel ?? this.currentLevel,
      xp: xp ?? this.xp,
      isLevelingUp: isLevelingUp ?? this.isLevelingUp,
    );
  }
}

// StateNotifierProvider
final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfile?>((ref) {
  return UserProfileNotifier(ref);
});

class UserProfileNotifier extends StateNotifier<UserProfile?> {
  final Ref ref;

  UserProfileNotifier(this.ref) : super(null) {
    // FIX: Menggunakan Level 1 dan XP 940 untuk simulasi
    initializeProfile(); 

    ref.listen<bool>(isAuthenticatedProvider, (bool? previous, bool? next) {
      if (next == true) {
        initializeProfile();
      } else if (next == false) {
        state = null;
      }
    });
  }

  void initializeProfile() {
    // FIX: Mulai dari Level 1 dengan XP dekat ambang batas Level 2 (1000 XP)
    state = UserProfile(
      name: 'Pengguna KataKata',
      streak: 0, // Mulai streak dari 0
      totalWordsTaught: 0,
      currentLevel: 1, // MULAI DARI LEVEL 1
      xp: 940, // XP awal
      isLevelingUp: false,
    );
  }

  // Fungsi untuk menambah XP setelah latihan (PENGAMANAN NULL)
  void addXp(int xpToAdd) {
    if (state != null) { 
      int newXp = state!.xp + xpToAdd;
      int oldLevel = state!.currentLevel;
      
      // LOGIC LEVEL UP (Target 1000 XP untuk Level 2)
      if (newXp >= 1000 && oldLevel < 2) { // Ambang Level 2
          levelUp();
      }
      
      state = state!.copyWith(xp: newXp);
    }
  }

  void levelUp() {
    if (state != null) { 
      int nextLevel = state!.currentLevel + 1;
      int remainingXp = state!.xp; 
      
      state = state!.copyWith(
        currentLevel: nextLevel,
        xp: remainingXp, 
        isLevelingUp: true, // SET state ini untuk memicu modal
      );
    }
  }
  
  void resetLevelUpStatus() {
     if (state != null && state!.isLevelingUp) {
        state = state!.copyWith(isLevelingUp: false);
     }
  }
}