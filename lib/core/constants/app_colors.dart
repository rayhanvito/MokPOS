import 'package:flutter/material.dart';

/// App color palette extracted from Figma design
/// Source: MokPOS Figma design system
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF1A72DD);
  static const Color secondary = Color(0xFFF8CF33);

  // Background Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF5F7FA);

  // Text Colors
  static const Color textPrimary = Color(0xFF2A3256);
  static const Color textSecondary = Color(0xFF545454);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF27AE60);
  static const Color error = Color(0xFFE74C3C);
  static const Color warning = Color(0xFFF39C12);
  static const Color info = Color(0xFF3498DB);

  // Neutral Colors
  static const Color border = Color(0xFFC4C4C4);
  static const Color disabled = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);

  // Shadow Colors
  static const Color shadowPrimary = Color(0x261A72DD); // rgba(26, 114, 221, 0.15)
  static const Color shadowDark = Color(0x0F000000); // rgba(0, 0, 0, 0.06)

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1A72DD), Color(0xFF1557B0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Overlay Colors
  static const Color overlay = Color(0x80000000); // rgba(0, 0, 0, 0.5)
  static const Color overlayLight = Color(0x1A000000); // rgba(0, 0, 0, 0.1)
}
