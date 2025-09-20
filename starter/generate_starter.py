"""
Generate a WorkAdventure starter site and zip with:
- Embedded tileset in map.json (no TSX/TSJ external refs)
- Required WA object layers: `start` (with spawn) and `floorLayer`
- Minimal tech-themed tilesheet (256x256, 8x8 tiles, 32px)

Outputs under starter/site/ and creates starter/workadventure-starter.zip

Requirements: pip install pillow
"""

import json
import os
import zipfile
from pathlib import Path
from PIL import Image, ImageDraw


def make_dirs(path: Path):
    path.mkdir(parents=True, exist_ok=True)


def generate_tileset_png(path: Path, img_size: int = 256, tile: int = 32) -> None:
    img = Image.new("RGBA", (img_size, img_size), (31, 41, 55, 255))
    draw = ImageDraw.Draw(img)

    for y in range(0, img_size, tile):
        for x in range(0, img_size, tile):
            xtile = x // tile
            ytile = y // tile

            if ytile == 0:
                # First row: special tiles for convenience
                if xtile == 0:
                    color = (31, 41, 55, 255)  # floor
                elif xtile == 1:
                    color = (17, 24, 39, 255)  # wall
                elif xtile == 2:
                    color = (55, 65, 81, 255)  # corridor
                elif xtile == 3:
                    color = (14, 165, 233, 255)  # door
                elif xtile == 4:
                    color = (34, 211, 238, 255)  # accent
                else:
                    color = (40, 60, 80, 255)
            else:
                color = (40, 60, 80, 255) if ((xtile + ytile) % 2 == 0) else (30, 45, 65, 255)

            draw.rectangle([x, y, x + tile - 1, y + tile - 1], fill=color)

    # Light outlines to give structure
    for y in range(0, img_size, tile):
        for x in range(0, img_size, tile):
            draw.rectangle([x, y, x + tile - 1, y + tile - 1], outline=(75, 85, 99, 255), width=1)

    img.save(path, "PNG")


def csv_rows(width: int, height: int, fill: int) -> str:
    row = ",".join([str(fill)] * width)
    return "\n".join([row] * height)


