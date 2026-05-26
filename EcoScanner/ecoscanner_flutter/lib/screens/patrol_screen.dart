import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../models/user_state.dart';
import '../providers/eco_state.dart';

class PatrolScreen extends StatefulWidget {
  const PatrolScreen({super.key});

  @override
  State<PatrolScreen> createState() => _PatrolScreenState();
}

class _PatrolScreenState extends State<PatrolScreen> {
  final TextEditingController _createController = TextEditingController();
  final TextEditingController _joinController = TextEditingController();

  @override
  void dispose() {
    _createController.dispose();
    _joinController.dispose();
    super.dispose();
  }

  void _createPatrol() {
    final name = _createController.text.trim();
    if (name.isEmpty) return;

    final state = Provider.of<EcoState>(context, listen: false);
    state.createPatrol(name);
    _createController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '¡Patrulla "$name" creada exitosamente!',
          style: AppTheme.tSm(Colors.white, FontWeight.w700),
        ),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _joinPatrol() {
    final code = _joinController.text.trim().toUpperCase();
    if (code.isEmpty) return;

    final state = Provider.of<EcoState>(context, listen: false);
    state.joinPatrol(code);
    _joinController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '¡Te has unido a la patrulla exitosamente!',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _leavePatrol() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('¿Salir de la Patrulla?'),
          content: const Text('Perderás el progreso de equipo acumulado en esta sesión. ¿Quieres salir?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final state = Provider.of<EcoState>(context, listen: false);
                state.leavePatrol();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.red, foregroundColor: Colors.white),
              child: const Text('Salir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<EcoState>(context);
    final isDark = context.isDark;
    final textC = isDark ? DarkColors.textDark : LightColors.textDark;
    final textM = isDark ? DarkColors.textMid : LightColors.textMid;
    final bg = isDark ? DarkColors.bgApp : LightColors.bgApp;
    final cardBg = isDark ? DarkColors.bgCard : LightColors.bgCard;

    final patrol = state.state.patrol;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.sp4, vertical: AppTheme.sp3),
          child: patrol.joined
              ? _buildJoinedView(patrol, textC, textM, cardBg, isDark)
              : _buildNonJoinedView(textC, textM, cardBg, isDark),
        ),
      ),
    );
  }

  Widget _buildNonJoinedView(Color textC, Color textM, Color cardBg, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Intro Block banner
        Text(
          'Patrullas Ecológicas',
          style: AppTheme.tXl(textC, FontWeight.w900),
        ),
        Text(
          'Une fuerzas con tus amigos y multipliquen su impacto.',
          style: AppTheme.tSm(textM, FontWeight.w600),
        ),
        const SizedBox(height: 20),

        Container(
          padding: const EdgeInsets.all(AppTheme.sp5),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(AppTheme.rLg),
            boxShadow: AppShadows.primary,
          ),
          child: Column(
            children: [
              const Text('👥', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              Text(
                'Juntos Reciclamos Mejor',
                style: AppTheme.tLg(Colors.white, FontWeight.w900),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'Crea un grupo ecológico o únete a uno existente. Podrán sumar puntos en equipo y competir en el ranking global de patrullas del parque.',
                style: AppTheme.tSm(Colors.white.withOpacity(0.9), FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Forms Row
        Text(
          'Crear una Nueva Patrulla',
          style: AppTheme.tMd(textC, FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(AppTheme.sp4),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(AppTheme.rLg),
            boxShadow: AppShadows.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _createController,
                style: AppTheme.tBase(textC, FontWeight.w700),
                decoration: InputDecoration(
                  hintText: 'Ej: Faunia Guardians',
                  hintStyle: AppTheme.tBase(textM.withOpacity(0.5), FontWeight.w600),
                  prefixIcon: const Icon(Icons.group_add_rounded, color: AppColors.primary),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF0F172A) : LightColors.bgApp,
                  contentPadding: const EdgeInsets.all(AppTheme.sp3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.rMd),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _createPatrol,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.rMd)),
                ),
                child: Text('Crear Patrulla', style: AppTheme.tBase(Colors.white, FontWeight.w800)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Text(
          'Unirse con Código',
          style: AppTheme.tMd(textC, FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(AppTheme.sp4),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(AppTheme.rLg),
            boxShadow: AppShadows.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _joinController,
                style: AppTheme.tBase(textC, FontWeight.w700),
                decoration: InputDecoration(
                  hintText: 'Código: ECO1, BLUE, FURN...',
                  hintStyle: AppTheme.tBase(textM.withOpacity(0.5), FontWeight.w600),
                  prefixIcon: const Icon(Icons.vpn_key_rounded, color: AppColors.adventureGold),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF0F172A) : LightColors.bgApp,
                  contentPadding: const EdgeInsets.all(AppTheme.sp3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.rMd),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _joinPatrol,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.adventureGold,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.rMd)),
                ),
                child: Text('Unirse a Patrulla', style: AppTheme.tBase(Colors.white, FontWeight.w800)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildJoinedView(PatrolState patrol, Color textC, Color textM, Color cardBg, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Patrol Info Header banner
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patrol.name,
                  style: AppTheme.tXl(textC, FontWeight.w900),
                ),
                Text(
                  'CÓDIGO DE GRUPO: ${patrol.code}',
                  style: AppTheme.tXs(AppColors.adventureGold, FontWeight.w800),
                ),
              ],
            ),
            IconButton(
              onPressed: _leavePatrol,
              icon: const Icon(Icons.exit_to_app_rounded, color: AppColors.red),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Total Points card
        Container(
          padding: const EdgeInsets.all(AppTheme.sp4),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(AppTheme.rLg),
            boxShadow: AppShadows.primary,
          ),
          child: Column(
            children: [
              Text(
                'PUNTUACIÓN COLECTIVA',
                style: AppTheme.tXs(Colors.white.withOpacity(0.8), FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🏆', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 8),
                  Text(
                    '${patrol.totalPoints} PTS',
                    style: AppTheme.tXxl(Colors.white, FontWeight.w900),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Members list Title
        Text(
          'Miembros del Equipo (${patrol.members.length})',
          style: AppTheme.tMd(textC, FontWeight.w900),
        ),
        const SizedBox(height: 12),

        // Member list builder
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: patrol.members.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final m = patrol.members[index];
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
                  // Status Ring & Avatar
                  Stack(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : LightColors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(m.avatar, style: const TextStyle(fontSize: 16)),
                      ),
                      if (m.online)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: AppColors.green2,
                              shape: BoxShape.circle,
                              border: Border.all(color: cardBg, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 14),

                  // Name details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m.name,
                          style: AppTheme.tBase(textC, FontWeight.w800),
                        ),
                        Text(
                          m.online ? 'En línea' : 'Desconectado',
                          style: AppTheme.tXs(m.online ? AppColors.green2 : textM, FontWeight.w600),
                        ),
                      ],
                    ),
                  ),

                  // Points Contribution
                  Row(
                    children: [
                      Text(
                        '${m.pts}',
                        style: AppTheme.tMd(m.isMe ? AppColors.primary : textC, FontWeight.w900),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        'pts',
                        style: AppTheme.tXs(textM, FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
