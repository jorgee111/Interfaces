import os, glob

# 1. Update marketplace.html button
with open('marketplace.html', 'r', encoding='utf-8') as f:
    market = f.read()
# Replace the old button style with smaller padding
market = market.replace('padding: 10px; font-size: 14px;', 'padding: 6px 12px; font-size: 13px;')
with open('marketplace.html', 'w', encoding='utf-8') as f:
    f.write(market)


# 2. Re-order bottom nav in all files
new_nav = """    <nav class="bottom-nav">
      <a href="escaner.html" class="nav-item" id="nav-escaner">
        <i class='bx bx-qr-scan'></i>
        <span>Escáner</span>
      </a>
      <a href="mapa.html" class="nav-item" id="nav-map">
        <i class='bx bx-map'></i>
        <span>Mapa</span>
      </a>
      <a href="index.html" class="nav-item" id="nav-home">
        <i class='bx bx-home-alt'></i>
        <span>Inicio</span>
      </a>
      <a href="criaturas.html" class="nav-item" id="nav-criaturas">
        <i class='bx bxs-leaf'></i>
        <span>Criaturas</span>
      </a>
      <a href="marketplace.html" class="nav-item" id="nav-marketplace">
        <i class='bx bx-gift'></i>
        <span>Premios</span>
      </a>
      <a href="profile.html" class="nav-item" id="nav-profile">
        <i class='bx bx-user'></i>
        <span>Perfil</span>
      </a>
    </nav>"""

old_nav_start = '<nav class="bottom-nav">'
old_nav_end = '</nav>'

