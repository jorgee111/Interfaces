import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'storage_stub.dart' if (dart.library.html) 'storage_web.dart' as storage;

void main() {
  runApp(const EcoScannerApp());
}

class AppColors {
  static const primary = Color(0xFF00BFA5);
  static const primaryDark = Color(0xFF009688);
  static const primaryDarker = Color(0xFF00796B);
  static const primaryLight = Color(0xFFE6FAF5);
  static const bgApp = Color(0xFFF2FBF9);
  static const bgCard = Colors.white;
  static const textDark = Color(0xFF0D3B2E);
  static const textMid = Color(0xFF4A7C6A);
  static const textMuted = Color(0xFF9DBDB3);
  static const orange = Color(0xFFFF7A3D);
  static const purple = Color(0xFF7C5CFC);
  static const yellow = Color(0xFFFFB830);
  static const blue = Color(0xFF4B9EFF);
  static const red = Color(0xFFFF4757);
  static const green2 = Color(0xFF2ECC71);
  static const mystery = Color(0xFF4F46E5);
  static const forest = Color(0xFF22C55E);
  static const ocean = Color(0xFF06B6D4);
  static const crystal = Color(0xFFA855F7);

  static const gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00E676), Color(0xFF00B8D4)],
  );
}

class EcoScannerApp extends StatefulWidget {
  const EcoScannerApp({super.key});

  @override
  State<EcoScannerApp> createState() => _EcoScannerAppState();
}

class _EcoScannerAppState extends State<EcoScannerApp> {
  late final EcoStore store;

  @override
  void initState() {
    super.initState();
    store = EcoStore()..load();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        return MaterialApp(
          title: 'EcoScanner Adventures',
          debugShowCheckedModeBanner: false,
          themeMode: store.darkMode ? ThemeMode.dark : ThemeMode.light,
          theme: _theme(false),
          darkTheme: _theme(true),
          home: AppFrame(store: store),
        );
      },
    );
  }

  ThemeData _theme(bool dark) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: dark ? Brightness.dark : Brightness.light,
    );
    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: dark ? const Color(0xFF0B1120) : AppColors.bgApp,
      fontFamily: 'Nunito',
      useMaterial3: true,
      textTheme: ThemeData(
        brightness: dark ? Brightness.dark : Brightness.light,
      ).textTheme.apply(
            fontFamily: 'Nunito',
            bodyColor: dark ? Colors.white : AppColors.textDark,
            displayColor: dark ? Colors.white : AppColors.textDark,
          ),
    );
  }
}

enum MainTab { home, adventure, creatures, rewards, profile }

enum ChapterType { scan, trivia, explore, group }

class RewardData {
  const RewardData({this.points = 0, this.creature, this.item});
  final int points;
  final String? creature;
  final String? item;
}

class Chapter {
  const Chapter({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.hint,
    required this.reward,
  });

  final String id;
  final String title;
  final String description;
  final ChapterType type;
  final String hint;
  final RewardData reward;
}

class Adventure {
  const Adventure({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.chapters,
  });

  final String id;
  final String title;
  final String description;
  final String icon;
  final List<Chapter> chapters;
}

class CreatureStage {
  const CreatureStage({
    required this.name,
    required this.emoji,
    required this.feedRequired,
    required this.description,
  });

  final String name;
  final String emoji;
  final int feedRequired;
  final String description;
}

class CreatureDef {
  const CreatureDef({
    required this.id,
    required this.name,
    required this.element,
    required this.color,
    required this.stages,
  });

  final String id;
  final String name;
  final String element;
  final Color color;
  final List<CreatureStage> stages;
}

class RewardCatalogItem {
  const RewardCatalogItem({
    required this.id,
    required this.title,
    required this.desc,
    required this.cost,
    required this.category,
    required this.color,
    required this.icon,
  });

  final String id;
  final String title;
  final String desc;
  final int cost;
  final String category;
  final List<Color> color;
  final IconData icon;
}

class Mission {
  const Mission({
    required this.icon,
    required this.title,
    required this.desc,
    required this.pts,
    required this.progress,
    required this.total,
    required this.expires,
  });

  final IconData icon;
  final String title;
  final String desc;
  final int pts;
  final int progress;
  final int total;
  final String expires;
}

class TriviaQuestion {
  const TriviaQuestion({
    required this.id,
    required this.category,
    required this.question,
    required this.options,
    required this.correct,
    required this.funFact,
  });

  final int id;
  final String category;
  final String question;
  final List<String> options;
  final int correct;
  final String funFact;
}

class LeaderboardItem {
  const LeaderboardItem({
    required this.rank,
    required this.name,
    required this.pts,
    this.members,
    this.isUser = false,
  });

  final int rank;
  final String name;
  final int pts;
  final int? members;
  final bool isUser;
}

class DiscoveredCreature {
  DiscoveredCreature({
    required this.id,
    required this.discoveredAt,
    required this.feedCount,
  });

  final String id;
  final String discoveredAt;
  int feedCount;

  Map<String, dynamic> toJson() => {
        'id': id,
        'discoveredAt': discoveredAt,
        'feedCount': feedCount,
      };
}

class QuestState {
  QuestState({
    required this.started,
    required this.completedChapters,
    required this.currentChapter,
  });

  bool started;
  List<String> completedChapters;
  String? currentChapter;

  Map<String, dynamic> toJson() => {
        'started': started,
        'completedChapters': completedChapters,
        'currentChapter': currentChapter,
      };
}

class EcoState {
  EcoState({
    required this.points,
    required this.rank,
    required this.streak,
    required this.redeemedIds,
    required this.activeQuestId,
    required this.quests,
    required this.inventory,
    required this.totalChaptersCompleted,
    required this.creatures,
    required this.answeredIds,
    required this.correctCount,
    required this.triviaStreak,
    required this.history,
  });

  int points;
  int rank;
  int streak;
  List<String> redeemedIds;
  String activeQuestId;
  Map<String, QuestState> quests;
  List<String> inventory;
  int totalChaptersCompleted;
  List<DiscoveredCreature> creatures;
  List<int> answeredIds;
  int correctCount;
  int triviaStreak;
  List<Map<String, dynamic>> history;

  Map<String, dynamic> toJson() => {
        'points': points,
        'rank': rank,
        'streak': streak,
        'redeemedIds': redeemedIds,
        'activeQuestId': activeQuestId,
        'quests': quests.map((key, value) => MapEntry(key, value.toJson())),
        'inventory': inventory,
        'totalChaptersCompleted': totalChaptersCompleted,
        'creatures': creatures.map((c) => c.toJson()).toList(),
        'answeredIds': answeredIds,
        'correctCount': correctCount,
        'triviaStreak': triviaStreak,
        'history': history,
      };
}

class EcoStore extends ChangeNotifier {
  static const stateKey = 'ecoscanner_state_flutter';
  static const darkKey = 'ecoscanner_dark';

  EcoState state = _defaultState();
  bool darkMode = false;

  void load() {
    darkMode = storage.readValue(darkKey) == 'true';
    final saved = storage.readValue(stateKey);
    if (saved != null) {
      try {
        final data = jsonDecode(saved) as Map<String, dynamic>;
        state = EcoState(
          points: data['points'] as int? ?? 1250,
          rank: data['rank'] as int? ?? 42,
          streak: data['streak'] as int? ?? 3,
          redeemedIds: List<String>.from(data['redeemedIds'] as List? ?? []),
          activeQuestId: data['activeQuestId'] as String? ?? 'bosque-perdido',
          quests: (data['quests'] as Map? ?? {}).map((key, value) {
            final v = Map<String, dynamic>.from(value as Map);
            return MapEntry(
              key.toString(),
              QuestState(
                started: v['started'] as bool? ?? false,
                completedChapters: List<String>.from(
                  v['completedChapters'] as List? ?? [],
                ),
                currentChapter: v['currentChapter'] as String?,
              ),
            );
          }),
          inventory: List<String>.from(data['inventory'] as List? ?? []),
          totalChaptersCompleted: data['totalChaptersCompleted'] as int? ?? 1,
          creatures: (data['creatures'] as List? ?? [])
              .map((raw) {
                final c = Map<String, dynamic>.from(raw as Map);
                return DiscoveredCreature(
                  id: c['id'] as String,
                  discoveredAt: c['discoveredAt'] as String? ?? '2025-05-20',
                  feedCount: c['feedCount'] as int? ?? 0,
                );
              })
              .cast<DiscoveredCreature>()
              .toList(),
          answeredIds: List<int>.from(data['answeredIds'] as List? ?? [0]),
          correctCount: data['correctCount'] as int? ?? 1,
          triviaStreak: data['triviaStreak'] as int? ?? 1,
          history: (data['history'] as List? ?? _defaultHistory())
              .map((h) => Map<String, dynamic>.from(h as Map))
              .toList(),
        );
        _ensureDefaults();
      } catch (_) {
        state = _defaultState();
      }
    }
    notifyListeners();
  }

  void _ensureDefaults() {
    state.quests.putIfAbsent(
      'bosque-perdido',
      () => QuestState(
        started: true,
        completedChapters: ['ch1'],
        currentChapter: 'ch2',
      ),
    );
    state.quests.putIfAbsent(
      'oceano-secreto',
      () => QuestState(
        started: false,
        completedChapters: [],
        currentChapter: 'ch1',
      ),
    );
    if (state.creatures.isEmpty) {
      state.creatures.addAll([
        DiscoveredCreature(
          id: 'leaf-fox',
          discoveredAt: '2025-05-20',
          feedCount: 3,
        ),
        DiscoveredCreature(
          id: 'shell-turtle',
          discoveredAt: '2025-05-21',
          feedCount: 1,
        ),
      ]);
    }
  }

  void save() {
    storage.writeValue(stateKey, jsonEncode(state.toJson()));
  }

  void toggleDark() {
    darkMode = !darkMode;
    storage.writeValue(darkKey, darkMode.toString());
    notifyListeners();
  }

  int addPoints(
    int amount, {
    String action = 'Acción sostenible',
    IconData icon = Icons.recycling,
  }) {
    final previousLevel = levelName;
    state.points += amount;
    state.history.insert(0, {
      'action': action,
      'pts': amount,
      'time': 'Ahora mismo',
      'icon': historyKeyFor(icon),
    });
    if (state.history.length > 20) state.history.removeLast();
    save();
    notifyListeners();
    if (previousLevel != levelName) {
      return 1;
    }
    return 0;
  }

  bool spendPoints(int amount) {
    if (state.points < amount) return false;
    state.points -= amount;
    save();
    notifyListeners();
    return true;
  }

  bool redeemReward(String rewardId, int cost) {
    if (state.redeemedIds.contains(rewardId)) return false;
    if (!spendPoints(cost)) return false;
    state.redeemedIds.add(rewardId);
    save();
    notifyListeners();
    return true;
  }

  Adventure? get activeAdventure =>
      adventures.where((a) => a.id == state.activeQuestId).firstOrNull;

  QuestProgress getQuestProgress(String questId) {
    final adventure = adventures.where((a) => a.id == questId).firstOrNull;
    final questState = state.quests[questId];
    if (adventure == null || questState == null)
      return const QuestProgress(0, 0);
    return QuestProgress(
      questState.completedChapters.length,
      adventure.chapters.length,
    );
  }

  Chapter? getCurrentChapter(String questId) {
    final adventure = adventures.where((a) => a.id == questId).firstOrNull;
    final questState = state.quests[questId];
    if (adventure == null || questState?.currentChapter == null) return null;
    return adventure.chapters
        .where((chapter) => chapter.id == questState!.currentChapter)
        .firstOrNull;
  }

