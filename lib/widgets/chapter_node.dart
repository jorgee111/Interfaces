import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_animations.dart';

enum ChapterNodeStatus {
  completed,
  active,
  locked,
}

class ChapterNode extends StatelessWidget {
  final int chapterNumber;
  final String title;
  final String description;
  final ChapterNodeStatus status;
  final bool isLast;

  const ChapterNode({
    super.key,
    required this.chapterNumber,
    required this.title,
    required this.description,
    required this.status,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textC = isDark ? DarkColors.textDark : LightColors.textDark;
    final textM = isDark ? DarkColors.textMid : LightColors.textMid;

    Color nodeColor = AppColors.chapterLocked;
    Widget markerWidget = const Icon(Icons.lock_rounded, color: Colors.white, size: 14);

    if (status == ChapterNodeStatus.completed) {
      nodeColor = AppColors.chapterCompleted;
      markerWidget = const Icon(Icons.check_rounded, color: Colors.white, size: 16);
    } else if (status == ChapterNodeStatus.active) {
      nodeColor = AppColors.chapterActive;
      markerWidget = PulseWidget(
        child: Container(
          width: 14,
          height: 14,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Indicator
          Column(
            children: [
              // Circle Node
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: nodeColor,
                  shape: BoxShape.circle,
                  boxShadow: status == ChapterNodeStatus.active
                      ? AppShadows.gold
                      : (status == ChapterNodeStatus.completed ? AppShadows.xs : null),
                ),
                alignment: Alignment.center,
                child: markerWidget,
              ),

              // Vertical Line connector
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 3,
                    color: status == ChapterNodeStatus.completed
                        ? AppColors.primary
                        : AppColors.chapterLocked.withOpacity(0.4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),

          // Chapter content text details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'CAPÍTULO $chapterNumber',
                      style: AppTheme.tXs(
                        status == ChapterNodeStatus.active
                            ? AppColors.adventureGold
                            : (status == ChapterNodeStatus.completed ? AppColors.primary : textM),
                        FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (status == ChapterNodeStatus.active)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: AppColors.adventureGold.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'ACTIVO',
                          style: AppTheme.tXs(AppColors.adventureGold, FontWeight.w900),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: AppTheme.tBase(
                    textC,
                    status == ChapterNodeStatus.locked ? FontWeight.w600 : FontWeight.w800,
                  ),
                ),
                Text(
                  description,
                  style: AppTheme.tSm(textM, FontWeight.w500),
                ),
                const SizedBox(height: 24), // Margin before next node
              ],
            ),
          ),
        ],
      ),
    );
  }
}
