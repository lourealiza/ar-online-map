Starter de mapa WorkAdventure

Gera um site estático com `map.json` e tileset embutido, pronto para hospedar via GitHub Pages, além de um ZIP para download.

Uso local:
- Requisitos: Python 3.9+ e `pip install pillow`
- Rodar: `python starter/generate_starter.py`
- Saída:
  - `starter/site/` com `map.json`, `tilesets/base.png`, `.nojekyll`
  - `starter/workadventure-starter.zip`

Publicação automática (GitHub Actions):
- A workflow em `.github/workflows/pages.yml` gera `starter/site` e publica no GitHub Pages.
- Após o primeiro deploy, a URL será:
  `https://SEU-USUARIO.github.io/NOME-DO-REPO/map.json`
- Use no WorkAdventure:
  `https://play.workadventu.re/_/SEU-USUARIO.github.io/NOME-DO-REPO/map.json`

