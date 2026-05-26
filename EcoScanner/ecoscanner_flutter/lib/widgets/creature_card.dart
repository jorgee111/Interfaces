import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_animations.dart';
import '../models/creature.dart';

class CreatureCard extends StatelessWidget {
  final Creature creature;
  final bool isDiscovered;
  final int feedCount;
  final VoidCallback onTap;

  const CreatureCard({
    super.key,
    required this.creature,
    required this.isDiscovered,
    required this.feedCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final cardBg = isDark ? DarkColors.bgCard : LightColors.bgCard;
    final textC = isDark ? DarkColors.textDark : LightColors.textDark;
    final textM = isDark ? DarkColors.textMid : LightColors.textMid;

    if (!isDiscovered) {
      // Locked Creature State
      return ShimmerWidget(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.rLg),
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : Colors.black.withOpacity(0.04),
              borderRadius: BorderRadius.circular(AppTheme.rLg),
              border: Border.all(
                color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.04),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.sp3),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black26 : Colors.white60,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_rounded,
                    color: Colors.grey,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 60,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : Colors.black12,
                    borderRadius: BorderRadius.circular(AppTheme.rSm),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 80,
                  height: 16,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : Colors.black12,
                    borderRadius: BorderRadius.circular(AppTheme.rSm),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Discovered Creature
    LinearGradient elementGradient = AppColors.creatureForestGradient;
    String elementText = '🌲 Bosque';

    if (creature.element == 'earth') {
      elementGradient = const LinearGradient(colors: [Color(0xFF8B5A2B), Color(0xFF5C3A21)]);
      elementText = '⛰️ Tierra';
    } else if (creature.element == 'ocean') {
      elementGradient = AppColors.creatureOceanGradient;
      elementText = '🌊 Océano';
    } else if (creature.element == 'air') {
      elementGradient = AppColors.creatureCrystalGradient;
      elementText = '🌀 Viento';
    } else if (creature.element == 'crystal') {
      elementGradient = AppColors.creatureCrystalGradient;
      elementText = '💎 Cristal';
    } else if (creature.element == 'light') {
      elementGradient = AppColors.creatureFlameGradient;
      elementText = '✨ Estelar';
    }

    // Determine stage index
    int stageIndex = 0;
    if (feedCount >= 15) {
      stageIndex = 2;
    } else if (feedCount >= 5) {
      stageIndex = 1;
    }

    final currentStage = creature.stages[stageIndex];

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.rLg),
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(AppTheme.rLg),
          boxShadow: AppShadows.sm,
          border: Border.all(
            color: creature.color.withOpacity(0.15),
            width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.rLg),
          child: Stack(
            children: [
              // Dynamic Colorful Element Background Top Half
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 90,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: elementGradient,
                  ),
                ),
              ),

              // Card content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(height: 16),
                    // Emoji avatar
                    FloatingCreature(
                      duration: Duration(seconds: 2 + creature.name.length % 3),
                      child: Container(
                        padding: const EdgeInsets.all(AppTheme.sp2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 8),
                          ],
                        ),
                        child: Text(
                          currentStage.emoji,
                          style: const TextStyle(fontSize: 34),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Element badge tag
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: creature.color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(AppTheme.rFull),
                      ),
                      child: Text(
                        elementText,
                        style: AppTheme.tXs(creature.color, FontWeight.w800),
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Name
                    Text(
                      creature.name,
                      style: AppTheme.tMd(textC, FontWeight.w900),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),

                    // Stage
                    Text(
                      currentStage.name,
                      style: AppTheme.tXs(textM, FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
