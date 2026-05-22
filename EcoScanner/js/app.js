/* ── ECOSCANNER ADVENTURES — DATA CONSTANTS ─────────────── */

const ADVENTURES = [
  {
    id: 'bosque-perdido',
    title: 'El Misterio del Bosque Perdido',
    description: 'Algo extraño ocurre en el corazón del parque. Los guardianes necesitan tu ayuda para descubrir qué está pasando.',
    icon: '🌲',
    totalChapters: 5,
    chapters: [
      {
        id: 'ch1',
        title: 'La Primera Pista',
        description: 'Dicen que cerca del puesto de comida hay algo escondido...',
        type: 'scan',
        hint: 'Busca la Eco-Estación más cercana a la zona de comida',
        reward: { points: 50, creature: 'leaf-fox' },
        completionText: '¡Has encontrado la primera pista! Y una pequeña criatura te ha seguido hasta aquí...'
      },
      {
        id: 'ch2',
        title: 'El Acertijo del Guardián',
        description: 'Un antiguo guardián te bloquea el paso. Solo la sabiduría te abrirá el camino.',
        type: 'trivia',
        hint: 'Responde correctamente para avanzar',
        reward: { points: 30, item: 'llave-dorada' },
        completionText: 'El guardián asiente con respeto. La llave dorada es tuya.'
      },
      {
        id: 'ch3',
        title: 'El Rastro Oculto',
        description: 'La llave dorada revela un mapa con 3 puntos marcados en el parque.',
        type: 'scan',
        hint: 'Encuentra y escanea en 2 Eco-Estaciones diferentes',
        scansRequired: 2,
        reward: { points: 60, creature: 'shell-turtle' },
        completionText: '¡Una tortuga ancestral emerge del suelo! Parece querer acompañarte.'
      },
      {
        id: 'ch4',
        title: 'La Llamada de la Manada',
        description: 'No puedes hacerlo solo. Necesitas que tu patrulla complete sus propias misiones.',
        type: 'group',
        hint: 'Consigue que 2 amigos se unan a tu patrulla',
        groupRequired: 2,
        reward: { points: 80, item: 'cristal-aurora' },
        completionText: 'Juntos sois más fuertes. El cristal aurora brilla con la energía del equipo.'
      },
      {
        id: 'ch5',
        title: 'El Corazón del Bosque',
        description: 'El capítulo final. El bosque te espera para revelarte su secreto.',
        type: 'scan',
        hint: 'Completa un último escaneo para desbloquear el secreto del bosque',
        reward: { points: 150, creature: 'crystal-deer' },
        completionText: '¡El Ciervo de Cristal aparece ante ti! Has salvado el Bosque Perdido. Eres un verdadero Guardián.'
      }
    ]
  },
  {
    id: 'oceano-secreto',
    title: 'Los Secretos del Océano',
    description: 'Las aguas del parque esconden criaturas legendarias. ¿Te atreves a buscarlas?',
    icon: '🌊',
    totalChapters: 4,
    chapters: [
      {
        id: 'ch1',
        title: 'Susurros del Agua',
        description: 'Las fuentes del parque parecen enviar un mensaje...',
        type: 'scan',
        hint: 'Visita la Eco-Estación cerca de la zona acuática',
        reward: { points: 50, creature: 'wave-dolphin' },
        completionText: '¡Un delfín de olas emerge! Te guiará en tu viaje oceánico.'
      },
      {
        id: 'ch2',
        title: 'El Desafío de las Mareas',
        description: 'Para dominar el océano, debes demostrar tu conocimiento.',
        type: 'trivia',
        hint: 'Responde 3 preguntas sobre la naturaleza',
        triviaRequired: 3,
        reward: { points: 45, item: 'perla-marina' },
        completionText: 'La perla marina brilla en tu inventario. El océano te acepta.'
      },
      {
        id: 'ch3',
        title: 'Explorador de Profundidades',
        description: 'Explora todos los rincones del parque para encontrar las corrientes ocultas.',
        type: 'explore',
        hint: 'Visita 4 zonas diferentes del mapa',
        zonesRequired: 4,
        reward: { points: 70, creature: 'wise-owl' },
        completionText: '¡El Búho Sabio desciende de las alturas! Puede ver lo que otros no ven.'
      },
      {
        id: 'ch4',
        title: 'La Tormenta Final',
        description: 'Una gran tormenta amenaza el parque. Solo uniendo fuerzas podrás detenerla.',
        type: 'group',
        hint: 'Completa 5 escaneos con tu patrulla',
        groupScansRequired: 5,
        reward: { points: 200, creature: 'spark-butterfly' },
        completionText: '¡La Mariposa Estelar nace de la tormenta! Has completado Los Secretos del Océano.'
      }
    ]
  }
];

