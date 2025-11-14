// lib/core/data/mock_questions.dart
import 'package:katakata_app/core/services/lesson_service.dart';

// Data Mock untuk Level 1 - Kosakata Dasar
final List<Question> level1Questions = [
  Question(
    id: 'L1Q1',
    text: 'Bagaimana mengatakan \'Halo\' dalam bahasa Spanyol?',
    options: ['Gracias', 'Adiós', 'Hola'],
    correctAnswer: 'Hola',
  ),
  Question(
    id: 'L1Q2',
    text: 'Apa arti \'Adiós\' dalam bahasa Indonesia?',
    options: ['Selamat tinggal', 'Terima kasih', 'Sampai jumpa'],
    correctAnswer: 'Selamat tinggal',
  ),
  Question(
    id: 'L1Q3',
    text: 'Kata \'Gato\' dalam bahasa Spanyol berarti?',
    options: ['Anjing', 'Kucing', 'Burung'],
    correctAnswer: 'Kucing',
  ),
];

// Data Mock untuk Level 2 - Kata Benda Sederhana
final List<Question> level2Questions = [
  Question(
    id: 'L2Q1',
    text: 'Bagaimana mengatakan \'Anjing\' dalam bahasa Spanyol?',
    options: ['Perro', 'Gato', 'Mesa'],
    correctAnswer: 'Perro',
  ),
  Question(
    id: 'L2Q2',
    text: 'Kata \'Agua\' berarti?',
    options: ['Roti', 'Air', 'Angin'],
    correctAnswer: 'Air',
  ),
  Question(
    id: 'L2Q3',
    text: 'Apa terjemahan \'Buku\'?',
    options: ['Casa', 'Libro', 'Mesa'],
    correctAnswer: 'Libro',
  ),
];

// Data Mock untuk Level 3 - Kalimat Dasar
final List<Question> level3Questions = [
  Question(
    id: 'L3Q1',
    text: 'Terjemahkan: \'Aku makan apel\'.',
    options: ['Yo tengo el pan', 'Yo como una manzana', 'Tú bebes agua'],
    correctAnswer: 'Yo como una manzana',
  ),
  Question(
    id: 'L3Q2',
    text: 'Kata manakah yang berarti \'Kamu\'?',
    options: ['Él', 'Tú', 'Nosotros'],
    correctAnswer: 'Tú',
  ),
];

// Data Mock untuk Level 4 - Warna
final List<Question> level4Questions = [
  Question(
    id: 'L4Q1',
    text: 'Apa warna \'Rojo\'?',
    options: ['Biru', 'Kuning', 'Merah'],
    correctAnswer: 'Merah',
  ),
  Question(
    id: 'L4Q2',
    text: 'Kata \'Blanco\' berarti?',
    options: ['Hitam', 'Putih', 'Hijau'],
    correctAnswer: 'Putih',
  ),
];

// Data Mock untuk Level 5 - Salam Lanjutan
final List<Question> level5Questions = [
  Question(
    id: 'L5Q1',
    text: 'Terjemahkan: \'Senang bertemu denganmu\'.',
    options: ['Mucho gusto', 'Lo siento', 'Hasta luego'],
    correctAnswer: 'Mucho gusto',
  ),
];

// MAP utama untuk memilih set pertanyaan berdasarkan Level
final Map<int, List<Question>> questionsByLevel = {
  1: level1Questions,
  2: level2Questions,
  3: level3Questions,
  4: level4Questions,
  5: level5Questions,
};