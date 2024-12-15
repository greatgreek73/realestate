import 'package:flutter/material.dart';

class AppColors {
  // Base colors
  static const background = Color(0xFF0A0A0A);
  static const surface = Color(0xFF121212);
  static const surfaceLight = Color(0xFF1A1A1A);
  static const accent = Color(0xFFD4AF37);  // Новый золотой цвет
  
  // Text colors
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xFF9CA3AF);
  static const textTertiary = Color(0xFF6B7280);
  
  // Additional colors
  static const divider = Color(0xFF1F2937);
  static final overlay = Colors.black.withOpacity(0.2);
  
  // Gradients
  static final cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      surface,
      Color(0xFF1A1A1A),
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
}