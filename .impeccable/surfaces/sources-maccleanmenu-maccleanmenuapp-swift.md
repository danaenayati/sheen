---
version: 1
slug: "sources-maccleanmenu-maccleanmenuapp-swift"
primary_target: "Sources/MacCleanMenu/MacCleanMenuApp.swift"
related_targets: []
---

# Surface: Sheen menu bar panel

Scope: the menu bar item (MenuBarExtra label) and its window panel in Sources/MacCleanMenu.
Mode: Operate.
Audience and job: a quick health glance. Click Sheen's mark in the menu bar, read CPU, memory, disk and battery in a second, see if anything needs attention, jump into the app.
Constraints: separate helper target (cannot import the app's Care views; shares MacCleanKit); on by default for new users, off switch stays in Settings → Menu bar; menu bar shows the mark only, never a value; Reduce Motion; light and dark appearance; truthful copy only.
Memorable moment: four room-coloured tiles that each open the tool they belong to.
Unresolved: translations of new copy.

## Direction contract

THESIS: The panel is Sheen's home room in miniature: the Midnight Indigo world, a light title voice, and four figure tiles in the colours of the sections they open. Refuses the stock system-monitor grid of coloured ring gauges on flat purple cards, and any value text in the menu bar itself.

OWN-WORLD: Midnight Indigo ground (deep to mid gradient with the cyan glow pool in dark; ice lavender to ice cyan in light). Tiles are the app's list panel recipe (ultra-thin material under deep 0.55 / pale top 0.55, 12pt continuous corners). Each metric owns a section colour: CPU Ember, Memory Cobalt, Disk Ultraviolet, Battery Emerald; its 22pt gradient tile and a 5pt bar in the same gradient; state copy turns Rose when a value crosses its threshold. SF Pro only; figures 28pt light with monospaced digits. White pill "Open Sheen" in dark, Midnight mid gradient pill in light. Menu bar item: Sheen's three-pane mark as a template image, nothing else.

STORY: Click the mark, see the Health tab: four figures and their bars, network and uptime underneath. Tips and Devices sit one click away, Tips showing its count. Click a tile to open its tool, a tip's action to open the right tool, or Open Sheen.

FIRST VIEWPORT: 340pt wide. Row 1: app icon 20pt, "Sheen" 15pt semibold, uptime right-aligned soft. Row 2: native segmented control Health | Tips · n | Devices. Health: 2 × 2 tiles (label row with 22pt tile, 28pt light figure, bar or sub line), then a soft line with ↓ / ↑ network speed and protection state. Footer: Open Sheen pill filling the width minus a quiet Quit text button.

FORM: Tabs (user-locked from the surface roll, seed:90c55bd4f7629e78, dealt index 7 of 7 grounded structures). Signature move: four section-coloured tiles; CPU, Memory and Disk open the tool that acts on them (Optimization, Optimization, Space Map), Battery is read-only; hover lifts the tile. Motion: tab switch crossfade 0.2s; values change with numeric content transitions; nothing loops.

FINISH: unreviewed and undocumented is unfinished; this build ends with the finish review, the verdict, DESIGN.md, and every shipping raster carrying its provenance
