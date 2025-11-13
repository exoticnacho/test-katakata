// lib/features/statistics/statistics_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katakata_app/core/constants/colors.dart';
import 'package:katakata_app/core/services/user_service.dart';

class StatisticsScreen extends ConsumerWidget {
    const StatisticsScreen({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        final userProfile = ref.watch(userProfileProvider);

        return Scaffold(
            backgroundColor: KataKataColors.offWhite,
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                    'Statistik Saya',
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: KataKataColors.charcoal,
                    ),
                ),
            ),
            body: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(
                            'Statistik Utama',
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: KataKataColors.charcoal,
                            ),
                        ),
                        const SizedBox(height: 16),
                        if (userProfile != null) ...[
                            _BuildStatCard( 
                                iconAsset: 'icon_streak.png',
                                title: 'Streak hari ini:',
                                value: '${userProfile.streak} hari',
                            ),
                            const SizedBox(height: 16),
                            _BuildStatCard(
                                iconAsset: 'icon_total_words.png',
                                title: 'Total kata dipelajari:',
                                value: '${userProfile.totalWordsTaught}',
                            ),
                            const SizedBox(height: 16),
                            _BuildStatCard(
                                iconAsset: 'icon_active_level.png',
                                title: 'Level aktif:',
                                value: 'Level ${userProfile.currentLevel}',
                            ),
                            const SizedBox(height: 16),
                            _BuildStatCard(
                                iconAsset: 'icon_streak.png',
                                title: 'Total XP:',
                                value: '${userProfile.xp}',
                            ),
                        ] else
                            const CircularProgressIndicator(),
                        const SizedBox(height: 40),
                        
                        // NOTE: Pencapaian dipindahkan kembali ke ProfileScreen sesuai permintaan, 
                        // tapi kita sediakan spasi di sini jika ingin menambah grafik dll.
                    ],
                ),
            ),
        );
    }
}

// Sub-Widget: _BuildStatCard (digunakan hanya di StatisticsScreen)
class _BuildStatCard extends StatelessWidget {
    final String iconAsset; 
    final String title;
    final String value;
    
    const _BuildStatCard({ 
        required this.iconAsset, 
        required this.title,
        required this.value,
    });

  @override
  Widget build(BuildContext context) {
    return Container( 
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: KataKataColors.offWhite,
        border: Border.all(color: KataKataColors.charcoal.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Image.asset('assets/images/$iconAsset', width: 24, height: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: KataKataColors.charcoal.withOpacity(0.7),
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