// lib/app/app.dart
import 'package:flutter/material.dart';
// FIX: Imports localization
import 'package:flutter_localizations/flutter_localizations.dart'; 
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:katakata_app/core/services/auth_service.dart';
import 'package:katakata_app/core/services/user_service.dart';
import 'package:katakata_app/features/splash/splash_screen.dart';
import 'package:katakata_app/features/onboarding/onboarding_screen.dart';
import 'package:katakata_app/features/auth/sign_in_screen.dart';
import 'package:katakata_app/features/main/main_layout_screen.dart'; 
import 'package:katakata_app/features/home/home_screen.dart';
import 'package:katakata_app/features/lesson/lesson_screen.dart';
import 'package:katakata_app/features/profile/profile_screen.dart';
import 'package:katakata_app/features/statistics/statistics_screen.dart';
import 'package:katakata_app/widgets/level_up_modal.dart'; // Tetap di sini
import 'package:katakata_app/features/lesson/stage_selection_screen.dart';

// FIX: GlobalKey untuk GoRouter
final rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(isAuthenticatedProvider);

  return GoRouter(
    initialLocation: '/',
    navigatorKey: rootNavigatorKey, // Pasang GlobalKey di sini
    
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
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: '/signin', builder: (context, state) => const SignInScreen()),
      
      ShellRoute(
        builder: (context, state, child) {
          return MainLayoutScreen(child: child);
        },
        routes: [
          GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
          GoRoute(path: '/statistik', builder: (context, state) => const StatisticsScreen()),
          GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
        ],
      ),
      
        GoRoute(
        path: '/stages',
        builder: (context, state) => const StageSelectionScreen(),
      ),
        GoRoute(
        path: '/lesson/:stageNumber',
        builder: (context, state) {
          final stageNumber = int.tryParse(state.pathParameters['stageNumber'] ?? '1') ?? 1;
          return LessonScreen(stageNumber: stageNumber);
        },
      ),
    ],
  );
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    
    // FIX: HAPUS GLOBAL LISTENER DI SINI. Logic Level Up sekarang ditangani sepenuhnya
    //      di LessonScreen untuk sequencing yang benar.

    return MaterialApp.router(
      title: 'KataKata',
      debugShowCheckedModeBanner: false,
      
      // FIX: Menambahkan localization delegates
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), 
        Locale('id', 'ID'), 
      ],
      
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: router,
    );
  }
}