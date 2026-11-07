#!/bin/bash
# Renders the README images in assets/screenshots from Sheen's own SwiftUI
# views (the files in Sources/MacClean/Views/Shared/Care), offscreen: no
# screen capture, no window, no mouse.
set -euo pipefail
cd "$(dirname "$0")/.."
WORK=$(mktemp -d)
for file in Sources/MacClean/Views/Shared/Care/*.swift; do
    sed '/^import MacCleanKit$/d' "$file" > "$WORK/$(basename "$file")"
done
cp scripts/showcase/*.swift Sources/MacCleanKit/SheenMark.swift "$WORK/"
CLT_SDK=/Library/Developer/CommandLineTools/SDKs/MacOSX26.sdk
if [[ -z "${SDKROOT:-}" && "$(xcode-select -p)" == /Library/Developer/CommandLineTools && -d "$CLT_SDK" ]]; then
    export SDKROOT="$CLT_SDK"
fi
swiftc -O -swift-version 6 -parse-as-library -target arm64-apple-macos14.0 "$WORK"/*.swift -o "$WORK/showcase"
mkdir -p assets/screenshots
"$WORK/showcase" assets/screenshots
rm -rf "$WORK"
