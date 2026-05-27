import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  // ── BORDER RADIUS ─────────────────────────
  static const double rSm = 8;
  static const double rMd = 14;
  static const double rLg = 20;
  static const double rXl = 28;
  static const double rXxl = 36;
  static const double rFull = 999;

  // ── SPACING ───────────────────────────────
  static const double sp1 = 4;
  static const double sp2 = 8;
  static const double sp3 = 12;
  static const double sp4 = 16;
  static const double sp5 = 20;
  static const double sp6 = 24;
  static const double sp8 = 32;
  static const double sp10 = 40;
  static const double sp12 = 48;

  // ── NAV HEIGHT ────────────────────────────
  static const double navH = 74;

  // ── TIMING ────────────────────────────────
  static const Duration durFast = Duration(milliseconds: 150);
  static const Duration durNorm = Duration(milliseconds: 280);
  static const Duration durSlow = Duration(milliseconds: 500);

  static const Curve ease = Curves.easeInOut;
  static const Curve easeBounce = Curves.elasticOut;

  // ── TEXT STYLES ────────────────────────────
  static TextStyle _base(double size, FontWeight weight, Color color) {
    return GoogleFonts.nunito(
      fontSize: size,
      fontWeight: weight,
      color: color,
    );
  }

  static TextStyle tXs(Color color, [FontWeight weight = FontWeight.w600]) =>
      _base(11, weight, color);
  static TextStyle tSm(Color color, [FontWeight weight = FontWeight.w600]) =>
      _base(13, weight, color);
  static TextStyle tBase(Color color, [FontWeight weight = FontWeight.w600]) =>
      _base(15, weight, color);
  static TextStyle tMd(Color color, [FontWeight weight = FontWeight.w700]) =>
      _base(17, weight, color);
  static TextStyle tLg(Color color, [FontWeight weight = FontWeight.w800]) =>
      _base(20, weight, color);
  static TextStyle tXl(Color color, [FontWeight weight = FontWeight.w900]) =>
      _base(24, weight, color);
  static TextStyle tXxl(Color color, [FontWeight weight = FontWeight.w900]) =>
      _base(28, weight, color);
  static TextStyle tXxxl(Color color, [FontWeight weight = FontWeight.w900]) =>
      _base(36, weight, color);

  // ── LIGHT THEME ───────────────────────────
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: LightColors.bgApp,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      surface: LightColors.bgCard,
      onSurface: LightColors.textDark,
    ),
    textTheme: GoogleFonts.nunitoTextTheme().apply(
      bodyColor: LightColors.textDark,
      displayColor: LightColors.textDark,
    ),
    cardTheme: CardThemeData(
      color: LightColors.bgCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(rXl),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: LightColors.bgApp,
      foregroundColor: LightColors.textDark,
      elevation: 0,
      titleTextStyle: GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: LightColors.textDark,
      ),
    ),
  );

  // ── DARK THEME ────────────────────────────
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: DarkColors.bgApp,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      surface: DarkColors.bgCard,
      onSurface: DarkColors.textDark,
    ),
    textTheme: GoogleFonts.nunitoTextTheme(
      ThemeData.dark().textTheme,
    ).apply(
      bodyColor: DarkColors.textDark,
      displayColor: DarkColors.textDark,
    ),
    cardTheme: CardThemeData(
      color: DarkColors.bgCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(rXl),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: DarkColors.bgApp,
      foregroundColor: DarkColors.textDark,
      elevation: 0,
      titleTextStyle: GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: DarkColors.textDark,
      ),
    ),
  );
}

// ── THEME EXTENSION HELPERS ─────────────────
extension ThemeHelpers on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Color get bgApp => isDark ? DarkColors.bgApp : LightColors.bgApp;
  Color get bgCard => isDark ? DarkColors.bgCard : LightColors.bgCard;
  Color get textDark => isDark ? DarkColors.textDark : LightColors.textDark;
  Color get textMid => isDark ? DarkColors.textMid : LightColors.textMid;
  Color get textMuted => isDark ? DarkColors.textMuted : LightColors.textMuted;
  Color get primaryLight =>
      isDark ? DarkColors.primaryLight : LightColors.primaryLight;
  Color get orangeSoft =>
      isDark ? DarkColors.orangeSoft : LightColors.orangeSoft;
  Color get purpleSoft =>
      isDark ? DarkColors.purpleSoft : LightColors.purpleSoft;
  Color get yellowSoft =>
      isDark ? DarkColors.yellowSoft : LightColors.yellowSoft;
  Color get blueSoft => isDark ? DarkColors.blueSoft : LightColors.blueSoft;
  Color get adventureGold =>
      isDark ? DarkColors.adventureGold : AppColors.adventureGold;
  Color get creatureForestC =>
      isDark ? DarkColors.creatureForest : AppColors.creatureForest;
  Color get creatureOceanC =>
      isDark ? DarkColors.creatureOcean : AppColors.creatureOcean;
  Color get creatureFlameC =>
      isDark ? DarkColors.creatureFlame : AppColors.creatureFlame;
  Color get creatureCrystalC =>
      isDark ? DarkColors.creatureCrystal : AppColors.creatureCrystal;
  Color get chapterLockedC =>
      isDark ? DarkColors.chapterLocked : AppColors.chapterLocked;
}