  void completeChapter(String questId, String chapterId) {
    final questState = state.quests[questId];
    final adventure = adventures.where((a) => a.id == questId).firstOrNull;
    if (questState == null || adventure == null) return;
    if (questState.completedChapters.contains(chapterId)) return;

    questState.completedChapters.add(chapterId);
    state.totalChaptersCompleted += 1;
    final chapterIndex = adventure.chapters.indexWhere(
      (c) => c.id == chapterId,
    );
    questState.currentChapter = chapterIndex < adventure.chapters.length - 1
        ? adventure.chapters[chapterIndex + 1].id
        : null;

    final chapter = adventure.chapters[chapterIndex];
    if (chapter.reward.points > 0) {
      addPoints(
        chapter.reward.points,
        action: 'Capítulo completado',
        icon: Icons.explore,
      );
    }
    final creature = chapter.reward.creature;
    if (creature != null) discoverCreature(creature);
    final item = chapter.reward.item;
    if (item != null && !state.inventory.contains(item))
      state.inventory.add(item);
    save();
    notifyListeners();
  }

  bool discoverCreature(String creatureId) {
    if (state.creatures.any((c) => c.id == creatureId)) return false;
    state.creatures.add(
      DiscoveredCreature(
        id: creatureId,
        discoveredAt: DateTime.now().toIso8601String().split('T').first,
        feedCount: 0,
      ),
    );
    save();
    notifyListeners();
    return true;
  }

  bool feedCreature(String creatureId) {
    final creature =
        state.creatures.where((c) => c.id == creatureId).firstOrNull;
    if (creature == null) return false;
    creature.feedCount += 1;
    save();
    notifyListeners();
    return true;
  }

  int creatureLevel(String creatureId, [int? feedOverride]) {
    final def = creatures.where((c) => c.id == creatureId).firstOrNull;
    final stateCreature =
        state.creatures.where((c) => c.id == creatureId).firstOrNull;
    if (def == null || stateCreature == null) return 0;
    final feed = feedOverride ?? stateCreature.feedCount;
    var level = 0;
    for (var i = def.stages.length - 1; i >= 0; i--) {
      if (feed >= def.stages[i].feedRequired) {
        level = i;
        break;
      }
    }
    return level;
  }

  CreatureStage? creatureStage(String creatureId) {
    final def = creatures.where((c) => c.id == creatureId).firstOrNull;
    if (def == null) return null;
    return def.stages[creatureLevel(creatureId)];
  }

  bool isCreatureDiscovered(String creatureId) {
    return state.creatures.any((c) => c.id == creatureId);
  }

  TriviaQuestion randomQuestion() {
    final unanswered =
        trivia.where((q) => !state.answeredIds.contains(q.id)).toList();
    if (unanswered.isEmpty) {
      state.answeredIds.clear();
      save();
      return trivia[math.Random().nextInt(trivia.length)];
    }
    return unanswered[math.Random().nextInt(unanswered.length)];
  }

  TriviaResult answerQuestion(TriviaQuestion question, int selectedIndex) {
    final correct = selectedIndex == question.correct;
    if (!state.answeredIds.contains(question.id))
      state.answeredIds.add(question.id);
    if (correct) {
      state.correctCount += 1;
      state.triviaStreak += 1;
      addPoints(5, action: 'Pregunta correcta', icon: Icons.psychology);
      if (state.triviaStreak % 3 == 0) {
        addPoints(
          15,
          action: 'Bonus de racha',
          icon: Icons.local_fire_department,
        );
      }
    } else {
      state.triviaStreak = 0;
    }
    save();
    notifyListeners();
    return TriviaResult(correct, question.funFact, state.triviaStreak);
  }

  String get levelName {
    var name = levels.first.name;
    for (final level in levels) {
      if (state.points >= level.minPoints) {
        name = level.name;
      }
    }
    return name;
  }
}

class QuestProgress {
  const QuestProgress(this.completed, this.total);
  final int completed;
  final int total;
  int get percent => total == 0 ? 0 : ((completed / total) * 100).round();
}

class TriviaResult {
  const TriviaResult(this.correct, this.funFact, this.streak);
  final bool correct;
  final String funFact;
  final int streak;
}

class LevelData {
  const LevelData(this.minPoints, this.name, this.icon);
  final int minPoints;
  final String name;
  final String icon;
}

EcoState _defaultState() => EcoState(
      points: 1250,
      rank: 42,
      streak: 3,
      redeemedIds: [],
      activeQuestId: 'bosque-perdido',
      quests: {
        'bosque-perdido': QuestState(
          started: true,
          completedChapters: ['ch1'],
          currentChapter: 'ch2',
        ),
        'oceano-secreto': QuestState(
          started: false,
          completedChapters: [],
          currentChapter: 'ch1',
        ),
      },
      inventory: ['llave-dorada'],
      totalChaptersCompleted: 1,
      creatures: [
        DiscoveredCreature(
          id: 'leaf-fox',
          discoveredAt: '2025-05-20',
          feedCount: 3,
        ),
        DiscoveredCreature(
          id: 'shell-turtle',
          discoveredAt: '2025-05-21',
          feedCount: 1,
        ),
      ],
      answeredIds: [0],
      correctCount: 1,
      triviaStreak: 1,
      history: _defaultHistory(),
    );

List<Map<String, dynamic>> _defaultHistory() => [
      {
        'action': 'Separación correcta',
        'pts': 10,
        'time': 'Hace 5 min',
        'icon': 'recycling',
      },
      {
        'action': 'Envase devuelto',
        'pts': 15,
        'time': 'Hace 20 min',
        'icon': 'package',
      },
      {
        'action': 'Misión diaria completada',
        'pts': 30,
        'time': 'Hace 1h',
        'icon': 'bolt',
      },
      {
        'action': 'Foto subida',
        'pts': 20,
        'time': 'Ayer 13:00',
        'icon': 'camera',
      },
    ];

String historyKeyFor(IconData icon) {
  if (icon == Icons.inventory_2) return 'package';
  if (icon == Icons.bolt || icon == Icons.local_fire_department) return 'bolt';
  if (icon == Icons.camera_alt) return 'camera';
  if (icon == Icons.explore) return 'explore';
  if (icon == Icons.psychology) return 'trivia';
  if (icon == Icons.qr_code_scanner) return 'scan';
  return 'recycling';
}

IconData historyIconFor(Object? raw) {
  final key = raw is String ? raw : _legacyHistoryKey(raw);
  switch (key) {
    case 'package':
      return Icons.inventory_2;
    case 'bolt':
      return Icons.bolt;
    case 'camera':
      return Icons.camera_alt;
    case 'explore':
      return Icons.explore;
    case 'trivia':
      return Icons.psychology;
    case 'scan':
      return Icons.qr_code_scanner;
    case 'recycling':
    default:
      return Icons.recycling;
  }
}

String _legacyHistoryKey(Object? raw) {
  if (raw == Icons.inventory_2.codePoint) return 'package';
  if (raw == Icons.bolt.codePoint) return 'bolt';
  if (raw == Icons.camera_alt.codePoint) return 'camera';
  if (raw == Icons.explore.codePoint) return 'explore';
  if (raw == Icons.psychology.codePoint) return 'trivia';
  if (raw == Icons.qr_code_scanner.codePoint) return 'scan';
  return 'recycling';
}

const levels = [
  LevelData(0, 'Explorador Novato', '🌱'),
  LevelData(100, 'Aventurero', '🗺️'),
  LevelData(300, 'Guardián del Parque', '🛡️'),
  LevelData(600, 'Leyenda Viviente', '⭐'),
];

const adventures = [
  Adventure(
    id: 'bosque-perdido',
    title: 'El Misterio del Bosque Perdido',
    description:
        'Algo extraño ocurre en el corazón del parque. Los guardianes necesitan tu ayuda para descubrir qué está pasando.',
    icon: '🌲',
    chapters: [
      Chapter(
        id: 'ch1',
        title: 'La Primera Pista',
        description:
            'Dicen que cerca del puesto de comida hay algo escondido...',
        type: ChapterType.scan,
        hint: 'Busca la Eco-Estación más cercana a la zona de comida',
        reward: RewardData(points: 50, creature: 'leaf-fox'),
      ),
      Chapter(
        id: 'ch2',
        title: 'El Acertijo del Guardián',
        description:
            'Un antiguo guardián te bloquea el paso. Solo la sabiduría te abrirá el camino.',
        type: ChapterType.trivia,
        hint: 'Responde correctamente para avanzar',
        reward: RewardData(points: 30, item: 'llave-dorada'),
      ),
      Chapter(
        id: 'ch3',
        title: 'El Rastro Oculto',
        description:
            'La llave dorada revela un mapa con 3 puntos marcados en el parque.',
        type: ChapterType.scan,
        hint: 'Encuentra y escanea en 2 Eco-Estaciones diferentes',
        reward: RewardData(points: 60, creature: 'shell-turtle'),
      ),
      Chapter(
        id: 'ch4',
        title: 'La Llamada de la Manada',
        description:
            'No puedes hacerlo solo. Necesitas que tu patrulla complete sus propias misiones.',
        type: ChapterType.group,
        hint: 'Consigue que 2 amigos se unan a tu patrulla',
        reward: RewardData(points: 80, item: 'cristal-aurora'),
      ),
      Chapter(
        id: 'ch5',
        title: 'El Corazón del Bosque',
        description:
            'El capítulo final. El bosque te espera para revelarte su secreto.',
        type: ChapterType.scan,
        hint:
            'Completa un último escaneo para desbloquear el secreto del bosque',
        reward: RewardData(points: 150, creature: 'crystal-deer'),
      ),
    ],
  ),
  Adventure(
    id: 'oceano-secreto',
    title: 'Los Secretos del Océano',
    description:
        'Las aguas del parque esconden criaturas legendarias. ¿Te atreves a buscarlas?',
    icon: '🌊',
    chapters: [
      Chapter(
        id: 'ch1',
        title: 'Susurros del Agua',
        description: 'Las fuentes del parque parecen enviar un mensaje...',
        type: ChapterType.scan,
        hint: 'Visita la Eco-Estación cerca de la zona acuática',
        reward: RewardData(points: 50, creature: 'wave-dolphin'),
      ),
      Chapter(
        id: 'ch2',
        title: 'El Desafío de las Mareas',
        description: 'Para dominar el océano, debes demostrar tu conocimiento.',
        type: ChapterType.trivia,
        hint: 'Responde 3 preguntas sobre la naturaleza',
        reward: RewardData(points: 45, item: 'perla-marina'),
      ),
      Chapter(
        id: 'ch3',
        title: 'Explorador de Profundidades',
        description:
            'Explora todos los rincones del parque para encontrar las corrientes ocultas.',
        type: ChapterType.explore,
        hint: 'Visita 4 zonas diferentes del mapa',
        reward: RewardData(points: 70, creature: 'wise-owl'),
      ),
      Chapter(
        id: 'ch4',
        title: 'La Tormenta Final',
        description:
            'Una gran tormenta amenaza el parque. Solo uniendo fuerzas podrás detenerla.',
        type: ChapterType.group,
        hint: 'Completa 5 escaneos con tu patrulla',
        reward: RewardData(points: 200, creature: 'spark-butterfly'),
      ),
    ],
  ),
];

