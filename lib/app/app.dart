// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:katakata_app/features/splash/splash_screen.dart';
import 'package:katakata_app/features/onboarding/onboarding_screen.dart';
import 'package:katakata_app/features/auth/sign_in_screen.dart';
import 'package:katakata_app/features/home/home_screen.dart';
import 'package:katakata_app/features/lesson/lesson_screen.dart';
import 'package:katakata_app/features/profile/profile_screen.dart';

final GoRouter _router = GoRouter(
  initialLocation: '/', // Pastikan ini adalah path awal kamu
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(), // Pastikan ini sesuai
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router( // <-- PENTING: Gunakan .router
      title: 'KataKata',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: _router, // <-- PENTING: Sambungkan GoRouter
    );
  }
}