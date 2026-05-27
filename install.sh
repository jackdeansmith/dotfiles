#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
BACKED_UP=false

backup_and_link() {
  local src="$1"
  local dest="$2"

  # Create parent directory if needed
  mkdir -p "$(dirname "$dest")"

  # If destination exists and is not already the correct symlink, back it up
  if [[ -e "$dest" || -L "$dest" ]]; then
    # Skip if it's already pointing to the right place
    if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
      echo "  ok: $dest → $src (already linked)"
      return
    fi
    if [[ "$BACKED_UP" == false ]]; then
      mkdir -p "$BACKUP_DIR"
      BACKED_UP=true
    fi
    mv "$dest" "$BACKUP_DIR/"
    echo "  backed up: $dest → $BACKUP_DIR/"
  fi

  ln -s "$src" "$dest"
  echo "  linked: $dest → $src"
}

echo "==> Installing dotfiles from $DOTFILES"
echo ""

# Linux: apt-install packages listed in linux-packages.txt
if [[ "$OSTYPE" == linux* ]] && command -v apt-get >/dev/null 2>&1; then
  pkgs=()
  while IFS= read -r line; do
    line="${line%%#*}"; line="${line//[[:space:]]/}"
    [[ -n "$line" ]] && pkgs+=("$line")
  done < "$DOTFILES/linux-packages.txt"

  missing=()
  for p in "${pkgs[@]}"; do
    dpkg -s "$p" >/dev/null 2>&1 || missing+=("$p")
  done

  if (( ${#missing[@]} > 0 )); then
    echo "Linux packages (apt):"
    echo "  installing: ${missing[*]}"
    sudo apt-get update -qq
    sudo apt-get install -y "${missing[@]}"
    echo ""
  fi
fi

# Shell
echo "Shell configs:"
backup_and_link "$DOTFILES/shell/zshrc"    "$HOME/.zshrc"
backup_and_link "$DOTFILES/shell/zshenv"   "$HOME/.zshenv"
backup_and_link "$DOTFILES/shell/zprofile" "$HOME/.zprofile"

# Platform-specific zprofile extensions get symlinked as hidden dotfiles
backup_and_link "$DOTFILES/shell/zprofile.mac"   "$HOME/.zprofile.mac"
backup_and_link "$DOTFILES/shell/zprofile.linux" "$HOME/.zprofile.linux"

# Git
echo ""
echo "Git configs:"
backup_and_link "$DOTFILES/git/gitconfig"        "$HOME/.gitconfig"
backup_and_link "$DOTFILES/git/gitignore_global" "$HOME/.gitignore_global"

# Neovim
echo ""
echo "Neovim config:"
backup_and_link "$DOTFILES/nvim/init.vim" "$HOME/.config/nvim/init.vim"

# vim-plug + plugins
PLUG_VIM="$HOME/.local/share/nvim/site/autoload/plug.vim"
if [[ ! -f "$PLUG_VIM" ]]; then
  echo "  installing vim-plug…"
  curl -fsSLo "$PLUG_VIM" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
if command -v nvim >/dev/null 2>&1; then
  echo "  running :PlugInstall…"
  nvim --headless +PlugInstall +qall 2>/dev/null || true
fi

# GitHub CLI
echo ""
echo "GitHub CLI config:"
backup_and_link "$DOTFILES/gh/config.yml" "$HOME/.config/gh/config.yml"

# Karabiner (macOS only)
if [[ "$OSTYPE" == darwin* ]]; then
  echo ""
  echo "Karabiner config (macOS):"
  backup_and_link "$DOTFILES/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
fi

# Secrets template
echo ""
if [[ ! -f "$HOME/.secrets" ]]; then
  cat > "$HOME/.secrets" <<'SECRETS'
# API Keys — never commit this file
export OPENAI_API_KEY=
export ANTHROPIC_API_KEY=
export GEMINI_API_KEY=
export OPENROUTER_API_KEY=
SECRETS
  chmod 600 "$HOME/.secrets"
  echo "Created ~/.secrets template — fill in your API keys."
else
  echo "~/.secrets already exists, skipping."
fi

echo ""
if [[ "$BACKED_UP" == true ]]; then
  echo "==> Done! Old files backed up to: $BACKUP_DIR"
else
  echo "==> Done! No files needed to be backed up."
fi
echo "Open a new shell to pick up the changes."