for file in glob.glob('*.html'):
    with open(file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    start_idx = content.find(old_nav_start)
    end_idx = content.find(old_nav_end, start_idx)
    
    if start_idx != -1 and end_idx != -1:
        content = content[:start_idx] + new_nav + content[end_idx + len(old_nav_end):]
        with open(file, 'w', encoding='utf-8') as f:
            f.write(content)


# 3. Merge Aventura into Index
with open('index.html', 'r', encoding='utf-8') as f:
    idx = f.read()

# Replace the ACTIVE QUEST PREVIEW section in index with Aventura sections
preview_start = idx.find('<!-- ─── ACTIVE QUEST PREVIEW ─── -->')
footer_start = idx.find('<!-- ─── FOOTER TEXT ─── -->')

if preview_start != -1 and footer_start != -1:
    aventura_sections = """
      <!-- ─── CURRENT CHAPTER ─── -->
      <section style="padding: 0 var(--sp-4); margin-bottom: var(--sp-6);" class="anim-fadeInUp delay-4">
        <h2 class="card-section-title mb-3">Capítulo Actual</h2>
        
        <div class="quest-card anim-quest-glow" id="current-chapter-card">
          <div class="quest-card__header" style="margin-bottom: 8px;">
            <span class="quest-card__title" id="current-chapter-title">Capítulo Actual</span>
          </div>
          <p class="t-sm c-mid fw-6 mb-3" id="current-chapter-desc">Descripción del capítulo...</p>
          
          <div style="background: rgba(255,184,48,0.1); border-radius: 12px; padding: 12px; margin-bottom: 16px;">
            <div class="flex items-c gap-2">
              <i class='bx bx-bulb' style="color: var(--adventure-gold); font-size: 20px;"></i>
              <span class="t-sm fw-7 c-dark" id="current-chapter-hint">Pista aquí</span>
            </div>
          </div>

          <div class="flex items-c justify-b mb-4">
            <span class="t-xs fw-8 c-mid uppercase">Recompensa:</span>
            <div class="flex items-c gap-2" id="current-chapter-rewards">
              <!-- Recompensas dinámicas -->
            </div>
          </div>

          <button class="btn btn-primary w-full" id="btn-chapter-action">
            Acción del Capítulo
          </button>
        </div>
      </section>

      <!-- ─── CHAPTER TIMELINE ─── -->
      <section style="padding: 0 var(--sp-4); margin-bottom: var(--sp-6);" class="anim-fadeInUp delay-5">
        <h2 class="card-section-title mb-4">Línea de Tiempo</h2>
        <div id="chapter-timeline" class="flex flex-col gap-4">
          <!-- Timeline nodes dinámicos -->
        </div>
      </section>
"""
    idx = idx[:preview_start] + aventura_sections + idx[footer_start:]


# Now inject the javascript into index.html
js_to_replace = """      // ── Populate Active Quest Preview ──
      const quest = EcoApp.getActiveAdventure();
      if (quest) {
        const progress = EcoApp.getQuestProgress(quest.id);
        const currentChapter = EcoApp.getCurrentChapter(quest.id);

        document.getElementById('active-quest-icon').textContent = quest.icon;
        document.getElementById('active-quest-title').textContent = quest.title;
        document.getElementById('active-quest-chapters').textContent = `${progress.completed}/${progress.total}`;
        document.getElementById('active-quest-progress-fill').style.width = `${progress.percent}%`;

        if (currentChapter) {
          document.getElementById('active-quest-chapter-name').textContent = currentChapter.title;
        }
      }"""

js_aventura = """
      // ── Populate Aventura Sections ──
      const quest = EcoApp.getActiveAdventure();
      if (quest) {
        const currentChapter = EcoApp.getCurrentChapter(quest.id);
        const state = EcoApp.getState();
        const questState = state.adventure.quests[quest.id];

        // Current Chapter
        if (currentChapter) {
          document.getElementById('current-chapter-title').textContent = `${currentChapter.title}`;
          document.getElementById('current-chapter-desc').textContent = currentChapter.description;
          document.getElementById('current-chapter-hint').textContent = currentChapter.hint;
          
          let rewardHtml = '';
          if (currentChapter.reward.points) rewardHtml += `<span class="badge-adventure">+${currentChapter.reward.points} pts</span>`;
          if (currentChapter.reward.item) rewardHtml += `<span class="inventory-item">${currentChapter.reward.item.replace('-', ' ')}</span>`;
          if (currentChapter.reward.creature) {
            const cDef = EcoApp.getAllCreatures().find(c => c.id === currentChapter.reward.creature);
            if (cDef) rewardHtml += `<span style="font-size: 20px;">${cDef.stages[0].emoji}</span>`;
          }
          document.getElementById('current-chapter-rewards').innerHTML = rewardHtml;

          const btn = document.getElementById('btn-chapter-action');
          if (currentChapter.type === 'scan') {
            btn.innerHTML = "<i class='bx bx-qr-scan'></i> Ir a Escanear";
            btn.onclick = () => window.location.href = 'escaner.html';
          } else if (currentChapter.type === 'trivia') {
            btn.innerHTML = "<i class='bx bx-brain'></i> Responder Acertijo";
            btn.onclick = () => window.location.href = 'trivia.html';
          } else if (currentChapter.type === 'explore') {
            btn.innerHTML = "<i class='bx bx-map-alt'></i> Explorar Mapa";
            btn.onclick = () => window.location.href = 'mapa.html';
          } else if (currentChapter.type === 'group') {
            btn.innerHTML = "<i class='bx bx-group'></i> Invitar Amigos";
            btn.onclick = () => { alert('¡Enlace de invitación copiado!'); };
          }
        } else {
          document.getElementById('current-chapter-card').innerHTML = `
            <div class="tc py-4">
              <div style="font-size: 48px; margin-bottom: 16px;">🏆</div>
              <h3 class="t-lg fw-8 c-dark mb-2">¡Aventura Completada!</h3>
              <p class="c-mid t-sm fw-6">Has terminado todas las misiones de esta aventura.</p>
            </div>
          `;
        }

        // Timeline
        const timelineHtml = quest.chapters.map((ch, idx) => {
          const isCompleted = questState.completedChapters.includes(ch.id);
          const isActive = questState.currentChapter === ch.id;
          const statusClass = isCompleted ? 'chapter-node--completed' : (isActive ? 'chapter-node--active' : 'chapter-node--locked');
          
          let markerHtml = '';
          if (isCompleted) markerHtml = "<i class='bx bx-check' style='color: white; font-size: 20px;'></i>";
          else if (isActive) markerHtml = "<div style='width: 12px; height: 12px; background: white; border-radius: 50%;'></div>";

          let typeIcon = 'bx-question-mark';
          if (ch.type === 'scan') typeIcon = 'bx-qr-scan';
          if (ch.type === 'trivia') typeIcon = 'bx-brain';
          if (ch.type === 'explore') typeIcon = 'bx-map-alt';
          if (ch.type === 'group') typeIcon = 'bx-group';

          return `
            <div class="chapter-node ${statusClass}" style="position: relative;">
              ${idx < quest.chapters.length - 1 ? '<div class="chapter-node__connector"></div>' : ''}
              <div class="chapter-node__marker flex items-c justify-c">${markerHtml}</div>
              <div class="chapter-node__content w-full card card-padded" style="margin-top: -4px;">
                <div class="flex items-c justify-b mb-1">
                  <span class="t-sm fw-8 c-dark">${ch.title}</span>
                  <i class='bx ${typeIcon} c-mid'></i>
                </div>
                <p class="t-xs c-mid fw-6 line-clamp-2">${ch.description}</p>
              </div>
            </div>
          `;
        }).join('');
        document.getElementById('chapter-timeline').innerHTML = timelineHtml;
      }
"""
idx = idx.replace(js_to_replace, js_aventura)

with open('index.html', 'w', encoding='utf-8') as f:
    f.write(idx)

# Delete aventura.html as it's no longer needed
if os.path.exists('aventura.html'):
    os.remove('aventura.html')

print("Applied 3rd round fixes.")
