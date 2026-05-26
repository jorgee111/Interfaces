import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/adventure.dart';
import '../models/creature.dart';
import '../models/trivia.dart';
import '../models/mission.dart';
import '../models/reward.dart';
import '../models/user_state.dart';

class LevelInfo {
  final int minPoints;
  final String name;
  final String icon;

  const LevelInfo({
    required this.minPoints,
    required this.name,
    required this.icon,
  });
}

class MascotInfo {
  final String name;
  final String icon;
  final Color color;
  final String desc;
  final String mood;

  const MascotInfo({
    required this.name,
    required this.icon,
    required this.color,
    required this.desc,
    required this.mood,
  });
}

class EcoState extends ChangeNotifier {
  static const List<LevelInfo> kLevels = [
    LevelInfo(minPoints: 0, name: 'Explorador Novato', icon: '🌱'),
    LevelInfo(minPoints: 100, name: 'Aventurero', icon: '🗺️'),
    LevelInfo(minPoints: 300, name: 'Guardián del Parque', icon: '🛡️'),
    LevelInfo(minPoints: 600, name: 'Leyenda Viviente', icon: '⭐'),
  ];

  static const List<Map<String, dynamic>> kDefaultLeaderboard = [
    {'rank': 1, 'name': 'Carlos López', 'pts': 2450, 'avatar': '🍃', 'badge': 'gold'},
    {'rank': 2, 'name': 'Ana Martínez', 'pts': 2200, 'avatar': '🌍', 'badge': 'silver'},
    {'rank': 3, 'name': 'Luis Rodríguez', 'pts': 1980, 'avatar': '♻️', 'badge': 'bronze'},
    {'rank': 4, 'name': 'Elena Torres', 'pts': 1920, 'avatar': '🌿', 'badge': ''},
    {'rank': 5, 'name': 'David Ruiz', 'pts': 1750, 'avatar': '🍃', 'badge': ''},
    {'rank': 6, 'name': 'María García', 'pts': 1680, 'avatar': '⭐', 'badge': ''},
    {'rank': 7, 'name': 'Pedro Sánchez', 'pts': 1420, 'avatar': '🍃', 'badge': ''},
    {'rank': 8, 'name': 'Laura Vega', 'pts': 1280, 'avatar': '❤️', 'badge': ''},
    {'rank': 9, 'name': 'Marco Díaz', 'pts': 980, 'avatar': '👤', 'badge': ''},
    {'rank': 10, 'name': 'Isabel Ramos', 'pts': 820, 'avatar': '👤', 'badge': ''},
  ];

  static const List<Map<String, dynamic>> kDefaultPatrolLeaderboard = [
    {'rank': 1, 'name': 'Green Avengers', 'pts': 12400, 'members': 6},
    {'rank': 2, 'name': 'Faunia Rangers', 'pts': 8920, 'members': 5},
    {'rank': 3, 'name': 'Blue Guardians', 'pts': 7800, 'members': 4},
    {'rank': 4, 'name': 'Planet Savers', 'pts': 6500, 'members': 5},
    {'rank': 5, 'name': 'Eco Warriors', 'pts': 5200, 'members': 3},
  ];

  static const List<Map<String, dynamic>> kMockPatrolMembers = [
    {'name': 'Alex R.', 'pts': 320, 'avatar': '🦊', 'online': true},
    {'name': 'Laura M.', 'pts': 280, 'avatar': '🐢', 'online': false},
    {'name': 'Pablo G.', 'pts': 195, 'avatar': '🦉', 'online': true},
    {'name': 'Sara T.', 'pts': 410, 'avatar': '🌿', 'online': true},
    {'name': 'Javi L.', 'pts': 155, 'avatar': '🌊', 'online': false},
  ];

  late SharedPreferences _prefs;
  late UserState _state;
  bool _isDark = false;
  bool _isInitialized = false;

  UserState get state => _state;
  bool get isDark => _isDark;
  bool get isInitialized => _isInitialized;

  // Initialize and load state
  EcoState() {
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    _isDark = _prefs.getBool('ecoscanner_dark') ?? false;
    final savedState = _prefs.getString('ecoscanner_state');

    if (savedState != null) {
      try {
        _state = UserState.fromJson(savedState);
      } catch (e) {
        _state = _createDefaultState();
      }
    } else {
      _state = _createDefaultState();
    }

    _isInitialized = true;
    notifyListeners();
  }

