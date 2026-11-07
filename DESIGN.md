---
name: Sheen
description: Every tool is a lit room; the cursor is the light on its glass object.
colors:
  smart-care-deep: "#0B0A2E"
  smart-care-mid: "#2B2384"
  smart-care-glow: "#37C8FF"
  smart-care-pale-top: "#E9EBFF"
  smart-care-pale-bottom: "#CFEFFF"
  smart-care-ink: "#1A1660"
  smart-care-tile-top: "#7E6BFF"
  smart-care-tile-bottom: "#22B5F5"
  smart-care-spark: "#5BE3FF"
  cleanup-deep: "#04241D"
  cleanup-mid: "#0C6A55"
  cleanup-glow: "#3BF0A8"
  cleanup-pale-top: "#E5FBF2"
  cleanup-pale-bottom: "#C2F1DF"
  cleanup-ink: "#07402F"
  cleanup-tile-top: "#45E8B0"
  cleanup-tile-bottom: "#0A9A7B"
  cleanup-spark: "#C8F25A"
  protection-deep: "#2A0619"
  protection-mid: "#8C1846"
  protection-glow: "#FF5C8A"
  protection-pale-top: "#FFEAF0"
  protection-pale-bottom: "#FFD3DF"
  protection-ink: "#5E0B2D"
  protection-tile-top: "#FF7B9C"
  protection-tile-bottom: "#C71A5A"
  protection-spark: "#FFB36B"
  performance-deep: "#2B1003"
  performance-mid: "#983A0B"
  performance-glow: "#FFB23F"
  performance-pale-top: "#FFF2E1"
  performance-pale-bottom: "#FFDDB8"
  performance-ink: "#5C2306"
  performance-tile-top: "#FFC54D"
  performance-tile-bottom: "#F0561A"
  performance-spark: "#FF7A59"
  applications-deep: "#05163A"
  applications-mid: "#1546B6"
  applications-glow: "#52A8FF"
  applications-pale-top: "#E6F0FF"
  applications-pale-bottom: "#C9DEFF"
  applications-ink: "#0B2B73"
  applications-tile-top: "#62BCFF"
  applications-tile-bottom: "#2F57F5"
  applications-spark: "#7CF0FF"
  files-deep: "#1A0939"
  files-mid: "#5A21B4"
  files-glow: "#C57EFF"
  files-pale-top: "#F3EAFF"
  files-pale-bottom: "#E0CCFF"
  files-ink: "#3A0F7A"
  files-tile-top: "#CB8EFF"
  files-tile-bottom: "#7434E6"
  files-spark: "#FF8AD8"
  settings-deep: "#111419"
  settings-mid: "#2C3340"
  settings-glow: "#8FA6C4"
  settings-pale-top: "#F1F3F7"
  settings-pale-bottom: "#E1E6EE"
  settings-ink: "#1E2430"
  settings-tile-top: "#9AA9BF"
  settings-tile-bottom: "#56637A"
  settings-spark: "#B9C7DB"
  glass-white: "#FFFFFF"
  brand-spark-top: "#9AE8FF"
typography:
  display:
    fontFamily: "SF Pro Display, -apple-system, system-ui"
    fontSize: "40pt"
    fontWeight: 300
    lineHeight: 1.1
    letterSpacing: "-0.6pt"
  display-compact:
    fontFamily: "SF Pro Display, -apple-system, system-ui"
    fontSize: "32pt"
    fontWeight: 300
    letterSpacing: "-0.4pt"
  headline-figure:
    fontFamily: "SF Pro Display, -apple-system, system-ui"
    fontSize: "34pt"
    fontWeight: 300
    fontFeature: "tnum"
  title:
    fontFamily: "SF Pro Display, -apple-system, system-ui"
    fontSize: "28pt"
    fontWeight: 300
    letterSpacing: "-0.3pt"
  subtitle:
    fontFamily: "SF Pro Text, -apple-system, system-ui"
    fontSize: "16pt"
    fontWeight: 400
    lineHeight: "22pt"
  body-strong:
    fontFamily: "SF Pro Text, -apple-system, system-ui"
    fontSize: "15pt"
    fontWeight: 600
  body:
    fontFamily: "SF Pro Text, -apple-system, system-ui"
    fontSize: "13pt"
    fontWeight: 400
  label:
    fontFamily: "SF Pro Text, -apple-system, system-ui"
    fontSize: "12pt"
    fontWeight: 400
  sidebar-section:
    fontFamily: "SF Pro Text, -apple-system, system-ui"
    fontSize: "11pt"
    fontWeight: 600
  wordmark:
    fontFamily: "SF Pro Text, -apple-system, system-ui"
    fontSize: "17pt"
    fontWeight: 600
