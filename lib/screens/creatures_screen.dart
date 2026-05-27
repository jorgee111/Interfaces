import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_animations.dart';
import '../widgets/creature_card.dart';
import '../models/creature.dart';
import '../models/user_state.dart';
import '../providers/eco_state.dart';

class CreaturesScreen extends StatefulWidget {
  const CreaturesScreen({super.key});

  @override
  State<CreaturesScreen> createState() => _CreaturesScreenState();
}

class _CreaturesScreenState extends State<CreaturesScreen> {
  void _showCreatureDetails(Creature creature, bool isDiscovered, int feedCount) {
    if (!isDiscovered) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '¡Esta criatura aún está oculta! Sigue completando capítulos de la aventura para descubrirla.',
            style: AppTheme.tSm(Colors.white, FontWeight.w700),
          ),
          backgroundColor: AppColors.adventureGold,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _CreatureDetailSheet(
          creature: creature,
          initialFeedCount: feedCount,
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

    final discoveredList = state.state.creatures.discovered;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.sp4, vertical: AppTheme.sp3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Colección de Criaturas',
                style: AppTheme.tXl(textC, FontWeight.w900),
              ),
              Text(
                'Criaturas mágicas que has descubierto reciclando en Faunia.',
                style: AppTheme.tSm(textM, FontWeight.w600),
              ),
              const SizedBox(height: 16),

              // Summary status text
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.sp3, vertical: AppTheme.sp2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(AppTheme.rMd),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Text('🎒', style: TextStyle(fontSize: 22)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Has descubierto ${discoveredList.length} de ${kCreatures.length} criaturas del parque.',
                        style: AppTheme.tSm(textC, FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Grid List of Creatures
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppTheme.sp3,
                    mainAxisSpacing: AppTheme.sp3,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: kCreatures.length,
                  itemBuilder: (context, index) {
                    final creature = kCreatures[index];
                    final bool isDiscovered = state.isCreatureDiscovered(creature.id);
                    final discoveredEntry = discoveredList.firstWhere(
                      (c) => c.id == creature.id,
                      orElse: () => DiscoveredCreature(id: '', discoveredAt: '', feedCount: 0),
                    );

                    return CreatureCard(
                      creature: creature,
                      isDiscovered: isDiscovered,
                      feedCount: discoveredEntry.feedCount,
                      onTap: () => _showCreatureDetails(creature, isDiscovered, discoveredEntry.feedCount),
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

class _CreatureDetailSheet extends StatefulWidget {
  final Creature creature;
  final int initialFeedCount;

  const _CreatureDetailSheet({
    required this.creature,
    required this.initialFeedCount,
  });

  @override
  State<_CreatureDetailSheet> createState() => _CreatureDetailSheetState();
}

class _CreatureDetailSheetState extends State<_CreatureDetailSheet> {
  late int _feedCount;

  @override
  void initState() {
    super.initState();
    _feedCount = widget.initialFeedCount;
  }

  void _feed() {
    final ecoState = Provider.of<EcoState>(context, listen: false);
    ecoState.feedCreature(widget.creature.id);

    // Increment mission progress
    ecoState.incrementMissionProgress('dm6', 1);

    setState(() {
      _feedCount++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '¡Has alimentado a ${widget.creature.name}! Recibes +5 Eco-Puntos. 🍎',
          style: AppTheme.tSm(Colors.white, FontWeight.w700),
        ),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textC = isDark ? DarkColors.textDark : LightColors.textDark;
    final textM = isDark ? DarkColors.textMid : LightColors.textMid;
    final cardBg = isDark ? DarkColors.bgCard : LightColors.bgCard;

    // Calculate level based on _feedCount
    int level = 0;
    int nextReq = 5;
    double progress = 0.0;

    if (_feedCount >= 15) {
      level = 2;
      nextReq = 15;
      progress = 1.0;
    } else if (_feedCount >= 5) {
      level = 1;
      nextReq = 15;
      progress = (_feedCount - 5) / 10;
    } else {
      level = 0;
      nextReq = 5;
      progress = _feedCount / 5;
    }

    final currentStage = widget.creature.stages[level];

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppTheme.rXxl),
          topRight: Radius.circular(AppTheme.rXxl),
        ),
        boxShadow: AppShadows.lg,
      ),
      padding: const EdgeInsets.all(AppTheme.sp5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag Indicator handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: textM.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Big Mascot Icon
          Center(
            child: FloatingCreature(
              child: Container(
                padding: const EdgeInsets.all(AppTheme.sp5),
                decoration: BoxDecoration(
                  color: widget.creature.color.withOpacity(0.12),
                  shape: BoxShape.circle,
                  border: Border.all(color: widget.creature.color.withOpacity(0.2), width: 2),
                ),
                child: Text(
                  currentStage.emoji,
                  style: const TextStyle(fontSize: 72),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Name and Details
          Center(
            child: Text(
              widget.creature.name,
              style: AppTheme.tXl(textC, FontWeight.w900),
            ),
          ),
          Center(
            child: Text(
              currentStage.name.toUpperCase(),
              style: AppTheme.tXs(widget.creature.color, FontWeight.w800),
            ),
          ),
          const SizedBox(height: 12),

          // Description stage text
          Center(
            child: Text(
              currentStage.description,
              style: AppTheme.tBase(textM, FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),

          // Evolution progress track meter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progreso de Evolución',
                style: AppTheme.tXs(textM, FontWeight.w800),
              ),
              Text(
                level == 2 ? 'Evolución Máxima' : '$_feedCount / $nextReq alimentos',
                style: AppTheme.tXs(textC, FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.rFull),
            child: Container(
              height: 8,
              color: isDark ? const Color(0xFF1E293B) : Colors.black.withOpacity(0.06),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  color: widget.creature.color,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Evolution stages details grid row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(widget.creature.stages.length, (index) {
              final stage = widget.creature.stages[index];
              final bool isActive = index <= level;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive ? widget.creature.color.withOpacity(0.12) : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppTheme.rSm),
                  border: Border.all(
                    color: isActive ? widget.creature.color.withOpacity(0.3) : textM.withOpacity(0.2),
                  ),
                ),
                child: Text(
                  '${stage.emoji} Lvl ${index + 1}',
                  style: AppTheme.tXs(
                    isActive ? widget.creature.color : textM,
                    FontWeight.w800,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),

          // Feed Action button
          ElevatedButton.icon(
            onPressed: _feed,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.creature.color,
              foregroundColor: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.rMd),
              ),
              padding: const EdgeInsets.all(AppTheme.sp4),
            ),
            icon: const Icon(Icons.apple_rounded, color: Colors.white),
            label: Text(
              'Alimentar (+5 Ptos)',
              style: AppTheme.tBase(Colors.white, FontWeight.w800),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