  UserState _createDefaultState() {
    return UserState.fromMap(const {});
  }

  Future<void> _save() async {
    await _prefs.setString('ecoscanner_state', _state.toJson());
  }

  // ── DARK MODE ────────────────────────────────
  void toggleDarkMode() {
    _isDark = !_isDark;
    _prefs.setBool('ecoscanner_dark', _isDark);
    notifyListeners();
  }

  // ── LEVEL HELPERS ────────────────────────────
  LevelInfo getLevel(int pts) {
    LevelInfo lv = kLevels[0];
    for (final l in kLevels) {
      if (pts >= l.minPoints) {
        lv = l;
      } else {
        break;
      }
    }
    return lv;
  }

  LevelInfo? getNextLevel(int pts) {
    for (final l in kLevels) {
      if (l.minPoints > pts) return l;
    }
    return null;
  }

  int getLevelProgress(int pts) {
    final cur = getLevel(pts);
    final nxt = getNextLevel(pts);
    if (nxt == null) return 100;
    final range = nxt.minPoints - cur.minPoints;
    final done = pts - cur.minPoints;
    return ((done / range) * 100).round();
  }

  // ── CO2 & WATER ORACLE ───────────────────────
  Map<String, String> getOracle() {
    final pts = _state.points;
    return {
      'co2': (pts * 0.05).toStringAsFixed(1),
      'water': (pts * 0.8).floor().toString(),
      'energy': (pts * 0.2).toStringAsFixed(1),
    };
  }

  // ── MASCOT SYSTEM ────────────────────────────
  MascotInfo getMascotData() {
    final pts = _state.points;
    final streak = _state.streak;
    int stage = 0;
    if (pts > 1000) {
      stage = 3;
    } else if (pts > 500) {
      stage = 2;
    } else if (pts > 100) {
      stage = 1;
    }

    final mood = streak > 0 ? 'Feliz 😊' : 'Triste 😢';

    final stages = [
      const MascotInfo(name: 'Semilla Eco', icon: '🥚', color: Color(0xFFFFB830), desc: 'Recién plantada.', mood: ''),
      const MascotInfo(name: 'Brote Tímido', icon: '🌱', color: Color(0xFF2ECC71), desc: 'Empieza a crecer.', mood: ''),
      const MascotInfo(name: 'Planta Fuerte', icon: '🌿', color: Color(0xFF00BFA5), desc: '¡Abonada con tus acciones!', mood: ''),
      const MascotInfo(name: 'Árbol Guardián', icon: '🌳', color: Color(0xFF009688), desc: '¡El rey del parque!', mood: ''),
    ];

    final baseMascot = stages[stage];
    return MascotInfo(
      name: baseMascot.name,
      icon: baseMascot.icon,
      color: baseMascot.color,
      desc: baseMascot.desc,
      mood: mood,
    );
  }

  // ── POINT ACTIONS ────────────────────────────
  void addPoints(int amount, [String action = 'Acción sostenible', String icon = '♻️']) {
    final newPoints = _state.points + amount;

    // Build updated history
    final updatedHistory = List<HistoryEntry>.from(_state.history);
    updatedHistory.insert(0, HistoryEntry(action: action, pts: amount, time: 'Ahora mismo', icon: icon));
    if (updatedHistory.length > 20) updatedHistory.removeLast();

    _state = UserState(
      user: _state.user,
      points: newPoints,
      rank: _state.rank,
      streak: _state.streak,
      patrol: _state.patrol,
      history: updatedHistory,
      redeemedIds: _state.redeemedIds,
      adventure: _state.adventure,
      creatures: _state.creatures,
      trivia: _state.trivia,
      dailyMissions: _state.dailyMissions,
    );

    _save();
    notifyListeners();
  }

  bool spendPoints(int amount) {
    if (_state.points < amount) return false;

    _state = UserState(
      user: _state.user,
      points: _state.points - amount,
      rank: _state.rank,
      streak: _state.streak,
      patrol: _state.patrol,
      history: _state.history,
      redeemedIds: _state.redeemedIds,
      adventure: _state.adventure,
      creatures: _state.creatures,
      trivia: _state.trivia,
      dailyMissions: _state.dailyMissions,
    );

    _save();
    notifyListeners();
    return true;
  }

