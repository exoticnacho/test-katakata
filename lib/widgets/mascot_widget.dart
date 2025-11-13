// lib/widgets/mascot_widget.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katakata_app/core/constants/colors.dart';

class MascotWidget extends StatelessWidget {
  final double size;

  const MascotWidget({super.key, this.size = 24});

  @override
  Widget build(BuildContext context) {
    // Ganti dengan gambar asli nanti
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: KataKataColors.pinkCeria,
      ),
      // Perbaikan: Hapus const dari Center karena child-nya menggunakan
      // perhitungan runtime (size * 0.5)
      child: Center(
        child: Text(
          'B',
          style: GoogleFonts.poppins( 
            fontSize: size * 0.5, 
            color: KataKataColors.charcoal,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}