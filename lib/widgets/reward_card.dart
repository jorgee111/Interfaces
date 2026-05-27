import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../models/reward.dart';

class RewardCard extends StatelessWidget {
  final Reward reward;
  final int userPoints;
  final VoidCallback onRedeemPressed;

  const RewardCard({
    super.key,
    required this.reward,
    required this.userPoints,
    required this.onRedeemPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final cardBg = isDark ? DarkColors.bgCard : LightColors.bgCard;
    final textC = isDark ? DarkColors.textDark : LightColors.textDark;
    final textM = isDark ? DarkColors.textMid : LightColors.textMid;

    final bool canAfford = userPoints >= reward.cost;

    LinearGradient gradient = AppColors.statBlue;
    if (reward.category == 'comida') {
      gradient = AppColors.statOrange;
    } else if (reward.category == 'fastpass') {
      gradient = AppColors.statPurple;
    } else if (reward.category == 'entradas') {
      gradient = AppColors.statGreen;
    }

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppTheme.rLg),
        boxShadow: AppShadows.sm,
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.04),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.rLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Image card gradient
            Container(
              height: 70,
              decoration: BoxDecoration(
                gradient: gradient,
              ),
              alignment: Alignment.center,
              child: Text(
                reward.icon,
                style: const TextStyle(fontSize: 32),
              ),
            ),

            // Content Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.sp3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reward.title,
                          style: AppTheme.tBase(textC, FontWeight.w800),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          reward.desc,
                          style: AppTheme.tXs(textM, FontWeight.w500),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Cost Tag
                        Row(
                          children: [
                            const Text('🪙', style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 4),
                            Text(
                              '${reward.cost} PTS',
                              style: AppTheme.tSm(AppColors.primary, FontWeight.w800),
                            ),
                          ],
                        ),

                        // Redeem button
                        ElevatedButton(
                          onPressed: canAfford ? onRedeemPressed : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: isDark ? Colors.white10 : Colors.black.withOpacity(0.06),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.rSm),
                            ),
                          ),
                          child: Text(
                            canAfford ? 'Canjear' : 'Bloqueado',
                            style: AppTheme.tXs(
                              canAfford ? Colors.white : textM.withOpacity(0.5),
                              FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
