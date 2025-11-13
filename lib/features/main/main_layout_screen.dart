import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          
          items: [
            // Navigasi 0: HOME
            BottomNavigationBarItem(
              icon: Opacity(
                opacity: currentIndex == 0 ? 1.0 : 0.6,
                child: Image.asset(
                  'assets/images/logo_katakata.png', 
                  height: iconSize, // FIX: Ukuran 40px
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
                  height: iconSize, // FIX: Ukuran 40px
                  color: currentIndex == 1 ? KataKataColors.pinkCeria : KataKataColors.charcoal,
                ),
              ),
              label: 'Statistik',
            ),
            // Navigasi 2: PROFIL
            BottomNavigationBarItem(
              icon: Opacity(
                opacity: currentIndex == 2 ? 1.0 : 0.6,
                child: Image.asset(
                  // Menggunakan placeholder karena aset avatar asli sulit diwarnai
                  'assets/images/icon_avatar_placeholder.png', 
                  height: iconSize, // FIX: Ukuran 40px
                  color: currentIndex == 2 ? KataKataColors.pinkCeria : KataKataColors.charcoal,
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
    if (location.startsWith('/profile')) {
      return 2;
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
      case 2:
        context.go('/profile');
        break;
    }
  }
}