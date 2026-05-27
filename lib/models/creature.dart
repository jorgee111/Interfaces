import 'package:flutter/material.dart';

class CreatureStage {
  final String name;
  final String emoji;
  final int feedRequired;
  final String description;

  const CreatureStage({
    required this.name,
    required this.emoji,
    required this.feedRequired,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'emoji': emoji,
      'feedRequired': feedRequired,
      'description': description,
    };
  }

  factory CreatureStage.fromMap(Map<String, dynamic> map) {
    return CreatureStage(
      name: map['name'],
      emoji: map['emoji'],
      feedRequired: map['feedRequired'],
      description: map['description'],
    );
  }
}

class Creature {
  final String id;
  final String name;
  final String element;
  final Color color;
  final List<CreatureStage> stages;

  const Creature({
    required this.id,
    required this.name,
    required this.element,
    required this.color,
    required this.stages,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'element': element,
      'color': color.value,
      'stages': stages.map((x) => x.toMap()).toList(),
    };
  }

  factory Creature.fromMap(Map<String, dynamic> map) {
    return Creature(
      id: map['id'],
      name: map['name'],
      element: map['element'],
      color: Color(map['color']),
      stages: List<CreatureStage>.from(map['stages']?.map((x) => CreatureStage.fromMap(x)) ?? const []),
    );
  }
}

// ── CONSTANT CREATURES CATALOG ─────────────────
final List<Creature> kCreatures = [
  const Creature(
    id: 'leaf-fox',
    name: 'Leaf Fox',
    element: 'forest',
    color: Color(0xFF22C55E),
    stages: [
      CreatureStage(name: 'Cachorro Hoja', emoji: '🦊', feedRequired: 0, description: 'Un pequeño zorro nacido entre las hojas.'),
      CreatureStage(name: 'Zorro del Bosque', emoji: '🦊', feedRequired: 5, description: 'Ha crecido y conoce cada rincón del bosque.'),
      CreatureStage(name: 'Guardián Forestal', emoji: '🦊', feedRequired: 15, description: 'Protector legendario del bosque. Su pelaje brilla con luz esmeralda.'),
    ],
  ),
  const Creature(
    id: 'shell-turtle',
    name: 'Shell Turtle',
    element: 'earth',
    color: Color(0xFFA16207),
    stages: [
      CreatureStage(name: 'Huevo Ancestral', emoji: '🥚', feedRequired: 0, description: 'Un huevo misterioso que late con energía antigua.'),
      CreatureStage(name: 'Tortuga Joven', emoji: '🐢', feedRequired: 5, description: 'Lenta pero sabia. Carga secretos en su caparazón.'),
      CreatureStage(name: 'Tortuga Ancestral', emoji: '🐢', feedRequired: 15, description: 'Ha vivido siglos. Su caparazón es un mapa del mundo.'),
    ],
  ),
  const Creature(
    id: 'wave-dolphin',
    name: 'Wave Dolphin',
    element: 'ocean',
    color: Color(0xFF06B6D4),
    stages: [
      CreatureStage(name: 'Cría de Olas', emoji: '🐬', feedRequired: 0, description: 'Salta entre las olas con alegría.'),
      CreatureStage(name: 'Delfín Viajero', emoji: '🐬', feedRequired: 5, description: 'Ha recorrido todos los mares del parque.'),
      CreatureStage(name: 'Delfín Guardián', emoji: '🐬', feedRequired: 15, description: 'Protector de las aguas. Su canto calma las tormentas.'),
    ],
  ),
  const Creature(
    id: 'wise-owl',
    name: 'Wise Owl',
    element: 'air',
    color: Color(0xFF7C5CFC),
    stages: [
      CreatureStage(name: 'Polluelo Curioso', emoji: '🐣', feedRequired: 0, description: 'Pequeño pero con ojos llenos de preguntas.'),
      CreatureStage(name: 'Búho Estudioso', emoji: '🦉', feedRequired: 5, description: 'Lee los vientos y conoce todos los acertijos.'),
      CreatureStage(name: 'Búho Sabio', emoji: '🦉', feedRequired: 15, description: 'La criatura más sabia. Sus ojos ven la verdad.'),
    ],
  ),
  const Creature(
    id: 'crystal-deer',
    name: 'Crystal Deer',
    element: 'crystal',
    color: Color(0xFFA855F7),
    stages: [
      CreatureStage(name: 'Cervatillo Cristal', emoji: '🦌', feedRequired: 0, description: 'Su cornamenta emite destellos tenues.'),
      CreatureStage(name: 'Ciervo Prisma', emoji: '🦌', feedRequired: 5, description: 'La luz se refracta en sus cristales creando arcoíris.'),
      CreatureStage(name: 'Ciervo Legendario', emoji: '🦌', feedRequired: 15, description: 'Criatura legendaria. Su presencia purifica todo a su alrededor.'),
    ],
  ),
  const Creature(
    id: 'spark-butterfly',
    name: 'Spark Butterfly',
    element: 'light',
    color: Color(0xFFF59E0B),
    stages: [
      CreatureStage(name: 'Oruga Chispa', emoji: '🐛', feedRequired: 0, description: 'Pequeña pero llena de energía eléctrica.'),
      CreatureStage(name: 'Crisálida Estelar', emoji: '🌟', feedRequired: 5, description: 'Algo mágico está ocurriendo dentro...'),
      CreatureStage(name: 'Mariposa Estelar', emoji: '🦋', feedRequired: 15, description: 'Sus alas brillan con la luz de las estrellas. La más rara de todas.'),
    ],
  ),
];
