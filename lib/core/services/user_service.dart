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
  final bool isLevelingUp; // FIX: Properti ini harus ada!

  UserProfile({
    required this.name,
    required this.streak,
    required this.totalWordsTaught,
    required this.currentLevel,
    required this.xp,
    this.isLevelingUp = false, // FIX: Inisialisasi properti baru
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
    state = UserProfile(
      name: 'Pengguna KataKata',
      streak: 7,
      totalWordsTaught: 150,
      currentLevel: 5,
      xp: 1940, // FIX: Titik pemicu Level Up (Target 2000 XP)
      isLevelingUp: false,
    );
  }

  // Fungsi untuk menambah XP setelah latihan (PENGAMANAN NULL)
  void addXp(int xpToAdd) {
    if (state != null) { 
      int newXp = state!.xp + xpToAdd;
      int oldLevel = state!.currentLevel;
      
      // FIX LOGIC: Pengecekan Level Up (Level 6 membutuhkan 2000 XP untuk demo)
      if (newXp >= 2000 && oldLevel < 6) { 
          levelUp();
      }
      
      state = state!.copyWith(xp: newXp);
    }
  }

  // Fungsi untuk naik level
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