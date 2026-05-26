import os

# 1. Update index.html buttons
with open('index.html', 'r', encoding='utf-8') as f:
    idx = f.read()

idx = idx.replace('style="background: rgba(255,255,255,0.2); backdrop-filter: blur(6px); border: 2px solid rgba(255,255,255,0.4); box-shadow: 0 8px 24px rgba(0,0,0,0.15); flex: 1;"', 'style="background: rgba(255,255,255,0.2); backdrop-filter: blur(6px); border: 2px solid rgba(255,255,255,0.4); box-shadow: 0 8px 24px rgba(0,0,0,0.15); padding: 8px 16px; font-size: 13px; width: auto;"')
idx = idx.replace('style="background: rgba(0,0,0,0.2); backdrop-filter: blur(6px); border: 2px solid rgba(255,255,255,0.2); flex: 1;"', 'style="background: rgba(0,0,0,0.2); backdrop-filter: blur(6px); border: 2px solid rgba(255,255,255,0.2); padding: 8px 16px; font-size: 13px; width: auto;"')

with open('index.html', 'w', encoding='utf-8') as f:
    f.write(idx)

# 2. Update marketplace.html buttons
with open('marketplace.html', 'r', encoding='utf-8') as f:
    market = f.read()

market = market.replace('style="padding: 6px 12px; font-size: 12px; ${canAfford', 'style="padding: 6px 12px; font-size: 12px; width: auto; ${canAfford')
market = market.replace('style="padding: 10px; font-size: 14px;"', 'style="padding: 8px 12px; font-size: 13px; width: auto;"')
market = market.replace('style="background: var(--adventure-gold); color: white; border: none; padding: 10px; font-size: 14px;"', 'style="background: var(--adventure-gold); color: white; border: none; padding: 8px 12px; font-size: 13px; width: auto;"')

with open('marketplace.html', 'w', encoding='utf-8') as f:
    f.write(market)

print("Buttons resized.")
