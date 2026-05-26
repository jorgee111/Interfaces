import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_animations.dart';
import '../providers/eco_state.dart';

class HeroCard extends StatelessWidget {
  const HeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<EcoState>(context);

    final userPts = state.state.points;
    final level = state.getLevel(userPts);
    final nextLevel = state.getNextLevel(userPts);
    final progress = state.getLevelProgress(userPts);
    final mascot = state.getMascotData();

    return Container(
      padding: const EdgeInsets.all(AppTheme.sp5),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppTheme.rXl),
        boxShadow: AppShadows.primary,
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.12),
              ),
            ),
          ),
          Positioned(
            left: -40,
            bottom: -40,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),

          // Main Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NIVEL ACTUAL',
                        style: AppTheme.tXs(Colors.white.withOpacity(0.8), FontWeight.w800),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            level.icon,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            level.name,
                            style: AppTheme.tLg(Colors.white, FontWeight.w900),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Animating Mascot
                  FloatingCreature(
                    duration: const Duration(seconds: 3),
                    child: Container(
                      padding: const EdgeInsets.all(AppTheme.sp2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
                      ),
                      child: Text(
                        mascot.icon,
                        style: const TextStyle(fontSize: 48),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Points Counter
              Text(
                'Eco-Puntos',
                style: AppTheme.tXs(Colors.white.withOpacity(0.8), FontWeight.w700),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$userPts',
                    style: GoogleFonts.nunito(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'PTS',
                    style: AppTheme.tXs(Colors.white.withOpacity(0.8), FontWeight.w800),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Progress Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progreso de Nivel',
                    style: AppTheme.tXs(Colors.white.withOpacity(0.9), FontWeight.w700),
                  ),
                  Text(
                    nextLevel != null
                        ? '${userPts}/${nextLevel.minPoints} pts'
                        : 'Máximo Nivel',
                    style: AppTheme.tXs(Colors.white.withOpacity(0.9), FontWeight.w800),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.rFull),
                child: Container(
                  height: 10,
                  color: Colors.white.withOpacity(0.24),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppTheme.rFull),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.white30,
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Mascot Mood indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.sp3, vertical: AppTheme.sp1),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppTheme.rFull),
                ),
                child: Text(
                  'Compañero: ${mascot.name} (${mascot.mood})',
                  style: AppTheme.tXs(Colors.white, FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
