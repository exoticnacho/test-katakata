// lib/core/services/user_service.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Tambahkan import auth_service.dart
import 'package:katakata_app/core/services/auth_service.dart';

// Model untuk Data Profil User
class UserProfile {
  final String name;
  final int streak;
  final int totalWordsTaught;
  final int currentLevel;
  final int xp;

  UserProfile({
    required this.name,
    required this.streak,
    required this.totalWordsTaught,
    required this.currentLevel,
    required this.xp,
  });

  // Method copyWith di dalam class UserProfile (Perbaikan Bug)
  UserProfile copyWith({
    String? name,
    int? streak,
    int? totalWordsTaught,
    int? currentLevel,
    int? xp,
  }) {
    return UserProfile(
      name: name ?? this.name,
      streak: streak ?? this.streak,
      totalWordsTaught: totalWordsTaught ?? this.totalWordsTaught,
      currentLevel: currentLevel ?? this.currentLevel,
      xp: xp ?? this.xp,
    );
  }
}

// StateNotifierProvider untuk mengelola data profil user
final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfile?>((ref) {
  return UserProfileNotifier(ref);
});

class UserProfileNotifier extends StateNotifier<UserProfile?> {
  final Ref ref;

  UserProfileNotifier(this.ref) : super(null) {
    // Listen perubahan auth state
    ref.listen<bool>(isAuthenticatedProvider, (bool? previous, bool? next) {
      if (next == true) {
        // Jika user login, inisialisasi profil
        initializeProfile();
      } else if (next == false) {
        // Jika user logout, hapus profil
        state = null;
      }
    });
  }

  void initializeProfile() {
    // Simulasi data awal setelah login
    state = UserProfile(
      name: 'Pengguna KataKata',
      streak: 7,
      totalWordsTaught: 150,
      currentLevel: 5,
      xp: 1250,
    );
  }

  // Fungsi untuk menambah XP setelah latihan
  void addXp(int xpToAdd) {
    if (state != null) {
      // Menggunakan copyWith yang sudah diperbaiki
      state = state!.copyWith(xp: state!.xp + xpToAdd);
      
      // LOGIKA LEVEL UP (Tambahan Opsional)
      // Jika XP melebihi 1000, naik level
      if (state!.xp >= 1000 * state!.currentLevel) {
          levelUp();
      }
    }
  }

  // Fungsi untuk naik level
  void levelUp() {
    if (state != null) {
      // Atur level baru, dan sisakan sisa XP (seperti Duolingo)
      int nextLevel = state!.currentLevel + 1;
      int remainingXp = state!.xp - (1000 * (nextLevel - 1));

      state = state!.copyWith(
        currentLevel: nextLevel,
        xp: remainingXp, // Reset XP ke sisa (atau biarkan menumpuk, tergantung aturan)
        // Saya asumsikan XP akan dihitung dari 0 lagi setelah naik level
      );
    }
  }
}

// Hapus extension karena copyWith sudah dipindahkan ke dalam class UserProfile.
// extension on UserProfile { ... }