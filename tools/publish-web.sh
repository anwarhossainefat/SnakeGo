#!/bin/bash
# Copies the GameMaker HTML5 export into docs/, which GitHub Pages serves as the playable website.
# It also swaps in our phone-friendly web/index.html instead of GameMaker's default one.
#
# Usage (from the project folder):
#   bash tools/publish-web.sh                 # uses ~/GameMakerProjects/SnakeGo-web
#   bash tools/publish-web.sh /path/to/export # or another export folder
set -e

PROJECT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="${1:-$HOME/GameMakerProjects/SnakeGo-web}"
DEST="$PROJECT/docs"

if [ ! -f "$SRC/html5game/SnakeGo.js" ]; then
    echo "Can't find an HTML5 export in: $SRC"
    echo "In GameMaker: set the target to HTML5, then Build > Create Executable > Package as Loose Files."
    exit 1
fi

rm -rf "$DEST"
mkdir -p "$DEST"
cp -R "$SRC/." "$DEST/"

# Our index.html, with a fresh number so browsers don't use an old cached copy of the game
sed "s/__CACHEBUST__/$(date +%s)/" "$PROJECT/web/index.html" > "$DEST/index.html"

# Tell GitHub Pages to serve the files exactly as they are
touch "$DEST/.nojekyll"

echo "Done: the web version is in docs/ ($(find "$DEST" -type f | wc -l | tr -d ' ') files)."
echo "Next: git add . && git commit -m \"Update web version\" && git push"
