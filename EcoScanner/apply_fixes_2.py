import os, glob

# 1. css/components.css
css_path = 'css/components.css'
with open(css_path, 'r', encoding='utf-8') as f:
    css = f.read()

# Make bottom-nav match app-container max-width and center it
if 'max-width:430px; left:50%; transform:translateX(-50%);' not in css:
    css = css.replace('position:fixed; bottom:0; left:0; width:100%; z-index:1000;', 
                      'position:fixed; bottom:0; left:50%; transform:translateX(-50%); width:100%; max-width:430px; z-index:1000;')

with open(css_path, 'w', encoding='utf-8') as f:
    f.write(css)

# 2. Extract escaner.html from index.html
index_path = 'index.html'
with open(index_path, 'r', encoding='utf-8') as f:
    idx = f.read()

# We will create escaner.html based on index.html but with only the scanner content.
# Wait, let's remove the scanner section from index.html:
scan_section_start = idx.find('<!-- ─── QUICK SCANNER ─── -->')
scan_section_end = idx.find('<!-- ─── FOOTER TEXT ─── -->')

if scan_section_start != -1 and scan_section_end != -1:
    idx_new = idx[:scan_section_start] + idx[scan_section_end:]
    with open(index_path, 'w', encoding='utf-8') as f:
        f.write(idx_new)

