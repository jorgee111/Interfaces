import re

content = open('mapa.html', 'r', encoding='utf-8').read()

FRAME_OPEN = '  <div class="iphone-frame">\n    <div class="iphone-screen">\n      <div class="dynamic-island">\n        <div class="dynamic-island__camera"></div>\n        <div class="dynamic-island__dot"></div>\n      </div>\n      <div class="iphone-status-bar">\n        <span class="status-time" id="status-clock">9:41</span>\n        <div class="status-icons">\n          <i class=\'bx bx-signal-5\' style="font-size:16px;"></i>\n          <i class=\'bx bx-wifi\' style="font-size:16px;"></i>\n          <div class="status-battery"><div class="battery-body"><div class="battery-fill"></div></div></div>\n        </div>\n      </div>\n'

FRAME_CLOSE = '    </div>\n  </div>\n'

new_nav = '''    <nav class="bottom-nav">
      <a href="index.html" class="nav-item" id="nav-home"><div class="nav-item-wrap"><i class='bx bx-home-alt'></i></div><span>Inicio</span></a>
      <a href="mapa.html" class="nav-item" id="nav-map"><div class="nav-item-wrap"><i class='bx bx-map'></i></div><span>Mapa</span></a>
      <a href="escaner.html" class="nav-item" id="nav-escaner"><div class="nav-item-wrap"><i class='bx bx-qr-scan'></i></div><span>Escanear</span></a>
      <a href="criaturas.html" class="nav-item" id="nav-criaturas"><div class="nav-item-wrap"><i class='bx bxs-leaf'></i></div><span>Criaturas</span></a>
      <a href="marketplace.html" class="nav-item" id="nav-marketplace"><div class="nav-item-wrap"><i class='bx bx-gift'></i></div><span>Premios</span></a>
      <a href="patrulla.html" class="nav-item" id="nav-patrulla"><div class="nav-item-wrap"><i class='bx bx-shield'></i></div><span>Patrulla</span></a>
      <a href="profile.html" class="nav-item" id="nav-profile"><div class="nav-item-wrap"><i class='bx bx-user'></i></div><span>Perfil</span></a>
    </nav>
'''

old_nav = re.compile(r'\s*<nav class="bottom-nav">.*?</nav>', re.DOTALL)
content = old_nav.sub('', content)

body_open = content.find('<body>')
body_close = content.rfind('</body>')
body_content = content[body_open+6:body_close]

new_body = (
    '\n' + FRAME_OPEN +
    '      <div class="app-container">\n' +
    body_content.strip() + '\n' +
    new_nav +
    '      </div>\n' +
    FRAME_CLOSE +
    '  <script>\n    function updateClock() {\n      var now = new Date();\n      var el = document.getElementById("status-clock");\n      if (el) el.textContent = String(now.getHours()).padStart(2,"0")+":"+String(now.getMinutes()).padStart(2,"0");\n    }\n    updateClock();\n    setInterval(updateClock, 30000);\n  </script>'
)

content = content[:body_open+6] + new_body + '\n' + content[body_close:]

open('mapa.html', 'w', encoding='utf-8').write(content)
print('mapa.html updated successfully')
