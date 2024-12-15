import 'package:flutter/material.dart';

class AppColors {
  // Основные цвета
  static const background = Color(0xFF111827); // gray-900
  static const surface = Color(0xFF1F2937);    // gray-800
  static const primary = Color(0xFF60A5FA);    // blue-400
  static const secondary = Color(0xFF34D399);  // green-400
  
  // Текстовые цвета
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xFF9CA3AF); // gray-400
  static const textTertiary = Color(0xFFD1D5DB); // gray-300

  // Градиенты
  static const cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF111827), // gray-900
      Color(0xFF1F2937), // gray-800
      Color(0xFF1E3A8A), // blue-900
    ],
  );

  static final investmentBlockGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.black.withOpacity(0.4),
      Colors.black.withOpacity(0.2),
    ],
  );

  static final dividerGradient = LinearGradient(
    colors: [
      Color(0xFF1E3A8A).withOpacity(0.2), // blue-900 20%
      Colors.white.withOpacity(0.2),
      Color(0xFF1E3A8A).withOpacity(0.2), // blue-900 20%
    ],
  );
}