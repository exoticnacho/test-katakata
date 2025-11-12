// lib/features/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katakata_app/core/constants/colors.dart';
// Hapus import ini karena tidak digunakan di file ini
// import 'package:katakata_app/widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _pageController.page?.round() == index
                        ? KataKataColors.pinkCeria
                        : KataKataColors.charcoal.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Hapus const karena onPressed akan diisi
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/signin');
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
          ],
        ),
      ),
    );
  }

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
            color: KataKataColors.pinkCeria.withValues(alpha: 0.3),
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
            color: KataKataColors.charcoal.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}