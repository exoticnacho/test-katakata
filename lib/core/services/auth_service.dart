// lib/core/services/auth_service.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Model untuk User
class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});
}

// INI ADALAH STATUS LOGIN (BENAR/SALAH)
final isAuthenticatedProvider = StateProvider<bool>((ref) => false);

// Provider untuk menyimpan data user yang sedang login
final userProvider = StateProvider<User?>((ref) => null);

// INI ADALAH STATUS LOADING (SIBUK/TIDAK)
final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<bool> {
  final Ref ref;

  AuthNotifier(this.ref) : super(false); // Awalnya tidak loading (false)

  // Fungsi login
  Future<void> login(String email, String password) async {
    state = true; // 1. Set isLoading = true
    
    // Simulasi login (menunggu 1 detik)
    await Future.delayed(const Duration(seconds: 1));

    if (email == 'user@example.com' && password == 'password') {
      // Simpan data user ke userProvider
      ref.read(userProvider.notifier).state = User(
        id: '1',
        name: 'Pengguna KataKata',
        email: email,
      );
      
      // PERBAIKAN BUG: Update status login (isAuthenticatedProvider) menjadi true
      ref.read(isAuthenticatedProvider.notifier).state = true;

    } else {
      // Login gagal (tidak melakukan apa-apa)
    }
    
    state = false; // 3. Set isLoading = false
  }

  // Fungsi logout
  Future<void> logout() async {
    // Hapus data user dari userProvider
    ref.read(userProvider.notifier).state = null;
    
    // PERBAIKAN BUG: Update status login (isAuthenticatedProvider) menjadi false
    ref.read(isAuthenticatedProvider.notifier).state = false;
  }
}