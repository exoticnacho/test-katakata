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
    // FIX: Mulai dari Level 1 dengan XP 0 agar naik Level setelah Stage 10
    state = UserProfile(
      name: 'Pengguna KataKata',
      streak: 0, 
      totalWordsTaught: 5,
      currentLevel: 1, 
      xp: 0, // <-- UBAH XP AWAL KE 0
      isLevelingUp: false,
    );
  }

  // Fungsi untuk menambah XP setelah latihan (PENGAMANAN NULL)
  void addXp(int xpToAdd) {
    if (state != null) { 
      int newXp = state!.xp + xpToAdd;
      int oldLevel = state!.currentLevel;
      
      // Hitung ambang batas Level berikutnya: Level N+1 butuh N * 1000 XP
      int requiredXpForNextLevel = oldLevel * 1000;
      
      // LOGIC LEVEL UP (Sekarang Universal)
      if (newXp >= requiredXpForNextLevel) { 
          // Panggil levelUp() sebelum mengupdate state XP
          levelUp();
      }
      
      // Update XP. Jika levelUp() dipanggil, level sudah naik.
      state = state!.copyWith(xp: newXp);
    }
  }

  void addWordsTaught(int wordsToAdd) {
    if (state != null) {
      int newTotalWords = state!.totalWordsTaught + wordsToAdd;
      state = state!.copyWith(
        totalWordsTaught: newTotalWords,
      );
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