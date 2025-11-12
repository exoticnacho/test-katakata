// lib/core/services/auth_service.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Model untuk User
class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});
}

// Ganti nama provider agar lebih deskriptif
final isAuthenticatedProvider = StateProvider<bool>((ref) => false);

// Provider untuk menyimpan data user yang sedang login
final userProvider = StateProvider<User?>((ref) => null);

// StateNotifierProvider untuk mengelola logika login/logout
final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<bool> {
  final Ref ref;

  AuthNotifier(this.ref) : super(false); // Awalnya tidak login

  // Fungsi login (nanti akan diganti dengan Firebase Auth)
  Future<void> login(String email, String password) async {
    // Simulasi login - nanti diganti dengan Firebase
    if (email == 'user@example.com' && password == 'password') {
      // Simpan data user ke userProvider
      ref.read(userProvider.notifier).state = User(
        id: '1',
        name: 'Pengguna KataKata',
        email: email,
      );
      // Ubah status login
      state = true; // state = true artinya login
    } else {
      // Login gagal - tidak ubah state
      // print('Login gagal');
    }
  }

  // Fungsi logout
  Future<void> logout() async {
    // Hapus data user dari userProvider
    ref.read(userProvider.notifier).state = null;
    // Ubah status logout
    state = false; // state = false artinya logout
  }
}