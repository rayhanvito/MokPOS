import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// App typography system using Rubik font family
/// Extracted from Figma design system
class AppTypography {
  AppTypography._();

  // Base font family
  static String get fontFamily => GoogleFonts.rubik().fontFamily!;

  // Display Styles
  static TextStyle displayLarge = GoogleFonts.rubik(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  // Heading Styles
  static TextStyle headingLarge = GoogleFonts.rubik(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static TextStyle headingMedium = GoogleFonts.rubik(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle headingSmall = GoogleFonts.rubik(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // Body Styles
  static TextStyle bodyLarge = GoogleFonts.rubik(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodyRegular = GoogleFonts.rubik(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodySmall = GoogleFonts.rubik(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // Label Styles
  static TextStyle label = GoogleFonts.rubik(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static TextStyle labelSmall = GoogleFonts.rubik(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.3,
  );

  // Caption Style
  static TextStyle caption = GoogleFonts.rubik(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.3,
  );

  // Button Styles
  static TextStyle button = GoogleFonts.rubik(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textWhite,
    height: 1.2,
  );

  static TextStyle buttonSmall = GoogleFonts.rubik(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textWhite,
    height: 1.2,
  );

  // Logo Style
  static TextStyle logo = GoogleFonts.rubik(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    height: 1.2,
  );
}
