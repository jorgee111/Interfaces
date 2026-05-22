/* ── ECOSCANNER — CONFETTI ENGINE ───────────────────────── */
const Confetti = (() => {
  let canvas, ctx, particles = [], rafId = null;

  function init() {
    if (canvas) return;
    canvas = document.createElement('canvas');
    Object.assign(canvas.style, {
      position:'fixed', top:'0', left:'0', width:'100%', height:'100%',
      pointerEvents:'none', zIndex:'9999',
    });
    document.body.appendChild(canvas);
    resize();
    window.addEventListener('resize', resize);
  }

  function resize() {
    if (!canvas) return;
    canvas.width  = window.innerWidth;
    canvas.height = window.innerHeight;
  }

  function randomBetween(a, b) { return a + Math.random() * (b - a); }

  function createParticle(colors) {
    return {
      x:    randomBetween(canvas.width * .2, canvas.width * .8),
      y:    -12,
      vx:   randomBetween(-3, 3),
      vy:   randomBetween(4, 9),
      rot:  randomBetween(0, 360),
      rotV: randomBetween(-6, 6),
      w:    randomBetween(8, 14),
      h:    randomBetween(4, 8),
      color: colors[Math.floor(Math.random() * colors.length)],
      alpha: 1,
      life:  1,
    };
  }

  function step() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    particles = particles.filter(p => p.alpha > 0.05);

    for (const p of particles) {
      p.x += p.vx;
      p.y += p.vy;
      p.vy += 0.18; // gravity
      p.rot += p.rotV;
      if (p.y > canvas.height * 0.7) p.alpha -= 0.03;

      ctx.save();
      ctx.globalAlpha = p.alpha;
      ctx.translate(p.x, p.y);
      ctx.rotate((p.rot * Math.PI) / 180);
      ctx.fillStyle = p.color;
      ctx.beginPath();
      ctx.ellipse(0, 0, p.w / 2, p.h / 2, 0, 0, Math.PI * 2);
      ctx.fill();
      ctx.restore();
    }

    if (particles.length > 0) rafId = requestAnimationFrame(step);
    else if (rafId) { cancelAnimationFrame(rafId); rafId = null; }
  }

  function fire({ count = 80, colors = ['#00C9A7','#FFB830','#7C5CFC','#FF7A3D','#4B9EFF','#FF4757','#2ECC71'] } = {}) {
    init();
    for (let i = 0; i < count; i++) {
      setTimeout(() => particles.push(createParticle(colors)), i * 12);
    }
    if (!rafId) rafId = requestAnimationFrame(step);
  }

  function goldFire() {
    fire({ count:60, colors:['#FFB830','#FFD700','#FFC107','#FFECB3','#FF8F00'] });
  }

  return { fire, goldFire };
})();
window.Confetti = Confetti;
