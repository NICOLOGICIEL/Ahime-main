# -*- coding: utf-8 -*-
"""Genere les icones PWA pour la version web a partir de l'icone du projet."""
from PIL import Image
import os
import json

BASE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(BASE, "assets", "image", "AhimeLogo1024.png")
ICONS_DIR = os.path.join(BASE, "web", "icons")
MANIFEST = os.path.join(BASE, "web", "manifest.json")
INDEX = os.path.join(BASE, "web", "index.html")

# Couleur theme du projet (depuis manifest / flutter_native_splash)
THEME_COLOR = (1, 117, 194, 255)  # #0175C2

os.makedirs(ICONS_DIR, exist_ok=True)

# Charger l'icone source du projet
src = Image.open(SRC).convert("RGBA")


def make_square_icon(size, out_path):
    """Icone classique : logo centree sur fond transparent."""
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    # Redimensionner le logo pour qu'il occupe ~85% de l'icone
    logo_size = int(size * 0.85)
    logo = src.resize((logo_size, logo_size), Image.LANCZOS)
    pos = ((size - logo_size) // 2, (size - logo_size) // 2)
    img.paste(logo, pos, logo)
    img.save(out_path, "PNG")
    print("Cree :", out_path)


def make_maskable_icon(size, out_path):
    """Icone maskable : logo centree dans une zone de securite sur fond theme."""
    img = Image.new("RGBA", (size, size), THEME_COLOR)
    # Zone de securite : logo occupe ~65% (marge de ~17.5% de chaque cote)
    safe_zone = int(size * 0.65)
    logo = src.resize((safe_zone, safe_zone), Image.LANCZOS)
    pos = ((size - safe_zone) // 2, (size - safe_zone) // 2)
    img.paste(logo, pos, logo)
    img.save(out_path, "PNG")
    print("Cree :", out_path)


def make_favicon(size, out_path):
    """Favicon : logo sur fond theme."""
    img = Image.new("RGBA", (size, size), THEME_COLOR)
    logo_size = int(size * 0.85)
    logo = src.resize((logo_size, logo_size), Image.LANCZOS)
    pos = ((size - logo_size) // 2, (size - logo_size) // 2)
    img.paste(logo, pos, logo)
    img.save(out_path, "PNG")
    print("Cree :", out_path)


# Generation des icones
make_square_icon(192, os.path.join(ICONS_DIR, "Icon-192.png"))
make_square_icon(512, os.path.join(ICONS_DIR, "Icon-512.png"))
make_maskable_icon(192, os.path.join(ICONS_DIR, "Icon-maskable-192.png"))
make_maskable_icon(512, os.path.join(ICONS_DIR, "Icon-maskable-512.png"))
make_favicon(32, os.path.join(BASE, "web", "favicon.png"))

# Mise a jour du manifest.json (garder la structure, noms de fichiers identiques)
manifest = {
    "name": "ahime",
    "short_name": "ahime",
    "start_url": ".",
    "display": "standalone",
    "background_color": "#0175C2",
    "theme_color": "#0175C2",
    "description": "Application Ahime",
    "orientation": "portrait-primary",
    "prefer_related_applications": False,
    "icons": [
        {"src": "icons/Icon-192.png", "sizes": "192x192", "type": "image/png"},
        {"src": "icons/Icon-512.png", "sizes": "512x512", "type": "image/png"},
        {"src": "icons/Icon-maskable-192.png", "sizes": "192x192", "type": "image/png", "purpose": "maskable"},
        {"src": "icons/Icon-maskable-512.png", "sizes": "512x512", "type": "image/png", "purpose": "maskable"},
    ],
}
with open(MANIFEST, "w", encoding="utf-8") as f:
    json.dump(manifest, f, indent=4, ensure_ascii=False)
    f.write("\n")
print("Mis a jour :", MANIFEST)

print("\nTermine. Les icones du projet sont maintenant utilisees pour la PWA web.")