  // ── USER / ONBOARDING ────────────────────────
  bool hasUser() => _state.user.name.isNotEmpty;

  void setUserName(String name) {
    _state = UserState(
      user: UserProfile(name: name.trim(), avatar: _state.user.avatar),
      points: _state.points,
      rank: _state.rank,
      streak: _state.streak,
      patrol: _state.patrol,
      history: _state.history,
      redeemedIds: _state.redeemedIds,
      adventure: _state.adventure,
      creatures: _state.creatures,
      trivia: _state.trivia,
      dailyMissions: _state.dailyMissions,
    );
    _save();
    notifyListeners();
  }

  String getUserName() => _state.user.name.isEmpty ? 'Explorador' : _state.user.name;

  // ── ADVENTURE METHODS ────────────────────────
  Adventure getActiveAdventure() {
    return kAdventures.firstWhere(
      (a) => a.id == _state.adventure.activeQuestId,
      orElse: () => kAdventures[0],
    );
  }

  void setActiveAdventure(String id) {
    final updatedQuests = Map<String, QuestProgress>.from(_state.adventure.quests);
    if (!updatedQuests.containsKey(id)) {
      updatedQuests[id] = const QuestProgress(started: true, completedChapters: [], currentChapter: 'ch1');
    } else {
      final old = updatedQuests[id]!;
      updatedQuests[id] = QuestProgress(started: true, completedChapters: old.completedChapters, currentChapter: old.currentChapter ?? 'ch1');
    }

    final updatedAdventure = AdventureState(
      activeQuestId: id,
      quests: updatedQuests,
      inventory: _state.adventure.inventory,
      totalChaptersCompleted: _state.adventure.totalChaptersCompleted,
    );

    _state = UserState(
      user: _state.user,
      points: _state.points,
      rank: _state.rank,
      streak: _state.streak,
      patrol: _state.patrol,
      history: _state.history,
      redeemedIds: _state.redeemedIds,
      adventure: updatedAdventure,
      creatures: _state.creatures,
      trivia: _state.trivia,
      dailyMissions: _state.dailyMissions,
    );
    _save();
    notifyListeners();
  }

  Map<String, dynamic> getQuestProgress(String questId) {
    final questState = _state.adventure.quests[questId];
    final quest = kAdventures.firstWhere((a) => a.id == questId, orElse: () => kAdventures[0]);
    if (questState == null) return {'completed': 0, 'total': quest.chapters.length, 'percent': 0};
    final completed = questState.completedChapters.length;
    final total = quest.chapters.length;
    return {
      'completed': completed,
      'total': total,
      'percent': ((completed / total) * 100).round(),
    };
  }

  Chapter? getCurrentChapter(String questId) {
    final questState = _state.adventure.quests[questId];
    final quest = kAdventures.firstWhere((a) => a.id == questId, orElse: () => kAdventures[0]);
    if (questState == null || questState.currentChapter == null) return null;
    return quest.chapters.firstWhere(
      (ch) => ch.id == questState.currentChapter,
      orElse: () => quest.chapters[0],
    );
  }

  void completeChapter(String questId, String chapterId) {
    final questState = _state.adventure.quests[questId];
    final quest = kAdventures.firstWhere((a) => a.id == questId);
    if (questState == null) return;

    if (!questState.completedChapters.contains(chapterId)) {
      final newCompleted = List<String>.from(questState.completedChapters)..add(chapterId);

      // Find next chapter
      final chapterIndex = quest.chapters.indexWhere((ch) => ch.id == chapterId);
      String? nextChapterId;
      if (chapterIndex < quest.chapters.length - 1) {
        nextChapterId = quest.chapters[chapterIndex + 1].id;
      }

      final updatedQuests = Map<String, QuestProgress>.from(_state.adventure.quests);
      updatedQuests[questId] = QuestProgress(
        started: true,
        completedChapters: newCompleted,
        currentChapter: nextChapterId,
      );

      final updatedInventory = List<String>.from(_state.adventure.inventory);

      // Grant rewards
      final chapter = quest.chapters.firstWhere((ch) => ch.id == chapterId);
      if (chapter.reward.creature != null) {
        discoverCreature(chapter.reward.creature!);
      }
      if (chapter.reward.item != null && !updatedInventory.contains(chapter.reward.item)) {
        updatedInventory.add(chapter.reward.item!);
      }

      final updatedAdventure = AdventureState(
        activeQuestId: _state.adventure.activeQuestId,
        quests: updatedQuests,
        inventory: updatedInventory,
        totalChaptersCompleted: _state.adventure.totalChaptersCompleted + 1,
      );

      _state = UserState(
        user: _state.user,
        points: _state.points,
        rank: _state.rank,
        streak: _state.streak,
        patrol: _state.patrol,
        history: _state.history,
        redeemedIds: _state.redeemedIds,
        adventure: updatedAdventure,
        creatures: _state.creatures,
        trivia: _state.trivia,
        dailyMissions: _state.dailyMissions,
      );

      addPoints(chapter.reward.points, 'Capítulo Completado', '🏆');
      _save();
      notifyListeners();
    }
  }

