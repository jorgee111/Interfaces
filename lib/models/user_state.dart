import 'dart:convert';
import 'mission.dart';

class UserProfile {
  final String name;
  final String avatar;

  const UserProfile({required this.name, required this.avatar});

  Map<String, dynamic> toMap() => {'name': name, 'avatar': avatar};
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'] ?? '',
      avatar: map['avatar'] ?? '⭐',
    );
  }
}

class PatrolMember {
  final String name;
  final int pts;
  final String avatar;
  final bool online;
  final bool isMe;

  const PatrolMember({
    required this.name,
    required this.pts,
    required this.avatar,
    required this.online,
    this.isMe = false,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'pts': pts,
    'avatar': avatar,
    'online': online,
    'isMe': isMe,
  };

  factory PatrolMember.fromMap(Map<String, dynamic> map) {
    return PatrolMember(
      name: map['name'] ?? '',
      pts: map['pts'] ?? 0,
      avatar: map['avatar'] ?? '⭐',
      online: map['online'] ?? false,
      isMe: map['isMe'] ?? false,
    );
  }
}

class PatrolState {
  final bool joined;
  final String name;
  final String code;
  final List<PatrolMember> members;
  final int totalPoints;

  const PatrolState({
    this.joined = false,
    this.name = '',
    this.code = '',
    this.members = const [],
    this.totalPoints = 0,
  });

  Map<String, dynamic> toMap() => {
    'joined': joined,
    'name': name,
    'code': code,
    'members': members.map((x) => x.toMap()).toList(),
    'totalPoints': totalPoints,
  };

  factory PatrolState.fromMap(Map<String, dynamic> map) {
    return PatrolState(
      joined: map['joined'] ?? false,
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      members: List<PatrolMember>.from(map['members']?.map((x) => PatrolMember.fromMap(x)) ?? const []),
      totalPoints: map['totalPoints'] ?? 0,
    );
  }
}

class HistoryEntry {
  final String action;
  final int pts;
  final String time;
  final String icon;

  const HistoryEntry({
    required this.action,
    required this.pts,
    required this.time,
    required this.icon,
  });

  Map<String, dynamic> toMap() => {
    'action': action,
    'pts': pts,
    'time': time,
    'icon': icon,
  };

  factory HistoryEntry.fromMap(Map<String, dynamic> map) {
    return HistoryEntry(
      action: map['action'] ?? '',
      pts: map['pts'] ?? 0,
      time: map['time'] ?? '',
      icon: map['icon'] ?? '♻️',
    );
  }
}

class QuestProgress {
  final bool started;
  final List<String> completedChapters;
  final String? currentChapter;

  const QuestProgress({
    this.started = false,
    this.completedChapters = const [],
    this.currentChapter,
  });

  Map<String, dynamic> toMap() => {
    'started': started,
    'completedChapters': completedChapters,
    'currentChapter': currentChapter,
  };

  factory QuestProgress.fromMap(Map<String, dynamic> map) {
    return QuestProgress(
      started: map['started'] ?? false,
      completedChapters: List<String>.from(map['completedChapters'] ?? const []),
      currentChapter: map['currentChapter'],
    );
  }
}

class AdventureState {
  final String activeQuestId;
  final Map<String, QuestProgress> quests;
  final List<String> inventory;
  final int totalChaptersCompleted;

  const AdventureState({
    required this.activeQuestId,
    required this.quests,
    required this.inventory,
    required this.totalChaptersCompleted,
  });

  Map<String, dynamic> toMap() => {
    'activeQuestId': activeQuestId,
    'quests': quests.map((key, value) => MapEntry(key, value.toMap())),
    'inventory': inventory,
    'totalChaptersCompleted': totalChaptersCompleted,
  };

  factory AdventureState.fromMap(Map<String, dynamic> map) {
    final questsMap = <String, QuestProgress>{};
    if (map['quests'] != null) {
      (map['quests'] as Map<String, dynamic>).forEach((key, value) {
        questsMap[key] = QuestProgress.fromMap(Map<String, dynamic>.from(value));
      });
    }
    return AdventureState(
      activeQuestId: map['activeQuestId'] ?? 'bosque-perdido',
      quests: questsMap,
      inventory: List<String>.from(map['inventory'] ?? const []),
      totalChaptersCompleted: map['totalChaptersCompleted'] ?? 0,
    );
  }
}

class DiscoveredCreature {
  final String id;
  final String discoveredAt;
  final int feedCount;

  const DiscoveredCreature({
    required this.id,
    required this.discoveredAt,
    required this.feedCount,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'discoveredAt': discoveredAt,
    'feedCount': feedCount,
  };

  factory DiscoveredCreature.fromMap(Map<String, dynamic> map) {
    return DiscoveredCreature(
      id: map['id'] ?? '',
      discoveredAt: map['discoveredAt'] ?? '',
      feedCount: map['feedCount'] ?? 0,
    );
  }
}

class CreaturesState {
  final List<DiscoveredCreature> discovered;

