import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:katakata_app/core/constants/colors.dart';

class KataKataButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  // FIX: Tambahkan parameter baru opsional
  final Color? backgroundColor;
  final Color? foregroundColor;

  const KataKataButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = double.infinity,
    // FIX: Tambahkan parameter baru opsional
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // Cek apakah warna kustom (solid) akan digunakan
    final bool useOverrideColor = backgroundColor != null;
    
    // Tentukan warna yang akan dipakai
    final Color effectiveBackgroundColor = backgroundColor ?? KataKataColors.violetCerah; // Default jika override
    final Color effectiveForegroundColor = foregroundColor ?? Colors.white; // Default text

    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        
        // FIX: Gunakan gradient HANYA JIKA backgroundColor tidak disediakan
        gradient: !useOverrideColor 
            ? const LinearGradient(
                colors: [KataKataColors.pinkCeria, KataKataColors.violetCerah],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null, 
        
        // FIX: Gunakan backgroundColor JIKA disediakan
        color: useOverrideColor ? effectiveBackgroundColor : null, 
        
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            // FIX: Gunakan foregroundColor yang efektif
            color: effectiveForegroundColor, 
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}