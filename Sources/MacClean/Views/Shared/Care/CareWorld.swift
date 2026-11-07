import SwiftUI
import MacCleanKit

/// One section's color world: the drenched ground behind every screen of the
/// section, the gradient its icon tiles and buttons share, and the glass tints
/// its hero objects are cut from. Dark appearance is a deep two-hue room with a
/// light pool; light appearance is the same hue, luminous.
struct CareWorld {
    let deep: Color
    let mid: Color
    let glow: Color
    let paleTop: Color
    let paleBottom: Color
    let ink: Color
    let tileTop: Color
    let tileBottom: Color
    /// A second hue the hero objects use for accent pieces.
    let spark: Color

    var tileGradient: LinearGradient {
        LinearGradient(colors: [tileTop, tileBottom], startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    var glass: GlassTint { GlassTint(top: tileTop, bottom: tileBottom, edge: deep) }
    var sparkGlass: GlassTint { GlassTint(top: spark.mix(.white, 0.35), bottom: spark, edge: deep) }
    var clearGlass: GlassTint { .clear(edge: deep, hue: glow) }
    /// Milky white glass with a breath of the spark hue, for the hero's lead piece.
    var pearl: GlassTint { GlassTint(top: .white, bottom: spark.mix(.white, 0.62), edge: mid) }
}

extension ModuleTheme {
    var world: CareWorld {
        switch self {
        case .smartScan:
            CareWorld(deep: Color(careHex: 0x0B0A2E), mid: Color(careHex: 0x2B2384), glow: Color(careHex: 0x37C8FF),
                      paleTop: Color(careHex: 0xE9EBFF), paleBottom: Color(careHex: 0xCFEFFF), ink: Color(careHex: 0x1A1660),
                      tileTop: Color(careHex: 0x7E6BFF), tileBottom: Color(careHex: 0x22B5F5), spark: Color(careHex: 0x5BE3FF))
        case .cleanup:
            CareWorld(deep: Color(careHex: 0x04241D), mid: Color(careHex: 0x0C6A55), glow: Color(careHex: 0x3BF0A8),
                      paleTop: Color(careHex: 0xE5FBF2), paleBottom: Color(careHex: 0xC2F1DF), ink: Color(careHex: 0x07402F),
                      tileTop: Color(careHex: 0x45E8B0), tileBottom: Color(careHex: 0x0A9A7B), spark: Color(careHex: 0xC8F25A))
        case .protection:
            CareWorld(deep: Color(careHex: 0x2A0619), mid: Color(careHex: 0x8C1846), glow: Color(careHex: 0xFF5C8A),
                      paleTop: Color(careHex: 0xFFEAF0), paleBottom: Color(careHex: 0xFFD3DF), ink: Color(careHex: 0x5E0B2D),
                      tileTop: Color(careHex: 0xFF7B9C), tileBottom: Color(careHex: 0xC71A5A), spark: Color(careHex: 0xFFB36B))
        case .performance:
            CareWorld(deep: Color(careHex: 0x2B1003), mid: Color(careHex: 0x983A0B), glow: Color(careHex: 0xFFB23F),
                      paleTop: Color(careHex: 0xFFF2E1), paleBottom: Color(careHex: 0xFFDDB8), ink: Color(careHex: 0x5C2306),
                      tileTop: Color(careHex: 0xFFC54D), tileBottom: Color(careHex: 0xF0561A), spark: Color(careHex: 0xFF7A59))
        case .applications:
            CareWorld(deep: Color(careHex: 0x05163A), mid: Color(careHex: 0x1546B6), glow: Color(careHex: 0x52A8FF),
                      paleTop: Color(careHex: 0xE6F0FF), paleBottom: Color(careHex: 0xC9DEFF), ink: Color(careHex: 0x0B2B73),
                      tileTop: Color(careHex: 0x62BCFF), tileBottom: Color(careHex: 0x2F57F5), spark: Color(careHex: 0x7CF0FF))
        case .files:
            CareWorld(deep: Color(careHex: 0x1A0939), mid: Color(careHex: 0x5A21B4), glow: Color(careHex: 0xC57EFF),
                      paleTop: Color(careHex: 0xF3EAFF), paleBottom: Color(careHex: 0xE0CCFF), ink: Color(careHex: 0x3A0F7A),
                      tileTop: Color(careHex: 0xCB8EFF), tileBottom: Color(careHex: 0x7434E6), spark: Color(careHex: 0xFF8AD8))
        case .settings:
            CareWorld(deep: Color(careHex: 0x111419), mid: Color(careHex: 0x2C3340), glow: Color(careHex: 0x8FA6C4),
                      paleTop: Color(careHex: 0xF1F3F7), paleBottom: Color(careHex: 0xE1E6EE), ink: Color(careHex: 0x1E2430),
                      tileTop: Color(careHex: 0x9AA9BF), tileBottom: Color(careHex: 0x56637A), spark: Color(careHex: 0xB9C7DB))
        }
    }
}

// MARK: - Ground

/// The section's room. Its light pool sits behind the hero object and drifts a
/// little with the pointer, so the whole room answers the same light.
struct CareGround: View {
    let theme: ModuleTheme
    @Environment(\.colorScheme) private var scheme
    @Environment(CarePointer.self) private var pointer: CarePointer?

    var body: some View {
        let world = theme.world
        let drift = pointer?.point ?? .zero
        let pool = UnitPoint(x: 0.28 + drift.x * 0.04, y: 0.46 + drift.y * 0.04)
        ZStack {
            if scheme == .dark {
                LinearGradient(colors: [world.deep, world.mid.mix(world.deep, 0.35), world.deep],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                RadialGradient(colors: [world.glow.opacity(0.42), world.mid.opacity(0.18), .clear],
                               center: pool, startRadius: 10, endRadius: 520)
                RadialGradient(colors: [world.mid.opacity(0.55), .clear],
                               center: UnitPoint(x: 0.92, y: 0.05), startRadius: 0, endRadius: 420)
                if theme == .smartScan { aurora(world, strength: 0.5, drift: drift) }
            } else {
                LinearGradient(colors: [world.paleTop, world.paleBottom],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                RadialGradient(colors: [world.glow.opacity(0.38), world.glow.opacity(0.10), .clear],
                               center: pool, startRadius: 10, endRadius: 520)
                RadialGradient(colors: [.white.opacity(0.65), .clear],
                               center: UnitPoint(x: 0.9, y: 0.0), startRadius: 0, endRadius: 380)
                if theme == .smartScan { aurora(world, strength: 0.32, drift: drift) }
            }
        }
        .accessibilityHidden(true)
    }

    /// Smart Scan's signature light: a long cyan band low across the room.
    private func aurora(_ world: CareWorld, strength: Double, drift: CGPoint) -> some View {
        GeometryReader { geometry in
            Ellipse()
                .fill(RadialGradient(colors: [world.spark.opacity(strength), world.glow.opacity(strength * 0.4), .clear],
                                     center: .center, startRadius: 0, endRadius: geometry.size.width * 0.45))
                .frame(width: geometry.size.width * 1.1, height: geometry.size.height * 0.42)
                .rotationEffect(.degrees(-12))
                .position(x: geometry.size.width * (0.42 + drift.x * 0.03), y: geometry.size.height * (0.72 + drift.y * 0.02))
                .blur(radius: 30)
        }
    }
}

// MARK: - Pointer light

/// Where the pointer is over the detail pane, normalised to -1...1 on both
/// axes (0 is the centre). Glass objects read it as their light source.
@MainActor @Observable
final class CarePointer {
    var point: CGPoint = .zero
}

private struct CarePointerTracking: ViewModifier {
    let pointer: CarePointer
    @State private var size: CGSize = .zero
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        content
            .onGeometryChange(for: CGSize.self) { $0.size } action: { size = $0 }
            .onContinuousHover(coordinateSpace: .local) { phase in
                track(phase, in: size)
            }
    }

    private func track(_ phase: HoverPhase, in size: CGSize) {
        guard !reduceMotion, size.width > 0, size.height > 0 else { return }
        switch phase {
        case .active(let location):
            let target = CGPoint(x: (location.x / size.width) * 2 - 1, y: (location.y / size.height) * 2 - 1)
            withAnimation(.interactiveSpring(response: 0.55, dampingFraction: 0.82)) {
                pointer.point = target
            }
        case .ended:
            withAnimation(.spring(response: 0.9, dampingFraction: 0.86)) {
                pointer.point = .zero
            }
        }
    }
}

extension View {
    /// Tracks the pointer over this view into `pointer`. Hand the pointer
    /// only to the views that should answer it (the visible tool), so hidden
    /// tools never redraw on mouse moves.
    func carePointerTracking(_ pointer: CarePointer) -> some View { modifier(CarePointerTracking(pointer: pointer)) }
}

// MARK: - Color mixing

extension Color {
    /// Linear blend in sRGB, `amount` of `other`.
    func mix(_ other: Color, _ amount: Double) -> Color {
        let a = NSColor(self).usingColorSpace(.sRGB) ?? .black
        let b = NSColor(other).usingColorSpace(.sRGB) ?? .black
        let t = CGFloat(amount)
        return Color(red: Double(a.redComponent + (b.redComponent - a.redComponent) * t),
                     green: Double(a.greenComponent + (b.greenComponent - a.greenComponent) * t),
                     blue: Double(a.blueComponent + (b.blueComponent - a.blueComponent) * t),
                     opacity: Double(a.alphaComponent + (b.alphaComponent - a.alphaComponent) * t))
    }
}
