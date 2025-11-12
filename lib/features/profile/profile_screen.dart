// lib/features/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katakata_app/core/constants/colors.dart';
import 'package:katakata_app/core/services/auth_service.dart';
import 'package:katakata_app/core/services/user_service.dart';
// Hapus import yang tidak digunakan
// import 'package:katakata_app/widgets/custom_button.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final currentUser = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: KataKataColors.offWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Profil Pengguna',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: KataKataColors.charcoal,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
              }
            },
            icon: Icon(Icons.logout_outlined, color: KataKataColors.charcoal),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: KataKataColors.pinkCeria.withValues(alpha: 0.3),
                  ),
                  child: Center(
                    child: Text(
                      currentUser != null ? currentUser.name.substring(0, 1).toUpperCase() : '?',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: KataKataColors.charcoal,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  currentUser != null ? currentUser.name : 'Memuat...',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: KataKataColors.charcoal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              'Statistik',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: KataKataColors.charcoal,
              ),
            ),
            const SizedBox(height: 16),
            if (userProfile != null) ...[
              _buildStatCard(
                icon: Icons.star_border,
                title: 'Streak hari ini:',
                value: '${userProfile.streak} dari!',
                context: context,
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                icon: Icons.menu_book_outlined,
                title: 'Total kata diajarkan:',
                value: '${userProfile.totalWordsTaught}',
                context: context,
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                icon: Icons.flag_outlined,
                title: 'Level aktif:',
                value: 'Level ${userProfile.currentLevel}',
                context: context,
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                icon: Icons.star,
                title: 'Total XP:',
                value: '${userProfile.xp}',
                context: context,
              ),
            ] else
              const CircularProgressIndicator(),
            const SizedBox(height: 30),
            Text(
              'Pencapaian',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: KataKataColors.charcoal,
              ),
            ),
            const SizedBox(height: 16),
            Container( // Tambahkan const
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: KataKataColors.offWhite,
                border: Border.all(color: KataKataColors.charcoal.withValues(alpha: 0.1)),
              ),
              child: Row(
                children: [
                  Icon(Icons.star, color: KataKataColors.kuningCerah, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'Level Up!',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: KataKataColors.charcoal,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: KataKataColors.kuningCerah.withValues(alpha: 0.3),
                    ),
                    child: Text(
                      'x3',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
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

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required BuildContext context,
  }) {
    return Container( // Tambahkan const
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: KataKataColors.offWhite,
        border: Border.all(color: KataKataColors.charcoal.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: KataKataColors.charcoal, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: KataKataColors.charcoal.withValues(alpha: 0.7),
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: KataKataColors.charcoal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}