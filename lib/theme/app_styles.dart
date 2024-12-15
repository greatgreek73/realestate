import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppStyles {
  static final borderRadiusLg = BorderRadius.circular(24);
  static final borderRadiusMd = BorderRadius.circular(12);
  static final borderRadiusSm = BorderRadius.circular(8);

  static final cardShadow = BoxShadow(
    color: Colors.black.withOpacity(0.2),
    blurRadius: 10,
    offset: const Offset(0, 4),
  );

  static final cardBorder = Border.all(
    color: Colors.white.withOpacity(0.1),
  );

  static const titleLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const titleMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const labelLarge = TextStyle(
    fontSize: 16,
    color: AppColors.textSecondary,
  );

  static const labelMedium = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static final investmentBlockDecoration = BoxDecoration(
    gradient: AppColors.investmentBlockGradient,
    borderRadius: borderRadiusMd,
    border: cardBorder,
  );
}
