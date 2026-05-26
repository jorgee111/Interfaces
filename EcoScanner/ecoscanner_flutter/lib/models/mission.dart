class Mission {
  final String id;
  final String icon;
  final String title;
  final String desc;
  final int pts;
  final int total;
  final String expires;
  int progress;
  bool done;

  Mission({
    required this.id,
    required this.icon,
    required this.title,
    required this.desc,
    required this.pts,
    required this.total,
    required this.expires,
    this.progress = 0,
    this.done = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'icon': icon,
      'title': title,
      'desc': desc,
      'pts': pts,
      'total': total,
      'expires': expires,
      'progress': progress,
      'done': done,
    };
  }

  factory Mission.fromMap(Map<String, dynamic> map) {
    return Mission(
      id: map['id'],
      icon: map['icon'],
      title: map['title'],
      desc: map['desc'],
      pts: map['pts'] ?? 0,
      total: map['total'] ?? 1,
      expires: map['expires'] ?? '',
      progress: map['progress'] ?? 0,
      done: map['done'] ?? false,
    );
  }
}

// ── DAILY MISSION POOL (REPLICATED FROM APP.JS) ─────────────────
final List<Mission> kDailyMissionsPool = [
  Mission(id: 'dm1', icon: '♻️', title: 'Recicla 3 envases', desc: 'Escanea 3 contenedores de reciclaje distintos en el parque', pts: 30, total: 3, expires: '20:00'),
  Mission(id: 'dm2', icon: '🧠', title: 'Maestro del trivia', desc: 'Responde correctamente 2 preguntas de trivia de naturaleza', pts: 20, total: 2, expires: '20:00'),
  Mission(id: 'dm3', icon: '🗺️', title: 'Explorador de zonas', desc: 'Visita y escanea en 2 zonas diferentes del parque', pts: 25, total: 2, expires: '20:00'),
  Mission(id: 'dm4', icon: '⚡', title: 'Reto relámpago', desc: 'Sé el primero de tu grupo en completar una misión hoy', pts: 50, total: 1, expires: '12:00'),
  Mission(id: 'dm5', icon: '👥', title: 'Patrulla unida', desc: 'Completa una acción junto con otro miembro de tu patrulla', pts: 40, total: 1, expires: '20:00'),
  Mission(id: 'dm6', icon: '🍃', title: 'Alimenta a tu criatura', desc: 'Alimenta a tu criatura compañera 3 veces hoy', pts: 15, total: 3, expires: '20:00'),
  Mission(id: 'dm7', icon: '📸', title: 'Documentalista eco', desc: 'Completa un escaneo con éxito y sube a 50+ puntos de sesión', pts: 20, total: 1, expires: '18:00'),
];
