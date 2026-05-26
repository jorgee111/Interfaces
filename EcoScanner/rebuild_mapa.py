import re

with open('mapa.html', 'r', encoding='utf-8') as f:
    content = f.read()

# The DOCTYPE got split. Let's reconstruct the file properly.
# Extract the head section
head_match = re.search(r'<head>.*?</head>', content, re.DOTALL)
head = head_match.group(0) if head_match else ''

# Extract the body inner content (everything between <body...> and </body>)
body_inner_match = re.search(r'<body[^>]*>(.*?)</body>', content, re.DOTALL)
body_inner = body_inner_match.group(1) if body_inner_match else ''

# Remove old iPhone frame stuff that got prepended
# The content should start from the page div
page_match = re.search(r'(<div class="app-container">[\s\S]*)', body_inner)
if page_match:
    page_content = page_match.group(1)
else:
    # Try without app-container wrapper
    page_match = re.search(r'(<div class="page"[\s\S]*)', body_inner)
    page_content = page_match.group(1) if page_match else body_inner

# Check if page_content already has app-container
if not page_content.strip().startswith('<div class="app-container">'):
    page_content = '<div class="app-container">\n' + page_content

FRAME = '''  <div class="iphone-frame">
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
          <div class="status-battery"><div class="battery-body"><div class="battery-fill"></div></div></div>
        </div>
      </div>'''

CLOCK_JS = '''  <script>
    function updateClock() {
      var now = new Date();
      var el = document.getElementById("status-clock");
      if (el) el.textContent = String(now.getHours()).padStart(2,"0")+":"+String(now.getMinutes()).padStart(2,"0");
    }
    updateClock(); setInterval(updateClock, 30000);
  </script>'''

# Rebuild
new_file = f'''<!DOCTYPE html>
<html lang="es">
{head}
<body style="overflow: hidden;">
{FRAME}
      {page_content}
    </div><!-- .iphone-screen -->
  </div><!-- .iphone-frame -->
{CLOCK_JS}
</body>
</html>'''

with open('mapa.html', 'w', encoding='utf-8') as f:
    f.write(new_file)

print("mapa.html rebuilt successfully")
print(f"Length: {len(new_file)} chars")
