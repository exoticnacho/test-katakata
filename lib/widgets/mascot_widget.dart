// lib/widgets/mascot_widget.dart
import 'package:flutter/material.dart';

class MascotWidget extends StatelessWidget {
  final double size;
  final String assetName; // Tambahkan parameter opsional untuk maskot spesifik

  const MascotWidget({
    super.key,
    this.size = 24,
    // Default ke maskot utama
    this.assetName = 'mascot_main.png', 
  });

  @override
  Widget build(BuildContext context) {
    // Menggunakan Image.asset untuk menampilkan maskot dari folder assets/images/
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        'assets/images/$assetName', // Memuat gambar berdasarkan nama aset
        fit: BoxFit.contain,
      ),
    );
  }
}