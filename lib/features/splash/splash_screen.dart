// lib/features/splash/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katakata_app/core/constants/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:katakata_app/widgets/mascot_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        context.go('/onboarding');
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
            // [FIX: Ukuran Logo] Menggunakan lebar agar proporsi terjaga
            Image.asset(
              'assets/images/logo_katakata.png',
              width: 400, // Ukuran yang lebih wajar dan terpusat
            ),
            
            const SizedBox(height: 20),
            
            // [FIX: Ukuran Maskot] Ukuran yang besar dan menonjol
            const MascotWidget(size: 120, assetName: 'mascot_main.png'), 
            
            const SizedBox(height: 40),
            Text(
              'Belajar Bahasa, Satu Kata Sekaligus!',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: KataKataColors.charcoal.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}