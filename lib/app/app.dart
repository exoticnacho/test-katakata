// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:katakata_app/core/services/auth_service.dart';
import 'package:katakata_app/features/splash/splash_screen.dart';
import 'package:katakata_app/features/onboarding/onboarding_screen.dart';
import 'package:katakata_app/features/auth/sign_in_screen.dart';
// Import Halaman Utama dan Layout Baru
import 'package:katakata_app/features/main/main_layout_screen.dart'; // File baru
import 'package:katakata_app/features/home/home_screen.dart';
import 'package:katakata_app/features/lesson/lesson_screen.dart';
import 'package:katakata_app/features/profile/profile_screen.dart';
import 'package:katakata_app/features/statistics/statistics_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  
  final authState = ref.watch(isAuthenticatedProvider);

  return GoRouter(
    initialLocation: '/',
    
    redirect: (BuildContext context, GoRouterState state) {
      final bool loggedIn = authState;
      final String location = state.uri.toString();

      final isPublicRoute = (location == '/' || location == '/onboarding' || location == '/signin');
      final isAuthRoute = location.startsWith('/home') || location.startsWith('/profile') || location.startsWith('/statistik') || location.startsWith('/lesson');

      if (!loggedIn && isAuthRoute) {
        return '/signin'; 
      }

      if (loggedIn && isPublicRoute) {
        return '/home';
      }

      return null;
    },

    routes: [
      // Rute non-authenticated (Splash, Onboarding, Sign In)
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
      
      // Rute Authenticated dengan Bottom Navbar (ShellRoute)
      ShellRoute(
        builder: (context, state, child) {
          // Gunakan kerangka MainLayoutScreen untuk semua rute anak
          return MainLayoutScreen(child: child);
        },
        routes: [
          // Navigasi 0: Home (Awal/Index)
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          // Navigasi 1: Statistik
          GoRoute(
            path: '/statistik',
            builder: (context, state) => const StatisticsScreen(),
          ),
          // Navigasi 2: Profile
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      
      // Rute Full Screen (tanpa Navbar)
      GoRoute(
        path: '/lesson',
        builder: (context, state) => const LessonScreen(),
      ),
    ],
  );
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'KataKata',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: router,
    );
  }
}