# AR Online — Mapa WorkAdventure (Starter)

Este repositório é um esqueleto mínimo para criar e hospedar um mapa do WorkAdventure a partir do zero, usando GitHub Pages. Com ele, você poderá abrir seu mapa diretamente no WorkAdventure via URL pública.

## Requisitos

- Tiled (editor de mapas): https://www.mapeditor.org/
- Uma conta no GitHub (para publicar via GitHub Pages)

## Estrutura do projeto

- `docs/` — conteúdo estático publicado no GitHub Pages (mapa e assets)
- `docs/map.json` — mapa inicial (formato JSON do Tiled) vazio para começar
- `docs/assets/` — coloque aqui imagens/tilesets do seu mapa
- `assets/` — pasta local opcional para organizar arquivos-fonte (não publicada)

## Passo a passo

1) Crie/edite o mapa no Tiled
- Abra o Tiled e crie um novo mapa Orthogonal (ex. 32x32px por tile).
- Adicione layers (tile layers / object layers) e seus tilesets (imagens).
- Salve/exporte o mapa em formato JSON (TMJ). Sugestão: exporte como `map.json`.

2) Coloque os arquivos no `docs/`
- Copie o `map.json` para `docs/`.
- Copie as imagens/tilesets referenciados para `docs/assets/` (e ajuste caminhos no Tiled se necessário).

3) Publique no GitHub Pages
- Faça o push deste repositório para o GitHub.
- Nas configurações do repositório, ative GitHub Pages com a opção “Deploy from a branch” e selecione a branch padrão (ex. `main`) e a pasta `/docs`.
- Aguarde a URL do Pages ficar ativa (ex.: `https://seuusuario.github.io/nome-do-repo/`).

4) Abra seu mapa no WorkAdventure
- Use a URL do WorkAdventure no formato:
  `https://play.workadventu.re/_/global/seuusuario.github.io/nome-do-repo/map.json`
- Substitua `seuusuario` e `nome-do-repo` pelos seus valores.

## Dicas importantes (WorkAdventure)

- Mantenha caminhos relativos no Tiled (ex.: `assets/tileset.png`).
- Se usar o Scripting API do WorkAdventure no futuro (WAM), será necessário adicionar um bundle JS e referenciá-lo nas propriedades do mapa/layer. Este starter não inclui build de scripts, focando no mapa puro.
- Para zonas interativas (portas, sites, etc.), use Object Layers no Tiled e defina as propriedades esperadas pelo WorkAdventure (ver documentação de “map-building” do WorkAdventure).

## Próximos passos

- Edite `docs/map.json` com o Tiled e adicione suas imagens em `docs/assets/`.
- Ative o GitHub Pages e teste a URL global no WorkAdventure.
- Se quiser, posso integrar um template com scripting (WAM) depois.

