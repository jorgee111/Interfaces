import 'dart:convert';

enum ChapterType {
  scan,
  trivia,
  explore,
  group,
}

class ChapterReward {
  final int points;
  final String? creature;
  final String? item;

  const ChapterReward({
    required this.points,
    this.creature,
    this.item,
  });

  Map<String, dynamic> toMap() {
    return {
      'points': points,
      if (creature != null) 'creature': creature,
      if (item != null) 'item': item,
    };
  }

  factory ChapterReward.fromMap(Map<String, dynamic> map) {
    return ChapterReward(
      points: map['points'] ?? 0,
      creature: map['creature'],
      item: map['item'],
    );
  }
}

class Chapter {
  final String id;
  final String title;
  final String description;
  final ChapterType type;
  final String hint;
  final ChapterReward reward;
  final String completionText;
  final int? scansRequired;
  final int? groupRequired;
  final int? triviaRequired;
  final int? zonesRequired;
  final int? groupScansRequired;

  const Chapter({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.hint,
    required this.reward,
    required this.completionText,
    this.scansRequired,
    this.groupRequired,
    this.triviaRequired,
    this.zonesRequired,
    this.groupScansRequired,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'hint': hint,
      'reward': reward.toMap(),
      'completionText': completionText,
      if (scansRequired != null) 'scansRequired': scansRequired,
      if (groupRequired != null) 'groupRequired': groupRequired,
      if (triviaRequired != null) 'triviaRequired': triviaRequired,
      if (zonesRequired != null) 'zonesRequired': zonesRequired,
      if (groupScansRequired != null) 'groupScansRequired': groupScansRequired,
    };
  }

  factory Chapter.fromMap(Map<String, dynamic> map) {
    return Chapter(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      type: ChapterType.values.byName(map['type']),
      hint: map['hint'],
      reward: ChapterReward.fromMap(map['reward']),
      completionText: map['completionText'],
      scansRequired: map['scansRequired'],
      groupRequired: map['groupRequired'],
      triviaRequired: map['triviaRequired'],
      zonesRequired: map['zonesRequired'],
      groupScansRequired: map['groupScansRequired'],
    );
  }
}

class Adventure {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int totalChapters;
  final List<Chapter> chapters;

  const Adventure({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.totalChapters,
    required this.chapters,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'totalChapters': totalChapters,
      'chapters': chapters.map((x) => x.toMap()).toList(),
    };
  }

  factory Adventure.fromMap(Map<String, dynamic> map) {
    return Adventure(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      icon: map['icon'],
      totalChapters: map['totalChapters'] ?? 0,
      chapters: List<Chapter>.from(map['chapters']?.map((x) => Chapter.fromMap(x)) ?? const []),
    );
  }
}

