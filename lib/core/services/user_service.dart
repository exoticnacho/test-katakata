// lib/core/services/user_service.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Tambahkan import auth_service.dart
import 'package:katakata_app/core/services/auth_service.dart';

// Model untuk Data Profil User
class UserProfile {
// ... (Model tetap sama)
  final String name;
  final int streak;
  final int totalWordsTaught;
  final int currentLevel;
  final int xp;
  final bool isLevelingUp; // FITUR BARU: Untuk trigger pop-up

  UserProfile({
    required this.name,
    required this.streak,
    required this.totalWordsTaught,
    required this.currentLevel,
    required this.xp,
    this.isLevelingUp = false, 
  });

  // Method copyWith yang diperbarui
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
    // FIX: Tidak langsung panggil initializeProfile() jika user belum authenticated
    // Hanya panggil listener yang akan memicu init setelah login (di auth_service)
    
    // Namun, untuk demo DUMMY LOGIN, kita panggil di constructor
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
      xp: 1940, // Titik pemicu Level Up
      isLevelingUp: false,
    );
  }

  // Fungsi untuk menambah XP setelah latihan
  void addXp(int xpToAdd) {
    if (state != null) { // PENGAMANAN NULL
      int newXp = state!.xp + xpToAdd;
      int oldLevel = state!.currentLevel;
      
      state = state!.copyWith(xp: newXp);

      if (newXp >= 1000 * (oldLevel + 1)) { 
          levelUp();
      }
    }
  }

  void levelUp() {
    if (state != null) { // PENGAMANAN NULL
      int nextLevel = state!.currentLevel + 1;
      int remainingXp = state!.xp; 
      
      state = state!.copyWith(
        currentLevel: nextLevel,
        xp: remainingXp, 
        isLevelingUp: true, 
      );
    }
  }
  
  void resetLevelUpStatus() {
     if (state != null && state!.isLevelingUp) {
        state = state!.copyWith(isLevelingUp: false);
     }
  }
}