rounded:
  tile-sm: "6pt"
  sidebar-row: "9pt"
  tile: "10pt"
  pill: "999pt"
spacing:
  hair: "3pt"
  xs: "6pt"
  sm: "10pt"
  md: "14pt"
  lg: "18pt"
  xl: "24pt"
  gap: "28pt"
  2xl: "30pt"
  3xl: "34pt"
  gutter: "44pt"
  top: "52pt"
components:
  button-primary-dark:
    backgroundColor: "{colors.glass-white}"
    textColor: "{colors.applications-mid}"
    typography: "{typography.body-strong}"
    rounded: "{rounded.pill}"
    padding: "0 30pt"
    height: "46pt"
  button-primary-light:
    backgroundColor: "{colors.protection-mid}"
    textColor: "{colors.glass-white}"
    typography: "{typography.body-strong}"
    rounded: "{rounded.pill}"
    padding: "0 30pt"
    height: "46pt"
  bullet-tile:
    backgroundColor: "{colors.applications-tile-bottom}"
    textColor: "{colors.glass-white}"
    rounded: "{rounded.tile}"
    size: "36pt"
  sidebar-tile:
    backgroundColor: "{colors.cleanup-tile-bottom}"
    textColor: "{colors.glass-white}"
    rounded: "{rounded.tile-sm}"
    size: "24pt"
  sidebar-row:
    typography: "{typography.body}"
    rounded: "{rounded.sidebar-row}"
    padding: "5pt 8pt"
---

# Design System: Sheen

## Overview

**Creative North Star: "The Lit Room"**

Each tool is a room drenched in its section's color. One original glass object per tool sits in the room under a light the cursor carries: the specular bloom and rim light slide toward the pointer, the object tilts toward it, its pieces parallax by depth, and its floor shadow swings the other way. Beside the object, a large light-weight title, one plain subtitle, three bulleted promises and a single pill action. Scanning happens in the same room: the object glides into the center of a progress ring cut from the section's gradient, and comes back to rest at the head of the results.

The system is native macOS through and through: SF Pro only, SF Symbols plus Sheen's own mark as the only glyph sources, the real sidebar vibrancy material, system materials under lists. What makes it its own is color and light, not chrome. Dark appearance is a deep two-hue field with a soft light pool behind the object; light appearance is the same hue made luminous, pale top to pale bottom with the same pool. Nothing ships as a raster: every object, tile and ground is drawn in code from a small set of glass primitives.

Density is low on the front door and normal on the working screens. A tool's intro is a single viewport with lots of air; once the tool has been used it reopens compact, button first, so returning users reach the task faster.

**Key Characteristics:**
- Seven color worlds (six sections plus Settings graphite), each nine colors; a world drenches ground, sidebar tint, list panels, tiles, ring and control tint together.
- One glass hero object per tool on a 300pt stage, lit by a pointer-driven light; static at rest under Reduce Motion.
- Light-weight display titles (40 / 32 / 28pt) with negative tracking; semibold only for labels and the action.
- One capsule primary action per screen, inverted between appearances.
- Rounded gradient tiles with white SF Symbols as the bullet and sidebar icon.

## Colors

A world system rather than a palette: every section owns a nine-color room (deep, mid, glow, pale top, pale bottom, ink, tile top, tile bottom, spark), and every surface inside the section draws from that room only.

### Primary
- **Midnight Indigo world** (`smart-care-*`): Smart Scan, the app's home. Deep indigo into violet-blue in dark, ice lavender into ice cyan in light, a cyan glow, and the only world with a signature extra light: a long, blurred cyan aurora band tilted -12° low across the room (strength 0.5 dark, 0.32 light).

### Secondary
- **Emerald world** (`cleanup-*`): Cleanup tools. Emerald into teal, mint glow, lime spark.
- **Rose Plum world** (`protection-*`): Protection tools. Plum into raspberry, rose glow, apricot spark.
- **Ember world** (`performance-*`): Performance tools. Rust into burnt orange, amber glow, coral spark.
- **Cobalt world** (`applications-*`): Applications tools. Navy into cobalt, sky glow, aqua spark.
- **Ultraviolet world** (`files-*`): Files tools. Aubergine into violet, lilac glow, pink spark.