  const CreaturesState({required this.discovered});

  Map<String, dynamic> toMap() => {
    'discovered': discovered.map((x) => x.toMap()).toList(),
  };

  factory CreaturesState.fromMap(Map<String, dynamic> map) {
    return CreaturesState(
      discovered: List<DiscoveredCreature>.from(map['discovered']?.map((x) => DiscoveredCreature.fromMap(x)) ?? const []),
    );
  }
}

class TriviaState {
  final List<int> answeredIds;
  final int correctCount;
  final int streak;

  const TriviaState({
    required this.answeredIds,
    required this.correctCount,
    required this.streak,
  });

  Map<String, dynamic> toMap() => {
    'answeredIds': answeredIds,
    'correctCount': correctCount,
    'streak': streak,
  };

  factory TriviaState.fromMap(Map<String, dynamic> map) {
    return TriviaState(
      answeredIds: List<int>.from(map['answeredIds'] ?? const []),
      correctCount: map['correctCount'] ?? 0,
      streak: map['streak'] ?? 0,
    );
  }
}

class DailyMissionsState {
  final String date;
  final List<String> completed;
  final int streak;
  final String lastCompletedDate;
  final List<Mission> activeMissions;

  const DailyMissionsState({
    required this.date,
    required this.completed,
    required this.streak,
    required this.lastCompletedDate,
    required this.activeMissions,
  });

  Map<String, dynamic> toMap() => {
    'date': date,
    'completed': completed,
    'streak': streak,
    'lastCompletedDate': lastCompletedDate,
    'activeMissions': activeMissions.map((x) => x.toMap()).toList(),
  };

  factory DailyMissionsState.fromMap(Map<String, dynamic> map) {
    return DailyMissionsState(
      date: map['date'] ?? '',
      completed: List<String>.from(map['completed'] ?? const []),
      streak: map['streak'] ?? 0,
      lastCompletedDate: map['lastCompletedDate'] ?? '',
      activeMissions: List<Mission>.from(map['activeMissions']?.map((x) => Mission.fromMap(Map<String, dynamic>.from(x))) ?? const []),
    );
  }
}

class UserState {
  final UserProfile user;
  final int points;
  final int rank;
  final int streak;
  final PatrolState patrol;
  final List<HistoryEntry> history;
  final List<String> redeemedIds;
  final AdventureState adventure;
  final CreaturesState creatures;
  final TriviaState trivia;
  final DailyMissionsState dailyMissions;

  const UserState({
    required this.user,
    required this.points,
    required this.rank,
    required this.streak,
    required this.patrol,
    required this.history,
    required this.redeemedIds,
    required this.adventure,
    required this.creatures,
    required this.trivia,
    required this.dailyMissions,
  });

  Map<String, dynamic> toMap() => {
    'user': user.toMap(),
    'points': points,
    'rank': rank,
    'streak': streak,
    'patrol': patrol.toMap(),
    'history': history.map((x) => x.toMap()).toList(),
    'redeemedIds': redeemedIds,
    'adventure': adventure.toMap(),
    'creatures': creatures.toMap(),
    'trivia': trivia.toMap(),
    'dailyMissions': dailyMissions.toMap(),
  };

  factory UserState.fromMap(Map<String, dynamic> map) {
    return UserState(
      user: UserProfile.fromMap(map['user'] ?? const {}),
      points: map['points'] ?? 1250,
      rank: map['rank'] ?? 42,
      streak: map['streak'] ?? 3,
      patrol: PatrolState.fromMap(map['patrol'] ?? const {}),
      history: List<HistoryEntry>.from(map['history']?.map((x) => HistoryEntry.fromMap(x)) ?? const []),
      redeemedIds: List<String>.from(map['redeemedIds'] ?? const []),
      adventure: AdventureState.fromMap(map['adventure'] ?? const {
        'activeQuestId': 'bosque-perdido',
        'quests': {
          'bosque-perdido': {
            'started': true,
            'completedChapters': ['ch1'],
            'currentChapter': 'ch2',
          },
          'oceano-secreto': {
            'started': false,
            'completedChapters': [],
            'currentChapter': 'ch1',
          }
        },
        'inventory': ['llave-dorada'],
        'totalChaptersCompleted': 1
      }),
      creatures: CreaturesState.fromMap(map['creatures'] ?? const {
        'discovered': [
          {'id': 'leaf-fox', 'discoveredAt': '2025-05-20', 'feedCount': 3},
          {'id': 'shell-turtle', 'discoveredAt': '2025-05-21', 'feedCount': 1}
        ]
      }),
      trivia: TriviaState.fromMap(map['trivia'] ?? const {
        'answeredIds': [0],
        'correctCount': 1,
        'streak': 1
      }),
      dailyMissions: DailyMissionsState.fromMap(map['dailyMissions'] ?? const {}),
    );
  }

  String toJson() => json.encode(toMap());
  factory UserState.fromJson(String source) => UserState.fromMap(json.decode(source));
}