  // ── CREATURE METHODS ─────────────────────────
  void discoverCreature(String creatureId) {
    if (!_state.creatures.discovered.any((c) => c.id == creatureId)) {
      final updatedDiscovered = List<DiscoveredCreature>.from(_state.creatures.discovered)
        ..add(DiscoveredCreature(
          id: creatureId,
          discoveredAt: DateTime.now().toIso8601String().split('T')[0],
          feedCount: 0,
        ));

      final updatedCreatures = CreaturesState(discovered: updatedDiscovered);

      _state = UserState(
        user: _state.user,
        points: _state.points,
        rank: _state.rank,
        streak: _state.streak,
        patrol: _state.patrol,
        history: _state.history,
        redeemedIds: _state.redeemedIds,
        adventure: _state.adventure,
        creatures: updatedCreatures,
        trivia: _state.trivia,
        dailyMissions: _state.dailyMissions,
      );
      _save();
      notifyListeners();
    }
  }

  void feedCreature(String creatureId) {
    final index = _state.creatures.discovered.indexWhere((c) => c.id == creatureId);
    if (index != -1) {
      final old = _state.creatures.discovered[index];
      final updatedDiscovered = List<DiscoveredCreature>.from(_state.creatures.discovered);
      updatedDiscovered[index] = DiscoveredCreature(
        id: old.id,
        discoveredAt: old.discoveredAt,
        feedCount: old.feedCount + 1,
      );

      final updatedCreatures = CreaturesState(discovered: updatedDiscovered);

      _state = UserState(
        user: _state.user,
        points: _state.points,
        rank: _state.rank,
        streak: _state.streak,
        patrol: _state.patrol,
        history: _state.history,
        redeemedIds: _state.redeemedIds,
        adventure: _state.adventure,
        creatures: updatedCreatures,
        trivia: _state.trivia,
        dailyMissions: _state.dailyMissions,
      );

      // Feeding rewards 5 points
      addPoints(5, 'Alimentar Criatura', '🍎');
      _save();
      notifyListeners();
    }
  }

  int getCreatureLevel(String creatureId) {
    final creature = _state.creatures.discovered.firstWhere(
      (c) => c.id == creatureId,
      orElse: () => const DiscoveredCreature(id: '', discoveredAt: '', feedCount: 0),
    );
    if (creature.id.isEmpty) return 0;
    return _calculateCreatureLevel(creatureId, creature.feedCount);
  }

  int _calculateCreatureLevel(String creatureId, int feedCount) {
    final creatureDef = kCreatures.firstWhere((c) => c.id == creatureId, orElse: () => kCreatures[0]);
    int level = 0;
    for (int i = creatureDef.stages.length - 1; i >= 0; i--) {
      if (feedCount >= creatureDef.stages[i].feedRequired) {
        level = i;
        break;
      }
    }
    return level;
  }

  CreatureStage? getCreatureStage(String creatureId) {
    final creatureDef = kCreatures.firstWhere((c) => c.id == creatureId, orElse: () => kCreatures[0]);
    final level = getCreatureLevel(creatureId);
    return creatureDef.stages[level];
  }

  bool isCreatureDiscovered(String creatureId) {
    return _state.creatures.discovered.any((c) => c.id == creatureId);
  }