const creatures = [
  CreatureDef(
    id: 'leaf-fox',
    name: 'Leaf Fox',
    element: 'forest',
    color: AppColors.forest,
    stages: [
      CreatureStage(
        name: 'Cachorro Hoja',
        emoji: '🦊',
        feedRequired: 0,
        description: 'Un pequeño zorro nacido entre las hojas.',
      ),
      CreatureStage(
        name: 'Zorro del Bosque',
        emoji: '🦊',
        feedRequired: 5,
        description: 'Ha crecido y conoce cada rincón del bosque.',
      ),
      CreatureStage(
        name: 'Guardián Forestal',
        emoji: '🦊',
        feedRequired: 15,
        description:
            'Protector legendario del bosque. Su pelaje brilla con luz esmeralda.',
      ),
    ],
  ),
  CreatureDef(
    id: 'shell-turtle',
    name: 'Shell Turtle',
    element: 'earth',
    color: Color(0xFFA16207),
    stages: [
      CreatureStage(
        name: 'Huevo Ancestral',
        emoji: '🥚',
        feedRequired: 0,
        description: 'Un huevo misterioso que late con energía antigua.',
      ),
      CreatureStage(
        name: 'Tortuga Joven',
        emoji: '🐢',
        feedRequired: 5,
        description: 'Lenta pero sabia. Carga secretos en su caparazón.',
      ),
      CreatureStage(
        name: 'Tortuga Ancestral',
        emoji: '🐢',
        feedRequired: 15,
        description: 'Ha vivido siglos. Su caparazón es un mapa del mundo.',
      ),
    ],
  ),
  CreatureDef(
    id: 'wave-dolphin',
    name: 'Wave Dolphin',
    element: 'ocean',
    color: AppColors.ocean,
    stages: [
      CreatureStage(
        name: 'Cría de Olas',
        emoji: '🐬',
        feedRequired: 0,
        description: 'Salta entre las olas con alegría.',
      ),
      CreatureStage(
        name: 'Delfín Viajero',
        emoji: '🐬',
        feedRequired: 5,
        description: 'Ha recorrido todos los mares del parque.',
      ),
      CreatureStage(
        name: 'Delfín Guardián',
        emoji: '🐬',
        feedRequired: 15,
        description: 'Protector de las aguas. Su canto calma las tormentas.',
      ),
    ],
  ),
  CreatureDef(
    id: 'wise-owl',
    name: 'Wise Owl',
    element: 'air',
    color: AppColors.purple,
    stages: [
      CreatureStage(
        name: 'Polluelo Curioso',
        emoji: '🐣',
        feedRequired: 0,
        description: 'Pequeño pero con ojos llenos de preguntas.',
      ),
      CreatureStage(
        name: 'Búho Estudioso',
        emoji: '🦉',
        feedRequired: 5,
        description: 'Lee los vientos y conoce todos los acertijos.',
      ),
      CreatureStage(
        name: 'Búho Sabio',
        emoji: '🦉',
        feedRequired: 15,
        description: 'La criatura más sabia. Sus ojos ven la verdad.',
      ),
    ],
  ),
  CreatureDef(
    id: 'crystal-deer',
    name: 'Crystal Deer',
    element: 'crystal',
    color: AppColors.crystal,
    stages: [
      CreatureStage(
        name: 'Cervatillo Cristal',
        emoji: '🦌',
        feedRequired: 0,
        description: 'Su cornamenta emite destellos tenues.',
      ),
      CreatureStage(
        name: 'Ciervo Prisma',
        emoji: '🦌',
        feedRequired: 5,
        description: 'La luz se refracta en sus cristales creando arcoíris.',
      ),
      CreatureStage(
        name: 'Ciervo Legendario',
        emoji: '🦌',
        feedRequired: 15,
        description:
            'Criatura legendaria. Su presencia purifica todo a su alrededor.',
      ),
    ],
  ),
  CreatureDef(
    id: 'spark-butterfly',
    name: 'Spark Butterfly',
    element: 'light',
    color: Color(0xFFF59E0B),
    stages: [
      CreatureStage(
        name: 'Oruga Chispa',
        emoji: '🐛',
        feedRequired: 0,
        description: 'Pequeña pero llena de energía eléctrica.',
      ),
      CreatureStage(
        name: 'Crisálida Estelar',
        emoji: '🌟',
        feedRequired: 5,
        description: 'Algo mágico está ocurriendo dentro...',
      ),
      CreatureStage(
        name: 'Mariposa Estelar',
        emoji: '🦋',
        feedRequired: 15,
        description:
            'Sus alas brillan con la luz de las estrellas. La más rara de todas.',
      ),
    ],
  ),
];

const rewards = [
  RewardCatalogItem(
    id: 'r1',
    title: 'Palomitas Gratis',
    desc: 'Canjea por unas palomitas pequeñas',
    cost: 40,
    category: 'comida',
    color: [Color(0xFF10B981), Color(0xFF047857)],
    icon: Icons.ramen_dining,
  ),
  RewardCatalogItem(
    id: 'r2',
    title: 'Refresco Mediano',
    desc: 'Bebida refrescante gratis',
    cost: 30,
    category: 'comida',
    color: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
    icon: Icons.local_drink,
  ),
  RewardCatalogItem(
    id: 'r3',
    title: 'Fast Pass Faunia',
    desc: 'Acceso rápido a 1 exhibición',
    cost: 100,
    category: 'fastpass',
    color: [Color(0xFFF59E0B), Color(0xFFD97706)],
    icon: Icons.bolt,
  ),
  RewardCatalogItem(
    id: 'r4',
    title: 'Entrada 50% Parque Warner',
    desc: 'Descuento para tu próxima aventura',
    cost: 250,
    category: 'entradas',
    color: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
    icon: Icons.confirmation_number,
  ),
  RewardCatalogItem(
    id: 'r5',
    title: 'Entrada Parque de Atracciones',
    desc: 'Entrada gratis 1 día',
    cost: 500,
    category: 'entradas',
    color: [Color(0xFF00E676), Color(0xFF00B8D4)],
    icon: Icons.local_activity,
  ),
  RewardCatalogItem(
    id: 'r6',
    title: 'Pin Edición Limitada',
    desc: 'Coleccionable exclusivo del parque',
    cost: 80,
    category: 'colec',
    color: [Color(0xFF2ECC71), Color(0xFF27AE60)],
    icon: Icons.push_pin,
  ),
];

const missions = [
  Mission(
    icon: Icons.recycling,
    title: 'Alimenta a tu criatura 3 veces',
    desc: 'Devuelve 3 envases reutilizables en cualquier punto',
    pts: 30,
    progress: 1,
    total: 3,
    expires: '14:00',
  ),
  Mission(
    icon: Icons.camera_alt,
    title: 'Documenta tu descubrimiento',
    desc: 'Sube evidencia de separación correcta orgánico/plástico',
    pts: 20,
    progress: 0,
    total: 1,
    expires: '18:00',
  ),
  Mission(
    icon: Icons.bolt,
    title: 'Misión Flash: ¡Primer explorador!',
    desc: 'Sé el primero de tu patrulla en escanear hoy',
    pts: 50,
    progress: 0,
    total: 1,
    expires: '12:00',
  ),
  Mission(
    icon: Icons.map,
    title: 'Eco-Explorador',
    desc: 'Recicla en un contenedor con poca actividad',
    pts: 25,
    progress: 0,
    total: 1,
    expires: '20:00',
  ),
  Mission(
    icon: Icons.group,
    title: 'Patrulla unida',
    desc: 'Tu patrulla completa al menos 1 acción cada miembro',
    pts: 40,
    progress: 2,
    total: 5,
    expires: '20:00',
  ),
];

const leaderboard = [
  LeaderboardItem(rank: 1, name: 'Carlos López', pts: 245),
  LeaderboardItem(rank: 2, name: 'Ana Martínez', pts: 220),
  LeaderboardItem(rank: 3, name: 'Luis Rodríguez', pts: 198),
  LeaderboardItem(rank: 4, name: 'Elena Torres', pts: 192),
  LeaderboardItem(rank: 5, name: 'María García', pts: 185, isUser: true),
  LeaderboardItem(rank: 6, name: 'Pedro Sánchez', pts: 172),
  LeaderboardItem(rank: 7, name: 'Laura Vega', pts: 158),
];

const patrolLeaderboard = [
  LeaderboardItem(rank: 1, name: 'Green Avengers', pts: 1240, members: 6),
  LeaderboardItem(
    rank: 2,
    name: 'Eco Warriors',
    pts: 892,
    members: 5,
    isUser: true,
  ),
  LeaderboardItem(rank: 3, name: 'Planet Savers', pts: 780, members: 4),
  LeaderboardItem(rank: 4, name: 'Blue Ocean', pts: 650, members: 5),
];

const trivia = [
  TriviaQuestion(
    id: 0,
    category: 'naturaleza',
    question: '¿Cuántos años tarda en degradarse una botella de plástico?',
    options: ['10 años', '100 años', '450 años'],
    correct: 2,
    funFact:
        'Una botella de plástico tarda unos 450 años en descomponerse. ¡Casi medio milenio!',
  ),
  TriviaQuestion(
    id: 1,
    category: 'naturaleza',
    question: '¿Qué porcentaje del agua del planeta es agua dulce accesible?',
    options: ['25%', 'Menos del 1%', '10%'],
    correct: 1,
    funFact:
        'Solo el 0.5% del agua del planeta es dulce y accesible. ¡Cada gota cuenta!',
  ),
  TriviaQuestion(
    id: 2,
    category: 'curiosidades',
    question:
        '¿Cuántos árboles se necesitan para producir el oxígeno de una persona al año?',
    options: ['2 árboles', '7 árboles', '22 árboles'],
    correct: 1,
    funFact:
        'Se necesitan aproximadamente 7 árboles para producir el oxígeno que respira una persona en un año.',
  ),
  TriviaQuestion(
    id: 3,
    category: 'naturaleza',
    question: '¿Cuál es el animal terrestre más rápido del mundo?',
    options: ['León', 'Guepardo', 'Gacela'],
    correct: 1,
    funFact:
        'El guepardo puede alcanzar velocidades de hasta 120 km/h en sprints cortos.',
  ),
  TriviaQuestion(
    id: 4,
    category: 'medioambiente',
    question: '¿Cuántas veces se puede reciclar el aluminio?',
    options: ['5 veces', '20 veces', 'Infinitas veces'],
    correct: 2,
    funFact:
        'El aluminio se puede reciclar infinitas veces sin perder calidad. ¡Es un material increíble!',
  ),
  TriviaQuestion(
    id: 5,
    category: 'curiosidades',
    question: '¿Qué animal puede dormir hasta 22 horas al día?',
    options: ['Oso perezoso', 'Koala', 'Gato'],
    correct: 1,
    funFact:
        'Los koalas duermen entre 18-22 horas al día porque las hojas de eucalipto les dan muy poca energía.',
  ),
  TriviaQuestion(
    id: 6,
    category: 'medioambiente',
    question: '¿Qué gas es el principal responsable del efecto invernadero?',
    options: ['Oxígeno', 'Dióxido de carbono', 'Nitrógeno'],
    correct: 1,
    funFact:
        'El CO₂ representa más del 75% de las emisiones de gases de efecto invernadero globales.',
  ),
  TriviaQuestion(
    id: 7,
    category: 'curiosidades',
    question:
        '¿Cuántas especies de insectos se estima que existen en el mundo?',
    options: ['100.000', '1 millón', '10 millones'],
    correct: 2,
    funFact:
        'Se estima que existen unos 10 millones de especies de insectos, ¡y solo conocemos 1 millón!',
  ),
  TriviaQuestion(
    id: 8,
    category: 'naturaleza',
    question: '¿Cuál es el océano más grande del planeta?',
    options: ['Atlántico', 'Índico', 'Pacífico'],
    correct: 2,
    funFact:
        'El Pacífico cubre más de 165 millones de km². ¡Es más grande que toda la tierra firme junta!',
  ),
  TriviaQuestion(
    id: 9,
    category: 'medioambiente',
    question: '¿Cuántas bolsas de plástico se usan cada minuto en el mundo?',
    options: ['100.000', '1 millón', '2 millones'],
    correct: 1,
    funFact:
        'Se usan aproximadamente 1 millón de bolsas de plástico por minuto en todo el mundo.',
  ),
  TriviaQuestion(
    id: 10,
    category: 'curiosidades',
    question: '¿Cuánto pesa aproximadamente una ballena azul adulta?',
    options: ['50 toneladas', '100 toneladas', '150 toneladas'],
    correct: 2,
    funFact:
        'Una ballena azul puede pesar hasta 150 toneladas, ¡el animal más grande que ha existido!',
  ),
  TriviaQuestion(
    id: 11,
    category: 'naturaleza',
    question: '¿Qué porcentaje del oxígeno mundial producen los océanos?',
    options: ['20%', '50%', '70%'],
    correct: 2,
    funFact:
        'Los océanos producen alrededor del 70% del oxígeno mundial gracias al fitoplancton.',
  ),
  TriviaQuestion(
    id: 12,
    category: 'medioambiente',
    question:
        '¿Cuántos litros de agua se necesitan para producir una camiseta de algodón?',
    options: ['100 litros', '700 litros', '2.700 litros'],
    correct: 2,
    funFact:
        'Se necesitan unos 2.700 litros de agua para una sola camiseta. ¡La moda tiene huella hídrica!',
  ),
  TriviaQuestion(
    id: 13,
    category: 'curiosidades',
    question: '¿Cuál es el árbol más antiguo del mundo?',
    options: [
      'Un roble de 1.000 años',
      'Un pino de 5.000 años',
      'Un olivo de 3.000 años',
    ],
    correct: 1,
    funFact:
        'El pino Matusalén tiene más de 4.850 años y vive en California. ¡Nació antes de las pirámides!',
  ),
  TriviaQuestion(
    id: 14,
    category: 'naturaleza',
    question: '¿Cuántas hormigas se estima que hay en la Tierra?',
    options: ['1 billón', '10 billones', '20 trillones'],
    correct: 2,
    funFact: 'Se estima que hay unos 20 trillones de hormigas en la Tierra.',
  ),
  TriviaQuestion(
    id: 15,
    category: 'medioambiente',
    question: '¿Qué material tarda más en degradarse?',
    options: ['Lata de aluminio', 'Botella de vidrio', 'Pañal desechable'],
    correct: 1,
    funFact:
        'Una botella de vidrio puede tardar hasta 4.000 años en degradarse, pero se recicla infinitamente.',
  ),
  TriviaQuestion(
    id: 16,
    category: 'curiosidades',
    question: '¿Pueden los pulpos cambiar de color?',
    options: [
      'No, es un mito',
      'Sí, pero solo 2 colores',
      'Sí, miles de combinaciones',
    ],
    correct: 2,
    funFact:
        'Los pulpos tienen células especiales llamadas cromatóforos que les permiten cambiar a miles de patrones.',
  ),
  TriviaQuestion(
    id: 17,
    category: 'naturaleza',
    question:
        '¿Cuántos km puede recorrer una mariposa monarca en su migración?',
    options: ['500 km', '2.000 km', '4.500 km'],
    correct: 2,
    funFact:
        'La mariposa monarca viaja hasta 4.500 km desde Canadá hasta México cada año.',
  ),
];

