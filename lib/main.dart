// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:katakata_app/app/app.dart'; // Tambahkan ini

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(), // Gunakan MyApp dari app.dart
    ),
  );
}