#!/bin/bash
# Completely remove Sheen and its support files.
# Usage: curl -fsSL https://raw.githubusercontent.com/danaenayati/sheen/main/scripts/uninstall.sh | bash
#
# Homebrew users can instead run:  brew uninstall --zap --cask sheen
# (the --zap flag removes the same support files via the cask's zap stanza).

set -euo pipefail

APP_NAME="Sheen.app"
INSTALL_DIR="/Applications"

cyan() { printf "\033[36m%s\033[0m\n" "$1"; }
green() { printf "\033[32m%s\033[0m\n" "$1"; }
red() { printf "\033[31m%s\033[0m\n" "$1"; }

# Guard: HOME must be set so the explicit paths below never expand to "/...".
if [ -z "${HOME:-}" ]; then
  red "HOME is not set; aborting to avoid removing unintended paths."
  exit 1
fi

# Exact, explicit paths only (no globs, no wildcards) so this can never delete
# more than Sheen's own files.
SUPPORT_PATHS=(
  "$HOME/Library/Application Support/MacClean"
  "$HOME/Library/Caches/io.github.danaenayati.sheen"
  "$HOME/Library/HTTPStorages/io.github.danaenayati.sheen"
  "$HOME/Library/Logs/MacClean"
  "$HOME/Library/Preferences/io.github.danaenayati.sheen.plist"
  "$HOME/Library/Preferences/io.github.danaenayati.sheen.shared.plist"
  "$HOME/Library/Saved Application State/io.github.danaenayati.sheen.savedState"
)

cyan "Quitting Sheen if it is running..."
osascript -e 'tell application "Sheen" to quit' >/dev/null 2>&1 || true
# The menu-bar helper is a separate process.
pkill -f "MacCleanMenu" >/dev/null 2>&1 || true

# Prefer Homebrew's own uninstall when the cask is installed, so brew's receipt
# stays consistent. --zap removes the support files too, so we're done after it.
if command -v brew >/dev/null 2>&1 && brew list --cask sheen >/dev/null 2>&1; then
  cyan "Removing the Homebrew cask (with --zap to clear support files)..."
  brew uninstall --zap --cask sheen
  green "✓ Sheen and its support files were removed via Homebrew."
  exit 0
fi

cyan "Removing $INSTALL_DIR/$APP_NAME..."
rm -rf "$INSTALL_DIR/$APP_NAME"

cyan "Removing support files..."
for path in "${SUPPORT_PATHS[@]}"; do
  if [ -e "$path" ]; then
    rm -rf "$path"
    echo "  removed $path"
  fi
done

# Clear any cached preferences held by cfprefsd so they don't get rewritten.
defaults delete io.github.danaenayati.sheen >/dev/null 2>&1 || true
defaults delete io.github.danaenayati.sheen.shared >/dev/null 2>&1 || true

green ""
green "✓ Sheen has been uninstalled."
echo ""
echo "If Sheen still appears under System Settings → General → Login Items,"
echo "remove the leftover entry there; macOS clears it once the app is gone."