def generate_map_json(path: Path, tileset_image_rel: str, tile: int = 32, width: int = 16, height: int = 12):
    embedded_tileset = {
        "firstgid": 1,
        "columns": 8,
        "image": tileset_image_rel,
        "imageheight": 256,
        "imagewidth": 256,
        "margin": 0,
        "name": "base",
        "spacing": 0,
        "tilecount": 64,
        "tileheight": tile,
        "tilewidth": tile,
    }

    layers = [
        {
            "id": 1,
            "name": "floor",
            "type": "tilelayer",
            "width": width,
            "height": height,
            "opacity": 1,
            "visible": True,
            "encoding": "csv",
            "data": csv_rows(width, height, 1),
        },
        {
            "id": 2,
            "name": "decor",
            "type": "tilelayer",
            "width": width,
            "height": height,
            "opacity": 1,
            "visible": True,
            "encoding": "csv",
            "data": csv_rows(width, height, 0),
        },
        {
            "id": 3,
            "name": "labels",
            "type": "objectgroup",
            "visible": True,
            "opacity": 1,
            "objects": [
                {
                    "id": 1,
                    "name": "Titulo",
                    "type": "text",
                    "x": 64,
                    "y": 40,
                    "width": 384,
                    "height": 24,
                    "visible": True,
                    "text": {
                        "text": "AR Online - Hub",
                        "wrap": True,
                        "halign": "center",
                        "valign": "top",
                        "color": "#FFFFFFFF",
                        "pixelsize": 18,
                        "fontfamily": "Arial",
                    },
                }
            ],
        },
        {
            "id": 4,
            "name": "start",
            "type": "objectgroup",
            "visible": True,
            "opacity": 1,
            "objects": [
                {"id": 2, "name": "spawn", "type": "point", "point": True, "x": 224, "y": 288, "visible": True}
            ],
        },
        {
            "id": 5,
            "name": "floorLayer",
            "type": "objectgroup",
            "visible": True,
            "opacity": 1,
            "objects": [],
        },
        {
            "id": 6,
            "name": "areas",
            "type": "objectgroup",
            "visible": True,
            "opacity": 1,
            "objects": [
                {
                    "id": 3,
                    "name": "ReuniaoJitsi",
                    "type": "area",
                    "x": 64,
                    "y": 224,
                    "width": 128,
                    "height": 96,
                    "visible": True,
                    "properties": [
                        {"name": "jitsiRoom", "type": "string", "value": "ReuniaoGeral"},
                        {"name": "jitsiWidth", "type": "int", "value": 900},
                        {"name": "jitsiTrigger", "type": "string", "value": "onaction"},
                    ],
                },
                {
                    "id": 4,
                    "name": "Mural",
                    "type": "area",
                    "x": 384,
                    "y": 224,
                    "width": 128,
                    "height": 96,
                    "visible": True,
                    "properties": [
                        {"name": "openWebsite", "type": "string", "value": "https://ar-online.com.br"},
                        {"name": "openWebsiteWidth", "type": "int", "value": 900},
                        {"name": "openWebsiteTrigger", "type": "string", "value": "onaction"},
                    ],
                },
                {
                    "id": 5,
                    "name": "Silencio",
                    "type": "area",
                    "x": 384,
                    "y": 320,
                    "width": 96,
                    "height": 64,
                    "visible": True,
                    "properties": [{"name": "silent", "type": "bool", "value": True}],
                },
            ],
        },
    ]

    map_json = {
        "compressionlevel": -1,
        "height": height,
        "width": width,
        "infinite": False,
        "nextlayerid": 7,
        "nextobjectid": 6,
        "orientation": "orthogonal",
        "renderorder": "right-down",
        "tiledversion": "1.10.2",
        "tileheight": tile,
        "tilewidth": tile,
        "type": "map",
        "version": "1.10",
        "backgroundcolor": "#e6e6e6",
        "tilesets": [embedded_tileset],
        "layers": layers,
    }

    with open(path, "w", encoding="utf-8") as f:
        json.dump(map_json, f, ensure_ascii=False, indent=2)


def write_pages_readme(path: Path):
    readme = """# WorkAdventure Starter (AR Online)

Este pacote serve um mapa do WorkAdventure via GitHub Pages.

Como publicar manualmente (caso não use a Action):
1. Settings → Pages → Deploy from a branch → `main` e pasta `/ (root)`.
2. URL final (exemplo): `https://SEU-USUARIO.github.io/NOME-DO-REPO/map.json`
3. Cole a URL no WorkAdventure: `https://play.workadventu.re/_/SEU-USUARIO.github.io/NOME-DO-REPO/map.json`

Estrutura:
- `map.json` — mapa principal (Tiled 1.10+), com tileset EMBUTIDO (compatível WA).
- `tilesets/base.png` — sprite-sheet simples (referenciado no tileset embutido).
- `.nojekyll` — garante que o GitHub Pages não quebre pastas.
"""
    with open(path, "w", encoding="utf-8") as f:
        f.write(readme)


def zip_site(site_root: Path, zip_path: Path):
    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as z:
        for folder, _, files in os.walk(site_root):
            for file in files:
                full = Path(folder) / file
                rel = full.relative_to(site_root)
                z.write(full, arcname=str(rel))


def main():
    base_dir = Path(__file__).parent
    site = base_dir / "site"
    tilesets = site / "tilesets"
    make_dirs(tilesets)
    make_dirs(site / "assets")

    # 1) tileset image
    img_path = tilesets / "base.png"
    generate_tileset_png(img_path)

    # 2) map.json with embedded tileset
    map_path = site / "map.json"
    generate_map_json(map_path, tileset_image_rel="tilesets/base.png")

    # 3) README + .nojekyll
    write_pages_readme(site / "README.md")
    (site / ".nojekyll").write_text("")

    # 4) zip everything
    zip_path = base_dir / "workadventure-starter.zip"
    zip_site(site, zip_path)
    print(str(zip_path))


if __name__ == "__main__":
    main()