// ── CONSTANT ADVENTURES CATALOG ────────────────
final List<Adventure> kAdventures = [
  Adventure(
    id: 'bosque-perdido',
    title: 'El Misterio del Bosque Perdido',
    description: 'Algo extraño ocurre en el corazón del parque. Los guardianes necesitan tu ayuda para descubrir qué está pasando.',
    icon: '🌲',
    totalChapters: 5,
    chapters: [
      Chapter(
        id: 'ch1',
        title: 'La Primera Pista',
        description: 'Dicen que cerca del puesto de comida hay algo escondido...',
        type: ChapterType.scan,
        hint: 'Busca la Eco-Estación más cercana a la zona de comida',
        reward: ChapterReward(points: 50, creature: 'leaf-fox'),
        completionText: '¡Has encontrado la primera pista! Y una pequeña criatura te ha seguido hasta aquí...',
      ),
      Chapter(
        id: 'ch2',
        title: 'El Acertijo del Guardián',
        description: 'Un antiguo guardián te bloquea el paso. Solo la sabiduría te abrirá el camino.',
        type: ChapterType.trivia,
        hint: 'Responde correctamente para avanzar',
        reward: ChapterReward(points: 30, item: 'llave-dorada'),
        completionText: 'El guardián asiente con respeto. La llave dorada es tuya.',
      ),
      Chapter(
        id: 'ch3',
        title: 'El Rastro Oculto',
        description: 'La llave dorada revela un mapa con 3 puntos marcados en el parque.',
        type: ChapterType.scan,
        hint: 'Encuentra y escanea en 2 Eco-Estaciones diferentes',
        scansRequired: 2,
        reward: ChapterReward(points: 60, creature: 'shell-turtle'),
        completionText: '¡Una tortuga ancestral emerge del suelo! Parece querer acompañarte.',
      ),
      Chapter(
        id: 'ch4',
        title: 'La Llamada de la Manada',
        description: 'No puedes hacerlo solo. Necesitas que tu patrulla complete sus propias misiones.',
        type: ChapterType.group,
        hint: 'Consigue que 2 amigos se unan a tu patrulla',
        groupRequired: 2,
        reward: ChapterReward(points: 80, item: 'cristal-aurora'),
        completionText: 'Juntos sois más fuertes. El cristal aurora brilla con la energía del equipo.',
      ),
      Chapter(
        id: 'ch5',
        title: 'El Corazón del Bosque',
        description: 'El capítulo final. El bosque te espera para revelarte su secreto.',
        type: ChapterType.scan,
        hint: 'Completa un último escaneo para desbloquear el secreto del bosque',
        reward: ChapterReward(points: 150, creature: 'crystal-deer'),
        completionText: '¡El Ciervo de Cristal aparece ante ti! Has salvado el Bosque Perdido. Eres un verdadero Guardián.',
      ),
    ],
  ),
  Adventure(
    id: 'oceano-secreto',
    title: 'Los Secretos del Océano',
    description: 'Las aguas del parque esconden criaturas legendarias. ¿Te atreves a buscarlas?',
    icon: '🌊',
    totalChapters: 4,
    chapters: [
      Chapter(
        id: 'ch1',
        title: 'Susurros del Agua',
        description: 'Las fuentes del parque parecen enviar un mensaje...',
        type: ChapterType.scan,
        hint: 'Visita la Eco-Estación cerca de la zona acuática',
        reward: ChapterReward(points: 50, creature: 'wave-dolphin'),
        completionText: '¡Un delfín de olas emerge! Te guiará en tu viaje oceánico.',
      ),
      Chapter(
        id: 'ch2',
        title: 'El Desafío de las Mareas',
        description: 'Para dominar el océano, debes demostrar tu conocimiento.',
        type: ChapterType.trivia,
        hint: 'Responde 3 preguntas sobre la naturaleza',
        triviaRequired: 3,
        reward: ChapterReward(points: 45, item: 'perla-marina'),
        completionText: 'La perla marina brilla en tu inventario. El océano te acepta.',
      ),
      Chapter(
        id: 'ch3',
        title: 'Explorador de Profundidades',
        description: 'Explora todos los rincones del parque para encontrar las corrientes ocultas.',
        type: ChapterType.explore,
        hint: 'Visita 4 zonas diferentes del mapa',
        zonesRequired: 4,
        reward: ChapterReward(points: 70, creature: 'wise-owl'),
        completionText: '¡El Búho Sabio desciende de las alturas! Puede ver lo que otros no ven.',
      ),
      Chapter(
        id: 'ch4',
        title: 'La Tormenta Final',
        description: 'Una gran tormenta amenaza el parque. Solo uniendo fuerzas podrás detenerla.',
        type: ChapterType.group,
        hint: 'Completa 5 escaneos con tu patrulla',
        groupScansRequired: 5,
        reward: ChapterReward(points: 200, creature: 'spark-butterfly'),
        completionText: '¡La Mariposa Estelar nace de la tormenta! Has completado Los Secretos del Océano.',
      ),
    ],
  ),
];
