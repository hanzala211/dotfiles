#!/usr/bin/env bash
set -euo pipefail

die() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

[ "$EUID" -ne 0 ] ||
  die "Run as your normal user, not with sudo."

[ "$(uname -m)" = "x86_64" ] ||
  die "This installer supports x86_64 only."

[ -f /etc/os-release ] ||
  die "Cannot identify this system."

. /etc/os-release
[ "$ID" = "ubuntu" ] ||
  die "This installer targets Ubuntu."

REPO="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROFILE="$REPO/nvim-florian"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
CONFIG="$CONFIG_HOME/nvim-florian"
BIN="$HOME/.local/bin"
RUNTIME="$HOME/.local/share/neovide-setup"
NVIM="$RUNTIME/neovim-0.11.6/bin/nvim"
NEOVIDE="$RUNTIME/neovide-0.16.2/neovide"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="$HOME/neovim-backups/install-$STAMP"

[ -f "$PROFILE/init.lua" ] ||
  die "Missing nvim-florian/init.lua in the repository."

for NAME in nv nvim-florian; do
  TARGET="$BIN/$NAME"
  if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
    grep -qF '# hanzallah-neovide-managed' "$TARGET" ||
      die "$TARGET already exists and is not managed by this installer."
  fi
done

sudo apt-get update
sudo apt-get install -y \
  git curl ca-certificates build-essential unzip ripgrep \
  fontconfig fonts-dejavu-core xclip wl-clipboard \
  fortune-mod fortunes-min libxkbcommon-x11-0

mkdir -p "$BIN" "$RUNTIME" "$CONFIG_HOME" "$BACKUP"

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

download() {
  curl --fail --location --retry 3 "$1" -o "$2"
  printf '%s  %s\n' "$3" "$2" | sha256sum -c -
}

download \
  "https://github.com/neovim/neovim/releases/download/v0.11.6/nvim-linux-x86_64.tar.gz" \
  "$WORK/nvim.tar.gz" \
  "2fc90b962327f73a78afbfb8203fd19db8db9cdf4ee5e2bef84704339add89cc"

download \
  "https://github.com/neovide/neovide/releases/download/0.16.2/neovide-linux-x86_64.tar" \
  "$WORK/neovide.tar" \
  "d3f4a50921b7144d6ab45096587d5f9bef3ad167f3d83e522e100b73efa73560"

mkdir "$WORK/neovide"
tar -xzf "$WORK/nvim.tar.gz" -C "$WORK"
tar -xf "$WORK/neovide.tar" -C "$WORK/neovide"

NEOVIDE_SOURCE="$(find "$WORK/neovide" -type f -name neovide -print -quit)"
[ -n "$NEOVIDE_SOURCE" ] || die "Neovide binary missing."

"$WORK/nvim-linux-x86_64/bin/nvim" --version >/dev/null
chmod +x "$NEOVIDE_SOURCE"
"$NEOVIDE_SOURCE" --version >/dev/null

if [ -e "$RUNTIME/neovim-0.11.6" ]; then
  mv "$RUNTIME/neovim-0.11.6" "$BACKUP/neovim-runtime"
fi

mv "$WORK/nvim-linux-x86_64" "$RUNTIME/neovim-0.11.6"

mkdir -p "$(dirname "$NEOVIDE")"
if [ -e "$NEOVIDE" ]; then
  cp -a "$NEOVIDE" "$BACKUP/neovide-binary"
fi
install -m 0755 "$NEOVIDE_SOURCE" "$NEOVIDE"

if [ "$(readlink -f "$CONFIG" 2>/dev/null || true)" != "$PROFILE" ]; then
  if [ -e "$CONFIG" ] || [ -L "$CONFIG" ]; then
    mv "$CONFIG" "$BACKUP/nvim-florian"
  fi
  ln -s "$PROFILE" "$CONFIG"
fi

printf '#!/usr/bin/env bash\n# hanzallah-neovide-managed\nexport NVIM_APPNAME=nvim-florian\nexport PATH="$PATH:/usr/games"\nexec %q --fork --neovim-bin %q "$@"\n' \
  "$NEOVIDE" "$NVIM" > "$BIN/nv"

printf '#!/usr/bin/env bash\n# hanzallah-neovide-managed\nexport NVIM_APPNAME=nvim-florian\nexport PATH="$PATH:/usr/games"\nexec %q "$@"\n' \
  "$NVIM" > "$BIN/nvim-florian"

chmod +x "$BIN/nv" "$BIN/nvim-florian"

touch "$HOME/.bashrc"
cp -a "$HOME/.bashrc" "$BACKUP/bashrc"

sed -i \
  '/^# BEGIN HANZALLAH NEOVIDE$/,/^# END HANZALLAH NEOVIDE$/d' \
  "$HOME/.bashrc"

cat >> "$HOME/.bashrc" <<'BASHRC'

# BEGIN HANZALLAH NEOVIDE
export PATH="$HOME/.local/bin:$PATH:/usr/games"
export NVIM_APPNAME=nvim-florian
alias nv="$HOME/.local/bin/nv"
# END HANZALLAH NEOVIDE
BASHRC

mkdir -p "$HOME/.local/share/applications"

DESKTOP="$HOME/.local/share/applications/neovide-florian.desktop"
if [ -e "$DESKTOP" ]; then
  cp -a "$DESKTOP" "$BACKUP/neovide-florian.desktop"
fi

cat > "$DESKTOP" <<DESKTOP
[Desktop Entry]
Version=1.0
Type=Application
Name=Neovide (Florian)
Comment=Neovide with Hanzallah's Florian-based configuration
Exec="$BIN/nv" %F
Terminal=false
Categories=Development;TextEditor;
DESKTOP

if [ -f "$PROFILE/lazy-lock.json" ]; then
  cp "$PROFILE/lazy-lock.json" "$WORK/lazy-lock.json"

  printf 'Restoring plugin revisions from lazy-lock.json...\n'

  PATH="$PATH:/usr/games" NVIM_APPNAME=nvim-florian \
    "$NVIM" --headless '+Lazy! restore' '+qa!'

  cp "$WORK/lazy-lock.json" "$PROFILE/lazy-lock.json"
else
  printf 'No lockfile: plugins will install on first launch.\n'
fi

printf '\nInstalled successfully.\n'
printf 'Configuration: %s\n' "$CONFIG"
printf 'Backups: %s\n' "$BACKUP"
printf 'Run: source ~/.bashrc\n'
printf 'Then: nv\n'
printf 'Terminal editor: nvim-florian\n'
