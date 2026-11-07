#!/bin/bash
# Build Sheen with Apple's Command Line Tools only: no Xcode, no Developer ID.
#
#   scripts/build-without-xcode.sh               Apple Silicon app in .build/dmg/Sheen.app
#   scripts/build-without-xcode.sh --universal   Apple Silicon + Intel (needs Xcode: CLT lacks Intel runtime libs)
#   scripts/build-without-xcode.sh --dmg         also package .build/Sheen-<version>.dmg
#   scripts/build-without-xcode.sh --install     also replace /Applications/Sheen.app
#
# Flags combine. The app is ad-hoc signed, so macOS asks you to confirm the
# first launch (see README → Install).
set -euo pipefail
cd "$(dirname "$0")/.."

ARCHS="--arch arm64"; DMG=false; INSTALL=false
for flag in "$@"; do
    case "$flag" in
        --universal) ARCHS="--arch arm64 --arch x86_64" ;;
        --dmg) DMG=true ;;
        --install) INSTALL=true ;;
        *) echo "unknown flag: $flag"; exit 2 ;;
    esac
done

# The macOS 27 SDK turns SwiftUI's @State into a macro whose plugin ships only
# inside Xcode. With Command Line Tools alone, build against the macOS 26 SDK.
CLT_SDK=/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk
if [[ -z "${SDKROOT:-}" && "$(xcode-select -p)" == /Library/Developer/CommandLineTools && -d "$CLT_SDK" ]]; then
    export SDKROOT="$CLT_SDK"
fi

LOG=.build/build-without-xcode.log
mkdir -p .build
BUILD_ARCHS="$ARCHS" bash scripts/build-dmg.sh --app-only >"$LOG" 2>&1 || {
    sed 's/\x1b\[[0-9;]*m//g' "$LOG" | grep -E "error:" | sort -u | head -40; exit 1; }

APP=".build/dmg/Sheen.app"
# SwiftPM records the deployment target (14.0) as the SDK version, and macOS
# draws old-style windows for apps built against an old SDK. Record the real one.
SDK_VERSION=$(xcrun --show-sdk-version)
for binary in "$APP/Contents/MacOS/MacClean" "$APP/Contents/Library/LoginItems/MacCleanMenu.app/Contents/MacOS/MacCleanMenu"; do
    vtool -set-build-version macos 14.0 "$SDK_VERSION" -replace -output "$binary" "$binary" 2>/dev/null
done
codesign --force --sign - "$APP/Contents/Library/LoginItems/MacCleanMenu.app" 2>/dev/null
codesign --force --sign - "$APP" 2>/dev/null
codesign --verify --deep --strict "$APP"
echo "built: $APP ($ARCHS)"

if $DMG; then
    VERSION=$(tr -d '[:space:]' < VERSION)
    bash scripts/prepare-dmg-staging.sh .build/dmg
    hdiutil create -volname "Sheen" -srcfolder .build/dmg -ov -format UDZO ".build/Sheen-${VERSION}.dmg" >/dev/null
    echo "dmg: .build/Sheen-${VERSION}.dmg"
fi

if $INSTALL; then
    osascript -e 'tell application id "io.github.danaenayati.sheen" to quit' 2>/dev/null || true
    sleep 1
    pkill -f "Sheen.app/Contents/MacOS/MacClean" 2>/dev/null || true
    rm -rf /Applications/Sheen.app
    ditto "$APP" /Applications/Sheen.app
    /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -u "$PWD/$APP" 2>/dev/null || true
    echo "installed: /Applications/Sheen.app"
fi
