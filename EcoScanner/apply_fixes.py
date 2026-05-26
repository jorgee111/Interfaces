import os

# 1. css/components.css
css_path = 'css/components.css'
with open(css_path, 'r', encoding='utf-8') as f:
    css = f.read()
css = css.replace('position:absolute; bottom:0; left:0;', 'position:fixed; bottom:0; left:0; width:100%; z-index:1000;')
css = css.replace('padding:8px 4px;', 'padding:4px 2px;')
css = css.replace('gap:4px;', 'gap:2px;')
css = css.replace('font-size:10px;', 'font-size:9px;')
with open(css_path, 'w', encoding='utf-8') as f:
    f.write(css)

# 2. marketplace.html
mp_path = 'marketplace.html'
with open(mp_path, 'r', encoding='utf-8') as f:
    mp = f.read()
mp = mp.replace('mTitle.textContent = selectedReward.title;', 'mTitle.innerHTML = selectedReward.title;')
mp = mp.replace('style="background: var(--adventure-gold); color: white; border: none;"', 'style="background: var(--adventure-gold); color: white; border: none; padding: 10px; font-size: 14px;"')
with open(mp_path, 'w', encoding='utf-8') as f:
    f.write(mp)

# 3. mapa.html
map_path = 'mapa.html'
with open(map_path, 'r', encoding='utf-8') as f:
    map_html = f.read()
map_html = map_html.replace('style="border-radius: var(--r-xl) var(--r-xl) 0 0; margin-bottom: var(--nav-h); z-index: 20; box-shadow: 0 -4px 20px rgba(0,0,0,0.1);"', 'style="position: absolute; bottom: 0; left: 0; width: 100%; border-radius: var(--r-xl) var(--r-xl) 0 0; margin-bottom: var(--nav-h); z-index: 20; box-shadow: 0 -4px 20px rgba(0,0,0,0.1);"')
with open(map_path, 'w', encoding='utf-8') as f:
    f.write(map_html)

# 4. dashboard.html
db_path = 'dashboard.html'
with open(db_path, 'r', encoding='utf-8') as f:
    db = f.read()

# Remove Trivia Banner
trivia_start = db.find('<!-- Trivia Banner -->')
trivia_end = db.find('<!-- Tus Criaturas Preview -->')
if trivia_start != -1 and trivia_end != -1:
    db = db[:trivia_start] + db[trivia_end:]

# Remove Tus Criaturas Preview
creatures_start = db.find('<!-- Tus Criaturas Preview -->')
creatures_end = db.find('<!-- Misiones Rápidas -->')
if creatures_start != -1 and creatures_end != -1:
    db = db[:creatures_start] + db[creatures_end:]

with open(db_path, 'w', encoding='utf-8') as f:
    f.write(db)

# 5. profile.html
pr_path = 'profile.html'
with open(pr_path, 'r', encoding='utf-8') as f:
    pr = f.read()

patrulla_html = """
        <!-- Tu Patrulla -->
        <h3 class="t-md fw-8 c-dark mb-3 anim-slideUp delay-1 px-4 mt-6">Tu Patrulla</h3>
        <div class="card p-4 mb-5 mx-4 anim-slideUp delay-2" style="background: rgba(124, 92, 252, 0.05); border: 1px solid rgba(124, 92, 252, 0.2);">
          <div class="flex items-c justify-b mb-3">
            <div class="flex items-c gap-3">
              <div style="background: var(--quest-purple); width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 24px; color: white;">
                <i class='bx bx-group'></i>
              </div>
              <div>
                <div class="t-md fw-9 c-dark" id="patrol-name">Cargando...</div>
                <div class="t-xs fw-7 c-mid"><span id="patrol-members">0</span> miembros activos</div>
              </div>
            </div>
            <div class="tc">
              <div class="t-lg fw-9 c-purple" id="patrol-pts">0</div>
              <div class="t-xs fw-7 c-mid">pts</div>
            </div>
          </div>
          <button class="btn btn-purple w-full" style="padding: 10px; font-size: 13px;">
            <i class='bx bx-target-lock'></i> Ver Misiones de Patrulla
          </button>
        </div>
"""

pr = pr.replace('<!-- Impact Metrics -->', patrulla_html + '\n        <!-- Impact Metrics -->')

# Update history rendering in profile JS
old_history_js = """
      const hContainer = document.getElementById('history-container');
      state.history.forEach((h, i) => {
        const el = document.createElement('div');
        el.className = 'history-item anim-fadeInUp';
        el.style.animationDelay = `${(i*50) + 400}ms`;
        el.innerHTML = `
          <div class="history-icon-wrap">${h.icon}</div>
          <div class="flex-1">
            <div class="history-action">${h.action}</div>
            <div class="history-time">${h.time}</div>
          </div>
          <div class="history-pts">+${h.pts}</div>
        `;
        hContainer.appendChild(el);
      });
"""

new_history_js = """
      const hContainer = document.getElementById('history-container');
      
      const renderHistory = (showAll = false) => {
        hContainer.innerHTML = '';
        const limit = showAll ? state.history.length : Math.min(5, state.history.length);
        for(let i=0; i<limit; i++) {
          const h = state.history[i];
          const el = document.createElement('div');
          el.className = 'history-item anim-fadeInUp';
          el.style.animationDelay = `${(i*50) + 100}ms`;
          el.innerHTML = `
            <div class="history-icon-wrap">${h.icon}</div>
            <div class="flex-1">
              <div class="history-action">${h.action}</div>
              <div class="history-time">${h.time}</div>
            </div>
            <div class="history-pts">+${h.pts}</div>
          `;
          hContainer.appendChild(el);
        }
        
        if (!showAll && state.history.length > 5) {
          const btn = document.createElement('button');
          btn.className = 'btn btn-secondary w-full mt-3';
          btn.innerHTML = '<i class="bx bx-chevron-down"></i> Ver historial completo';
          btn.onclick = () => renderHistory(true);
          hContainer.appendChild(btn);
        }
      };
      
      renderHistory();

      // Set Patrol
      if(state.patrol) {
        document.getElementById('patrol-name').textContent = state.patrol.name;
        document.getElementById('patrol-members').textContent = state.patrol.members;
        document.getElementById('patrol-pts').textContent = state.patrol.points;
      }
"""

pr = pr.replace(old_history_js, new_history_js)

# Add more spacing between sections (replace mt-3 with mt-5 for headings)
pr = pr.replace('<h3 class="t-md fw-8 c-dark mb-3 anim-slideUp delay-1 px-4">Tu Progreso</h3>', '<h3 class="t-md fw-8 c-dark mb-3 mt-6 anim-slideUp delay-1 px-4">Tu Progreso</h3>')
pr = pr.replace('<h3 class="t-md fw-8 c-dark mb-3 anim-slideUp delay-4 px-4">Historial de Actividad</h3>', '<h3 class="t-md fw-8 c-dark mb-3 mt-6 anim-slideUp delay-4 px-4">Historial de Actividad</h3>')

with open(pr_path, 'w', encoding='utf-8') as f:
    f.write(pr)

print("All fixes applied successfully.")