const CREATURES = [
  {
    id: 'leaf-fox',
    name: 'Leaf Fox',
    element: 'forest',
    color: '#22C55E',
    bgGradient: 'linear-gradient(135deg, #22C55E20, #16A34A30)',
    stages: [
      { name: 'Cachorro Hoja', emoji: '🦊', feedRequired: 0, description: 'Un pequeño zorro nacido entre las hojas.' },
      { name: 'Zorro del Bosque', emoji: '🦊', feedRequired: 5, description: 'Ha crecido y conoce cada rincón del bosque.' },
      { name: 'Guardián Forestal', emoji: '🦊', feedRequired: 15, description: 'Protector legendario del bosque. Su pelaje brilla con luz esmeralda.' }
    ]
  },
  {
    id: 'shell-turtle',
    name: 'Shell Turtle',
    element: 'earth',
    color: '#A16207',
    bgGradient: 'linear-gradient(135deg, #A1620720, #92400E30)',
    stages: [
      { name: 'Huevo Ancestral', emoji: '🥚', feedRequired: 0, description: 'Un huevo misterioso que late con energía antigua.' },
      { name: 'Tortuga Joven', emoji: '🐢', feedRequired: 5, description: 'Lenta pero sabia. Carga secretos en su caparazón.' },
      { name: 'Tortuga Ancestral', emoji: '🐢', feedRequired: 15, description: 'Ha vivido siglos. Su caparazón es un mapa del mundo.' }
    ]
  },
  {
    id: 'wave-dolphin',
    name: 'Wave Dolphin',
    element: 'ocean',
    color: '#06B6D4',
    bgGradient: 'linear-gradient(135deg, #06B6D420, #0891B230)',
    stages: [
      { name: 'Cría de Olas', emoji: '🐬', feedRequired: 0, description: 'Salta entre las olas con alegría.' },
      { name: 'Delfín Viajero', emoji: '🐬', feedRequired: 5, description: 'Ha recorrido todos los mares del parque.' },
      { name: 'Delfín Guardián', emoji: '🐬', feedRequired: 15, description: 'Protector de las aguas. Su canto calma las tormentas.' }
    ]
  },
  {
    id: 'wise-owl',
    name: 'Wise Owl',
    element: 'air',
    color: '#7C5CFC',
    bgGradient: 'linear-gradient(135deg, #7C5CFC20, #6D28D930)',
    stages: [
      { name: 'Polluelo Curioso', emoji: '🐣', feedRequired: 0, description: 'Pequeño pero con ojos llenos de preguntas.' },
      { name: 'Búho Estudioso', emoji: '🦉', feedRequired: 5, description: 'Lee los vientos y conoce todos los acertijos.' },
      { name: 'Búho Sabio', emoji: '🦉', feedRequired: 15, description: 'La criatura más sabia. Sus ojos ven la verdad.' }
    ]
  },
  {
    id: 'crystal-deer',
    name: 'Crystal Deer',
    element: 'crystal',
    color: '#A855F7',
    bgGradient: 'linear-gradient(135deg, #A855F720, #9333EA30)',
    stages: [
      { name: 'Cervatillo Cristal', emoji: '🦌', feedRequired: 0, description: 'Su cornamenta emite destellos tenues.' },
      { name: 'Ciervo Prisma', emoji: '🦌', feedRequired: 5, description: 'La luz se refracta en sus cristales creando arcoíris.' },
      { name: 'Ciervo Legendario', emoji: '🦌', feedRequired: 15, description: 'Criatura legendaria. Su presencia purifica todo a su alrededor.' }
    ]
  },
  {
    id: 'spark-butterfly',
    name: 'Spark Butterfly',
    element: 'light',
    color: '#F59E0B',
    bgGradient: 'linear-gradient(135deg, #F59E0B20, #D9770630)',
    stages: [
      { name: 'Oruga Chispa', emoji: '🐛', feedRequired: 0, description: 'Pequeña pero llena de energía eléctrica.' },
      { name: 'Crisálida Estelar', emoji: '🌟', feedRequired: 5, description: 'Algo mágico está ocurriendo dentro...' },
      { name: 'Mariposa Estelar', emoji: '🦋', feedRequired: 15, description: 'Sus alas brillan con la luz de las estrellas. La más rara de todas.' }
    ]
  }
];