extension FirstOrNullExtension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

class AppFrame extends StatefulWidget {
  const AppFrame({super.key, required this.store});
  final EcoStore store;

  @override
  State<AppFrame> createState() => _AppFrameState();
}

class _AppFrameState extends State<AppFrame> {
  MainTab tab = MainTab.home;
  bool showDashboard = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.store,
      builder: (context, _) {
        final dark = Theme.of(context).brightness == Brightness.dark;
        final bg = dark ? const Color(0xFF0B1120) : AppColors.bgApp;
        return Scaffold(
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: ColoredBox(
                color: bg,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 82),
                          child: _screen(),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: BottomNav(
                        current: tab,
                        onChanged: (next) {
                          setState(() {
                            showDashboard = false;
                            tab = next;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _screen() {
    if (showDashboard) {
      return DashboardScreen(
        store: widget.store,
        openTrivia: () => _push(TriviaScreen(store: widget.store)),
        openMissions: () => _push(DailyMissionsScreen(store: widget.store)),
        openCreatures: () => setState(() => tab = MainTab.creatures),
      );
    }
    return switch (tab) {
      MainTab.home => HomeScreen(
          store: widget.store,
          openAdventure: () => setState(() => tab = MainTab.adventure),
          openMap: () => _push(MapScreen(store: widget.store)),
          openCreatures: () => setState(() => tab = MainTab.creatures),
          openDashboard: () => setState(() => showDashboard = true),
        ),
      MainTab.adventure => AdventureScreen(
          store: widget.store,
          openHome: () => setState(() => tab = MainTab.home),
          openMap: () => _push(MapScreen(store: widget.store)),
          openTrivia: () => _push(TriviaScreen(store: widget.store)),
        ),
      MainTab.creatures => CreaturesScreen(store: widget.store),
      MainTab.rewards => RewardsScreen(store: widget.store),
      MainTab.profile => ProfileScreen(
          store: widget.store,
          openCreatures: () => setState(() => tab = MainTab.creatures),
        ),
    };
  }

  Future<void> _push(Widget screen) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
    setState(() {});
  }
}

class BottomNav extends StatelessWidget {
  const BottomNav({super.key, required this.current, required this.onChanged});
  final MainTab current;
  final ValueChanged<MainTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 74,
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF151F32) : Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.primary.withOpacity(.12)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          _item(context, MainTab.home, Icons.home_outlined, 'Inicio'),
          _item(context, MainTab.adventure, Icons.explore_outlined, 'Aventura'),
          _item(context, MainTab.creatures, Icons.eco, 'Criaturas'),
          _item(context, MainTab.rewards, Icons.card_giftcard, 'Premios'),
          _item(context, MainTab.profile, Icons.person_outline, 'Perfil'),
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context,
    MainTab item,
    IconData icon,
    String label,
  ) {
    final active = item == current;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () => onChanged(item),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: EdgeInsets.only(
            left: 4,
            right: 4,
            top: active ? 0 : 8,
            bottom: active ? 12 : 8,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 7),
          decoration: BoxDecoration(
            gradient: active ? AppColors.gradient : null,
            borderRadius: BorderRadius.circular(28),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(.28),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 22,
                color: active ? Colors.white : foreground(context),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: active ? Colors.white : foreground(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color foreground(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : AppColors.textDark;

Color midText(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF94A3B8)
        : AppColors.textMid;

Color cardColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF151F32)
        : Colors.white;

class AppScroll extends StatelessWidget {
  const AppScroll({super.key, required this.children, this.padding});
  final List<Widget> children;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: padding ?? const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: children,
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    this.subtitle,
  });

  final String title;
  final Widget? leading;
  final Widget? trailing;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 8)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: midText(context),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class EcoCard extends StatelessWidget {
  const EcoCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.color,
    this.border,
  });
  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final Color? color;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          padding: padding,
          decoration: BoxDecoration(
            color: color ?? cardColor(context),
            borderRadius: BorderRadius.circular(20),
            border: border,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.06),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.gradient = AppColors.gradient,
    this.foreground = Colors.white,
    this.compact = false,
  });

  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final Gradient gradient;
  final Color foreground;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap == null ? .55 : 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onTap,
          child: Ink(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 16 : 22,
              vertical: compact ? 10 : 15,
            ),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(999),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(.25),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: foreground, size: 19),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: foreground,
                      fontWeight: FontWeight.w900,
                      fontSize: compact ? 13 : 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SoftButton extends StatelessWidget {
  const SoftButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.full = false,
  });
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool full;

  @override
  Widget build(BuildContext context) {
    final child = TextButton.icon(
      onPressed: onTap,
      icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 18),
      label: Text(label, textAlign: TextAlign.center),
      style: TextButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: AppColors.primaryDarker,
        textStyle: const TextStyle(fontWeight: FontWeight.w900),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
    );
    return full ? SizedBox(width: double.infinity, child: child) : child;
  }
}

class Badge extends StatelessWidget {
  const Badge(
    this.text, {
    super.key,
    this.color = AppColors.yellow,
    this.textColor,
  });
  final String text;
  final Color color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: textColor ?? color,
        ),
      ),
    );
  }
}

class FloatingEmoji extends StatefulWidget {
  const FloatingEmoji(this.emoji, {super.key, this.size = 42});
  final String emoji;
  final double size;

  @override
  State<FloatingEmoji> createState() => _FloatingEmojiState();
}

