import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TahfeezColors {
  static const Color primary = Color(0xFF1B5E60);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF004D40);
  static const Color onPrimaryContainer = Color(0xFF00332D);
  static const Color primaryFixed = Color(0xFF00695C);
  static const Color primaryFixedDim = Color(0xFF80CBC4);
  static const Color onPrimaryFixed = Color(0xFFFFFFFF);
  static const Color onPrimaryFixedVariant = Color(0xFF00251A);

  static const Color secondary = Color(0xFF6D4C41);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFD7CCC8);
  static const Color onSecondaryContainer = Color(0xFF3E2723);

  static const Color tertiary = Color(0xFF5D4037);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFBCAAA4);
  static const Color onTertiaryContainer = Color(0xFF3E2723);
  static const Color tertiaryFixedDim = Color(0xFF8D6E63);
  static const Color onTertiaryFixed = Color(0xFFFFFFFF);

  static const Color surface = Color(0xFFFAFAFA);
  static const Color surfaceContainer = Color(0xFFF5F5F5);
  static const Color surfaceContainerLow = Color(0xFFEEEEEE);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFE0E0E0);
  static const Color onSurface = Color(0xFF212121);
  static const Color onSurfaceVariant = Color(0xFF757575);

  static const Color outline = Color(0xFFBDBDBD);
  static const Color outlineVariant = Color(0xFFE0E0E0);

  static const Color error = Color(0xFFD32F2F);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFCDD2);
  static const Color onErrorContainer = Color(0xFFB71C1C);

  static const Color background = Color(0xFFF5F5F5);
}

class TahfeezTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: TahfeezColors.primary,
        primary: TahfeezColors.primary,
        onPrimary: TahfeezColors.onPrimary,
        secondary: TahfeezColors.secondary,
        onSecondary: TahfeezColors.onSecondary,
        tertiary: TahfeezColors.tertiary,
        surface: TahfeezColors.surface,
        onSurface: TahfeezColors.onSurface,
        error: TahfeezColors.error,
      ),
      scaffoldBackgroundColor: TahfeezColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: TahfeezColors.surfaceContainerLowest,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: TahfeezColors.primary),
        titleTextStyle: GoogleFonts.lexend(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: TahfeezColors.onSurface,
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.lexend(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: TahfeezColors.onSurface,
        ),
        headlineMedium: GoogleFonts.lexend(
          fontSize: 28,
          fontWeight: FontWeight.w500,
          color: TahfeezColors.onSurface,
        ),
        titleLarge: GoogleFonts.lexend(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: TahfeezColors.onSurface,
        ),
        labelLarge: GoogleFonts.lexend(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: TahfeezColors.onSurface,
        ),
        labelMedium: GoogleFonts.lexend(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: TahfeezColors.onSurface,
        ),
        bodyLarge: GoogleFonts.lexend(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: TahfeezColors.onSurface,
        ),
        bodyMedium: GoogleFonts.lexend(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: TahfeezColors.onSurface,
        ),
      ),
    );
  }
}

class TahfeezTextStyles {
  static TextStyle get headlineLg => GoogleFonts.lexend(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: TahfeezColors.onSurface,
  );

  static TextStyle get headlineMd => GoogleFonts.lexend(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    color: TahfeezColors.onSurface,
  );

  static TextStyle get titleLg => GoogleFonts.lexend(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: TahfeezColors.onSurface,
  );

  static TextStyle get labelLg => GoogleFonts.lexend(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: TahfeezColors.onSurface,
  );

  static TextStyle get labelMd => GoogleFonts.lexend(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: TahfeezColors.onSurface,
  );

  static TextStyle get bodyLg => GoogleFonts.lexend(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: TahfeezColors.onSurface,
  );

  static TextStyle get bodyMd => GoogleFonts.lexend(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: TahfeezColors.onSurface,
  );
}
