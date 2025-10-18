import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { light, dark, system }

final lightColorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
final darkColorScheme =
    ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark);
final ThemeData lightTheme = ThemeData(
  colorScheme: lightColorScheme,
  textTheme: TextThemes.textTheme(lightColorScheme),
  useMaterial3: true,
);

final ThemeData darkTheme = ThemeData(
  colorScheme: darkColorScheme,
  textTheme: TextThemes.textTheme(darkColorScheme),
  useMaterial3: true,
);

class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
        displayLarge: GoogleFonts.poppins(
          color: colorScheme.onSurface,
          fontSize: 32.sp,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.poppins(
          color: colorScheme.onSurface,
          fontSize: 28.sp,
          fontWeight: FontWeight.w600,
        ),
        displaySmall: GoogleFonts.poppins(
          color: colorScheme.onSurface,
          fontSize: 24.sp,
          fontWeight: FontWeight.normal,
        ),
        headlineLarge: GoogleFonts.poppins(
          color: colorScheme.onSurface,
          fontSize: 22.sp,
          fontWeight: FontWeight.normal,
        ),
        headlineMedium: GoogleFonts.poppins(
          color: colorScheme.onSurface,
          fontSize: 20.sp,
          fontWeight: FontWeight.normal,
        ),
        headlineSmall: GoogleFonts.poppins(
          color: colorScheme.onSurface,
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
        titleLarge: GoogleFonts.poppins(
          color: colorScheme.onSurface,
          fontSize: 20.sp,
          fontWeight: FontWeight.w400,
        ),
        titleMedium: GoogleFonts.poppins(
          color: colorScheme.onSurface,
          fontSize: 18.sp,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: GoogleFonts.poppins(
          color: colorScheme.onSurface,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: GoogleFonts.poppins(
          color: colorScheme.onSurface,
          fontSize: 16.sp,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: GoogleFonts.poppins(
          color: colorScheme.onSurface,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: GoogleFonts.poppins(
          color: colorScheme.onSurface,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: GoogleFonts.poppins(
          color: colorScheme.onSurface,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: GoogleFonts.poppins(
          color: colorScheme.onSurface,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: GoogleFonts.poppins(
          color: colorScheme.onSurface,
          fontSize: 10.sp,
          fontWeight: FontWeight.w400,
        ),
      );
}

class LightCodeColors {
  Color get black900 => const Color(0XFF000000);

  Color get blueGray100 => const Color(0XFFD9D9D9);

  Color get blueGray10001 => const Color(0XFFD5D5D5);

  Color get blueGray50 => const Color(0XFFECEFF2);

  Color get blueGray90001 => const Color(0XFF292D32);

  Color get gray300 => const Color(0XFFE3E4E8);

  Color get gray50 => const Color(0XFFF8F9F9);

  Color get gray5001 => const Color(0XFFF7F8F8);

  Color get red100 => const Color(0XFFFFC9C9);

  Color get whiteA700 => const Color(0XFFFFFFFF);
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  ThemeProvider() {
    loadThemeMode();
  }

  ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(
          primary: Colors.blue,
          surface: Colors.white,
          onSurface: Colors.black,
          primaryContainer: Colors.blueGrey.shade100,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
          contentTextStyle: TextStyle(color: Colors.black87, fontSize: 14),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        textTheme: TextThemes.textTheme(
          ColorScheme.light(
            primary: Colors.blue,
            surface: Colors.white30,
            onSurface: Colors.black,
          ),
        ),
      );

  ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: Colors.teal,
          surface: Colors.black,
          onSurface: Colors.white,
          primaryContainer: Colors.blueGrey.shade100,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: Colors.black,
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
          contentTextStyle:
              const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        textTheme: TextThemes.textTheme(
          ColorScheme.dark(
            primary: Colors.teal,
            surface: Colors.black,
            onSurface: Colors.white,
          ),
        ),
      );

  void setTheme(AppThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();

    switch (mode) {
      case AppThemeMode.light:
        _themeMode = ThemeMode.light;
        prefs.setString('theme_mode', 'light');
        break;
      case AppThemeMode.dark:
        _themeMode = ThemeMode.dark;
        prefs.setString('theme_mode', 'dark');
        break;
      case AppThemeMode.system:
        _themeMode = ThemeMode.system;
        prefs.setString('theme_mode', 'system');
        break;
    }

    notifyListeners();
  }

  void loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString('theme_mode') ?? 'system';

    if (savedMode == 'light') {
      _themeMode = ThemeMode.light;
    } else if (savedMode == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }

    notifyListeners();
  }
}