### Neutral
- **Graphite world** (`settings-*`): Settings. The one desaturated room: slate grounds, steel-blue glow; it keeps every role so Settings behaves like any other room.
- **Glass White** (`glass-white`): the dark-room pill body, tile glyphs, rim light and specular bloom. Used at fixed opacities (rim 0.95 to 0.08, face sheen 0.34, specular 0.75), never as a flat panel fill.
- **Brand Spark Ice** (`brand-spark-top`): retired from the wordmark (the sidebar now shows the app icon); kept as the Smart Scan spark's lighter neighbour.

### How each role is applied
- **Deep / mid** build the dark ground: a top-leading to bottom-trailing gradient deep, mid mixed 35% into deep, deep; a mid corner light at the top right (0.55 opacity, 420pt radius). Deep also tints the dark panel and sidebar (0.55 / 0.5), edges every glass piece, and colors the dark floor shadow (0.85).
- **Glow** is the light pool behind the hero (0.42 dark, 0.38 light, 520pt radius at 28% / 46% of the pane, drifting 4% with the pointer) and the progress ring's glow.
- **Pale top / pale bottom** build the light ground; pale top tints the light panel and sidebar (0.55 / 0.42).
- **Ink** is all text on light grounds; on dark grounds text is white. Secondary text is ink at 0.74 to 0.76.
- **Tile top / tile bottom** are the shared gradient for tiles, the main glass tint, and the ring; tile bottom is the system control tint for the selected tool.
- **Spark** is the second hue reserved for accent pieces inside hero objects (spark glass, pearl glass) and the ring's tail.

### Named Rules
**The One Room Rule.** A screen belongs to exactly one world. Ground, sidebar tint, list panel tint, ring, pill and control tint all come from the selected tool's section; the only other worlds on screen are the sidebar's own row tiles, each carrying its section.

**The Derived Glass Rule.** Glass is never given its own colors. It is cut from four tints derived from the world: section glass (tile gradient, deep edge), spark glass (spark lifted 35% toward white), clear glass (white with a breath of glow), and pearl (white into spark mixed 62% toward white, mid edge).

## Typography

**Display Font:** SF Pro (system font, weights light 300 for display)
**Body Font:** SF Pro (system font)

**Character:** One family, voiced by weight. Titles are large and light with slight negative tracking, so the room and the object carry the weight; semibold appears only where the eye must land: bullet labels, the action, the selected sidebar row.

### Hierarchy
- **Display** (300, 40pt, -0.6pt tracking): the tool's name on its first-visit intro.
- **Display compact** (300, 32pt, -0.4pt): the tool's name on the compact intro after first use.
- **Headline figure** (300, 34pt, monospaced digits, numeric content transition): the progress percentage under the ring.
- **Title** (300, 28pt, -0.3pt): screen titles on results and list screens.
- **Subtitle** (400, 16pt, 3pt extra line spacing; 14pt on compact): one plain sentence under the display title, secondary ink.
- **Body strong** (600, 15pt): bullet labels and the pill label.
- **Body** (400, 13pt): bullet detail lines and sidebar rows (600 when selected).
- **Label** (400, 12pt): the requirement note with an info symbol, scan detail lines; 12pt medium for compact bullet labels.
- **Sidebar section** (600, 11pt, ink 0.5): section headers in the sidebar.

### Named Rules
**The Light Voice Rule.** Every title on a tool screen is light weight (300). Bold display type is not part of this system.

## Layout

The window is a vibrancy sidebar plus a full-bleed detail pane; the pane is the room and has no inset card.

- **First-visit intro, 660pt and wider:** hero on the left, text column on the right. Column max 370pt with a 28pt gap; at 980pt and wider, column 430pt with a 44pt gap. The hero scales to fill what the column leaves: (pane width - 88 - gap - column) / 320, clamped 0.8 to 1.25.
- **First-visit intro, narrower than 660pt:** hero (0.78) stacked above a 460pt text column, 24pt apart.
- **Compact intro (after first use):** hero at 0.56; title, subtitle, then the action, then one row of small tiles and labels. Side by side (30pt) at 640pt and wider, stacked (18pt) below. Text column max 520pt.
- **Pane padding:** 44pt horizontal, 52pt top, 32pt bottom; content vertically centered in a scroll view that only bounces when it overflows.
- **Intro rhythm:** title to subtitle 10pt, subtitle to bullets 30pt, between bullets 18pt, tile to label 14pt, bullets to action 34pt, action to note 14pt.
- **Progress:** a 270pt ring, centered, percentage 26pt below, phase line 6pt below that (max 420pt, middle-truncated).
- **Sidebar:** every tool visible, grouped by section headers; wordmark row 44pt from the top; rows at 1pt spacing with 5pt / 8pt padding; Settings pinned below a divider.

