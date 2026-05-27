import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../models/adventure.dart';
import '../providers/eco_state.dart';

class QuestCard extends StatelessWidget {
  final VoidCallback? onActionPressed;

  const QuestCard({
    super.key,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<EcoState>(context);
    final isDark = context.isDark;

    final activeAdventure = state.getActiveAdventure();
    final currentChapter = state.getCurrentChapter(activeAdventure.id);

    final cardBg = isDark ? DarkColors.bgCard : LightColors.bgCard;
    final textC = isDark ? DarkColors.textDark : LightColors.textDark;
    final textM = isDark ? DarkColors.textMid : LightColors.textMid;

    if (currentChapter == null) {
      // Quest is completely finished
      return Container(
        padding: const EdgeInsets.all(AppTheme.sp5),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(AppTheme.rXl),
          boxShadow: AppShadows.sm,
          border: Border.all(
            color: AppColors.primary.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            const Text(
              '🎉',
              style: TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 12),
            Text(
              '¡Aventura Completada!',
              style: AppTheme.tLg(textC, FontWeight.w900),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Has completado todos los capítulos de "${activeAdventure.title}". ¡Eres un verdadero defensor del medio ambiente!',
              style: AppTheme.tBase(textM, FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Set icon based on chapter type
    IconData typeIcon = Icons.qr_code_scanner_rounded;
    String typeLabel = 'ESCANEAR';
    Color typeColor = AppColors.primary;

    switch (currentChapter.type) {
      case ChapterType.scan:
        typeIcon = Icons.qr_code_scanner_rounded;
        typeLabel = 'ESCANEAR';
        typeColor = AppColors.primary;
        break;
      case ChapterType.trivia:
        typeIcon = Icons.psychology_rounded;
        typeLabel = 'TRIVIA';
        typeColor = AppColors.adventureGold;
        break;
      case ChapterType.explore:
        typeIcon = Icons.explore_rounded;
        typeLabel = 'EXPLORAR';
        typeColor = AppColors.blue;
        break;
      case ChapterType.group:
        typeIcon = Icons.group_rounded;
        typeLabel = 'GRUPAL';
        typeColor = AppColors.purple;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppTheme.rXl),
        boxShadow: AppShadows.sm,
        border: Border(
          left: BorderSide(
            color: AppColors.adventureGold,
            width: 6,
          ),
        ),
      ),
      padding: const EdgeInsets.all(AppTheme.sp5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row with level & badge tag
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    activeAdventure.icon,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    activeAdventure.title.toUpperCase(),
                    style: AppTheme.tXs(textM, FontWeight.w800),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.sp2, vertical: AppTheme.sp1 / 2),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppTheme.rSm),
                ),
                child: Row(
                  children: [
                    Icon(typeIcon, color: typeColor, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      typeLabel,
                      style: AppTheme.tXs(typeColor, FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Chapter Header
          Text(
            currentChapter.title,
            style: AppTheme.tLg(textC, FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            currentChapter.description,
            style: AppTheme.tBase(textM, FontWeight.w600),
          ),
          const SizedBox(height: 12),

          // Clue Box
          Container(
            padding: const EdgeInsets.all(AppTheme.sp3),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : LightColors.bgApp,
              borderRadius: BorderRadius.circular(AppTheme.rMd),
              border: Border.all(
                color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline_rounded,
                  color: AppColors.adventureGold,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PISTA DEL CAPÍTULO',
                        style: AppTheme.tXs(AppColors.adventureGold, FontWeight.w800),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        currentChapter.hint,
                        style: AppTheme.tSm(textC, FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Reward and Action Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RECOMPENSA',
                    style: AppTheme.tXs(textM, FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Text(
                        '🪙',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '+${currentChapter.reward.points} PTS',
                        style: AppTheme.tMd(AppColors.primary, FontWeight.w800),
                      ),
                      if (currentChapter.reward.creature != null) ...[
                        const SizedBox(width: 8),
                        const Text(
                          '👾',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Mascota',
                          style: AppTheme.tSm(AppColors.purple, FontWeight.w700),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: onActionPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shadowColor: AppColors.primaryGlow,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.rMd),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.sp4, vertical: AppTheme.sp3),
                ),
                child: Row(
                  children: [
                    Text(
                      currentChapter.type == ChapterType.trivia ? 'Jugar Trivia' : 'Ver Objetivo',
                      style: AppTheme.tSm(Colors.white, FontWeight.w800),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward_rounded, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