const TRIVIA_POOL = [
  {
    id: 0,
    category: 'naturaleza',
    question: '¿Cuántos años tarda en degradarse una botella de plástico?',
    options: ['10 años', '100 años', '450 años'],
    correct: 2,
    funFact: 'Una botella de plástico tarda unos 450 años en descomponerse. ¡Casi medio milenio!'
  },
  {
    id: 1,
    category: 'naturaleza',
    question: '¿Qué porcentaje del agua del planeta es agua dulce accesible?',
    options: ['25%', 'Menos del 1%', '10%'],
    correct: 1,
    funFact: 'Solo el 0.5% del agua del planeta es dulce y accesible. ¡Cada gota cuenta!'
  },
  {
    id: 2,
    category: 'curiosidades',
    question: '¿Cuántos árboles se necesitan para producir el oxígeno de una persona al año?',
    options: ['2 árboles', '7 árboles', '22 árboles'],
    correct: 1,
    funFact: 'Se necesitan aproximadamente 7 árboles para producir el oxígeno que respira una persona en un año.'
  },
  {
    id: 3,
    category: 'naturaleza',
    question: '¿Cuál es el animal terrestre más rápido del mundo?',
    options: ['León', 'Guepardo', 'Gacela'],
    correct: 1,
    funFact: 'El guepardo puede alcanzar velocidades de hasta 120 km/h en sprints cortos.'
  },
  {
    id: 4,
    category: 'medioambiente',
    question: '¿Cuántas veces se puede reciclar el aluminio?',
    options: ['5 veces', '20 veces', 'Infinitas veces'],
    correct: 2,
    funFact: 'El aluminio se puede reciclar infinitas veces sin perder calidad. ¡Es un material increíble!'
  },
  {
    id: 5,
    category: 'curiosidades',
    question: '¿Qué animal puede dormir hasta 22 horas al día?',
    options: ['Oso perezoso', 'Koala', 'Gato'],
    correct: 1,
    funFact: 'Los koalas duermen entre 18-22 horas al día porque las hojas de eucalipto les dan muy poca energía.'
  },
  {
    id: 6,
    category: 'medioambiente',
    question: '¿Qué gas es el principal responsable del efecto invernadero?',
    options: ['Oxígeno', 'Dióxido de carbono', 'Nitrógeno'],
    correct: 1,
    funFact: 'El CO₂ representa más del 75% de las emisiones de gases de efecto invernadero globales.'
  },
  {
    id: 7,
    category: 'curiosidades',
    question: '¿Cuántas especies de insectos se estima que existen en el mundo?',
    options: ['100.000', '1 millón', '10 millones'],
    correct: 2,
    funFact: 'Se estima que existen unos 10 millones de especies de insectos, ¡y solo conocemos 1 millón!'
  },
  {
    id: 8,
    category: 'naturaleza',
    question: '¿Cuál es el océano más grande del planeta?',
    options: ['Atlántico', 'Índico', 'Pacífico'],
    correct: 2,
    funFact: 'El Pacífico cubre más de 165 millones de km². ¡Es más grande que toda la tierra firme junta!'
  },
  {
    id: 9,
    category: 'medioambiente',
    question: '¿Cuántas bolsas de plástico se usan cada minuto en el mundo?',
    options: ['100.000', '1 millón', '2 millones'],
    correct: 1,
    funFact: 'Se usan aproximadamente 1 millón de bolsas de plástico por minuto en todo el mundo.'
  },
  {
    id: 10,
    category: 'curiosidades',
    question: '¿Cuánto pesa aproximadamente una ballena azul adulta?',
    options: ['50 toneladas', '100 toneladas', '150 toneladas'],
    correct: 2,
    funFact: 'Una ballena azul puede pesar hasta 150 toneladas, ¡el animal más grande que ha existido!'
  },
  {
    id: 11,
    category: 'naturaleza',
    question: '¿Qué porcentaje del oxígeno mundial producen los océanos?',
    options: ['20%', '50%', '70%'],
    correct: 2,
    funFact: 'Los océanos producen alrededor del 70% del oxígeno mundial gracias al fitoplancton.'
  },
  {
    id: 12,
    category: 'medioambiente',
    question: '¿Cuántos litros de agua se necesitan para producir una camiseta de algodón?',
    options: ['100 litros', '700 litros', '2.700 litros'],
    correct: 2,
    funFact: 'Se necesitan unos 2.700 litros de agua para una sola camiseta. ¡La moda tiene huella hídrica!'
  },
  {
    id: 13,
    category: 'curiosidades',
    question: '¿Cuál es el árbol más antiguo del mundo?',
    options: ['Un roble de 1.000 años', 'Un pino de 5.000 años', 'Un olivo de 3.000 años'],
    correct: 1,
    funFact: 'El pino Matusalén tiene más de 4.850 años y vive en California. ¡Nació antes de las pirámides!'
  },
  {
    id: 14,
    category: 'naturaleza',
    question: '¿Cuántas hormigas se estima que hay en la Tierra?',
    options: ['1 billón', '10 billones', '20 trillones'],
    correct: 2,
    funFact: 'Se estima que hay unos 20 trillones (20.000.000.000.000.000) de hormigas en la Tierra.'
  },
  {
    id: 15,
    category: 'medioambiente',
    question: '¿Qué material tarda más en degradarse?',
    options: ['Lata de aluminio', 'Botella de vidrio', 'Pañal desechable'],
    correct: 1,
    funFact: 'Una botella de vidrio puede tardar hasta 4.000 años en degradarse, pero se recicla infinitamente.'
  },
  {
    id: 16,
    category: 'curiosidades',
    question: '¿Pueden los pulpos cambiar de color?',
    options: ['No, es un mito', 'Sí, pero solo 2 colores', 'Sí, miles de combinaciones'],
    correct: 2,
    funFact: 'Los pulpos tienen células especiales llamadas cromatóforos que les permiten cambiar a miles de patrones.'
  },
  {
    id: 17,
    category: 'naturaleza',
    question: '¿Cuántos km puede recorrer una mariposa monarca en su migración?',
    options: ['500 km', '2.000 km', '4.500 km'],
    correct: 2,
    funFact: 'La mariposa monarca viaja hasta 4.500 km desde Canadá hasta México cada año. ¡Increíble para su tamaño!'
  }
];

