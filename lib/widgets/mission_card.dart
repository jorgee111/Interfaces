import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../models/mission.dart';

class MissionCard extends StatelessWidget {
  final Mission mission;
  final VoidCallback onCompletePressed;

  const MissionCard({
    super.key,
    required this.mission,
    required this.onCompletePressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final cardBg = isDark ? DarkColors.bgCard : LightColors.bgCard;
    final textC = isDark ? DarkColors.textDark : LightColors.textDark;
    final textM = isDark ? DarkColors.textMid : LightColors.textMid;

    final double percent = mission.total > 0 ? (mission.progress / mission.total) : 0.0;

    return Container(
      padding: const EdgeInsets.all(AppTheme.sp4),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppTheme.rLg),
        boxShadow: AppShadows.xs,
        border: Border.all(
          color: mission.done
              ? AppColors.primary.withOpacity(0.2)
              : (isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.04)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mission Icon Circle
          Container(
            padding: const EdgeInsets.all(AppTheme.sp3),
            decoration: BoxDecoration(
              color: mission.done
                  ? AppColors.primary.withOpacity(0.12)
                  : (isDark ? const Color(0xFF1E293B) : LightColors.primaryLight),
              shape: BoxShape.circle,
            ),
            child: Text(
              mission.icon,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(width: 14),

          // Main information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        mission.title,
                        style: AppTheme.tBase(
                          textC,
                          mission.done ? FontWeight.w600 : FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+${mission.pts} PTS',
                      style: AppTheme.tSm(AppColors.primary, FontWeight.w800),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  mission.desc,
                  style: AppTheme.tXs(textM, FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Progress Bar or Expiry Text
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppTheme.rFull),
                        child: Container(
                          height: 6,
                          color: isDark ? const Color(0xFF334155) : Colors.black.withOpacity(0.06),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: percent,
                            child: Container(
                              color: mission.done ? AppColors.primary : AppColors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${mission.progress}/${mission.total}',
                      style: AppTheme.tXs(
                        mission.done ? AppColors.primary : textM,
                        FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Action Checklist buttons
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (mission.done)
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                )
              else
                IconButton(
                  onPressed: onCompletePressed,
                  icon: const Icon(
                    Icons.add_circle_outline_rounded,
                    color: AppColors.primary,
                    size: 26,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              const SizedBox(height: 4),
              Text(
                'Exp: ${mission.expires}',
                style: AppTheme.tXs(textM.withOpacity(0.7), FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
