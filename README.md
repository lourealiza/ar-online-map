WorkAdventure-AROnline

Projeto de mapa mínimo para WorkAdventure usando Tiled.

Estrutura:
- `map.json` — mapa principal (Tiled JSON)
- `tilesets/` — tilesets e imagens associadas
- `assets/` — imagens, áudios, sprites e fontes do jogo

Como editar no Tiled:
- Abra `map.json` no Tiled (v1.10+ recomendado)
- O tileset externo `tilesets/example.tsx` já está referenciado
- Ajuste a imagem do tileset em `tilesets/example.tsx` se necessário (`../assets/images/example-tiles.png`)

Camadas e propriedades:
- `ground` — camada base de tiles
- `collision` — possui propriedade `collides: true`
- `areas` — grupo de objetos com zonas WorkAdventure:
  - `StartArea` com `start: "entrada"`
  - `Website` com `openWebsite` e `openWebsiteWidth`
  - `Reuniao` com `jitsiRoom` e `jitsiWidth`
  - `SilentZone` com `silent: true`

Testar no WorkAdventure (link direto):
- Publique o mapa em uma URL pública e use o formato:
  `https://play.workadventu.re/_/<URL-PUBLICA-DO-MAP.JSON>`
- Se o código estiver no GitHub público, um atalho comum é:
  `https://play.workadventu.re/_/raw.githubusercontent.com/lourealiza/workadventure-aronline/main/map.json`

Dicas:
- Mantenha caminhos relativos corretos entre `map.json`, `tilesets/*.tsx` e `assets/`
- Para novos tilesets, prefira tilesets externos (`.tsx`) e referencie-os em `map.json`