  // ── TRIVIA METHODS ───────────────────────────
  TriviaQuestion getRandomQuestion() {
    final unanswered = kTriviaPool.where((q) => !_state.trivia.answeredIds.contains(q.id)).toList();
    if (unanswered.isEmpty) {
      // Reset answered questions
      final updatedTrivia = TriviaState(answeredIds: const [], correctCount: _state.trivia.correctCount, streak: _state.trivia.streak);
      _state = UserState(
        user: _state.user,
        points: _state.points,
        rank: _state.rank,
        streak: _state.streak,
        patrol: _state.patrol,
        history: _state.history,
        redeemedIds: _state.redeemedIds,
        adventure: _state.adventure,
        creatures: _state.creatures,
        trivia: updatedTrivia,
        dailyMissions: _state.dailyMissions,
      );
      _save();
      return kTriviaPool[Random().nextInt(kTriviaPool.length)];
    }
    return unanswered[Random().nextInt(unanswered.length)];
  }

  Map<String, dynamic> answerQuestion(int questionId, int selectedIndex) {
    final question = kTriviaPool.firstWhere((q) => q.id == questionId);
    final isCorrect = selectedIndex == question.correct;

    final updatedAnswered = List<int>.from(_state.trivia.answeredIds);
    if (!updatedAnswered.contains(questionId)) {
      updatedAnswered.add(questionId);
    }

    int correctCount = _state.trivia.correctCount;
    int streak = _state.trivia.streak;

    if (isCorrect) {
      correctCount++;
      streak++;
    } else {
      streak = 0;
    }

    final updatedTrivia = TriviaState(
      answeredIds: updatedAnswered,
      correctCount: correctCount,
      streak: streak,
    );

    _state = UserState(
      user: _state.user,
      points: _state.points,
      rank: _state.rank,
      streak: _state.streak,
      patrol: _state.patrol,
      history: _state.history,
      redeemedIds: _state.redeemedIds,
      adventure: _state.adventure,
      creatures: _state.creatures,
      trivia: updatedTrivia,
      dailyMissions: _state.dailyMissions,
    );

    if (isCorrect) {
      addPoints(5, 'Trivia Correcta', '🧠');
      if (streak % 3 == 0) {
        addPoints(15, 'Bono de Trivia (x3)', '🔥');
      }
    }

    _save();
    notifyListeners();

    return {
      'correct': isCorrect,
      'funFact': question.funFact,
      'streak': streak,
    };
  }

  Map<String, int> getTriviaStats() {
    return {
      'answered': _state.trivia.answeredIds.length,
      'correct': _state.trivia.correctCount,
      'streak': _state.trivia.streak,
      'total': kTriviaPool.length,
    };
  }

  // ── DAILY MISSIONS ───────────────────────────
  String getTodayStr() {
    return DateTime.now().toIso8601String().split('T')[0];
  }

  List<Mission> getDailyMissions() {
    final today = getTodayStr();
    if (_state.dailyMissions.date != today || _state.dailyMissions.activeMissions.isEmpty) {
      final shuffled = List<Mission>.from(kDailyMissionsPool)..shuffle();
      final active = shuffled.take(3).map((m) => Mission(
        id: m.id,
        icon: m.icon,
        title: m.title,
        desc: m.desc,
        pts: m.pts,
        total: m.total,
        expires: m.expires,
        progress: 0,
        done: false,
      )).toList();

      final updatedDaily = DailyMissionsState(
        date: today,
        completed: const [],
        streak: _state.dailyMissions.streak,
        lastCompletedDate: _state.dailyMissions.lastCompletedDate,
        activeMissions: active,
      );

      _state = UserState(
        user: _state.user,
        points: _state.points,
        rank: _state.rank,
        streak: _state.streak,
        patrol: _state.patrol,
        history: _state.history,
        redeemedIds: _state.redeemedIds,
        adventure: _state.adventure,
        creatures: _state.creatures,
        trivia: _state.trivia,
        dailyMissions: updatedDaily,
      );
      _save();
    }

    return _state.dailyMissions.activeMissions;
  }

