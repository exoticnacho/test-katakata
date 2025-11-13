// lib/features/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Text(
              'KataKata',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..shader = const LinearGradient( // PERBAIKAN: Tambah const
                    colors: [KataKataColors.pinkCeria, KataKataColors.violetCerah],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0)),
              ),
            ),
            const SizedBox(width: 8),
            const MascotWidget(size: 24),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.push('/profile'); // Navigasi GoRouter
            },
            icon: const Icon(Icons.person_outline, color: KataKataColors.charcoal),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: KataKataColors.offWhite,
                // PERBAIKAN: Gunakan .withOpacity()
                border: Border.all(color: KataKataColors.charcoal.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.flag_outlined, color: KataKataColors.charcoal),
                  const SizedBox(width: 8),
                  Text(
                    userProfile != null ? 'Level ${userProfile.currentLevel} - Kosakata Dasar' : 'Memuat...',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: KataKataColors.charcoal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: userProfile != null ? (userProfile.xp % 1000) / 1000 : 0.0,
              // PERBAIKAN: Gunakan .withOpacity()
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
            const SizedBox(height: 40),
            KataKataButton(
              text: 'Mulai Latihan Baru',
              onPressed: () {
                 context.push('/lesson'); // Navigasi GoRouter
              },
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: KataKataColors.offWhite,
                      // PERBAIKAN: Gunakan .withOpacity()
                      border: Border.all(color: KataKataColors.charcoal.withOpacity(0.1)),
                    ),
                    child: Row(
                      children: [
                        const MascotWidget(size: 48),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            userProfile != null ? 'Halo ${userProfile.name}! Yuk lanjut belajar hari ini!' : 'Memuat...',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: KataKataColors.charcoal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}