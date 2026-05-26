class Reward {
  final String id;
  final String title;
  final String desc;
  final int cost;
  final String category;
  final String icon;
  final bool available;

  const Reward({
    required this.id,
    required this.title,
    required this.desc,
    required this.cost,
    required this.category,
    required this.icon,
    this.available = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'cost': cost,
      'category': category,
      'icon': icon,
      'available': available,
    };
  }

  factory Reward.fromMap(Map<String, dynamic> map) {
    return Reward(
      id: map['id'],
      title: map['title'],
      desc: map['desc'],
      cost: map['cost'] ?? 0,
      category: map['category'] ?? '',
      icon: map['icon'] ?? '',
      available: map['available'] ?? true,
    );
  }
}

// ── REWARDS CATALOG CONSTANT ───────────────────
final List<Reward> kRewardsCatalog = [
  Reward(id: 'r1', title: 'Palomitas Gratis', desc: 'Canjea por unas palomitas pequeñas', cost: 40, category: 'comida', icon: '🍿'),
  Reward(id: 'r2', title: 'Refresco Mediano', desc: 'Bebida refrescante gratis', cost: 30, category: 'comida', icon: '🥤'),
  Reward(id: 'r3', title: 'Fast Pass Faunia', desc: 'Acceso rápido a 1 exhibición', cost: 100, category: 'fastpass', icon: '⚡'),
  Reward(id: 'r4', title: 'Entrada 50% Parque Warner', desc: 'Descuento para tu próxima aventura', cost: 250, category: 'entradas', icon: '🎟️'),
  Reward(id: 'r5', title: 'Entrada Parque de Atracciones', desc: 'Entrada gratis 1 día', cost: 500, category: 'entradas', icon: '🎫'),
  Reward(id: 'r6', title: 'Pin Edición Limitada', desc: 'Coleccionable exclusivo del parque', cost: 80, category: 'colec', icon: '📍'),
];