class _FloatingEmojiState extends State<FloatingEmoji>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final dy = -10 * Curves.easeInOut.transform(controller.value);
        final angle = (-2 + 4 * controller.value) * math.pi / 180;
        return Transform.translate(
          offset: Offset(0, dy),
          child: Transform.rotate(angle: angle, child: child),
        );
      },
      child: Text(widget.emoji, style: TextStyle(fontSize: widget.size)),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.store,
    required this.openAdventure,
    required this.openMap,
    required this.openCreatures,
    required this.openDashboard,
  });

  final EcoStore store;
  final VoidCallback openAdventure;
  final VoidCallback openMap;
  final VoidCallback openCreatures;
  final VoidCallback openDashboard;

  @override
  Widget build(BuildContext context) {
    final quest = store.activeAdventure!;
    final progress = store.getQuestProgress(quest.id);
    final chapter = store.getCurrentChapter(quest.id);
    final firstCreature = store.state.creatures.firstOrNull;
    final firstStage =
        firstCreature == null ? null : store.creatureStage(firstCreature.id);
    final firstDef = firstCreature == null
        ? null
        : creatures.where((c) => c.id == firstCreature.id).firstOrNull;
    return AppScroll(
      children: [
        TopBar(
          title: 'EcoScanner',
          subtitle: 'Adventures',
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: AppColors.gradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.eco, color: Colors.white),
          ),
          trailing: InkWell(
            onTap: openDashboard,
            child: const FloatingEmoji('🦊', size: 28),
          ),
        ),
        _HomeHero(openAdventure: openAdventure, openMap: openMap),
        const SizedBox(height: 20),
        SectionTitle(icon: Icons.info_outline, title: '¿Cómo funciona?'),
        const SizedBox(height: 12),
        const OnboardStep(
          color: AppColors.yellow,
          icon: Icons.explore,
          title: '1. Elige tu aventura',
          desc: 'Selecciona una quest y sigue las pistas por el parque',
        ),
        const SizedBox(height: 12),
        const OnboardStep(
          color: AppColors.blue,
          icon: Icons.map_outlined,
          title: '2. Explora y juega',
          desc: 'Resuelve acertijos, descubre criaturas y completa misiones',
        ),
        const SizedBox(height: 12),
        const OnboardStep(
          color: AppColors.purple,
          icon: Icons.card_giftcard,
          title: '3. Gana recompensas',
          desc: 'Tus logros en el juego te dan premios reales en el parque',
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            const Expanded(
              child: SectionTitle(title: '🐾 Criaturas por Descubrir'),
            ),
            TextButton(
              onPressed: openCreatures,
              child: const Text(
                'Ver todas →',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
        Text(
          '¿Las encontrarás todas?',
          style: TextStyle(
            color: midText(context),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 172,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              CreatureCard(
                title: firstStage?.name ?? 'Leaf Fox',
                emoji: firstStage?.emoji ?? '🦊',
                level: firstCreature == null
                    ? 1
                    : store.creatureLevel(firstCreature.id) + 1,
                color: firstDef?.color ?? AppColors.forest,
                width: 140,
              ),
              const SizedBox(width: 12),
              const CreatureCard(
                title: '???',
                emoji: '?',
                undiscovered: true,
                width: 140,
              ),
              const SizedBox(width: 12),
              const CreatureCard(
                title: '???',
                emoji: '?',
                undiscovered: true,
                width: 140,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SectionTitle(
          icon: Icons.explore,
          title: 'Tu Aventura Activa',
          color: AppColors.yellow,
        ),
        const SizedBox(height: 12),
        QuestCard(
          icon: quest.icon,
          title: quest.title,
          chapters: '${progress.completed}/${progress.total}',
          percent: progress.percent,
          hint: 'Siguiente: ${chapter?.title ?? 'Aventura completada'}',
          onTap: openAdventure,
        ),
        const SizedBox(height: 24),
        EcoCard(
          border: Border.all(
            color: AppColors.primary.withOpacity(.25),
            width: 2,
          ),
          child: Column(
            children: [
              const Text('📷', style: TextStyle(fontSize: 36)),
              const SizedBox(height: 6),
              const Text(
                'Escáner Rápido',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              Text(
                'Escanea directamente para alimentar a tus criaturas',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: midText(context),
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 16),
              SoftButton(
                label: 'Abrir Escáner',
                icon: Icons.qr_code_scanner,
                full: true,
                onTap: () => showScannerSheet(context, store),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Sin descargas. Sin registros. Solo explora y juega. 🌿',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: midText(context),
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _HomeHero extends StatelessWidget {
  const _HomeHero({required this.openAdventure, required this.openMap});
  final VoidCallback openAdventure;
  final VoidCallback openMap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: BoxDecoration(
        gradient: AppColors.gradient,
        borderRadius: BorderRadius.circular(36),
      ),
      child: Stack(
        children: [
          Positioned(right: -50, top: -60, child: _softCircle(180)),
          Positioned(left: -50, bottom: -70, child: _softCircle(140)),
          Column(
            children: [
              const Text(
                '🗺️ Tu Aventura en el Parque Comienza Aquí',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Explora, descubre criaturas y desbloquea recompensas mientras haces del parque un lugar mejor',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 18),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingEmoji('🦊'),
                  SizedBox(width: 18),
                  FloatingEmoji('🐢'),
                  SizedBox(width: 18),
                  FloatingEmoji('🦉'),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _glassButton(
                      '🗺️ Empezar Aventura',
                      openAdventure,
                      Colors.white.withOpacity(.20),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _glassButton(
                      '📍 Ver Mapa',
                      openMap,
                      Colors.black.withOpacity(.20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _glassButton(String label, VoidCallback onTap, Color color) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withOpacity(.35), width: 1.5),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

Widget _softCircle(double size) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(.10),
      ),
    );

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.icon,
    this.color = AppColors.primary,
  });
  final String title;
  final IconData? icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }
}

class OnboardStep extends StatelessWidget {
  const OnboardStep({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    required this.desc,
  });
  final Color color;
  final IconData icon;
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return EcoCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(.16),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  desc,
                  style: TextStyle(
                    color: midText(context),
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CreatureCard extends StatelessWidget {
  const CreatureCard({
    super.key,
    required this.title,
    required this.emoji,
    this.level,
    this.color = AppColors.forest,
    this.undiscovered = false,
    this.width,
    this.onTap,
  });

  final String title;
  final String emoji;
  final int? level;
  final Color color;
  final bool undiscovered;
  final double? width;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: undiscovered ? const Color(0xFF1A1A2E) : null,
              gradient: undiscovered
                  ? null
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [color, Color.lerp(color, Colors.black, .18)!],
                    ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                Center(
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(undiscovered ? .08 : .28),
                    ),
                  ),
                ),
                if (level != null && !undiscovered)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.25),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Nv. $level',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                Center(
                  child: undiscovered
                      ? Text(
                          emoji,
                          style: TextStyle(
                            fontSize: 52,
                            color: Colors.white.withOpacity(.25),
                            fontWeight: FontWeight.w900,
                          ),
                        )
                      : FloatingEmoji(emoji, size: 54),
                ),
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 14,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: undiscovered
                          ? Colors.white.withOpacity(.38)
                          : Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuestCard extends StatelessWidget {
  const QuestCard({
    super.key,
    required this.icon,
    required this.title,
    required this.chapters,
    required this.percent,
    required this.hint,
    this.onTap,
  });
  final String icon;
  final String title;
  final String chapters;
  final int percent;
  final String hint;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return EcoCard(
      onTap: onTap,
      border: const Border(left: BorderSide(color: AppColors.yellow, width: 4)),
      child: Column(
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Badge(chapters, color: AppColors.yellow),
            ],
          ),
          const SizedBox(height: 12),
          ProgressLine(percent: percent, color: AppColors.yellow),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  hint,
                  style: TextStyle(
                    color: midText(context),
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
              const Badge('Continuar aventura', color: AppColors.yellow),
            ],
          ),
        ],
      ),
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    super.key,
    required this.percent,
    this.color = AppColors.primary,
    this.background,
  });
  final int percent;
  final Color color;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 6,
        color: background ?? color.withOpacity(.14),
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: percent.clamp(0, 100) / 100,
            child: Container(color: color),
          ),
        ),
      ),
    );
  }
}

Future<void> showScannerSheet(BuildContext context, EcoStore store) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => ScannerSheet(store: store),
  );
}

class ScannerSheet extends StatefulWidget {
  const ScannerSheet({super.key, required this.store});
  final EcoStore store;

  @override
  State<ScannerSheet> createState() => _ScannerSheetState();
}

class _ScannerSheetState extends State<ScannerSheet> {
  String mode = 'idle';
  bool bbox = false;

  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ModalHandle(onClose: () => Navigator.pop(context)),
          Text(
            _title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 18),
          if (mode != 'error') _scannerFrame() else const SizedBox(height: 12),
          const SizedBox(height: 18),
          Text(
            _description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: mode == 'error'
                  ? AppColors.red
                  : (mode == 'success' ? AppColors.primary : midText(context)),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 22),
          if (mode == 'idle')
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: GradientButton(
                    label: 'Simular Éxito',
                    onTap: _success,
                  ),
                ),
                const SizedBox(height: 12),
                SoftButton(
                  label: 'Simular Error',
                  full: true,
                  onTap: () => setState(() => mode = 'error'),
                ),
              ],
            )
          else if (mode == 'error')
            SizedBox(
              width: double.infinity,
              child: GradientButton(
                label: 'Reintentar',
                onTap: () => setState(() => mode = 'idle'),
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.all(10),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  String get _title {
    if (mode == 'error') return 'Error de Cámara';
    if (mode == 'analyzing') return 'Analizando con IA...';
    if (mode == 'success') return '¡Material detectado!';
    return 'Escanear Contenedor';
  }

  String get _description {
    if (mode == 'error')
      return 'No pudimos acceder a tu cámara. Por favor verifica los permisos del navegador e inténtalo de nuevo.';
    if (mode == 'analyzing') return 'Identificando tipo de material...';
    if (mode == 'success') return 'Plástico PET listo para reciclar.';
    return 'Busca los códigos QR en las bandejas o contenedores de reciclaje.';
  }

  Widget _scannerFrame() {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: AppColors.primary, width: 2.5),
        ),
        child: Stack(
          children: [
            const Center(
              child: Icon(
                Icons.camera_alt,
                size: 58,
                color: AppColors.primaryDark,
              ),
            ),
            const _ScanLine(),
            if (bbox)
              Positioned(
                top: mode == 'success' ? 40 : 55,
                left: mode == 'success' ? 84 : 55,
                width: mode == 'success' ? 112 : 168,
                height: mode == 'success' ? 196 : 168,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(.10),
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Transform.translate(
                      offset: const Offset(0, 26),
                      child: const Badge(
                        'Botella (98%)',
                        color: AppColors.primary,
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _success() {
    setState(() {
      mode = 'analyzing';
      bbox = true;
    });
    Timer(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() => mode = 'success');
      Timer(const Duration(milliseconds: 1200), () {
        if (!mounted) return;
        widget.store.addPoints(
          50,
          action: 'Material reciclado',
          icon: Icons.qr_code_scanner,
        );
        Navigator.pop(context);
        showSuccessDialog(
          context,
          '¡Bien hecho!',
          'Has ganado 50 Eco-Puntos. ¡Tu criatura ha sido alimentada!',
        );
      });
    });
  }
}

class _ScanLine extends StatefulWidget {
  const _ScanLine();

  @override
  State<_ScanLine> createState() => _ScanLineState();
}

class _ScanLineState extends State<_ScanLine>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Positioned(
          left: 16,
          right: 16,
          top: 24 + (controller.value * 220),
          child: Container(
            height: 2,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.primary,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ModalContainer extends StatelessWidget {
  const ModalContainer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20,
        10,
        20,
        28 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: cardColor(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(top: false, child: child),
    );
  }
}

class ModalHandle extends StatelessWidget {
  const ModalHandle({super.key, this.onClose});
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 4, bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.35),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        if (onClose != null)
          Positioned(
            right: 0,
            top: 0,
            child: IconButton.filledTonal(
              onPressed: onClose,
              icon: const Icon(Icons.close),
            ),
          ),
      ],
    );
  }
}

void showSuccessDialog(BuildContext context, String title, String message) {
  showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      icon: const Icon(Icons.celebration, color: AppColors.primary, size: 54),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.w900),
      ),
      content: Text(message, textAlign: TextAlign.center),
      actions: [
        SizedBox(
          width: double.infinity,
          child: GradientButton(
            label: '¡Genial!',
            onTap: () => Navigator.pop(context),
          ),
        ),
      ],
    ),
  );
}

class AdventureScreen extends StatelessWidget {
  const AdventureScreen({
    super.key,
    required this.store,
    required this.openHome,
    required this.openMap,
    required this.openTrivia,
  });
  final EcoStore store;
  final VoidCallback openHome;
  final VoidCallback openMap;
  final VoidCallback openTrivia;

