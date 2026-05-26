import os, re

BASE_DIR = r'c:\Users\JorgePJ\OneDrive\Escritorio\Web\Interfaces\EcoScanner'
html_files = [
    'index.html','mapa.html','escaner.html','criaturas.html',
    'marketplace.html','profile.html','mision-diaria.html',
    'trivia.html','dashboard.html', 'patrulla.html', 'onboarding.html'
]

FRAME_OPEN_REGEX = re.compile(r'  <div class="iphone-frame">\s*<div class="iphone-screen">\s*<div class="dynamic-island">.*?</div>\s*<div class="iphone-status-bar">.*?</div>\s*', re.DOTALL)
FRAME_CLOSE_REGEX = re.compile(r'\s*</div><!-- \.iphone-screen -->\s*</div><!-- \.iphone-frame -->\s*', re.DOTALL)
FRAME_CLOSE_REGEX2 = re.compile(r'\s*</div>\s*</div>\s*', re.DOTALL)
SCRIPT_REGEX = re.compile(r'  <script>\s*(?:// Live clock|function updateClock).*?</script>\s*', re.DOTALL)

for filename in html_files:
    filepath = os.path.join(BASE_DIR, filename)
    if not os.path.exists(filepath):
        continue
    
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Special handling for body start and end if it contains the frame
    content = FRAME_OPEN_REGEX.sub('', content)
    
    # The end tags might just be </div></div> before </body>
    if '</div><!-- .iphone-screen -->' in content:
        content = FRAME_CLOSE_REGEX.sub('\n', content)
    else:
        # manual cleanup at the end of body
        body_end = content.rfind('</body>')
        if body_end != -1:
            end_chunk = content[:body_end]
            end_chunk = end_chunk.replace('</div>\n    </div>\n  </div>', '</div>')
            end_chunk = end_chunk.replace('    </div><!-- .iphone-screen -->\n  </div><!-- .iphone-frame -->', '')
            content = end_chunk + content[body_end:]

    content = SCRIPT_REGEX.sub('', content)

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f"Cleaned: {filename}")

# Fix components.css max-width back to 430px for bottom-nav
css_file = os.path.join(BASE_DIR, 'css', 'components.css')
with open(css_file, 'r', encoding='utf-8') as f:
    css_content = f.read()

css_content = css_content.replace('max-width:393px;', 'max-width:430px;')
with open(css_file, 'w', encoding='utf-8') as f:
    f.write(css_content)

print("CSS updated")
