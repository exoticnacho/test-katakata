import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katakata_app/core/constants/colors.dart';

class MainLayoutScreen extends StatelessWidget {
  final Widget child;

  const MainLayoutScreen({super.key, required this.child});

  // UKURAN IKON FINAL UNTUK NAVBAR
  static const double iconSize = 40.0;

  @override
  Widget build(BuildContext context) {
    // Index navigasi berdasarkan rute saat ini
    final String location = GoRouterState.of(context).uri.toString();
    int currentIndex = _calculateIndex(location);

    return Scaffold(
      backgroundColor: KataKataColors.offWhite,
      // Halaman Anak (Home, Statistik, atau Profile)
      body: child, 
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: KataKataColors.charcoal.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => _onItemTapped(context, index),
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: KataKataColors.pinkCeria,
          unselectedItemColor: KataKataColors.charcoal.withOpacity(0.6),
          selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12), // FIX: Gunakan GoogleFonts
          unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12), // FIX: Gunakan GoogleFonts
          
          items: [
            // Navigasi 0: HOME / LATIHAN
            BottomNavigationBarItem(
              icon: Opacity(
                opacity: currentIndex == 0 ? 1.0 : 0.6,
                child: Image.asset(
                  'assets/images/logo_katakata.png', 
                  height: iconSize, 
                  color: currentIndex == 0 ? KataKataColors.pinkCeria : KataKataColors.charcoal,
                ),
              ),
              label: 'Latihan',
            ),
            // Navigasi 1: STATISTIK
            BottomNavigationBarItem(
              icon: Opacity(
                opacity: currentIndex == 1 ? 1.0 : 0.6,
                child: Image.asset(
                  'assets/images/icon_streak.png', 
                  height: iconSize, 
                  color: currentIndex == 1 ? KataKataColors.pinkCeria : KataKataColors.charcoal,
                ),
              ),
              label: 'Statistik',
            ),
            // FIX: Navigasi 2: GLOSARIUM
            BottomNavigationBarItem(
              icon: Opacity(
                opacity: currentIndex == 2 ? 1.0 : 0.6,
                child: Icon( // Menggunakan Icon standar karena tidak ada asset untuk Glosarium
                  Icons.auto_stories, // Ikon buku/stories
                  size: iconSize,
                  color: currentIndex == 2 ? KataKataColors.pinkCeria : KataKataColors.charcoal,
                ),
              ),
              label: 'Glosarium',
            ),
            // FIX: Navigasi 3: PROFIL
            BottomNavigationBarItem(
              icon: Opacity(
                opacity: currentIndex == 3 ? 1.0 : 0.6,
                child: Image.asset(
                  'assets/images/icon_avatar_placeholder.png', 
                  height: iconSize, 
                  color: currentIndex == 3 ? KataKataColors.pinkCeria : KataKataColors.charcoal,
                ),
              ),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }

  int _calculateIndex(String location) {
    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/statistik')) {
      return 1;
    }
    // FIX: Tambahkan Glosarium (Index 2)
    if (location.startsWith('/wordlist')) {
      return 2;
    }
    if (location.startsWith('/profile')) {
      return 3; // FIX: Profil adalah Index 3
    }
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/statistik');
        break;
      // FIX: Navigasi Glosarium
      case 2:
        context.go('/wordlist');
        break;
      // FIX: Navigasi Profil
      case 3:
        context.go('/profile');
        break;
    }
  }
}