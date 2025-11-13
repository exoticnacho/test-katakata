// lib/features/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katakata_app/core/constants/colors.dart';
import 'package:katakata_app/core/services/user_service.dart';
import 'package:katakata_app/widgets/custom_button.dart';
import 'package:katakata_app/widgets/mascot_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: KataKataColors.offWhite,
      // Hapus AppBar karena kita akan menggunakan Bottom Navigation Bar di masa depan
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo_katakata.png',
              height: 60, 
            ),
            const SizedBox(width: 1),
            const MascotWidget(size: 50, assetName: 'mascot_main.png'), 
          ],
        ),
        actions: [
          // Navigasi ke Halaman Profil
          IconButton(
            onPressed: () {
              context.push('/profile'); 
            },
            // FIX: Menggunakan ikon Avatar/Person standar Material (atau ikon kustom)
            icon: Image.asset('assets/images/icon_avatar_placeholder.png', width: 50, height: 50),
          ),
          const SizedBox(width: 1),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container Status Level
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: KataKataColors.offWhite,
                border: Border.all(color: KataKataColors.charcoal.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  // FIX: Ukuran Ikon Bendera Progress (30)
                  Image.asset('assets/images/flag_uk.png', width: 30, height: 30),
                  const SizedBox(width: 12),
                  Text(
                    userProfile != null ? 'Level ${userProfile.currentLevel} - Kosakata Dasar' : 'Memuat...',
                    style: GoogleFonts.poppins(
                      fontSize: 18, 
                      fontWeight: FontWeight.w600,
                      color: KataKataColors.charcoal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Progress Bar dan Stars
            LinearProgressIndicator(
              value: userProfile != null ? (userProfile.xp % 1000) / 1000 : 0.0,
              backgroundColor: KataKataColors.charcoal.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation(KataKataColors.kuningCerah),
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (int i = 0; i < 5; i++)
                  Icon(
                    i < 3 ? Icons.star : Icons.star_border, // Contoh 3/5 bintang
                    color: KataKataColors.kuningCerah,
                    size: 20,
                  ),
              ],
            ),
            
            const Spacer(), // Dorong konten ke tengah bawah

            // Tombol Mulai Latihan Baru
            KataKataButton(
              text: 'Mulai Latihan Baru',
              onPressed: () {
                 context.push('/lesson');
              },
            ),
            const SizedBox(height: 15),
            
            // Kontainer untuk maskot bicara (Speech Bubble)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: KataKataColors.offWhite,
                border: Border.all(color: KataKataColors.charcoal.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  // FIX: Ukuran Maskot Speech (60)
                  const MascotWidget(size: 90, assetName: 'mascot_speech.png'), 
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      userProfile != null ? 'Halo ${userProfile.name}! Yuk lanjut belajar hari ini!' : 'Memuat...',
                      style: GoogleFonts.poppins(
                        fontSize: 16, 
                        color: KataKataColors.charcoal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}