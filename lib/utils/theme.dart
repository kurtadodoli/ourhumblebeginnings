import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Vintage Café Color Palette inspired by warm, cozy atmosphere
  static const Color primaryColor = Color(0xFF8B4513);    // Rich coffee brown
  static const Color accentColor = Color(0xFFCD853F);     // Warm sandy brown
  static const Color backgroundColor = Color(0xFFFFFDF5); // Warm cream white
  static const Color surfaceColor = Color(0xFFFFFFFF);    // Pure white
  static const Color textPrimary = Color(0xFF3C2A1E);     // Deep coffee brown
  static const Color textSecondary = Color(0xFF8B7355);   // Muted brown
  static const Color dividerColor = Color(0xFFE8DCC6);    // Warm light beige
  static const Color shadowColor = Color(0x1A8B4513);     // Coffee shadow
  
  // Vintage accent colors
  static const Color vintageOrange = Color(0xFFD2691E);   // Burnt orange
  static const Color vintageBeige = Color(0xFFF5F5DC);    // Vintage beige
  static const Color creamWhite = Color(0xFFFAF0E6);      // Linen white
  
  // Success, Warning, Error Colors (vintage toned)
  static const Color successGreen = Color(0xFF6B8E23);    // Olive green
  static const Color warningOrange = Color(0xFFD2691E);   // Vintage orange
  static const Color errorRed = Color(0xFFB85450);        // Vintage red
  static const Color infoBlue = Color(0xFF4682B4);

  // Modern Minimalist Typography Configuration
  static TextTheme get _modernTextTheme {
    // Inter - Modern, clean, and highly legible font for body text
    final baseFont = GoogleFonts.inter();
    
    // Poppins - Modern, rounded font for headings and display text
    final headingFont = GoogleFonts.poppins();
    
    return TextTheme(
      // Display styles - for large text, hero sections
      displayLarge: headingFont.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w300,
        color: textPrimary,
        letterSpacing: -1.0,
        height: 1.2,
      ),
      displayMedium: headingFont.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: -0.5,
        height: 1.3,
      ),
      displaySmall: headingFont.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: -0.25,
        height: 1.3,
      ),
      
      // Headline styles - for page titles, section headers
      headlineLarge: headingFont.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: -0.5,
        height: 1.3,
      ),
      headlineMedium: headingFont.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: -0.25,
        height: 1.4,
      ),
      headlineSmall: headingFont.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.4,
      ),
      
      // Title styles - for card headers, dialog titles
      titleLarge: baseFont.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.4,
      ),
      titleMedium: baseFont.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.1,
        height: 1.5,
      ),
      titleSmall: baseFont.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.1,
        height: 1.5,
      ),
      
      // Body styles - for main content, descriptions
      bodyLarge: baseFont.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: 0.1,
        height: 1.6,
      ),
      bodyMedium: baseFont.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        letterSpacing: 0.15,
        height: 1.5,
      ),
      bodySmall: baseFont.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        letterSpacing: 0.2,
        height: 1.4,
      ),
      
      // Label styles - for buttons, form labels
      labelLarge: baseFont.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.3,
        height: 1.4,
      ),
      labelMedium: baseFont.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.4,
        height: 1.3,
      ),
      labelSmall: baseFont.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: textSecondary,
        letterSpacing: 0.5,
        height: 1.3,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: accentColor,
        surface: surfaceColor,
        error: errorRed,
      ),
      
      // Modern Typography
      textTheme: _modernTextTheme,
      
      // App Bar Theme - Vintage café style with modern typography
      appBarTheme: AppBarTheme(
        backgroundColor: creamWhite,
        foregroundColor: textPrimary,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      
      // Card Theme - Vintage style with warm tones
      cardTheme: CardTheme(
        elevation: 2,
        shadowColor: shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: dividerColor, width: 1),
        ),
        color: surfaceColor,
        margin: const EdgeInsets.symmetric(vertical: 6),
      ),
      
      // Elevated Button Theme - Modern minimalist style
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: creamWhite,
          elevation: 2,
          shadowColor: shadowColor,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
      
      // Text Button Theme - Modern style
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: textSecondary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
      ),
      
      // Input Decoration Theme - Modern minimalist style
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: dividerColor),
        ),
        filled: true,
        fillColor: backgroundColor,
        labelStyle: GoogleFonts.inter(
          color: textSecondary,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: GoogleFonts.inter(
          color: accentColor,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      
      // Chip Theme - Modern minimalist style
      chipTheme: ChipThemeData(
        backgroundColor: backgroundColor,
        selectedColor: accentColor.withValues(alpha: 0.1),
        labelStyle: GoogleFonts.inter(
          color: textPrimary,
          fontWeight: FontWeight.w500,
          fontSize: 12,
          letterSpacing: 0.3,
        ),
        secondarySelectedColor: accentColor,
        checkmarkColor: accentColor,
        side: const BorderSide(color: dividerColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: accentColor,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      
      // FAB Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: surfaceColor,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 24,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        primary: accentColor,
        secondary: primaryColor,
        surface: const Color(0xFF1E1E1E),
        error: errorRed,
      ),
      
      // Modern Typography for dark theme
      textTheme: _modernTextTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      
      // App Bar Theme - Modern dark style
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: -0.5,
        ),
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF333333), width: 1),
        ),
        color: const Color(0xFF1E1E1E),
      ),
      
      // Elevated Button Theme - Modern dark style
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