# Let's create escaner.html
escaner_content = """<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <title>Escáner — EcoScanner Adventures</title>
  <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800;900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="css/main.css">
  <link rel="stylesheet" href="css/components.css">
  <link rel="stylesheet" href="css/animations.css">
</head>
<body>
  <div class="app-container">
    <div class="page" style="padding-bottom: calc(var(--nav-h) + 8px);">

      <!-- Top Bar -->
      <div class="top-bar anim-fadeInDown">
        <div class="top-bar-title">Escáner de Residuos</div>
      </div>

      <div class="content pt-0 flex flex-col items-c justify-c h-full">
        <!-- ─── QUICK SCANNER ─── -->
        <div class="card card-padded w-full anim-fadeInUp" id="quick-scanner-section" style="text-align: center; border: 2px dashed rgba(0,191,165,0.25); margin-top: 20px;">
          <div style="font-size: 48px; margin-bottom: 12px;">📷</div>
          <h3 class="t-md fw-9 c-dark mb-1">Escáner Activo</h3>
          <p class="t-sm c-mid fw-6 mb-6">Enfoca el código QR del contenedor para sumar puntos y alimentar a tus criaturas.</p>
          <button id="btn-scan-start" class="btn btn-primary w-full" style="padding: 16px; font-size: 16px;">
            <i class='bx bx-qr-scan' style="font-size: 24px;"></i> Abrir Cámara
          </button>
        </div>
      </div>
    </div>

    <!-- ─── SCANNER MODAL ─── -->
    <div id="scanner-modal" class="modal-overlay hidden">
      <div class="modal-sheet tc" style="padding-bottom: 40px; position:relative;">
        <button class="modal-close-btn" id="btn-close-scanner">×</button>
        <div class="modal-handle"></div>
        <h2 class="t-xl fw-9 c-dark mb-4" id="scanner-title">Escanear Contenedor</h2>
        
        <div class="scanner-frame" id="scanner-view">
          <div class="scanner-corner tl"></div>
          <div class="scanner-corner tr"></div>
          <div class="scanner-corner bl"></div>
          <div class="scanner-corner br"></div>
          <div class="scanner-line"></div>
          <div class="scanner-icon"><i class='bx bx-camera'></i></div>
          <!-- AI Bounding Box -->
          <div id="ai-bbox" class="hidden" style="position: absolute; border: 2px solid var(--primary); background: rgba(0,230,118, 0.1); top: 20%; left: 20%; width: 60%; height: 60%; transition: all 0.3s;">
            <div style="position: absolute; bottom: -24px; left: 50%; transform: translateX(-50%); background: var(--primary); color: white; font-size: 10px; font-weight: 800; padding: 2px 6px; border-radius: 4px; white-space: nowrap;">
              <i class='bx bx-check'></i> Botella (98%)
            </div>
          </div>
        </div>

        <div id="scanner-loading" class="hidden py-3">
          <div class="spinner"></div>
          <p class="mt-4">Verificando código...</p>
        </div>

        <p id="scanner-desc" class="c-mid t-sm my-6 fw-6 px-4">
          Busca los códigos QR en las bandejas o contenedores de reciclaje.
        </p>

        <div id="scanner-actions" class="flex flex-col gap-3">
          <button id="btn-scan-success" class="btn btn-primary w-full">Simular Éxito</button>
          <button id="btn-scan-error" class="btn btn-ghost w-full">Simular Error</button>
        </div>
      </div>
    </div>

    <!-- ─── SUCCESS MODAL ─── -->
    <div id="success-modal" class="modal-overlay hidden">
      <div class="modal-sheet tc">
        <button class="modal-close-btn" id="btn-close-success">×</button>
        <div style="font-size: 64px; color: var(--primary);"><i class='bx bxs-party'></i></div>
        <h2 class="t-2xl fw-9 c-dark mt-2">¡Bien hecho!</h2>
        <p class="c-mid mt-2 mb-6">Has ganado 50 Eco-Puntos. ¡Tu criatura ha sido alimentada!</p>
        <button id="btn-awesome" class="btn btn-primary w-full">¡Genial!</button>
      </div>
    </div>

    <!-- ─── BOTTOM NAV ─── -->
    <nav class="bottom-nav">
      <a href="index.html" class="nav-item" id="nav-home">
        <i class='bx bx-home-alt'></i>
        <span>Inicio</span>
      </a>
      <a href="mapa.html" class="nav-item" id="nav-map">
        <i class='bx bx-map'></i>
        <span>Mapa</span>
      </a>
      <a href="escaner.html" class="nav-item" id="nav-escaner">
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
    </nav>
  </div>

  <script src="js/confetti.js"></script>
  <script src="js/app.js"></script>
  <script>
    document.addEventListener('DOMContentLoaded', () => {
      EcoApp.initNav('escaner');

      const scanStart = document.getElementById('btn-scan-start');
      const scannerModal = document.getElementById('scanner-modal');
      const scanSuccess = document.getElementById('btn-scan-success');
      const scanError = document.getElementById('btn-scan-error');
      const successModal = document.getElementById('success-modal');
      const btnAwesome = document.getElementById('btn-awesome');
      const closeScanner = document.getElementById('btn-close-scanner');
      const closeSuccess = document.getElementById('btn-close-success');
      const sView = document.getElementById('scanner-view');
      const sDesc = document.getElementById('scanner-desc');
      const sActions = document.getElementById('scanner-actions');
      const sLoading = document.getElementById('scanner-loading');
      const sTitle = document.getElementById('scanner-title');

      function resetScannerUI() {
        sView.classList.remove('hidden');
        sDesc.classList.remove('hidden');
        sActions.classList.remove('hidden');
        sLoading.classList.add('hidden');
        sTitle.textContent = 'Escanear Contenedor';
        sDesc.style.color = 'var(--mid)';
        sDesc.textContent = 'Busca los códigos QR en las bandejas o contenedores de reciclaje.';
        sActions.innerHTML = `
          <button id="btn-scan-success" class="btn btn-primary w-full">Simular Éxito</button>
          <button id="btn-scan-error" class="btn btn-ghost w-full">Simular Error</button>
        `;
        document.getElementById('btn-scan-success').addEventListener('click', handleScanSuccess);
        document.getElementById('btn-scan-error').addEventListener('click', handleScanError);
      }

      scanStart.addEventListener('click', () => {
        resetScannerUI();
        scannerModal.classList.remove('hidden');
      });

      closeScanner.addEventListener('click', () => scannerModal.classList.add('hidden'));
      closeSuccess.addEventListener('click', () => successModal.classList.add('hidden'));

      function handleScanError() {
        sTitle.textContent = 'Error de Cámara';
        sView.classList.add('hidden');
        sDesc.textContent = 'No pudimos acceder a tu cámara. Por favor verifica los permisos del navegador e inténtalo de nuevo.';
        sDesc.style.color = 'var(--red)';
        sActions.innerHTML = `<button class="btn btn-primary w-full" id="btn-retry-scan">Reintentar</button>`;
        document.getElementById('btn-retry-scan').addEventListener('click', resetScannerUI);
      }

      function handleScanSuccess() {
        sActions.classList.add('hidden');
        sTitle.textContent = 'Analizando con IA...';
        sDesc.textContent = 'Identificando tipo de material...';
        sDesc.style.color = 'var(--primary)';

        const bbox = document.getElementById('ai-bbox');
        bbox.classList.remove('hidden');

        setTimeout(() => {
          bbox.style.width = '40%'; bbox.style.height = '70%'; bbox.style.left = '30%'; bbox.style.top = '15%';
        }, 500);

        setTimeout(() => {
          sTitle.textContent = '¡Material detectado!';
          sDesc.textContent = 'Plástico PET listo para reciclar.';

          setTimeout(() => {
            EcoApp.addPoints(50);
            scannerModal.classList.add('hidden');
            successModal.classList.remove('hidden');
            if (typeof Confetti !== 'undefined') Confetti.fire();
            bbox.classList.add('hidden');
            bbox.style = "position: absolute; border: 2px solid var(--primary); background: rgba(0,230,118, 0.1); top: 20%; left: 20%; width: 60%; height: 60%; transition: all 0.3s;";
          }, 1500);
        }, 1500);
      }

      scanError.addEventListener('click', handleScanError);
      scanSuccess.addEventListener('click', handleScanSuccess);
      btnAwesome.addEventListener('click', () => successModal.classList.add('hidden'));
    });
  </script>
</body>
</html>
"""
with open('escaner.html', 'w', encoding='utf-8') as f:
    f.write(escaner_content)