  void incrementMissionProgress(String id, int amount) {
    final index = _state.dailyMissions.activeMissions.indexWhere((m) => m.id == id);
    if (index != -1) {
      final mission = _state.dailyMissions.activeMissions[index];
      if (!mission.done) {
        final newProgress = min(mission.progress + amount, mission.total);
        mission.progress = newProgress;

        if (newProgress >= mission.total) {
          completeMission(id);
        } else {
          _save();
          notifyListeners();
        }
      }
    }
  }

  bool completeMission(String missionId) {
    if (!_state.dailyMissions.completed.contains(missionId)) {
      final newCompleted = List<String>.from(_state.dailyMissions.completed)..add(missionId);

      // Find the mission in active ones
      final mission = _state.dailyMissions.activeMissions.firstWhere((m) => m.id == missionId);
      mission.done = true;
      mission.progress = mission.total;

      int streak = _state.dailyMissions.streak;
      String lastCompletedDate = _state.dailyMissions.lastCompletedDate;

      if (newCompleted.length >= 3) {
        final today = getTodayStr();
        final yesterday = DateTime.now().subtract(const Duration(days: 1)).toIso8601String().split('T')[0];

        if (lastCompletedDate == yesterday) {
          streak += 1;
        } else if (lastCompletedDate != today) {
          streak = 1;
        }
        lastCompletedDate = today;
      }

      final updatedDaily = DailyMissionsState(
        date: _state.dailyMissions.date,
        completed: newCompleted,
        streak: streak,
        lastCompletedDate: lastCompletedDate,
        activeMissions: _state.dailyMissions.activeMissions,
      );

      _state = UserState(
        user: _state.user,
        points: _state.points,
        rank: _state.rank,
        streak: _state.streak,
        patrol: _state.patrol,
        history: _state.history,
        redeemedIds: _state.redeemedIds,
        adventure: _state.adventure,
        creatures: _state.creatures,
        trivia: _state.trivia,
        dailyMissions: updatedDaily,
      );

      addPoints(mission.pts, 'Misión Diaria', '⚡');
      _save();
      notifyListeners();
      return true;
    }
    return false;
  }

  int getMissionStreak() => _state.dailyMissions.streak;

  int getPendingMissionsCount() {
    final missions = getDailyMissions();
    return missions.where((m) => !_state.dailyMissions.completed.contains(m.id)).length;
  }

  // ── PATROL METHODS ───────────────────────────
  String generateCode() {
    final rand = Random();
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(4, (index) => chars[rand.nextInt(chars.length)]).join();
  }

  void createPatrol(String name) {
    final code = generateCode();

    final members = [
      PatrolMember(name: getUserName(), pts: _state.points, avatar: '⭐', online: true, isMe: true),
      PatrolMember(name: kMockPatrolMembers[0]['name'], pts: kMockPatrolMembers[0]['pts'], avatar: kMockPatrolMembers[0]['avatar'], online: kMockPatrolMembers[0]['online']),
      PatrolMember(name: kMockPatrolMembers[1]['name'], pts: kMockPatrolMembers[1]['pts'], avatar: kMockPatrolMembers[1]['avatar'], online: kMockPatrolMembers[1]['online']),
      PatrolMember(name: kMockPatrolMembers[2]['name'], pts: kMockPatrolMembers[2]['pts'], avatar: kMockPatrolMembers[2]['avatar'], online: kMockPatrolMembers[2]['online']),
    ];

    final totalPoints = _state.points + 320 + 280 + 195;

    final updatedPatrol = PatrolState(
      joined: true,
      name: name.trim(),
      code: code,
      members: members,
      totalPoints: totalPoints,
    );

    _state = UserState(
      user: _state.user,
      points: _state.points,
      rank: _state.rank,
      streak: _state.streak,
      patrol: updatedPatrol,
      history: _state.history,
      redeemedIds: _state.redeemedIds,
      adventure: _state.adventure,
      creatures: _state.creatures,
      trivia: _state.trivia,
      dailyMissions: _state.dailyMissions,
    );

    _save();
    notifyListeners();
  }

