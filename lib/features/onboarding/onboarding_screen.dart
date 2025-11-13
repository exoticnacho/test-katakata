// lib/features/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // PERBAIKAN: Import GoRouter
import 'package:google_fonts/google_fonts.dart';
import 'package:katakata_app/core/constants/colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  // PERBAIKAN: Tambahkan dispose untuk membersihkan controller
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KataKataColors.offWhite,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return _buildPage(index);
                },
              ),
            ),
            
            // PERBAIKAN: Bungkus indikator dengan AnimatedBuilder
            // Ini akan "mendengarkan" _pageController dan hanya
            // membangun ulang widget ini saat halaman berubah.
            AnimatedBuilder(
              animation: _pageController,
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) {
                      // Cek apakah controller sudah terpasang
                      final bool hasClients = _pageController.hasClients;
                      final double page = hasClients ? (_pageController.page ?? 0.0) : 0.0;
                      
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: page.round() == index
                              ? KataKataColors.pinkCeria
                              : KataKataColors.charcoal.withOpacity(0.3),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // PERBAIKAN: Gunakan GoRouter untuk navigasi
                context.go('/signin');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: KataKataColors.pinkCeria,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Text(
                'Mulai Belajar!',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20), // Tambahan padding bawah
          ],
        ),
      ),
    );
  }

  // Widget _buildPage tidak berubah
  Widget _buildPage(int index) {
    final titles = ['Belajar Seru', 'Latihan Interaktif', 'Progres Terpantau'];
    final descriptions = [
      'Dengan Baloo, belajar bahasa jadi menyenangkan dan tidak membosankan.',
      'Jawab soal pilihan ganda dengan cepat dan dapatkan poin!',
      'Lihat kemajuanmu setiap hari dan raih pencapaian baru.'
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: KataKataColors.pinkCeria.withOpacity(0.3),
          ),
          child: Center(
            child: Text(
              'B',
              style: GoogleFonts.poppins(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: KataKataColors.charcoal,
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Text(
          titles[index],
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: KataKataColors.charcoal,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          descriptions[index],
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: KataKataColors.charcoal.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}