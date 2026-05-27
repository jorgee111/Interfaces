import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../models/user_state.dart';
import '../providers/eco_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<EcoState>(context);
    final isDark = context.isDark;
    final textC = isDark ? DarkColors.textDark : LightColors.textDark;
    final textM = isDark ? DarkColors.textMid : LightColors.textMid;
    final bg = isDark ? DarkColors.bgApp : LightColors.bgApp;
    final cardBg = isDark ? DarkColors.bgCard : LightColors.bgCard;

    final String name = state.getUserName();
    final userPts = state.state.points;
    final level = state.getLevel(userPts);

    // Oracle Metrics
    final oracle = state.getOracle();

    // History logs
    final history = state.state.history;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.sp4, vertical: AppTheme.sp3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card Profile Summary
              Container(
                padding: const EdgeInsets.all(AppTheme.sp5),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(AppTheme.rLg),
                  boxShadow: AppShadows.sm,
                  border: Border.all(
                    color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.04),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.12),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 2),
                      ),
                      alignment: Alignment.center,
                      child: const Text('⭐', style: TextStyle(fontSize: 24)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: AppTheme.tLg(textC, FontWeight.w900),
                          ),
                          Row(
                            children: [
                              Text(level.icon, style: const TextStyle(fontSize: 14)),
                              const SizedBox(width: 4),
                              Text(
                                level.name,
                                style: AppTheme.tXs(AppColors.primary, FontWeight.w800),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Settings Row Dark mode toggle
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.sp4, vertical: AppTheme.sp2),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(AppTheme.rMd),
                  border: Border.all(
                    color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.04),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded, color: AppColors.primary),
                        const SizedBox(width: 14),
                        Text(
                          'Modo Oscuro',
                          style: AppTheme.tBase(textC, FontWeight.w800),
                        ),
                      ],
                    ),
                    Switch(
                      value: isDark,
                      onChanged: (val) {
                        state.toggleDarkMode();
                      },
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Oracle Savings Heading
              Text(
                'Calculadora de Ahorro Eco (Oráculo)',
                style: AppTheme.tMd(textC, FontWeight.w900),
              ),
              Text(
                'Estimación del impacto positivo que tus Eco-Puntos representan.',
                style: AppTheme.tSm(textM, FontWeight.w600),
              ),
              const SizedBox(height: 12),

              // Oracle Metrics Row list
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: AppTheme.sp2,
                mainAxisSpacing: AppTheme.sp2,
                childAspectRatio: 0.94,
                children: [
                  _buildOracleCard('🌱 CO2', oracle['co2']!, 'kg', isDark ? const Color(0xFF1E293B) : Colors.white, textC, textM),
                  _buildOracleCard('💧 Agua', oracle['water']!, 'L', isDark ? const Color(0xFF1E293B) : Colors.white, textC, textM),
                  _buildOracleCard('⚡ Energía', oracle['energy']!, 'kWh', isDark ? const Color(0xFF1E293B) : Colors.white, textC, textM),
                ],
              ),
              const SizedBox(height: 24),

              // Recent Activities Timeline
              Text(
                'Historial de Acciones',
                style: AppTheme.tMd(textC, FontWeight.w900),
              ),
              const SizedBox(height: 12),

              if (history.isEmpty)
                Container(
                  padding: const EdgeInsets.all(AppTheme.sp5),
                  alignment: Alignment.center,
                  child: Text(
                    'Aún no has registrado ninguna acción.',
                    style: AppTheme.tSm(textM, FontWeight.w600),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: history.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final h = history[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppTheme.sp4, vertical: AppTheme.sp3),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(AppTheme.rMd),
                        border: Border.all(
                          color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.04),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Text(h.icon, style: const TextStyle(fontSize: 16)),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  h.action,
                                  style: AppTheme.tBase(textC, FontWeight.w800),
                                ),
                                Text(
                                  h.time,
                                  style: AppTheme.tXs(textM, FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '+${h.pts} PTS',
                            style: AppTheme.tBase(AppColors.primary, FontWeight.w900),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOracleCard(String label, String value, String unit, Color cardBg, Color textC, Color textM) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppTheme.rMd),
        boxShadow: AppShadows.xs,
        border: Border.all(color: textM.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTheme.tXs(textM, FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: textC,
                ),
              ),
              const SizedBox(width: 1),
              Text(
                unit,
                style: AppTheme.tXs(textM, FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
