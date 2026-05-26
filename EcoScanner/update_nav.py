import os, glob

new_nav = """  <nav class="bottom-nav">
    <a href="index.html" class="nav-item" id="nav-home">
      <i class='bx bx-home-alt'></i>
      <span>Inicio</span>
    </a>
    <a href="mapa.html" class="nav-item" id="nav-map">
      <i class='bx bx-map'></i>
      <span>Mapa</span>
    </a>
    <a href="index.html" class="nav-item" id="nav-escaner">
      <i class='bx bx-qr-scan'></i>
      <span>Escáner</span>
    </a>
    <a href="aventura.html" class="nav-item" id="nav-aventura">
      <i class='bx bx-compass'></i>
      <span>Aventura</span>
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

files = glob.glob('*.html')
for f in files:
    with open(f, 'r', encoding='utf-8') as file:
        content = file.read()
    
    start_idx = content.find(old_nav_start)
    end_idx = content.find(old_nav_end, start_idx)
    
    if start_idx != -1 and end_idx != -1:
        end_idx += len(old_nav_end)
        new_content = content[:start_idx] + new_nav + content[end_idx:]
        with open(f, 'w', encoding='utf-8') as file:
            file.write(new_content)
        print(f'Updated nav in {f}')
