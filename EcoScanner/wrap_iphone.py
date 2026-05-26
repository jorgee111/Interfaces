import os, glob, re

BASE_DIR = r'c:\Users\JorgePJ\OneDrive\Escritorio\Web\Interfaces\EcoScanner'

# ── New 7-item nav with iPhone-compatible structure ──────────────
def make_nav(active_id):
    items = [
        ('index.html',        'nav-home',       'bx-home-alt',  'Inicio'),
        ('mapa.html',         'nav-map',        'bx-map',       'Mapa'),
        ('escaner.html',      'nav-escaner',    'bx-qr-scan',   'Escáner'),
        ('criaturas.html',    'nav-criaturas',  'bxs-leaf',     'Criaturas'),
        ('marketplace.html',  'nav-marketplace','bx-gift',      'Premios'),
        ('patrulla.html',     'nav-patrulla',   'bx-shield',    'Patrulla'),
        ('profile.html',      'nav-profile',    'bx-user',      'Perfil'),
    ]
    html = '    <nav class="bottom-nav">\n'
    for href, nav_id, icon, label in items:
        # missions badge only on home
        badge = '<span class="nav-badge" id="missions-badge" style="display:none;">3</span>' if nav_id == 'nav-home' else ''
        html += f"""      <a href="{href}" class="nav-item" id="{nav_id}">
        <div class="nav-item-wrap">
          <i class='bx {icon}'></i>
          {badge}
        </div>
        <span>{label}</span>
      </a>
"""
    html += '    </nav>\n'
    return html

# ── iPhone 17 frame HTML wrapper ─────────────────────────────────
FRAME_OPEN = '''  <div class="iphone-frame">
    <div class="iphone-screen">
      <div class="dynamic-island">
        <div class="dynamic-island__camera"></div>
        <div class="dynamic-island__dot"></div>
      </div>
      <div class="iphone-status-bar">
        <span class="status-time" id="status-clock">9:41</span>
        <div class="status-icons">
          <i class='bx bx-signal-5' style="font-size:16px;"></i>
          <i class='bx bx-wifi' style="font-size:16px;"></i>
          <div class="status-battery">
            <div class="battery-body"><div class="battery-fill"></div></div>
          </div>
        </div>
      </div>
'''
FRAME_CLOSE = '''    </div><!-- .iphone-screen -->
  </div><!-- .iphone-frame -->
'''

STATUS_CLOCK_JS = """
  <script>
    // Live clock for status bar
    function updateClock() {
      const now = new Date();
      const h = now.getHours().toString().padStart(2,'0');
      const m = now.getMinutes().toString().padStart(2,'0');
      const el = document.getElementById('status-clock');
      if (el) el.textContent = h + ':' + m;
    }
    updateClock();
    setInterval(updateClock, 30000);
  </script>
"""

html_files = [
    'index.html','mapa.html','escaner.html','criaturas.html',
    'marketplace.html','profile.html','mision-diaria.html',
    'trivia.html','dashboard.html'
]

nav_id_map = {
    'index.html': 'home',
    'mapa.html': 'map',
    'escaner.html': 'escaner',
    'criaturas.html': 'criaturas',
    'marketplace.html': 'marketplace',
    'profile.html': 'profile',
    'mision-diaria.html': 'home',
    'trivia.html': 'home',
    'dashboard.html': 'home',
}

for filename in html_files:
    filepath = os.path.join(BASE_DIR, filename)
    if not os.path.exists(filepath):
        continue
    
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 1. Remove old nav block
    nav_pattern = re.compile(r'\s*<nav class="bottom-nav">.*?</nav>', re.DOTALL)
    content = nav_pattern.sub('', content)
    
    # 2. Remove existing iphone frame if present (idempotent)
    content = content.replace(FRAME_OPEN, '')
    content = content.replace(FRAME_CLOSE, '')
    
    # 3. Remove old status clock script if exists
    content = re.sub(r'\s*<script>\s*// Live clock.*?</script>', '', content, flags=re.DOTALL)
    
    # 4. Wrap body content with iframe structure
    # Find <body> open and </body> close
    body_open = content.find('<body>')
    body_close = content.rfind('</body>')
    
    if body_open == -1 or body_close == -1:
        continue
    
    body_content = content[body_open+6:body_close]
    
    # Build new nav
    active = nav_id_map.get(filename, 'home')
    new_nav = make_nav(active)
    
    new_body = (
        '\n' + FRAME_OPEN +
        '      <div class="app-container">\n' +
        body_content.strip() + '\n' +
        new_nav +
        '      </div><!-- .app-container -->\n' +
        FRAME_CLOSE +
        STATUS_CLOCK_JS
    )
    
    content = content[:body_open+6] + new_body + '\n' + content[body_close:]
    
    # 5. Fix EcoApp.initNav calls to use correct ID
    init_map = {
        'index.html': 'home', 'mapa.html': 'map', 'escaner.html': 'escaner',
        'criaturas.html': 'criaturas', 'marketplace.html': 'marketplace',
        'profile.html': 'profile', 'mision-diaria.html': 'home',
        'trivia.html': 'home', 'dashboard.html': 'home',
    }
    if filename in init_map:
        content = re.sub(
            r"EcoApp\.initNav\('[^']*'\)",
            f"EcoApp.initNav('{init_map[filename]}')",
            content
        )
    
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f"Updated: {filename}")

print("\nAll files updated with iPhone 17 frame + 7-tab nav.")