**The Object Is The Subject Rule.** At every width the hero object takes whatever space the text column leaves; the text column is capped, the object is not shrunk to make room for decoration.

## Elevation & Depth

Depth here is light, not stacking. Surfaces do not float on each other; the room is one plane, and the glass objects are the only things with thickness. Each glass piece is extruded away from the light in stacked side-wall layers (7 for tinted glass, 14 merged in one compositing group at 0.13 opacity for clear glass), then a face gradient, a top sheen, a specular bloom placed toward the light, a blurred inner edge shadow, and a rim light graded from the lit side. Whole objects tilt up to 8° toward the pointer on a 0.55 perspective and render in one Metal pass.

### Shadow Vocabulary
- **Floor shadow** (ellipse 210 x 30pt, blur 16, deep at 0.85 dark / mid at 0.32 light, shifted -18pt x light): under every hero object, swinging opposite the light.
- **Pill shadow** (deep at 0.5 dark / 0.28 light, radius 10 y 5; hover radius 16 y 8): under the primary action only.
- **Tile shadow** (deep at 0.28, radius 6 y 3; glyph shadow deep 0.35 radius 1 y 1): under bullet and sidebar tiles.
- **Ring glow** (glow at 0.55 dark / 0.3 light, radius 10): on the progress arc.

### Named Rules
**The Cursor Is The Light Rule.** Every highlight, rim, bevel, extrusion and floor shadow answers one shared light. At rest it sits top-left; the pointer pulls it across the object. Never paint a fixed highlight that disagrees with it.

**The Colored Shadow Rule.** Shadows are tinted with the world's deep or mid, never neutral black, except the hairline bevel of an engraved symbol (black 0.28).

## Shapes

Continuous (squircle) corners everywhere a rectangle is rounded. Three recurring forms: the capsule (the primary action only), the rounded tile (corner radius 0.28 of its side: 10pt at 36pt, about 6pt at 22 to 24pt), and the soft row (9pt, sidebar selection). Hero objects are cut from a fixed shape kit: shield, tapered bin or cup, folder, sheet with folded corner, flap, lens, arc band, gear, circle; intricate silhouettes (puzzle piece, wrench, paperclip) are cut from SF Symbols as glass solids, and marks inside glass are SF Symbols engraved into the face (lit edge toward the light, shadowed edge away).

## Components

### Buttons
Confident and singular: one pill per screen, inverted by appearance.
- **Shape:** capsule, minimum 150 x 46pt, 30pt horizontal padding, 15pt semibold label.
- **Dark room:** white pill (white to white 0.88 top to bottom) with a label in the section's mid mixed 25% into deep.
- **Light room:** the section's mid as a gradient (mid lifted 12% toward white to mid mixed 30% into deep), white label, 1pt white 0.28 inner stroke.
- **Hover / pressed:** hover brightens 0.03 and deepens the shadow (0.16s ease-out); pressed darkens 0.06 and scales to 0.97 (0.1s ease-out).
- **Disabled:** a quiet translucent pill (white 0.14 dark, mid 0.14 light) with a readable label (white 0.62 dark, ink 0.55 light); the button never fades into the room.

### Bullet tile
- Rounded tile in the section's tile gradient (top-leading to bottom-trailing), white sheen from top to center (0.38), 0.75pt white 0.32 border, white SF Symbol at 0.44 of the tile side, semibold. 36pt in intros, 22pt in the compact strip, 24pt in the sidebar. Decorative: hidden from VoiceOver; the label beside it carries the meaning.

### Cards / Containers
- **List and results panels:** the system ultra-thin material with the room laid over it (deep 0.55 dark, pale top 0.55 light); list backdrops are hidden so the panel shows through. No borders, no radius of their own.

### Navigation
- **Sidebar:** the real macOS sidebar vibrancy material tinted by the current world (deep 0.5 dark, pale top 0.42 light), crossfading 0.35s on selection. Wordmark: the app icon at 24pt plus "Sheen" at 17pt semibold. Rows: 24pt section tile, 13pt label (regular at 0.8 ink, semibold at full ink when selected), selection fill ink 0.13, hover 0.06, 9pt continuous corners. The selected row scrolls into view (0.3s ease-out).