  void joinPatrol(String code) {
    final patrolNames = {
      'ECO1': 'Green Avengers',
      'FURN': 'Faunia Rangers',
      'BLUE': 'Blue Guardians',
    };
    final patrolName = patrolNames[code.toUpperCase()] ?? 'Patrulla ${code.toUpperCase()}';

    final members = [
      PatrolMember(name: getUserName(), pts: _state.points, avatar: '⭐', online: true, isMe: true),
      PatrolMember(name: kMockPatrolMembers[0]['name'], pts: kMockPatrolMembers[0]['pts'], avatar: kMockPatrolMembers[0]['avatar'], online: kMockPatrolMembers[0]['online']),
      PatrolMember(name: kMockPatrolMembers[1]['name'], pts: kMockPatrolMembers[1]['pts'], avatar: kMockPatrolMembers[1]['avatar'], online: kMockPatrolMembers[1]['online']),
      PatrolMember(name: kMockPatrolMembers[2]['name'], pts: kMockPatrolMembers[2]['pts'], avatar: kMockPatrolMembers[2]['avatar'], online: kMockPatrolMembers[2]['online']),
      PatrolMember(name: kMockPatrolMembers[3]['name'], pts: kMockPatrolMembers[3]['pts'], avatar: kMockPatrolMembers[3]['avatar'], online: kMockPatrolMembers[3]['online']),
    ];

    final totalPoints = _state.points + 320 + 280 + 195 + 410;

    final updatedPatrol = PatrolState(
      joined: true,
      name: patrolName,
      code: code.toUpperCase(),
      members: members,
      totalPoints: totalPoints,
    );

    _state = UserState(
      user: _state.user,
      points: _state.points,
      rank: _state.rank,
      streak: _state.streak,
      patrol: updatedPatrol,
      history: _state.history,
      redeemedIds: _state.redeemedIds,
      adventure: _state.adventure,
      creatures: _state.creatures,
      trivia: _state.trivia,
      dailyMissions: _state.dailyMissions,
    );

    _save();
    notifyListeners();
  }

  void leavePatrol() {
    _state = UserState(
      user: _state.user,
      points: _state.points,
      rank: _state.rank,
      streak: _state.streak,
      patrol: const PatrolState(joined: false),
      history: _state.history,
      redeemedIds: _state.redeemedIds,
      adventure: _state.adventure,
      creatures: _state.creatures,
      trivia: _state.trivia,
      dailyMissions: _state.dailyMissions,
    );
    _save();
    notifyListeners();
  }

  // ── LEADERBOARDS ─────────────────────────────
  List<Map<String, dynamic>> getFullLeaderboard() {
    final userPts = _state.points;
    final name = getUserName();

    final lb = kDefaultLeaderboard.map((e) => Map<String, dynamic>.from(e)).toList();

    int userRank = lb.length + 1;
    for (int i = 0; i < lb.length; i++) {
      if (userPts >= lb[i]['pts']) {
        userRank = i + 1;
        break;
      }
    }

    final userEntry = {
      'rank': userRank,
      'name': name,
      'pts': userPts,
      'avatar': '⭐',
      'badge': userRank == 1 ? 'gold' : userRank == 2 ? 'silver' : userRank == 3 ? 'bronze' : '',
      'isUser': true,
    };

    lb.insert(userRank - 1, userEntry);
    final trimmed = lb.take(10).toList();
    for (int i = 0; i < trimmed.length; i++) {
      trimmed[i]['rank'] = i + 1;
    }
    return trimmed;
  }

  List<Map<String, dynamic>> getPatrolLeaderboard() {
    final hasP = _state.patrol.joined;
    final patrolName = _state.patrol.name;
    final patrolPts = _state.patrol.totalPoints;
    final membersCount = _state.patrol.members.length;

    final lb = kDefaultPatrolLeaderboard.map((e) => Map<String, dynamic>.from(e)).toList();

    if (!hasP) return lb;

    bool inserted = false;
    for (int i = 0; i < lb.length; i++) {
      if (patrolPts >= lb[i]['pts']) {
        lb.insert(i, {
          'rank': i + 1,
          'name': patrolName,
          'pts': patrolPts,
          'members': membersCount,
          'isUser': true,
        });
        inserted = true;
        break;
      }
    }

    if (!inserted) {
      lb.add({
        'rank': lb.length + 1,
        'name': patrolName,
        'pts': patrolPts,
        'members': membersCount,
        'isUser': true,
      });
    }

    final trimmed = lb.take(5).toList();
    for (int i = 0; i < trimmed.length; i++) {
      trimmed[i]['rank'] = i + 1;
    }
    return trimmed;
  }
}
