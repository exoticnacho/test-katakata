// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Import tambahan yang diperlukan untuk localization
import 'package:flutter_localizations/flutter_localizations.dart'; 
import 'package:katakata_app/app/app.dart'; 

void main() {
  // Tambahkan inisialisasi jika Anda menggunakan GoRouter untuk navigasi awal
  WidgetsFlutterBinding.ensureInitialized();
  // Tidak perlu memanggil runApp di sini karena sudah ada di app.dart
  runApp(
    const ProviderScope(
      child: MyApp(), 
    ),
  );
}