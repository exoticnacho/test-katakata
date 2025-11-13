// lib/features/splash/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katakata_app/core/constants/colors.dart';
import 'package:go_router/go_router.dart'; // <-- PERBAIKAN 1: Import GoRouter

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) { // Pastikan widget masih mounted
        // PERBAIKAN 2: Ganti Navigator.pushReplacementNamed
        // Navigator.pushReplacementNamed(context, '/onboarding');
        context.go('/onboarding'); // Gunakan navigasi GoRouter
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KataKataColors.offWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'KataKata',
              style: GoogleFonts.poppins(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..shader = const LinearGradient(
                    colors: [KataKataColors.pinkCeria, KataKataColors.violetCerah],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0)),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // Kode ini (withOpacity) sudah benar, abaikan error linter sebelumnya
                color: KataKataColors.pinkCeria.withOpacity(0.3),
              ),
              child: Center(
                child: Text(
                  'B',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: KataKataColors.charcoal,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'Belajar Bahasa, Satu Kata Sekaligus!',
              style: GoogleFonts.poppins(
                fontSize: 16,
                // Kode ini (withOpacity) sudah benar
                color: KataKataColors.charcoal.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}