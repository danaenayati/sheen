---
version: 1
slug: "sources-macclean-views-shared-nativeskin-swift"
primary_target: "Sources/MacClean/Views/Shared/NativeSkin.swift"
related_targets: ["Sources/MacClean/Views/Shared/ModuleContainerView.swift","Sources/MacClean/Views/Sidebar/SidebarView.swift"]
---

# Surface: Sheen tool screens

Scope: the app shell (sidebar + detail pane), Smart Scan, the 22 tool intro screens, and each tool's scanning, results and done states.
Mode: Operate.
Audience and job: people who go straight to one tool. Every tool's first screen is a front door: what it finds, what happens next, one action.
Constraints: SwiftUI, macOS 14+, view layer only (upstream scanning and cleaning untouched, changes kept in shared components); light and dark appearance; Reduce Motion; English copy; no MacPaw artwork, icons or branding.
Memorable moment: the cursor is the light source on each tool's glass object.
Unresolved: public product name; translations of new copy.

## Direction contract

THESIS: Each tool is a lit room: its section's color drenches the whole detail pane, one original glass object per tool sits under a light that follows the cursor, and three plain bullets say what the tool finds. Refuses the open-source-cleaner default (grey pane, centered SF Symbol, lone Scan button) and CleanMyMac's flat picture that only slides.

OWN-WORLD: Six section grounds, each a deep two-hue field with a soft light pool in dark appearance and a luminous tinted field in light appearance: Smart Scan midnight indigo with cyan aurora; Cleanup emerald to teal; Protection rose to plum; Performance ember amber to rust; Applications cobalt to sapphire; Files ultraviolet to violet. Glass objects: gradient bodies, rim light, engraved SF Symbol glyphs, specular bloom, colored floor shadow. Bullet: 34pt squircle tile in the section gradient with a white glyph, semibold label, one secondary line. SF Pro throughout, 40pt light title. White pill primary button with a section-colored label. Dark translucent sidebar grouped by section, all 22 tools visible.

STORY: Pick a tool, know in one glance what it will find and that nothing is removed before review, press Scan, watch progress in the same room, review and select, clean, see what was freed.

FIRST VIEWPORT: Detail pane is the full-bleed section ground. Left ~45%: the tool's glass object, ~300pt, on its floor shadow, vertically centered. Right column (max 420pt): title, subtitle (max 2 lines), three bullets, the primary pill button under the bullets, a quiet requirement line when Full Disk Access is needed. After the first completed use the tool opens compact: object 150pt, bullets as one row, button first in reading order. Narrow windows stack the object above the text.

FORM: user-pinned category standard (CleanMyMac, "like it but better", 2026-11-06), raised on four named axes the user chose: real depth and light, clearer bullets, faster to the task, light and dark worlds. No seed key: concept-seed was not run because the direction is pinned by the user. Signature interaction: pointer light. The highlight and rim light slide across the glass, the object tilts up to 8 degrees toward the cursor, inner layers parallax by depth, the floor shadow moves opposite, all easing back to rest when the pointer leaves; static under Reduce Motion. Motion grammar: 200-300 ms state changes, a soft spring for pointer response, one authored transition: the intro object shrinks into the center of the scanning progress.

FINISH: unreviewed and undocumented is unfinished; this build ends with the finish review, the verdict, DESIGN.md, and every shipping raster carrying its provenance
