/* ── ECOSCANNER — GLOBAL STATE ──────────────────────────── */
const EcoApp = (() => {
  const LEVELS = [
    { min:0,   name:'🌱 Novato Verde',      color:'#4CAF50' },
    { min:100, name:'🌿 Guardián Eco',       color:'#00C9A7' },
    { min:300, name:'🌍 Héroe del Reciclaje',color:'#2196F3' },
    { min:600, name:'⭐ Leyenda Verde',       color:'#FFB830' },
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
    for (const l of LEVELS) { if (pts >= l.min) lv = l; else break; }
    return lv;
  }
  function getNextLevel(pts) {
    for (const l of LEVELS) { if (l.min > pts) return l; }
    return null;
  }
  function getLevelProgress(pts) {
    const cur = getLevel(pts);
    const nxt = getNextLevel(pts);
    if (!nxt) return 100;
    const range = nxt.min - cur.min;
    const done  = pts - cur.min;
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

  return {
    get, getPoints, getLevelData, getProgress, getNextLevelData,
    getCatalog, getLeaderboard, getPatrolBoard, getMissions, getMetrics,
    getOracle, getMascotData, addPoints, spendPoints, initNav, save, toggleDarkMode,
    LEVELS, REWARDS_CATALOG,
  };
})();

window.EcoApp = EcoApp;
