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
}

// StateNotifierProvider untuk mengelola data profil user
// Kita gunakan StateProvider dulu, lalu gunakan ref.listen di StateNotifier untuk mengupdate.
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
      state = state!.copyWith(xp: state!.xp + xpToAdd);
    }
  }

  // Fungsi untuk naik level (simulasi)
  void levelUp() {
    if (state != null) {
      state = state!.copyWith(
        currentLevel: state!.currentLevel + 1,
        xp: state!.xp, // XP bisa di-reset atau ditambahkan ke level baru
      );
    }
  }
}

// Extension untuk membuat method copyWith (immutable update)
extension on UserProfile {
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