  @override
  Widget build(BuildContext context) {
    final quest = store.activeAdventure!;
    final progress = store.getQuestProgress(quest.id);
    final chapter = store.getCurrentChapter(quest.id);
    final questState = store.state.quests[quest.id]!;
    final companion = store.state.creatures.firstOrNull;
    final companionStage =
        companion == null ? null : store.creatureStage(companion.id);
    return AppScroll(
      children: [
        TopBar(
          title: 'Aventura',
          leading: IconButton(
            onPressed: openHome,
            icon: const Icon(Icons.arrow_back),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: openMap,
                icon: const Icon(Icons.map_outlined, color: AppColors.primary),
              ),
              const Icon(
                Icons.inventory_2_outlined,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
        QuestHero(
          quest: quest,
          progress: progress,
          companion: companionStage?.emoji ?? '🦊',
        ),
        const SizedBox(height: 22),
        const SectionTitle(title: 'Capítulo Actual'),
        const SizedBox(height: 12),
        if (chapter == null)
          _completedAdventure(context)
        else
          _chapterCard(context, quest, chapter),
        const SizedBox(height: 24),
        const SectionTitle(title: 'Línea de Tiempo'),
        const SizedBox(height: 14),
        ...quest.chapters.map((ch) {
          final completed = questState.completedChapters.contains(ch.id);
          final active = questState.currentChapter == ch.id;
          return ChapterNode(chapter: ch, completed: completed, active: active);
        }),
        const SizedBox(height: 18),
        const SectionTitle(title: '🎒 Tu Inventario'),
        const SizedBox(height: 12),
        EcoCard(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: store.state.inventory.isEmpty
                ? [
                    Text(
                      'Aún no tienes objetos. Completa misiones para conseguirlos.',
                      style: TextStyle(
                        color: midText(context),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ]
                : store.state.inventory
                    .map(
                      (item) => Badge(
                        item.replaceAll('-', ' '),
                        color: AppColors.primary,
                      ),
                    )
                    .toList(),
          ),
        ),
        const SizedBox(height: 22),
        const SectionTitle(title: 'Más Aventuras'),
        const SizedBox(height: 12),
        EcoCard(
          child: Row(
            children: [
              Text(
                quest.id == 'bosque-perdido' ? '🌊' : '🌲',
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quest.id == 'bosque-perdido'
                          ? 'Los Secretos del Océano'
                          : 'El Misterio del Bosque Perdido',
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    Text(
                      'Próximamente disponible',
                      style: TextStyle(color: midText(context), fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Badge('Bloqueada', color: AppColors.textMuted),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chapterCard(BuildContext context, Adventure quest, Chapter chapter) {
    return EcoCard(
      border: const Border(left: BorderSide(color: AppColors.yellow, width: 4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            chapter.title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            chapter.description,
            style: TextStyle(
              color: midText(context),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.yellow.withOpacity(.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb, color: AppColors.yellow),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    chapter.hint,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                'RECOMPENSA:',
                style: TextStyle(
                  color: midText(context),
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                ),
              ),
              const Spacer(),
              if (chapter.reward.points > 0)
                Badge('+${chapter.reward.points} pts', color: AppColors.yellow),
              if (chapter.reward.item != null) ...[
                const SizedBox(width: 6),
                Badge(
                  chapter.reward.item!.replaceAll('-', ' '),
                  color: AppColors.primary,
                ),
              ],
              if (chapter.reward.creature != null) ...[
                const SizedBox(width: 6),
                Text(
                  creatures
                      .where((c) => c.id == chapter.reward.creature)
                      .first
                      .stages
                      .first
                      .emoji,
                  style: const TextStyle(fontSize: 22),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: GradientButton(
              label: _chapterAction(chapter.type).$1,
              icon: _chapterAction(chapter.type).$2,
              onTap: () => _runChapterAction(context, quest, chapter),
            ),
          ),
        ],
      ),
    );
  }

  Widget _completedAdventure(BuildContext context) {
    return EcoCard(
      child: Column(
        children: [
          const Text('🏆', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 8),
          const Text(
            '¡Aventura Completada!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(
            'Has terminado todas las misiones de esta aventura.',
            style: TextStyle(color: midText(context)),
          ),
        ],
      ),
    );
  }

  (String, IconData) _chapterAction(ChapterType type) {
    return switch (type) {
      ChapterType.scan => ('Ir a Escanear', Icons.qr_code_scanner),
      ChapterType.trivia => ('Responder Acertijo', Icons.psychology),
      ChapterType.explore => ('Explorar Mapa', Icons.map_outlined),
      ChapterType.group => ('Invitar Amigos', Icons.group_add),
    };
  }

  void _runChapterAction(
    BuildContext context,
    Adventure quest,
    Chapter chapter,
  ) {
    switch (chapter.type) {
      case ChapterType.scan:
        showScannerSheet(context, store);
      case ChapterType.trivia:
        openTrivia();
      case ChapterType.explore:
        openMap();
      case ChapterType.group:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Enlace de invitación copiado!')),
        );
    }
  }
}

class QuestHero extends StatelessWidget {
  const QuestHero({
    super.key,
    required this.quest,
    required this.progress,
    required this.companion,
  });
  final Adventure quest;
  final QuestProgress progress;
  final String companion;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDarker, Color(0xFF004D40)],
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            top: -50,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.yellow.withOpacity(.10),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  Text(quest.icon, style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quest.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            height: 1.15,
                          ),
                        ),
                        Text(
                          '${progress.completed}/${progress.total} capítulos completados',
                          style: TextStyle(
                            color: Colors.white.withOpacity(.9),
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ProgressLine(
                percent: progress.percent,
                color: Colors.white,
                background: Colors.white.withOpacity(.20),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Badge(
                    'Compañero',
                    color: Colors.white,
                    textColor: Colors.white,
                  ),
                  const Spacer(),
                  FloatingEmoji(companion, size: 30),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChapterNode extends StatelessWidget {
  const ChapterNode({
    super.key,
    required this.chapter,
    required this.completed,
    required this.active,
  });
  final Chapter chapter;
  final bool completed;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = completed
        ? AppColors.primary
        : (active ? AppColors.yellow : const Color(0xFFCBD5E1));
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color: AppColors.yellow.withOpacity(.35),
                            blurRadius: 12,
                          ),
                        ]
                      : null,
                ),
                child: completed
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : active
                        ? Center(
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.lock,
                            color: Color(0xFF94A3B8),
                            size: 17,
                          ),
              ),
              Container(width: 2, height: 62, color: color.withOpacity(.45)),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: EcoCard(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chapter.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: completed || active
                                ? foreground(context)
                                : foreground(context).withOpacity(.55),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          chapter.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: midText(context),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                      switch (chapter.type) {
                        ChapterType.scan => Icons.qr_code_scanner,
                        ChapterType.trivia => Icons.psychology,
                        ChapterType.explore => Icons.map_outlined,
                        ChapterType.group => Icons.group,
                      },
                      color: midText(context)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CreaturesScreen extends StatefulWidget {
  const CreaturesScreen({super.key, required this.store});
  final EcoStore store;

  @override
  State<CreaturesScreen> createState() => _CreaturesScreenState();
}

class _CreaturesScreenState extends State<CreaturesScreen> {
  String? featuredId;

  @override
  void initState() {
    super.initState();
    featuredId = widget.store.state.creatures.firstOrNull?.id;
  }

  @override
  Widget build(BuildContext context) {
    featuredId ??= widget.store.state.creatures.firstOrNull?.id;
    final featured = featuredId == null
        ? null
        : widget.store.state.creatures
            .where((c) => c.id == featuredId)
            .firstOrNull;
    final def = featured == null
        ? null
        : creatures.where((c) => c.id == featured.id).firstOrNull;
    final stage =
        featured == null ? null : widget.store.creatureStage(featured.id);
    final level =
        featured == null ? 0 : widget.store.creatureLevel(featured.id);
    final progress =
        featured == null ? 0 : _creatureProgress(featured.feedCount, level);
    return AppScroll(
      children: [
        TopBar(
          title: 'Tus Criaturas',
          trailing: Badge(
            '${widget.store.state.creatures.length}/${creatures.length}',
            color: AppColors.yellow,
          ),
        ),
        if (featured != null && def != null && stage != null) ...[
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [def.color, Color.lerp(def.color, Colors.black, .55)!],
              ),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              children: [
                FloatingEmoji(stage.emoji, size: 64),
                Badge(stage.name, color: Colors.white, textColor: Colors.white),
                const SizedBox(height: 8),
                Text(
                  def.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stage.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(.9),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 22),
                ProgressLine(
                  percent: progress,
                  color: Colors.white,
                  background: Colors.white.withOpacity(.20),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: GradientButton(
                    label:
                        level >= 2 ? 'Evolución Máxima' : 'Alimentar (10 pts)',
                    icon: level >= 2 ? Icons.check : Icons.apple,
                    gradient: const LinearGradient(
                      colors: [Colors.white, Colors.white],
                    ),
                    foreground: def.color,
                    onTap: level >= 2 ? null : () => _feed(featured.id),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
        const SectionTitle(title: 'Colección Completa'),
        const SizedBox(height: 12),
        GridView.builder(
          itemCount: creatures.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 3 / 4,
          ),
          itemBuilder: (context, index) {
            final creature = creatures[index];
            final discovered = widget.store.isCreatureDiscovered(creature.id);
            if (!discovered) {
              return CreatureCard(
                title: 'Sin descubrir',
                emoji: '?',
                undiscovered: true,
                onTap: () => _message(
                  '¡Completa aventuras para descubrir esta criatura!',
                ),
              );
            }
            final stage = widget.store.creatureStage(creature.id)!;
            return CreatureCard(
              title: creature.name,
              emoji: stage.emoji,
              level: widget.store.creatureLevel(creature.id) + 1,
              color: creature.color,
              onTap: () {
                setState(() => featuredId = creature.id);
                _showCreatureDetail(creature.id);
              },
            );
          },
        ),
        const SizedBox(height: 24),
        const SectionTitle(title: '¿Cómo descubrir más?'),
        const SizedBox(height: 12),
        EcoCard(
          child: Column(
            children: [
              _tip(
                context,
                '🗺️',
                'Completa aventuras para desbloquear criaturas nuevas.',
              ),
              _tip(
                context,
                '📷',
                'Escanea en Eco-Estaciones para ganar puntos y alimentarlas.',
              ),
              _tip(
                context,
                '🧠',
                'Responde trivias para ganar alimento rápido.',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tip(BuildContext context, String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  int _creatureProgress(int feed, int level) {
    if (level == 0) return ((feed / 5) * 33).round().clamp(0, 33);
    if (level == 1)
      return (33 + (((feed - 5) / 10) * 33)).round().clamp(33, 66);
    return 100;
  }

  void _feed(String id) {
    final oldLevel = widget.store.creatureLevel(id);
    if (!widget.store.spendPoints(10)) {
      _message(
        '¡No tienes suficientes puntos! Necesitas 10 puntos para alimentar.',
      );
      return;
    }
    widget.store.feedCreature(id);
    final newLevel = widget.store.creatureLevel(id);
    setState(() {});
    if (newLevel > oldLevel) {
      showSuccessDialog(
        context,
        '¡INCREÍBLE!',
        'Tu criatura ha evolucionado al Nivel ${newLevel + 1}!',
      );
    }
  }

  void _showCreatureDetail(String id) {
    final def = creatures.where((c) => c.id == id).first;
    final stateCreature =
        widget.store.state.creatures.where((c) => c.id == id).first;
    final stage = widget.store.creatureStage(id)!;
    final level = widget.store.creatureLevel(id);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ModalContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ModalHandle(onClose: () => Navigator.pop(context)),
            FloatingEmoji(stage.emoji, size: 78),
            Text(
              def.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            Badge(stage.name, color: AppColors.yellow),
            const SizedBox(height: 12),
            Text(
              stage.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: midText(context),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: EcoCard(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text(
                          'Elemento'.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            color: midText(context),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '● ${def.element.toUpperCase()}',
                          style: TextStyle(
                            color: def.color,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: EcoCard(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text(
                          'Alimentado'.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            color: midText(context),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${stateCreature.feedCount} veces',
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: GradientButton(
                label: level >= 2 ? 'Evolución Máxima' : 'Alimentar (10 pts)',
                icon: level >= 2 ? Icons.check : Icons.apple,
                onTap: level >= 2
                    ? null
                    : () {
                        Navigator.pop(context);
                        _feed(id);
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key, required this.store});
  final EcoStore store;

  @override
  Widget build(BuildContext context) {
    return AppScroll(
      children: [
        Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.yellow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.card_giftcard, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Premios de Aventurero',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                  height: 1.05,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Tus hazañas en el parque te otorgan recompensas reales.',
          style: TextStyle(
            color: midText(context),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: Badge(
            '${store.state.points} pts',
            color: AppColors.yellow,
            textColor: Colors.white,
          ),
        ),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: const [
              Badge('Todos', color: AppColors.yellow, textColor: Colors.white),
              SizedBox(width: 8),
              Badge('Comida', color: AppColors.primary),
              SizedBox(width: 8),
              Badge('Fast Pass', color: AppColors.purple),
              SizedBox(width: 8),
              Badge('Merch', color: AppColors.orange),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...rewards.map(
          (reward) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: RewardCard(store: store, reward: reward),
          ),
        ),
      ],
    );
  }
}

class RewardCard extends StatelessWidget {
  const RewardCard({super.key, required this.store, required this.reward});
  final EcoStore store;
  final RewardCatalogItem reward;

  @override
  Widget build(BuildContext context) {
    final canAfford = store.state.points >= reward.cost;
    final redeemed = store.state.redeemedIds.contains(reward.id);
    return EcoCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            height: 100,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: reward.color,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(reward.icon, color: Colors.white, size: 42),
                const Spacer(),
                Badge(
                  reward.category,
                  color: Colors.white,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reward.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  reward.desc,
                  style: TextStyle(
                    color: midText(context),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.yellow),
                    const SizedBox(width: 5),
                    Text(
                      '${reward.cost}',
                      style: TextStyle(
                        fontSize: 18,
                        color: canAfford
                            ? foreground(context)
                            : AppColors.textMuted,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      ' pts',
                      style: TextStyle(
                        color: midText(context),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    GradientButton(
                      label: redeemed ? 'Canjeado' : 'Canjear',
                      icon: redeemed ? Icons.check : Icons.bolt,
                      compact: true,
                      gradient: LinearGradient(
                        colors: (canAfford && !redeemed)
                            ? [AppColors.yellow, const Color(0xFFF59E0B)]
                            : [AppColors.primaryLight, AppColors.primaryLight],
                      ),
                      foreground: (canAfford && !redeemed)
                          ? Colors.white
                          : AppColors.primaryDarker,
                      onTap: (canAfford && !redeemed)
                          ? () => _confirm(context)
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirm(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => ModalContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ModalHandle(onClose: () => Navigator.pop(context)),
            Icon(reward.icon, color: AppColors.yellow, size: 60),
            const SizedBox(height: 12),
            Text(
              reward.title,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text(
              '¿Confirmas el canjeo por ${reward.cost} pts?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: midText(context),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Te quedarán ${store.state.points - reward.cost} pts.',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: SoftButton(
                    label: 'Cancelar',
                    onTap: () => Navigator.pop(context),
                    full: true,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GradientButton(
                    label: 'Canjear',
                    gradient: const LinearGradient(
                      colors: [AppColors.yellow, Color(0xFFF59E0B)],
                    ),
                    onTap: () {
                      if (store.redeemReward(reward.id, reward.cost)) {
                        Navigator.pop(context);
                        showSuccessDialog(
                          context,
                          'Premio canjeado',
                          '${reward.title} está listo para usar.',
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.store,
    required this.openCreatures,
  });
  final EcoStore store;
  final VoidCallback openCreatures;

  @override
  Widget build(BuildContext context) {
    final companion = store.state.creatures.firstOrNull;
    final stage = companion == null ? null : store.creatureStage(companion.id);
    final def = companion == null
        ? null
        : creatures.where((c) => c.id == companion.id).firstOrNull;
    final level = companion == null ? 0 : store.creatureLevel(companion.id);
    final progress =
        companion == null ? 0 : _creatureProgress(companion.feedCount, level);
    final pts = store.state.points;
    return AppScroll(
      children: [
        TopBar(
          title: 'Tu Perfil',
          trailing: IconButton.filledTonal(
            onPressed: store.toggleDark,
            icon: Icon(store.darkMode ? Icons.light_mode : Icons.dark_mode),
          ),
        ),
        EcoCard(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: AppColors.gradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.star,
                      color: Color(0xFFFFD700),
                      size: 34,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'María García',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            IconButton.filledTonal(
                              onPressed: () =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Perfil compartido'),
                                ),
                              ),
                              icon: const Icon(Icons.share),
                            ),
                          ],
                        ),
                        Wrap(
                          spacing: 10,
                          runSpacing: 4,
                          children: [
                            Text(
                              '🏅 Ranking #${store.state.rank}',
                              style: TextStyle(
                                color: midText(context),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              '🍃 $pts puntos',
                              style: TextStyle(
                                color: midText(context),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              EcoCard(
                onTap: openCreatures,
                border: const Border(
                  left: BorderSide(color: AppColors.yellow, width: 4),
                ),
                child: Row(
                  children: [
                    FloatingEmoji(stage?.emoji ?? '🥚', size: 54),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Tu Compañero',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textMuted,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'Ver colección →',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Badge(
                            stage?.name ?? 'Sin descubrir',
                            color: AppColors.yellow,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            def?.name ?? 'Empieza una aventura',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ProgressLine(
                            percent: progress,
                            color: def?.color ?? AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const SectionTitle(title: 'Tu Progreso'),
        const SizedBox(height: 12),
        EcoCard(
          color: AppColors.yellow.withOpacity(.06),
          border: Border.all(color: AppColors.yellow.withOpacity(.22)),
          child: Column(
            children: [
              _profileRow(
                context,
                Icons.map_outlined,
                'Capítulos Completados',
                'En todas tus aventuras',
                '${store.state.totalChaptersCompleted}',
                AppColors.yellow,
              ),
              Divider(color: Colors.black.withOpacity(.06)),
              _profileRow(
                context,
                Icons.inventory_2_outlined,
                'Objetos en Inventario',
                '',
                '${store.state.inventory.length}',
                AppColors.primary,
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const SectionTitle(
          icon: Icons.eco,
          title: 'Tu Impacto Real',
          color: AppColors.primaryDarker,
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.35,
          children: const [
            StatCard(
              color: [Color(0xFF00A1FF), Color(0xFF007AFF)],
              value: '12',
              label: 'Envases Devueltos',
              icon: Icons.inventory_2,
            ),
            StatCard(
              color: [Color(0xFF34C759), Color(0xFF28A745)],
              value: '28',
              label: 'Residuos Separados',
              icon: Icons.eco,
            ),
            StatCard(
              color: [Color(0xFFAF52DE), Color(0xFFFF2D55)],
              value: '4.3 kg',
              label: 'Kg Reciclados',
              icon: Icons.trending_up,
            ),
            StatCard(
              color: [Color(0xFFFF9500), Color(0xFFFFCC00)],
              value: '3',
              label: 'Días Activos',
              icon: Icons.calendar_today,
            ),
          ],
        ),
        const SizedBox(height: 22),
        EcoCard(
          color: cardColor(context),
          border: Border.all(
            color: AppColors.primary.withOpacity(.2),
            width: 2,
          ),
          child: Column(
            children: [
              const Text(
                '🌍 Eco-Oracle',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              Text(
                'El impacto acumulado de tus acciones equivale a los siguientes beneficios ambientales reales:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: midText(context),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 14),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  OracleItem(
                    icon: Icons.park,
                    value: '${pts ~/ 100}',
                    label: 'Árboles Plantados',
                  ),
                  OracleItem(
                    icon: Icons.water_drop,
                    value: '${(pts * .8).floor()}',
                    label: 'Litros Agua Ahorrados',
                  ),
                  OracleItem(
                    icon: Icons.cloud,
                    value: (pts * .05).toStringAsFixed(1),
                    label: 'Kg CO₂ Evitados',
                  ),
                  OracleItem(
                    icon: Icons.bolt,
                    value: (pts * .2).toStringAsFixed(1),
                    label: 'kWh Energía Ahorrada',
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const SectionTitle(title: 'Historial de Actividad'),
        const SizedBox(height: 12),
        EcoCard(
          child: Column(
            children: store.state.history.map((h) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 9),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        historyIconFor(h['icon']),
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            h['action'].toString(),
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          Text(
                            h['time'].toString(),
                            style: TextStyle(
                              color: midText(context),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '+${h['pts']}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  int _creatureProgress(int feed, int level) {
    if (level == 0) return ((feed / 5) * 33).round().clamp(0, 33);
    if (level == 1)
      return (33 + (((feed - 5) / 10) * 33)).round().clamp(33, 66);
    return 100;
  }

  Widget _profileRow(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: TextStyle(color: midText(context), fontSize: 11),
                ),
            ],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 23,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.color,
    required this.value,
    required this.label,
    required this.icon,
  });
  final List<Color> color;
  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: color,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(.9),
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class OracleItem extends StatelessWidget {
  const OracleItem({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primary, size: 28),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.primaryDarker,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textMid,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class TriviaScreen extends StatefulWidget {
  const TriviaScreen({super.key, required this.store});
  final EcoStore store;

  @override
  State<TriviaScreen> createState() => _TriviaScreenState();
}

class _TriviaScreenState extends State<TriviaScreen> {
  late TriviaQuestion question;
  TriviaResult? result;

  @override
  void initState() {
    super.initState();
    question = widget.store.randomQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: SafeArea(
            child: AppScroll(
              children: [
                TopBar(
                  title: 'Anti-Cola Games 🎮',
                  leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.chevron_left),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _stat(
                      context,
                      'Racha',
                      '${widget.store.state.triviaStreak} 🔥',
                      AppColors.yellow,
                    ),
                    _divider(),
                    _stat(
                      context,
                      'Respondidas',
                      '${widget.store.state.answeredIds.length}/${trivia.length}',
                      foreground(context),
                    ),
                    _divider(),
                    _stat(
                      context,
                      'Correctas',
                      '${widget.store.state.correctCount}',
                      AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 34),
                if (result == null) _questionView() else _resultView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _stat(BuildContext context, String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: midText(context),
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _divider() =>
      Container(width: 1, height: 24, color: Colors.black.withOpacity(.10));

  Widget _questionView() {
    return Column(
      children: [
        Badge(question.category.toUpperCase(), color: AppColors.purple),
        const SizedBox(height: 14),
        Text(
          question.question,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 22),
        ...question.options.asMap().entries.map((entry) {
          final letters = ['A', 'B', 'C'];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => setState(
                  () =>
                      result = widget.store.answerQuestion(question, entry.key),
                ),
                style: OutlinedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  foregroundColor: foreground(context),
                  side: BorderSide(color: AppColors.primaryLight, width: 2),
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                child: Text('${letters[entry.key]})  ${entry.value}'),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _resultView() {
    final res = result!;
    return Column(
      children: [
        Icon(
          res.correct ? Icons.celebration : Icons.cancel_outlined,
          color: res.correct ? AppColors.primary : AppColors.red,
          size: 70,
        ),
        const SizedBox(height: 8),
        Text(
          res.correct ? '¡Correcto!' : '¡Uy! Casi.',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: res.correct ? AppColors.primary : AppColors.red,
          ),
        ),
        const SizedBox(height: 18),
        EcoCard(
          color: Colors.black.withOpacity(.03),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lightbulb, color: AppColors.yellow),
                  SizedBox(width: 8),
                  Text(
                    '¿Sabías que...?',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                res.funFact,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: midText(context),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        if (res.correct && res.streak > 0 && res.streak % 3 == 0) ...[
          const SizedBox(height: 14),
          Badge(
            '🔥 ¡Racha de ${3}! +15 pts bonus',
            color: AppColors.yellow,
            textColor: Colors.white,
          ),
        ],
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: GradientButton(
            label: 'Siguiente Pregunta',
            onTap: () => setState(() {
              question = widget.store.randomQuestion();
              result = null;
            }),
          ),
        ),
      ],
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.store});
  final EcoStore store;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapZone? selected;

  final zones = const [
    MapZone(
      'polos',
      'Ecosistema de los Polos',
      'Zona de Criaturas',
      AppColors.ocean,
      Icons.water_drop,
      'A 180m',
      'Hogar de los pingüinos. Escanea los contenedores de esta zona con forma de iglú para conseguir alimento Ice para tus criaturas de agua.',
      'Escanear aquí',
      .15,
      .35,
    ),
    MapZone(
      'jungla',
      'La Jungla Amazónica',
      'Misión Activa',
      AppColors.yellow,
      Icons.explore,
      'A 50m',
      'Siente el clima tropical. El tucán ha escondido una pista cerca del área de manatíes. Ve a investigar.',
      'Ver Misión',
      .40,
      .65,
    ),
    MapZone(
      'africano',
      'Bosque Africano',
      'Zona de Criaturas',
      AppColors.forest,
      Icons.eco,
      'A 120m',
      'Los lémures saltan entre los árboles. Hay una Eco-Estación especial aquí que multiplica x2 los puntos de alimento forestal.',
      'Escanear aquí',
      .50,
      .25,
    ),
    MapZone(
      'sombras',
      'Sombras Silenciosas',
      'Misterio',
      AppColors.mystery,
      Icons.question_mark,
      'A 210m',
      'El noctuario está a oscuras. Se rumorea que una criatura legendaria aparece aquí después de las 18:00 si reciclas correctamente.',
      'Investigar',
      .30,
      .80,
    ),
    MapZone(
      'veneno',
      'Pabellón Veneno',
      'Misterio',
      AppColors.mystery,
      Icons.question_mark,
      'A 40m',
      'Peligro y belleza. Los cuidadores necesitan ayuda para separar residuos especiales. Misión bloqueada.',
      'Nivel Insuficiente',
      .80,
      .30,
    ),
    MapZone(
      'steller',
      'Bahía de Steller',
      'Misión Disponible',
      AppColors.yellow,
      Icons.explore,
      'A 300m',
      '¡Es hora de la exhibición de leones marinos! Ayuda a recoger 3 envases en las gradas antes de que empiece.',
      'Ver Misión',
      .25,
      .15,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => setState(() => selected = null),
                  child: CustomPaint(
                    painter: MapPainter(),
                    child: Container(
                      color: const Color(0xFFE8F5E9).withOpacity(.65),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      EcoCard(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.chevron_left),
                            ),
                            const Expanded(
                              child: Text(
                                'Mapa Interactivo - Faunia',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.w900),
                              ),
                            ),
                            const Badge('● En vivo', color: AppColors.primary),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      EcoCard(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 9,
                        ),
                        child: const Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 12,
                          children: [
                            Text(
                              '● Misión',
                              style: TextStyle(
                                color: AppColors.yellow,
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '● Criaturas',
                              style: TextStyle(
                                color: AppColors.forest,
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '● Misterio',
                              style: TextStyle(
                                color: AppColors.mystery,
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ...zones.map(
                (zone) => Positioned(
                  top: MediaQuery.of(context).size.height * zone.top,
                  left: math.min(
                    386,
                    MediaQuery.of(context).size.width * zone.left,
                  ),
                  child: MapPin(
                    zone: zone,
                    onTap: () => setState(() => selected = zone),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * .70,
                left: MediaQuery.of(context).size.width * .45,
                child: Column(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.blue.withOpacity(.35),
                            spreadRadius: 6,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.blue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Tú estás aquí',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (selected != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: EcoCard(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                selected!.title,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            Badge(selected!.dist, color: AppColors.yellow),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: selected!.color,
                              child: Icon(selected!.icon, color: Colors.white),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              selected!.type.toUpperCase(),
                              style: TextStyle(
                                color: selected!.color,
                                fontWeight: FontWeight.w900,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          selected!.desc,
                          style: TextStyle(
                            color: midText(context),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: SoftButton(
                                label: 'Cerrar',
                                full: true,
                                onTap: () => setState(() => selected = null),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: GradientButton(
                                label: selected!.button,
                                compact: true,
                                gradient: LinearGradient(
                                  colors:
                                      selected!.button == 'Nivel Insuficiente'
                                          ? [
                                              AppColors.textMuted,
                                              AppColors.textMuted,
                                            ]
                                          : [selected!.color, selected!.color],
                                ),
                                onTap: selected!.button == 'Nivel Insuficiente'
                                    ? null
                                    : () {
                                        if (selected!.button == 'Escanear aquí')
                                          showScannerSheet(
                                            context,
                                            widget.store,
                                          );
                                        if (selected!.button == 'Ver Misión')
                                          Navigator.pop(context);
                                        if (selected!.button == 'Investigar')
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Debes estar en el Noctuario para investigar este misterio.',
                                              ),
                                            ),
                                          );
                                      },
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
      ),
    );
  }
}

class MapZone {
  const MapZone(
    this.id,
    this.title,
    this.type,
    this.color,
    this.icon,
    this.dist,
    this.desc,
    this.button,
    this.top,
    this.left,
  );
  final String id;
  final String title;
  final String type;
  final Color color;
  final IconData icon;
  final String dist;
  final String desc;
  final String button;
  final double top;
  final double left;
}

class MapPin extends StatelessWidget {
  const MapPin({super.key, required this.zone, required this.onTap});
  final MapZone zone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: zone.color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: zone.color.withOpacity(.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(zone.icon, color: Colors.white),
      ),
    );
  }
}

class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(.20)
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path1 = Path()
      ..moveTo(30, 150)
      ..quadraticBezierTo(150, 50, 300, 120)
      ..quadraticBezierTo(370, 160, 450, 150);
    final path2 = Path()
      ..moveTo(120, 120)
      ..quadraticBezierTo(250, 300, 180, 450);
    final path3 = Path()
      ..moveTo(300, 120)
      ..quadraticBezierTo(350, 350, 250, 550);
    final path4 = Path()
      ..moveTo(180, 450)
      ..quadraticBezierTo(220, 500, 250, 550);
    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint..strokeWidth = 20);
    canvas.drawPath(path3, paint..strokeWidth = 18);
    canvas.drawPath(path4, paint..strokeWidth = 14);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
    required this.store,
    required this.openTrivia,
    required this.openMissions,
    required this.openCreatures,
  });
  final EcoStore store;
  final VoidCallback openTrivia;
  final VoidCallback openMissions;
  final VoidCallback openCreatures;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool patrol = false;

  @override
  Widget build(BuildContext context) {
    final quest = widget.store.activeAdventure!;
    final progress = widget.store.getQuestProgress(quest.id);
    final companion = widget.store.state.creatures.firstOrNull;
    final stage =
        companion == null ? null : widget.store.creatureStage(companion.id);
    return AppScroll(
      children: [
        TopBar(
          title: 'Novedades',
          trailing: Badge(
            '${widget.store.state.points}',
            color: AppColors.primary,
          ),
        ),
        QuestHero(
          quest: quest,
          progress: progress,
          companion: stage?.emoji ?? '🥚',
        ),
        const SizedBox(height: 18),
        EcoCard(
          child: Column(
            children: [
              Row(
                children: [
                  const SectionTitle(
                    icon: Icons.emoji_events,
                    title: 'Ranking de Aventureros',
                    color: AppColors.yellow,
                  ),
                  const Spacer(),
                  Text(
                    'En vivo',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: GradientButton(
                      label: 'Individual',
                      compact: true,
                      gradient: LinearGradient(
                        colors: patrol
                            ? [AppColors.primaryLight, AppColors.primaryLight]
                            : [AppColors.primary, AppColors.primary],
                      ),
                      foreground:
                          patrol ? AppColors.primaryDarker : Colors.white,
                      onTap: () => setState(() => patrol = false),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GradientButton(
                      label: 'Patrullas',
                      compact: true,
                      gradient: LinearGradient(
                        colors: patrol
                            ? [AppColors.primary, AppColors.primary]
                            : [AppColors.primaryLight, AppColors.primaryLight],
                      ),
                      foreground:
                          patrol ? Colors.white : AppColors.primaryDarker,
                      onTap: () => setState(() => patrol = true),
                    ),
                  ),
                ],
              ),
              if (patrol) ...[
                const SizedBox(height: 12),
                EcoCard(
                  color: AppColors.purple.withOpacity(.10),
                  border: Border.all(color: AppColors.purple.withOpacity(.20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '🎯 Meta Diaria de Patrulla',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 8),
                      const ProgressLine(percent: 48, color: AppColors.purple),
                      const SizedBox(height: 10),
                      SoftButton(
                        label: 'Invitar Amigos a la Patrulla',
                        icon: Icons.person_add,
                        full: true,
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Enlace copiado al portapapeles: ecoscanner.app/invite/12345',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 12),
              ...(patrol ? patrolLeaderboard : leaderboard).map(
                (item) => RankRow(item: item, patrol: patrol),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        EcoCard(
          onTap: widget.openTrivia,
          color: AppColors.purple,
          child: Row(
            children: const [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🎮 Anti-Cola Games',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'Juega mientras esperas en la cola.',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(Icons.chevron_right, color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            const Expanded(child: SectionTitle(title: 'Tus Criaturas')),
            TextButton(
              onPressed: widget.openCreatures,
              child: const Text('Ver colección'),
            ),
          ],
        ),
        SizedBox(
          height: 98,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: widget.store.state.creatures.take(3).map((c) {
              final def = creatures.where((x) => x.id == c.id).first;
              final stage = widget.store.creatureStage(c.id)!;
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: EcoCard(
                  padding: const EdgeInsets.all(12),
                  onTap: widget.openCreatures,
                  child: SizedBox(
                    width: 82,
                    child: Column(
                      children: [
                        FloatingEmoji(stage.emoji, size: 32),
                        Text(
                          def.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            const Expanded(child: SectionTitle(title: 'Misiones del Día')),
            TextButton(
              onPressed: widget.openMissions,
              child: const Text('Ver todas'),
            ),
          ],
        ),
        ...missions.take(2).map(
              (m) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: MissionRow(mission: m),
              ),
            ),
      ],
    );
  }
}

class RankRow extends StatelessWidget {
  const RankRow({super.key, required this.item, required this.patrol});
  final LeaderboardItem item;
  final bool patrol;

  @override
  Widget build(BuildContext context) {
    final color = item.rank == 1
        ? const Color(0xFFFFB830)
        : item.rank == 2
            ? const Color(0xFFB0BEC5)
            : item.rank == 3
                ? const Color(0xFFFF7043)
                : AppColors.primaryLight;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: BoxDecoration(
        color: item.isUser ? AppColors.primaryLight : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: Text(
              '#${item.rank}',
              style: TextStyle(
                color: item.rank <= 3 ? Colors.white : AppColors.primaryDarker,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      patrol ? Icons.group : Icons.eco,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        item.name,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                    if (item.isUser)
                      const Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Badge('TÚ', color: AppColors.primary),
                      ),
                  ],
                ),
                Text(
                  '${item.pts} puntos ${patrol ? '• ${item.members} miembros' : ''}',
                  style: TextStyle(color: midText(context), fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(
            Icons.emoji_events,
            color: item.rank <= 3 ? color : AppColors.textMuted.withOpacity(.4),
          ),
        ],
      ),
    );
  }
}

class MissionRow extends StatelessWidget {
  const MissionRow({super.key, required this.mission, this.large = false});
  final Mission mission;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return EcoCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: large ? 40 : 48,
                height: large ? 40 : 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(mission.icon, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mission.title,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    Text(
                      mission.desc,
                      maxLines: large ? 3 : 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: midText(context), fontSize: 12),
                    ),
                  ],
                ),
              ),
              Text(
                '+${mission.pts}',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          if (large) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Progreso',
                  style: TextStyle(
                    color: midText(context),
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
                const Spacer(),
                Text(
                  '${mission.progress}/${mission.total}',
                  style: TextStyle(
                    color: midText(context),
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          ProgressLine(
            percent: ((mission.progress / mission.total) * 100).round(),
          ),
          if (large) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '⏱ Expira: ${mission.expires}',
                style: const TextStyle(
                  color: AppColors.orange,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class DailyMissionsScreen extends StatelessWidget {
  const DailyMissionsScreen({super.key, required this.store});
  final EcoStore store;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: SafeArea(
            child: AppScroll(
              children: [
                TopBar(
                  title: 'Misiones del Día',
                  leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.chevron_left),
                  ),
                ),
                Center(
                  child: Badge(
                    '🔥 ¡Racha de ${store.state.streak} días de misiones!',
                    color: AppColors.yellow,
                    textColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Misiones secundarias que se renuevan cada día. Complétalas para ganar puntos extra y subir de nivel a tus criaturas más rápido.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: midText(context),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 18),
                ...missions.map(
                  (m) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: MissionRow(mission: m, large: true),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
