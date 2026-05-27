import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/mission_card.dart';
import '../providers/eco_state.dart';

class DailyMissionScreen extends StatelessWidget {
  const DailyMissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<EcoState>(context);
    final isDark = context.isDark;
    final textC = isDark ? DarkColors.textDark : LightColors.textDark;
    final textM = isDark ? DarkColors.textMid : LightColors.textMid;
    final bg = isDark ? DarkColors.bgApp : LightColors.bgApp;

    final missions = state.getDailyMissions();
    final streak = state.getMissionStreak();
    final pendingCount = state.getPendingMissionsCount();

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.sp4, vertical: AppTheme.sp3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                'Misiones Diarias',
                style: AppTheme.tXl(textC, FontWeight.w900),
              ),
              Text(
                'Completa estos retos hoy y mantén viva tu racha ecológica.',
                style: AppTheme.tSm(textM, FontWeight.w600),
              ),
              const SizedBox(height: 16),

              // Streak status block panel
              Container(
                padding: const EdgeInsets.all(AppTheme.sp4),
                decoration: BoxDecoration(
                  color: isDark ? DarkColors.bgCard : Colors.white,
                  borderRadius: BorderRadius.circular(AppTheme.rLg),
                  boxShadow: AppShadows.sm,
                  border: Border.all(
                    color: streak > 0 ? AppColors.orange.withOpacity(0.3) : textM.withOpacity(0.1),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppTheme.sp3),
                      decoration: BoxDecoration(
                        color: AppColors.orange.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Text('🔥', style: TextStyle(fontSize: 28)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            streak == 1 ? 'Racha de 1 día' : 'Racha de $streak días',
                            style: AppTheme.tBase(textC, FontWeight.w800),
                          ),
                          Text(
                            streak > 0
                                ? '¡Excelente! Mantén el ritmo para conseguir multiplicadores de Eco-Puntos.'
                                : 'Completa las 3 misiones de hoy para comenzar una racha.',
                            style: AppTheme.tSm(textM, FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Summary mission status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Retos Disponibles',
                    style: AppTheme.tMd(textC, FontWeight.w900),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: pendingCount > 0
                          ? AppColors.blue.withOpacity(0.12)
                          : AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(AppTheme.rSm),
                    ),
                    child: Text(
                      pendingCount > 0 ? '$pendingCount pendientes' : '¡Completadas!',
                      style: AppTheme.tXs(
                        pendingCount > 0 ? AppColors.blue : AppColors.primary,
                        FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Checklist list view builder
              Expanded(
                child: ListView.separated(
                  itemCount: missions.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final mission = missions[index];
                    return MissionCard(
                      mission: mission,
                      onCompletePressed: () {
                        state.completeMission(mission.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '¡Felicidades! Has completado "${mission.title}" y ganado +${mission.pts} Eco-Puntos.',
                              style: AppTheme.tSm(Colors.white, FontWeight.w700),
                            ),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
