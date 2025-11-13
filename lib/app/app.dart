// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // PERBAIKAN: Import Riverpod
import 'package:katakata_app/core/services/auth_service.dart'; // PERBAIKAN: Import auth service
import 'package:katakata_app/features/splash/splash_screen.dart';
import 'package:katakata_app/features/onboarding/onboarding_screen.dart';
import 'package:katakata_app/features/auth/sign_in_screen.dart';
import 'package:katakata_app/features/home/home_screen.dart';
import 'package:katakata_app/features/lesson/lesson_screen.dart';
import 'package:katakata_app/features/profile/profile_screen.dart';

// PERBAIKAN: Ubah _router menjadi Provider agar bisa membaca provider lain
final goRouterProvider = Provider<GoRouter>((ref) {
  
  // Ambil status autentikasi dari Riverpod
  // Kita 'watch' agar GoRouter rebuild saat status login berubah
  final authState = ref.watch(isAuthenticatedProvider);

  return GoRouter(
    initialLocation: '/',
    
    // PERBAIKAN: Tambahkan logic redirect
    redirect: (BuildContext context, GoRouterState state) {
      final bool loggedIn = authState;
      final String location = state.uri.toString();

      // Daftar halaman publik yang bisa diakses tanpa login
      final isPublicRoute = (location == '/' || location == '/onboarding' || location == '/signin');

      // 1. Jika BELUM login dan mencoba akses halaman privat
      if (!loggedIn && !isPublicRoute) {
        return '/signin'; // Arahkan ke signin
      }

      // 2. Jika SUDAH login dan berada di halaman publik
      if (loggedIn && isPublicRoute) {
        return '/home'; // Otomatis arahkan ke home
      }

      return null; // Tidak perlu redirect
    },

    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/signin',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/lesson',
        builder: (context, state) => const LessonScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});

// PERBAIKAN: Ubah MyApp menjadi ConsumerWidget
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Baca goRouterProvider
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'KataKata',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: router, // Gunakan router dari provider
    );
  }
}