# Update nav links in all HTML files
html_files = glob.glob('*.html')
for f in html_files:
    if f != 'escaner.html':
        with open(f, 'r', encoding='utf-8') as file:
            content = file.read()
        
        # Replace the href of nav-escaner from index.html to escaner.html
        content = content.replace('<a href="index.html" class="nav-item" id="nav-escaner">', '<a href="escaner.html" class="nav-item" id="nav-escaner">')
        with open(f, 'w', encoding='utf-8') as file:
            file.write(content)

# 3. mapa.html: remove margin-bottom from pin-info
with open('mapa.html', 'r', encoding='utf-8') as f:
    mapa_html = f.read()

# Replace the style attribute to remove margin-bottom: var(--nav-h);
mapa_html = mapa_html.replace('margin-bottom: var(--nav-h);', '')

with open('mapa.html', 'w', encoding='utf-8') as f:
    f.write(mapa_html)

# 4. profile.html: add margin to impact and oracle sections
with open('profile.html', 'r', encoding='utf-8') as f:
    profile_html = f.read()

profile_html = profile_html.replace('<h3 class="t-lg fw-9 c-dark">Tu Impacto Real</h3>', '<h3 class="t-lg fw-9 c-dark mt-6">Tu Impacto Real</h3>')
profile_html = profile_html.replace('<div class="card p-4 mb-5 mx-4 anim-slideUp delay-3"', '<div class="card p-4 mb-5 mt-6 mx-4 anim-slideUp delay-3"')

with open('profile.html', 'w', encoding='utf-8') as f:
    f.write(profile_html)

# 5. marketplace.html: fix innerText error in modal icon
with open('marketplace.html', 'r', encoding='utf-8') as f:
    market_html = f.read()

market_html = market_html.replace('mIcon.textContent = selectedReward.icon;', 'mIcon.innerHTML = selectedReward.icon;')

with open('marketplace.html', 'w', encoding='utf-8') as f:
    f.write(market_html)

print("Fixes applied successfully.")
