# Product

<!-- impeccable:product-schema 1 -->

## Platform

macos

## Users
People who keep a Mac tidy without paying for a subscription. They mostly go straight to one specific tool (Uninstaller, Space Map, Large & Old Files, Malware Removal and so on) rather than running the one-click Smart Scan, so every tool must stand on its own as a complete, inviting screen. The build will be released publicly, so the screens must be clear to people who are not technical.

## Product Purpose
A free, open-source Mac cleaner, optimizer and malware scanner: Sheen (github.com/danaenayati/sheen, BSD-3-Clause) grew out of an open-source BSD-3 cleaner whose cleaning engine it keeps, with an interface redesigned to be more modern than CleanMyMac. Success: someone who knows CleanMyMac opens any tool and finds it at least as inviting and clear, and better in motion and craft.

## Positioning
The whole CleanMyMac toolkit (22 tools across Cleanup, Protection, Performance, Applications and Files, plus a menu-bar widget) with no subscription, no telemetry, and every line open to read. Trash-first deletion with a protected-paths guard: it is built never to lose data.

## Operating Context
Opened now and then, for a few minutes, usually to do one job: remove an app, find what is filling the disk, check for malware, clear junk. Each tool follows the same ritual: introduction, scan, review results with selection, clean, done summary. Some tools act without a scan (Uninstaller and Clean History list items directly; Shredder takes dropped files). Some scans need Full Disk Access, which the user grants in System Settings.

## Capabilities and Constraints
- Native macOS app, Swift 6 + SwiftUI, macOS 14 or newer; releases are Apple Silicon (Command Line Tools cannot link Intel; Intel needs Xcode). Started from the upstream project's v1.28.0 plus the Glass Care theme patch.
- Built with Command Line Tools only (macOS 26 SDK pinned, binaries restamped with vtool, ad-hoc signed). No Apple Developer account, so public builds are not notarized: the app must not claim "Apple-notarized".
- The cleaning, scanning and safety code is upstream's and stays untouched; the redesign lives in the view layer, kept in shared components so upstream updates merge cleanly.
- UI language: English. Upstream also ships Chinese and Russian strings through `L10n.tr(zh, en, ru)`; whether the redesign's new copy gets those translations is undecided.
- Name: Sheen (chosen 2026-11-07). The upstream project's name appears only in LICENSE and one credit line: BSD-3 forbids using upstream contributors' names to endorse or promote Sheen.

## Brand Commitments
- Sits alongside CleanMyMac (the user's explicit reference, 2026-11-06): each section in its own drenched color world, a large glossy hero object, big light title and subtitle, a bulleted list of what the tool does (rounded gradient icon tile + bold label), and hero elements that move with the mouse. The bar is "like CleanMyMac but better".
- Never reuse MacPaw's artwork, icons, illustrations, product names or branding; every illustration is original.
- Keep upstream's BSD-3-Clause notice in LICENSE and a factual credit line in the README; never use the upstream name in product UI or promotion.

## Evidence on Hand
- The 22 tools and their real behavior in Sources/MacClean (Views, Modules) and the upstream README feature list.
- No telemetry, ads or subscriptions (true of this build too).
- No screenshots, testimonials, download counts or reviews of this build exist; upstream's "100,000+ downloads" and "Apple-notarized" belong to upstream and must not be claimed for this build.

## Product Principles
1. Every tool is a front door: its first screen says what it finds and what happens next, in plain words.
2. Show what will be removed before anything is removed; delight never hides a consequence.
3. Craft and motion earn trust, but the task always wins: no animation delays a scan, a review or a clean.
4. Honest about this build: no borrowed claims, no borrowed artwork.

## Accessibility & Inclusion
Pointer-driven tilt and parallax must stop under Reduce Motion. White text on saturated grounds must keep readable contrast. Every hero illustration is decorative and hidden from VoiceOver; every bullet reads as plain text.