/* ── ECOSCANNER ADVENTURES — GLOBAL STATE ──────────────── */
const EcoApp = (() => {
  const LEVELS = [
    { minPoints: 0, name: 'Explorador Novato', icon: '🌱' },
    { minPoints: 100, name: 'Aventurero', icon: '🗺️' },
    { minPoints: 300, name: 'Guardián del Parque', icon: '🛡️' },
    { minPoints: 600, name: 'Leyenda Viviente', icon: '⭐' }
  ];

  const REWARDS_CATALOG = [
    { id:'r1', title:'10% de Descuento', desc:'En tu próxima entrada al parque', cost:50,  category:'descuento', color:'linear-gradient(135deg, #FF9500, #FFCC00)',  icon:'<i class="bx bx-purchase-tag-alt"></i>',  available:true },
    { id:'r2', title:'Fast Pass Premium',     desc:'Acceso rápido a 3 atracciones',  cost:120, category:'fastpass',  color:'linear-gradient(135deg, #AF52DE, #FF2D55)', icon:'<i class="bx bxs-zap"></i>',  available:true },
    { id:'r3', title:'Pin Edición Limitada',  desc:'Coleccionable exclusivo del parque', cost:80, category:'colec', color:'linear-gradient(135deg, #00A1FF, #007AFF)',   icon:'<i class="bx bx-pin"></i>', available:true },
    { id:'r4', title:'Menú Eco Gratis',       desc:'Bebida + snack sostenible',       cost:90,  category:'comida',   color:'linear-gradient(135deg, #34C759, #28A745)', icon:'<i class="bx bx-restaurant"></i>',  available:true },
    { id:'r5', title:'Filtro AR Exclusivo',   desc:'Filtro especial para tus fotos',  cost:30,  category:'digital',  color:'var(--primary-gradient)','icon':'<i class="bx bx-camera-movie"></i>', available:true },
    { id:'r6', title:'Donación Árbol',        desc:'Plantamos un árbol en tu nombre', cost:60,  category:'donacion', color:'linear-gradient(135deg, #2ECC71, #27AE60)',       icon:'<i class="bx bx-tree"></i>',  available:true },
  ];

  const LEADERBOARD = [
    { rank:1, name:'Carlos López',  pts:245, avatar:'<i class="bx bx-leaf"></i>', badge:'gold'   },
    { rank:2, name:'Ana Martínez',  pts:220, avatar:'<i class="bx bx-world"></i>', badge:'silver' },
    { rank:3, name:'Luis Rodríguez',pts:198, avatar:'<i class="bx bx-recycle"></i>', badge:'bronze' },
    { rank:4, name:'Elena Torres',  pts:192, avatar:'<i class="bx bx-seedling"></i>', badge:''       },
    { rank:5, name:'María García',  pts:185, avatar:'<i class="bx bxs-star"></i>', badge:'',  isUser:true },
    { rank:6, name:'Pedro Sánchez', pts:172, avatar:'<i class="bx bx-leaf"></i>', badge:''       },
    { rank:7, name:'Laura Vega',    pts:158, avatar:'<i class="bx bx-heart"></i>', badge:''       },
  ];

  const PATROL_LEADERBOARD = [
    { rank:1, name:'Green Avengers', pts:1240, members:6 },
    { rank:2, name:'Eco Warriors',   pts:892,  members:5, isUser:true },
    { rank:3, name:'Planet Savers',  pts:780,  members:4 },
    { rank:4, name:'Blue Ocean',     pts:650,  members:5 },
  ];

  const MISSIONS = [
    { id:'m1', icon:'<i class="bx bx-recycle"></i>', title:'Recicla 3 envases hoy',      desc:'Devuelve 3 envases reutilizables en cualquier punto',  pts:30, progress:1, total:3,  expires:'14:00', done:false },
    { id:'m2', icon:'<i class="bx bx-camera"></i>', title:'Foto de separación perfecta', desc:'Sube evidencia de separación correcta orgánico/plástico', pts:20, progress:0, total:1, expires:'18:00', done:false },
    { id:'m3', icon:'<i class="bx bxs-zap"></i>', title:'Reto relámpago: ¡Sé el 1º!', desc:'Sé el primero de tu patrulla en escanear hoy',         pts:50, progress:0, total:1,  expires:'12:00', done:false },
    { id:'m4', icon:'<i class="bx bx-map-alt"></i>', title:'Eco-Explorador',              desc:'Recicla en un contenedor con poca actividad',          pts:25, progress:0, total:1,  expires:'20:00', done:false },
    { id:'m5', icon:'<i class="bx bx-group"></i>', title:'Patrulla unida',              desc:'Tu patrulla completa al menos 1 acción cada miembro',  pts:40, progress:2, total:5,  expires:'20:00', done:false },
  ];

  const ECO_METRICS = {
    bottles:   { label:'Envases Devueltos',   value:12, icon:'<i class="bx bx-package"></i>', color:'blue',     unit:'' },
    separated: { label:'Residuos Separados',  value:28, icon:'<i class="bx bx-leaf"></i>', color:'green',  unit:'' },
    kg:        { label:'Kg Reciclados',       value:4.3,icon:'<i class="bx bx-trending-up"></i>', color:'purple',   unit:'kg' },
    days:      { label:'Días Activos',        value:3,  icon:'<i class="bx bx-calendar"></i>', color:'orange',   unit:'' },
  };

  // ── State ───────────────────────────────────────────────────────
  const defaultState = {
    user:    { name:'María García', avatar:'⭐' },
    points:  1250,
    rank:    42,
    streak:  3,
    patrol:  { name:'Los Guardianes Verdes', points:8400, members:12 },
    history: [
      { action:'Separación correcta',    pts:+10, time:'Hace 5 min',  icon:'<i class="bx bx-recycle"></i>' },
      { action:'Envase devuelto',         pts:+15, time:'Hace 20 min', icon:'<i class="bx bx-package"></i>' },
      { action:'Misión diaria completada',pts:+30, time:'Hace 1h',     icon:'<i class="bx bxs-zap"></i>' },
      { action:'Foto subida',             pts:+20, time:'Ayer 13:00',  icon:'<i class="bx bx-camera"></i>' },
    ],
    redeemedIds: [],
    adventure: {
      activeQuestId: 'bosque-perdido',
      quests: {
        'bosque-perdido': {
          started: true,
          completedChapters: ['ch1'],
          currentChapter: 'ch2'
        },
        'oceano-secreto': {
          started: false,
          completedChapters: [],
          currentChapter: 'ch1'
        }
      },
      inventory: ['llave-dorada'],
      totalChaptersCompleted: 1
    },
    creatures: {
      discovered: [
        { id: 'leaf-fox', discoveredAt: '2025-05-20', feedCount: 3 },
        { id: 'shell-turtle', discoveredAt: '2025-05-21', feedCount: 1 }
      ]
    },
    trivia: {
      answeredIds: [0],
      correctCount: 1,
      streak: 1
    }
  };

  let state = (() => {
    try {
      const saved = localStorage.getItem('ecoscanner_state');
      return saved ? { ...defaultState, ...JSON.parse(saved) } : { ...defaultState };
    } catch { return { ...defaultState }; }
  })();

  // ── Init Dark Mode ───────────────────────────────────────────────
  const isDark = localStorage.getItem('ecoscanner_dark') === 'true';
  if (isDark) document.body.classList.add('dark-mode');

  function toggleDarkMode() {
    const isDarkNow = document.body.classList.toggle('dark-mode');
    localStorage.setItem('ecoscanner_dark', isDarkNow);
    return isDarkNow;
  }

  function save() {
    try { localStorage.setItem('ecoscanner_state', JSON.stringify(state)); } catch {}
  }

  // ── Level helpers ────────────────────────────────────────────────
  function getLevel(pts) {
    let lv = LEVELS[0];
    for (const l of LEVELS) { if (pts >= l.minPoints) lv = l; else break; }
    return lv;
  }
  function getNextLevel(pts) {
    for (const l of LEVELS) { if (l.minPoints > pts) return l; }
    return null;
  }
  function getLevelProgress(pts) {
    const cur = getLevel(pts);
    const nxt = getNextLevel(pts);
    if (!nxt) return 100;
    const range = nxt.minPoints - cur.minPoints;
    const done  = pts - cur.minPoints;
    return Math.round((done / range) * 100);
  }

  // ── Haptic & Audio Feedback ──────────────────────────────────────
  function playSuccessSound() {
    try {
      const ctx = new (window.AudioContext || window.webkitAudioContext)();
      const osc = ctx.createOscillator();
      const gainNode = ctx.createGain();
      osc.type = 'sine';
      osc.connect(gainNode);
      gainNode.connect(ctx.destination);
      osc.frequency.setValueAtTime(523.25, ctx.currentTime); // C5
      osc.frequency.setValueAtTime(659.25, ctx.currentTime + 0.1); // E5
      osc.frequency.setValueAtTime(1046.50, ctx.currentTime + 0.2); // C6
      gainNode.gain.setValueAtTime(0.1, ctx.currentTime);
      gainNode.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.5);
      osc.start(ctx.currentTime);
      osc.stop(ctx.currentTime + 0.5);
    } catch(e) {}
  }

  function triggerHapticFeedback() {
    if (navigator.vibrate) {
      navigator.vibrate([100, 50, 100]);
    }
  }

  // ── Point actions ────────────────────────────────────────────────
  function addPoints(amount, action='Acción sostenible', icon='<i class="bx bx-recycle"></i>') {
    triggerHapticFeedback();
    playSuccessSound();

    const prev = state.points;
    state.points += amount;
    state.history.unshift({ action, pts:+amount, time:'Ahora mismo', icon });
    if (state.history.length > 20) state.history.pop();
    save();
    document.dispatchEvent(new CustomEvent('eco:points-added', { detail:{ amount, total:state.points, prev } }));
    if (getLevel(state.points).name !== getLevel(prev).name) {
      document.dispatchEvent(new CustomEvent('eco:level-up', { detail:{ level: getLevel(state.points) } }));
    }
    return state.points;
  }

  function spendPoints(amount) {
    if (state.points < amount) return false;
    state.points -= amount;
    save();
    document.dispatchEvent(new CustomEvent('eco:points-spent', { detail:{ amount, total:state.points } }));
    return true;
  }

  // ── Getters ──────────────────────────────────────────────────────
  function get() { return state; }
  function getPoints() { return state.points; }
  function getLevelData() { return getLevel(state.points); }
  function getProgress() { return getLevelProgress(state.points); }
  function getNextLevelData() { return getNextLevel(state.points); }
  function getCatalog() { return REWARDS_CATALOG; }
  function getLeaderboard() { return LEADERBOARD; }
  function getPatrolBoard() { return PATROL_LEADERBOARD; }
  function getMissions() { return MISSIONS; }
  function getMetrics() { return ECO_METRICS; }
  function getState() { return state; }
  function saveState(s) { state = s; save(); }

  // ── CO2 Oracle ───────────────────────────────────────────────────
  function getOracle(pts) {
    return {
      co2:   (pts * 0.05).toFixed(1),
      water: Math.floor(pts * 0.8),
      energy:(pts * 0.2).toFixed(1),
    };
  }

  const getMascotData = () => {
    const pts = state.points;
    const streak = state.streak;
    let stage = 0;
    if (pts > 1000) stage = 3;
    else if (pts > 500) stage = 2;
    else if (pts > 100) stage = 1;
    
    let mood = streak > 0 ? 'Feliz 😊' : 'Triste 😢';
    
    const stages = [
      { name: 'Semilla Eco', icon: '<i class="bx bxs-circle"></i>', color: 'var(--yellow)', desc: 'Recién plantada.' },
      { name: 'Brote Tímido', icon: '<i class="bx bx-leaf"></i>', color: 'var(--green2)', desc: 'Empieza a crecer.' },
      { name: 'Planta Fuerte', icon: '<i class="bx bxs-leaf"></i>', color: 'var(--primary)', desc: '¡Abonada con tus acciones!' },
      { name: 'Árbol Guardián', icon: '<i class="bx bxs-tree"></i>', color: 'var(--primary-dark)', desc: '¡El rey del parque!' },
    ];
    
    return { ...stages[stage], mood };
  };

  // ── Navigation active state ──────────────────────────────────────
  function initNav(activePage) {
    const items = document.querySelectorAll('.nav-item');
    items.forEach(el => el.classList.remove('active'));
    const target = document.getElementById('nav-' + activePage);
    if (target) target.classList.add('active');
  }

  // === ADVENTURE METHODS ===
  function getActiveAdventure() {
    const s = getState();
    return ADVENTURES.find(a => a.id === s.adventure.activeQuestId);
  }

  function getQuestProgress(questId) {
    const s = getState();
    const questState = s.adventure.quests[questId];
    const quest = ADVENTURES.find(a => a.id === questId);
    if (!quest || !questState) return { completed: 0, total: 0, percent: 0 };
    const completed = questState.completedChapters.length;
    const total = quest.chapters.length;
    return { completed, total, percent: Math.round((completed / total) * 100) };
  }

  function getCurrentChapter(questId) {
    const s = getState();
    const questState = s.adventure.quests[questId];
    const quest = ADVENTURES.find(a => a.id === questId);
    if (!quest || !questState) return null;
    return quest.chapters.find(ch => ch.id === questState.currentChapter);
  }

  function completeChapter(questId, chapterId) {
    const s = getState();
    const questState = s.adventure.quests[questId];
    const quest = ADVENTURES.find(a => a.id === questId);
    if (!questState || !quest) return;

    if (!questState.completedChapters.includes(chapterId)) {
      questState.completedChapters.push(chapterId);
      s.adventure.totalChaptersCompleted++;

      // Find next chapter
      const chapterIndex = quest.chapters.findIndex(ch => ch.id === chapterId);
      if (chapterIndex < quest.chapters.length - 1) {
        questState.currentChapter = quest.chapters[chapterIndex + 1].id;
      } else {
        questState.currentChapter = null; // Quest completed
      }

      // Grant rewards
      const chapter = quest.chapters.find(ch => ch.id === chapterId);
      if (chapter && chapter.reward) {
        if (chapter.reward.points) addPoints(chapter.reward.points);
        if (chapter.reward.creature) discoverCreature(chapter.reward.creature);
        if (chapter.reward.item && !s.adventure.inventory.includes(chapter.reward.item)) {
          s.adventure.inventory.push(chapter.reward.item);
        }
      }

      saveState(s);
      document.dispatchEvent(new CustomEvent('eco:chapter-completed', { detail: { questId, chapterId } }));
    }
  }

  function getInventory() {
    return getState().adventure.inventory;
  }

  // === CREATURE METHODS ===
  function discoverCreature(creatureId) {
    const s = getState();
    if (!s.creatures.discovered.find(c => c.id === creatureId)) {
      s.creatures.discovered.push({
        id: creatureId,
        discoveredAt: new Date().toISOString().split('T')[0],
        feedCount: 0
      });
      saveState(s);
      document.dispatchEvent(new CustomEvent('eco:creature-discovered', { detail: { creatureId } }));
    }
  }

  function feedCreature(creatureId) {
    const s = getState();
    const creature = s.creatures.discovered.find(c => c.id === creatureId);
    if (creature) {
      creature.feedCount++;
      saveState(s);

      // Check evolution
      const creatureDef = CREATURES.find(c => c.id === creatureId);
      if (creatureDef) {
        const oldLevel = _calculateCreatureLevel(creatureId, creature.feedCount - 1);
        const newLevel = _calculateCreatureLevel(creatureId, creature.feedCount);
        if (newLevel > oldLevel) {
          document.dispatchEvent(new CustomEvent('eco:creature-evolved', { detail: { creatureId, newLevel } }));
        }
      }

      document.dispatchEvent(new CustomEvent('eco:creature-fed', { detail: { creatureId } }));
    }
  }

  function _calculateCreatureLevel(creatureId, feedCount) {
    const creatureDef = CREATURES.find(c => c.id === creatureId);
    if (!creatureDef) return 0;
    let level = 0;
    for (let i = creatureDef.stages.length - 1; i >= 0; i--) {
      if (feedCount >= creatureDef.stages[i].feedRequired) {
        level = i;
        break;
      }
    }
    return level;
  }

  function getCreatureLevel(creatureId) {
    const s = getState();
    const creature = s.creatures.discovered.find(c => c.id === creatureId);
    if (!creature) return 0;
    return _calculateCreatureLevel(creatureId, creature.feedCount);
  }

  function getCreatureStage(creatureId) {
    const creatureDef = CREATURES.find(c => c.id === creatureId);
    if (!creatureDef) return null;
    const level = getCreatureLevel(creatureId);
    return creatureDef.stages[level];
  }

  function getDiscoveredCreatures() {
    return getState().creatures.discovered;
  }

  function getAllCreatures() {
    return CREATURES;
  }

  function isCreatureDiscovered(creatureId) {
    return getState().creatures.discovered.some(c => c.id === creatureId);
  }

  // === TRIVIA METHODS ===
  function getRandomQuestion() {
    const s = getState();
    const unanswered = TRIVIA_POOL.filter(q => !s.trivia.answeredIds.includes(q.id));
    if (unanswered.length === 0) {
      // Reset pool if all answered
      s.trivia.answeredIds = [];
      saveState(s);
      return TRIVIA_POOL[Math.floor(Math.random() * TRIVIA_POOL.length)];
    }
    return unanswered[Math.floor(Math.random() * unanswered.length)];
  }

  function answerQuestion(questionId, selectedIndex) {
    const s = getState();
    const question = TRIVIA_POOL.find(q => q.id === questionId);
    if (!question) return { correct: false };

    const isCorrect = selectedIndex === question.correct;

    if (!s.trivia.answeredIds.includes(questionId)) {
      s.trivia.answeredIds.push(questionId);
    }

    if (isCorrect) {
      s.trivia.correctCount++;
      s.trivia.streak++;
      addPoints(5);

      // Bonus for streak of 3
      if (s.trivia.streak % 3 === 0) {
        addPoints(15); // Bonus!
      }
    } else {
      s.trivia.streak = 0;
    }

    saveState(s);
    return { correct: isCorrect, funFact: question.funFact, streak: s.trivia.streak };
  }

  function getTriviaStats() {
    const s = getState();
    return {
      answered: s.trivia.answeredIds.length,
      correct: s.trivia.correctCount,
      streak: s.trivia.streak,
      total: TRIVIA_POOL.length
    };
  }

  return {
    get, getPoints, getLevelData, getProgress, getNextLevelData,
    getCatalog, getLeaderboard, getPatrolBoard, getMissions, getMetrics,
    getOracle, getMascotData, addPoints, spendPoints, initNav, save, toggleDarkMode,
    getState, saveState,
    // Adventure methods
    getActiveAdventure, getQuestProgress, getCurrentChapter, completeChapter, getInventory,
    // Creature methods
    discoverCreature, feedCreature, getCreatureLevel, getCreatureStage,
    getDiscoveredCreatures, getAllCreatures, isCreatureDiscovered,
    // Trivia methods
    getRandomQuestion, answerQuestion, getTriviaStats,
    LEVELS, REWARDS_CATALOG,
  };
})();

window.EcoApp = EcoApp;
