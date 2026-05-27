import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_animations.dart';
import '../widgets/hero_card.dart';
import '../widgets/quest_card.dart';
import '../widgets/chapter_node.dart';
import '../models/adventure.dart';
import '../models/creature.dart';
import '../providers/eco_state.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onNavigate;
  final VoidCallback onPlayTrivia;

  const HomeScreen({
    super.key,
    required this.onNavigate,
    required this.onPlayTrivia,
  });

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<EcoState>(context);
    final isDark = context.isDark;
    final textC = isDark ? DarkColors.textDark : LightColors.textDark;
    final textM = isDark ? DarkColors.textMid : LightColors.textMid;
    final bg = isDark ? DarkColors.bgApp : LightColors.bgApp;

    final String name = state.getUserName();
    final activeAdventure = state.getActiveAdventure();
    final currentChapter = state.getCurrentChapter(activeAdventure.id);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.sp4, vertical: AppTheme.sp3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Row (Greeting & Avatar)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¡Hola, $name! 👋',
                        style: AppTheme.tLg(textC, FontWeight.w900),
                      ),
                      Text(
                        '¿Listo para otra Eco-Aventura?',
                        style: AppTheme.tSm(textM, FontWeight.w600),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => onNavigate(6), // Profile page is index 6
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.12),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 1.5),
                      ),
                      alignment: Alignment.center,
                      child: const Text('⭐', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Hero Mascot Card
              const HeroCard(),
              const SizedBox(height: 20),

              // Play Trivia Shortcut
              InkWell(
                onTap: onPlayTrivia,
                borderRadius: BorderRadius.circular(AppTheme.rMd),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.sp4, vertical: AppTheme.sp3),
                  decoration: BoxDecoration(
                    color: AppColors.adventureGold.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(AppTheme.rMd),
                    border: Border.all(
                      color: AppColors.adventureGold.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      PulseWidget(
                        child: const Text('🧠', style: TextStyle(fontSize: 24)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Trivia Ecológica Diaria',
                              style: AppTheme.tBase(textC, FontWeight.w800),
                            ),
                            Text(
                              '¡Responde y gana bonos de Eco-Puntos!',
                              style: AppTheme.tSm(textM, FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.play_circle_fill_rounded, color: AppColors.adventureGold, size: 28),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Top Recicladores Section
              Text(
                '🏆 Top Recicladores',
                style: AppTheme.tMd(textC, FontWeight.w900),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(AppTheme.sp4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(AppTheme.rMd),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    Text(
                      '¡Los 3 mejores ganarán merchandising exclusivo!',
                      style: AppTheme.tXs(textC, FontWeight.w800),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildPodium(context, 'Ana', 1240, 2, AppColors.blue),
                        _buildPodium(context, 'Carlos', 1580, 1, AppColors.adventureGold),
                        _buildPodium(context, 'Laura', 980, 3, AppColors.purple),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Section Header
              Text(
                'Objetivo Actual',
                style: AppTheme.tMd(textC, FontWeight.w900),
              ),
              const SizedBox(height: 8),

              // Active chapter objective card
              QuestCard(
                onActionPressed: () {
                  if (currentChapter == null) return;
                  if (currentChapter.type == ChapterType.trivia) {
                    onPlayTrivia();
                  } else if (currentChapter.type == ChapterType.explore) {
                    onNavigate(1); // Map page
                  } else if (currentChapter.type == ChapterType.group) {
                    onNavigate(5); // Patrol page
                  } else {
                    onNavigate(2); // Scanner page
                  }
                },
              ),
              const SizedBox(height: 24),

              // Adventure timeline vertical nodes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Camino de la Aventura',
                    style: AppTheme.tMd(textC, FontWeight.w900),
                  ),
                  Text(
                    '${state.getQuestProgress(activeAdventure.id)['completed']}/${activeAdventure.totalChapters} Capítulos',
                    style: AppTheme.tSm(AppColors.primary, FontWeight.w800),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Timeline builder
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activeAdventure.chapters.length,
                itemBuilder: (context, index) {
                  final ch = activeAdventure.chapters[index];
                  final bool isCompleted = state.state.adventure.quests[activeAdventure.id]?.completedChapters.contains(ch.id) ?? false;
                  final bool isActive = state.state.adventure.quests[activeAdventure.id]?.currentChapter == ch.id;

                  ChapterNodeStatus nodeStatus = ChapterNodeStatus.locked;
                  if (isCompleted) {
                    nodeStatus = ChapterNodeStatus.completed;
                  } else if (isActive) {
                    nodeStatus = ChapterNodeStatus.active;
                  }

                  return ChapterNode(
                    chapterNumber: index + 1,
                    title: ch.title,
                    description: ch.hint,
                    status: nodeStatus,
                    isLast: index == activeAdventure.chapters.length - 1,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPodium(BuildContext context, String name, int points, int rank, Color color) {
    final double height = rank == 1 ? 80.0 : (rank == 2 ? 60.0 : 40.0);
    final String emoji = rank == 1 ? '🥇' : (rank == 2 ? '🥈' : '🥉');
    final isDark = context.isDark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(name, style: AppTheme.tXs(isDark ? Colors.white : Colors.black, FontWeight.w800)),
        Text('$points pts', style: AppTheme.tXs(color, FontWeight.w800)),
        const SizedBox(height: 8),
        Container(
          width: 50,
          height: height,
          decoration: BoxDecoration(
            color: color.withOpacity(0.8),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            '#$rank',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
          ),
        ),
      ],
    );
  }
}
