import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class RankItem extends StatelessWidget {
  final int rank;
  final String name;
  final int points;
  final String avatar;
  final bool isUser;
  final String badge;

  const RankItem({
    super.key,
    required this.rank,
    required this.name,
    required this.points,
    required this.avatar,
    required this.isUser,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final cardBg = isDark ? DarkColors.bgCard : LightColors.bgCard;
    final textC = isDark ? DarkColors.textDark : LightColors.textDark;
    final textM = isDark ? DarkColors.textMid : LightColors.textMid;

    // Leaderboard Trophy / Badge Icons
    Widget rankIcon = Text(
      '$rank',
      style: AppTheme.tBase(textM, FontWeight.w800),
    );

    if (badge == 'gold' || rank == 1) {
      rankIcon = const Text('🥇', style: TextStyle(fontSize: 22));
    } else if (badge == 'silver' || rank == 2) {
      rankIcon = const Text('🥈', style: TextStyle(fontSize: 22));
    } else if (badge == 'bronze' || rank == 3) {
      rankIcon = const Text('🥉', style: TextStyle(fontSize: 22));
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.sp2),
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.sp4, vertical: AppTheme.sp3),
      decoration: BoxDecoration(
        color: isUser
            ? (isDark ? const Color(0xFF0F2D27) : AppColors.primary.withOpacity(0.08))
            : cardBg,
        borderRadius: BorderRadius.circular(AppTheme.rMd),
        border: Border.all(
          color: isUser
              ? AppColors.primary.withOpacity(0.3)
              : (isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.04)),
          width: isUser ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          // Rank Indicator Medal
          SizedBox(
            width: 32,
            child: Align(
              alignment: Alignment.centerLeft,
              child: rankIcon,
            ),
          ),

          // User Avatar icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : LightColors.primaryLight,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              avatar,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(width: 14),

          // User Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTheme.tBase(
                    textC,
                    isUser ? FontWeight.w800 : FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (isUser)
                  Text(
                    '¡Tú!',
                    style: AppTheme.tXs(AppColors.primary, FontWeight.w800),
                  ),
              ],
            ),
          ),

          // Points
          Row(
            children: [
              Text(
                '$points',
                style: AppTheme.tMd(
                  isUser ? AppColors.primary : textC,
                  FontWeight.w900,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'pts',
                style: AppTheme.tXs(textM, FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
