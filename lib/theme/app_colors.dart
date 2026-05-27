import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── PRIMARY ────────────────────────────────
  static const Color primary = Color(0xFF00BFA5);
  static const Color primaryDark = Color(0xFF009688);
  static const Color primaryDarker = Color(0xFF00796B);
  static const Color primaryGlow = Color(0x5900BFA5);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00E676), Color(0xFF00B8D4)],
  );

  // ── ACCENT COLORS ─────────────────────────
  static const Color orange = Color(0xFFFF7A3D);
  static const Color purple = Color(0xFF7C5CFC);
  static const Color yellow = Color(0xFFFFB830);
  static const Color blue = Color(0xFF4B9EFF);
  static const Color red = Color(0xFFFF4757);
  static const Color green2 = Color(0xFF2ECC71);

  // ── ADVENTURE THEME ───────────────────────
  static const Color adventureGold = Color(0xFFFFB830);
  static const Color adventureAmber = Color(0xFFF59E0B);
  static const Color questPurple = Color(0xFF7C5CFC);
  static const Color mysteryIndigo = Color(0xFF4F46E5);

  // ── CREATURE COLORS ───────────────────────
  static const Color creatureForest = Color(0xFF22C55E);
  static const Color creatureOcean = Color(0xFF06B6D4);
  static const Color creatureFlame = Color(0xFFF97316);
  static const Color creatureCrystal = Color(0xFFA855F7);

  // ── CHAPTER STATES ────────────────────────
  static const Color chapterLocked = Color(0xFFCBD5E1);
  static const Color chapterActive = adventureGold;
  static const Color chapterCompleted = primary;

  // ── CREATURE GRADIENTS ────────────────────
  static LinearGradient creatureForestGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
  );
  static LinearGradient creatureOceanGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
  );
  static LinearGradient creatureFlameGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF97316), Color(0xFFEA580C)],
  );
  static LinearGradient creatureCrystalGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFA855F7), Color(0xFF7C3AED)],
  );

  // ── STAT CARD GRADIENTS ───────────────────
  static const LinearGradient statBlue = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00A1FF), Color(0xFF007AFF)],
  );
  static const LinearGradient statGreen = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF34C759), Color(0xFF28A745)],
  );
  static const LinearGradient statPurple = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFAF52DE), Color(0xFFFF2D55)],
  );
  static const LinearGradient statOrange = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF9500), Color(0xFFFFCC00)],
  );

  // ── QUEST HERO GRADIENT ───────────────────
  static const LinearGradient questHeroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00796B), Color(0xFF004D40)],
  );

  // ── RANK BADGE GRADIENTS ──────────────────
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFB830), Color(0xFFFF8F00)],
  );
  static const LinearGradient silverGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFB0BEC5), Color(0xFF78909C)],
  );
  static const LinearGradient bronzeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF7043), Color(0xFFE64A19)],
  );

  // ── ADVENTURE GOLD GRADIENT ───────────────
  static const LinearGradient adventureGoldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFB830), Color(0xFFF59E0B)],
  );
}

// ── LIGHT THEME COLORS ──────────────────────
class LightColors {
  LightColors._();
  static const Color bgApp = Color(0xFFF2FBF9);
  static const Color bgCard = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF0D3B2E);
  static const Color textMid = Color(0xFF4A7C6A);
  static const Color textMuted = Color(0xFF9DBDB3);
  static const Color primaryLight = Color(0xFFE6FAF5);
  static const Color orangeSoft = Color(0xFFFFF1EB);
  static const Color purpleSoft = Color(0xFFF0EBFF);
  static const Color yellowSoft = Color(0xFFFFF8E6);
  static const Color blueSoft = Color(0xFFEBF4FF);
}

// ── DARK THEME COLORS ───────────────────────
class DarkColors {
  DarkColors._();
  static const Color bgApp = Color(0xFF0B1120);
  static const Color bgCard = Color(0xFF151F32);
  static const Color textDark = Color(0xFFF8FAFC);
  static const Color textMid = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF475569);
  static const Color primaryLight = Color(0xFF0D2B24);
  static const Color orangeSoft = Color(0xFF2E1A12);
  static const Color purpleSoft = Color(0xFF221C3B);
  static const Color yellowSoft = Color(0xFF302611);
  static const Color blueSoft = Color(0xFF122138);
  static const Color adventureGold = Color(0xFFFFCA5C);
  static const Color adventureAmber = Color(0xFFFBB83B);
  static const Color questPurple = Color(0xFF9B82FC);
  static const Color mysteryIndigo = Color(0xFF7370E8);
  static const Color creatureForest = Color(0xFF4ADE80);
  static const Color creatureOcean = Color(0xFF22D3EE);
  static const Color creatureFlame = Color(0xFFFB923C);
  static const Color creatureCrystal = Color(0xFFC084FC);
  static const Color chapterLocked = Color(0xFF475569);
  static const Color undiscoveredBg = Color(0xFF0F0F23);
  static const Color questHeroStart = Color(0xFF0D3D35);
  static const Color questHeroEnd = Color(0xFF071F1B);
}

// ── SHADOWS ─────────────────────────────────
class AppShadows {
  AppShadows._();

  static List<BoxShadow> xs = [
    const BoxShadow(color: Color(0x0F000000), blurRadius: 4, offset: Offset(0, 1)),
  ];
  static List<BoxShadow> sm = [
    const BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 2)),
  ];
  static List<BoxShadow> md = [
    const BoxShadow(color: Color(0x1A000000), blurRadius: 20, offset: Offset(0, 4)),
  ];
  static List<BoxShadow> lg = [
    const BoxShadow(color: Color(0x24000000), blurRadius: 32, offset: Offset(0, 8)),
  ];
  static List<BoxShadow> primary = [
    const BoxShadow(color: Color(0x6600BFA5), blurRadius: 24, offset: Offset(0, 8)),
  ];
  static List<BoxShadow> orange = [
    const BoxShadow(color: Color(0x59FF7A3D), blurRadius: 24, offset: Offset(0, 8)),
  ];
  static List<BoxShadow> purple = [
    const BoxShadow(color: Color(0x597C5CFC), blurRadius: 24, offset: Offset(0, 8)),
  ];
  static List<BoxShadow> gold = [
    const BoxShadow(color: Color(0x99FFB830), blurRadius: 16, offset: Offset(0, 6)),
  ];
}