### Sheen mark
- The app icon reduced to a one-colour template: a back pane as a 1.5pt outline (-14°), a solid front pane (+8°) cut free of it by a 3pt clear gap, and a short round-capped glint in the front pane's upper-left that touches neither edge. 18pt in the menu bar (macOS tints it), and the white glyph of the Smart Scan sidebar tile. Never coloured, never with a value beside it.

### Menu bar panel
- The Midnight Indigo room at 340pt wide, natural height (never squeezed), cyan glow pool behind the header and the aurora band low behind the footer.
- Header: app icon 20pt, "Sheen" 15pt semibold, uptime in soft ink at the right. A full-width native segmented control: Health, Tips · n, Devices. All three tabs are laid out together and only one shows, so the panel never resizes.
- Health: a 2 × 2 grid of figure tiles in series colours (CPU Ember, Memory Cobalt, Disk Ultraviolet, Battery Emerald): 22pt tile, 13pt label, a rose state note at the right of the label row when past its threshold (short form when space runs out), 28pt light monospaced figure, 5pt bar in the series gradient (rose when alerted), one 11pt sub line. CPU and Memory open Optimization, Disk opens Space Map; hover lifts the tile. Below: ↓ / ↑ network and the protection state ("No threats found", or a rose link to Malware Removal).
- Tips: list-panel cards with the tile in the colour of the tool the action opens, and a compact 24pt pill naming the tool it opens. Devices: drives and displays as tile rows. Empty states use a 36pt tile and one plain sentence.
- Footer: the room's pill "Open Sheen" filling the row, and a quiet "Quit" that quits only the monitor.

### Hero object (signature)
- One original glass object per tool (22), composed on a 300 x 300pt stage inside a 320 x 330pt frame, scaled 0.5 to 1.25 by context. Built only from the glass primitives and the shape kit, lit by the shared light, layered at depths for parallax (front +1 with the pointer, back -1 against; 11pt x, 8pt y at full reach). Always decorative and hidden from VoiceOver.

### Progress ring (signature)
- 270pt ring, 10pt track (white 0.1 dark, mid 0.12 light), round-capped arc in an angular gradient tile bottom, tile top, spark, starting at 12 o'clock, eased 0.35s per update. The tool's hero sits inside at 0.6, having glided there from the intro (matched geometry, smooth 0.45s).

### Outcome marks
- **Result coin:** a 96pt section-glass coin (thickness 10) with a 40pt bold engraved symbol, heading every end state (done, nothing found, blocked).
- **Outcome hero:** the tool's object at rest (0.5) with a 52pt pearl coin carrying a 22pt symbol in the section's mid at its lower right.

### Motion
- Pointer response: interactive spring (response 0.55, damping 0.82); release back to rest: spring (0.9, 0.86). Ground light pool and aurora drift a few percent with the pointer.
- State changes: 0.1 to 0.35s ease-out. Intro to list (first use): 0.28s ease-out, crossfade with a 1.02 scale.
- Reduce Motion: no pointer tracking (the light stays at rest), transitions become plain crossfades.
- Only the visible tool receives the pointer; hidden tools never redraw on mouse movement.

## Do's and Don'ts

### Do:
- **Do** take every color on a tool screen from its section's world, including the control tint (tile bottom).
- **Do** build any new hero object from the glass primitives and shape kit, at 300 x 300pt, with pieces assigned depths, and hide it from VoiceOver.
- **Do** keep titles light weight (40 / 32 / 28pt) and reserve semibold for labels and the action.
- **Do** put exactly one capsule primary action on a tool screen: white with a section label in dark rooms, section gradient with a white label in light rooms.
- **Do** keep disabled actions readable (label at 0.62 white or 0.55 ink) on a quiet translucent pill.
- **Do** stop all pointer tracking under Reduce Motion and fall back to crossfades.
- **Do** write intro copy as a label plus one plain, true line per bullet, three bullets per tool.

### Don't:
- **Don't** paint a fixed highlight, gloss or shadow on glass that ignores the shared light, and don't tilt an object more than 8°.
- **Don't** mix two worlds' grounds on one screen, or tint shadows neutral black.
- **Don't** set tool titles in bold display type; the older bold welcome cards (30 and 34pt bold) are not part of this system.
- **Don't** ship raster artwork, and never reuse MacPaw's artwork, icons, illustrations or branding; every object is original and drawn in code.
- **Don't** wrap the room in an inset card or grey pane; the detail pane is the ground, full-bleed.
- **Don't** let animation hold up a scan, review or clean.
