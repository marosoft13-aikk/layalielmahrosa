import 'package:flutter/material.dart';

class AppTheme {
  // =========================
  // Main Colors
  // =========================

  static const Color primaryBrown = Color(0xFF5C3D2E);
  static const Color goldAccent = Color(0xFFC8A96E);
  static const Color lightCream = Color(0xFFF5F0E8);
  static const Color darkBrown = Color(0xFF3A2318);

  static const Color greenAccent = Color(0xFF4CAF50);
  static const Color redAccent = Color(0xFFE53935);

  static const Color bgColor = Color(0xFFFAF7F2);
  static const Color cardBg = Color(0xFFFFFFFF);

  static const Color textDark = Color(0xFF2C1810);
  static const Color textGray = Color(0xFF8D7B6E);
  static const Color dividerColor = Color(0xFFE8DDD0);

  // =========================
  // Additional Colors
  // Used by main_tab.dart
  // =========================

  static const Color midnightBlue = Color(0xFF191970);
  static const Color deepNavy = Color(0xFF0B1F3A);
  static const Color royalIndigo = Color(0xFF4B0082);

  static const Color deepGold = Color(0xFFB8860B);
  static const Color starGold = Color(0xFFFFD700);

  static const Color emerald = Color(0xFF2E8B57);
  static const Color emeraldDeep = Color(0xFF145A32);

  static const Color ruby = Color(0xFFE0115F);
  static const Color rubyDeep = Color(0xFF8B0000);

  static const Color sapphire = Color(0xFF0F52BA);
  static const Color sapphireDeep = Color(0xFF082567);

  static const Color amethyst = Color(0xFF9966CC);
  static const Color amethystDeep = Color(0xFF5B2C6F);

  static const Color copper = Color(0xFFB87333);
  static const Color copperDeep = Color(0xFF7B3F00);

  // =========================
  // Light Theme
  // =========================

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBrown,
          primary: primaryBrown,
          secondary: goldAccent,
          surface: bgColor,
          background: bgColor,
        ),

        fontFamily: 'Cairo',

        scaffoldBackgroundColor: bgColor,

        // =========================
        // App Bar
        // =========================

        appBarTheme: const AppBarTheme(
          backgroundColor: primaryBrown,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        // =========================
        // Cards
        // =========================

        cardTheme: CardThemeData(
          color: cardBg,
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        // =========================
        // Buttons
        // =========================

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBrown,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 14,
            ),
            textStyle: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // =========================
        // Bottom Navigation
        // =========================

        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: primaryBrown,
          unselectedItemColor: textGray,
          type: BottomNavigationBarType.fixed,
          elevation: 12,
          selectedLabelStyle: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 10,
          ),
        ),

        // =========================
        // Text Theme
        // =========================

        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Cairo',
            color: textDark,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: TextStyle(
            fontFamily: 'Cairo',
            color: textDark,
            fontWeight: FontWeight.bold,
          ),
          displaySmall: TextStyle(
            fontFamily: 'Cairo',
            color: textDark,
            fontWeight: FontWeight.bold,
          ),
          headlineLarge: TextStyle(
            fontFamily: 'Cairo',
            color: textDark,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'Cairo',
            color: textDark,
            fontWeight: FontWeight.bold,
          ),
          headlineSmall: TextStyle(
            fontFamily: 'Cairo',
            color: textDark,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Cairo',
            color: textDark,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: TextStyle(
            fontFamily: 'Cairo',
            color: textDark,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Cairo',
            color: textDark,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Cairo',
            color: textDark,
          ),
        ),

        // =========================
        // Input Fields
        // =========================

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: dividerColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: dividerColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: primaryBrown,
              width: 2,
            ),
          ),
          hintStyle: const TextStyle(
            fontFamily: 'Cairo',
            color: textGray,
          ),
          prefixIconColor: textGray,
        ),

        // =========================
        // Chips
        // =========================

        chipTheme: ChipThemeData(
          backgroundColor: lightCream,
          selectedColor: primaryBrown,
          labelStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
}
