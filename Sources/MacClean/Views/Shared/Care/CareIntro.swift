import SwiftUI
import MacCleanKit

/// Remembers which tools have been used, so their intro can step aside.
enum CareUsage {
    static let defaultsKey = "careUsedTools"

    static func key(_ tool: SidebarItem) -> String { String(describing: tool) }

    static func wasUsed(_ tool: SidebarItem, in stored: String) -> Bool {
        stored.split(separator: ",").contains(Substring(key(tool)))
    }

    static func marking(_ tool: SidebarItem, in stored: String) -> String {
        wasUsed(tool, in: stored) ? stored : (stored.isEmpty ? key(tool) : stored + "," + key(tool))
    }
}

private struct CareToolKey: EnvironmentKey {
    nonisolated(unsafe) static let defaultValue: SidebarItem? = nil
}

private struct CareStaticRenderKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    /// Set by offscreen renderers (README images), which cannot draw a scroll view.
    var careStaticRender: Bool {
        get { self[CareStaticRenderKey.self] }
        set { self[CareStaticRenderKey.self] = newValue }
    }

    /// The tool whose screen this view belongs to (set per module in ContentView).
    var careTool: SidebarItem? {
        get { self[CareToolKey.self] }
        set { self[CareToolKey.self] = newValue }
    }
}

/// A tool's front door: its glass object, what it finds, and one action.
/// Full size on first visit; compact once the tool has been used.
struct CareIntro: View {
    let tool: SidebarItem
    let action: () -> Void
    @AppStorage(CareUsage.defaultsKey) private var usedTools = ""
    @Environment(\.colorScheme) private var scheme
    @Environment(\.careHeroNamespace) private var heroSpace
    @Environment(\.careStaticRender) private var staticRender

    var body: some View {
        GeometryReader { geometry in
            if staticRender {
                layout(in: geometry.size)
            } else {
                ScrollView { layout(in: geometry.size) }
                    .scrollBounceBehavior(.basedOnSize)
            }
        }
        .foregroundStyle(ink)
    }

    private func layout(in size: CGSize) -> some View {
        let copy = CareCopy.of(tool)
        let compact = CareUsage.wasUsed(tool, in: usedTools)
        return Group {
            if compact {
                compactLayout(copy, wide: size.width >= 640)
            } else if size.width >= 660 {
                // The object takes whatever the text column leaves,
                // so it stays the subject of the room at every width.
                let column: CGFloat = size.width >= 980 ? 430 : 370
                let gap: CGFloat = size.width >= 980 ? 44 : 28
                let scale = min(max((size.width - 88 - gap - column) / 320, 0.8), 1.25)
                HStack(spacing: gap) {
                    CareHero(tool: tool, scale: scale).careHeroMatch(tool, in: heroSpace)
                    details(copy).frame(maxWidth: column, alignment: .leading)
                }
            } else {
                VStack(spacing: 24) {
                    CareHero(tool: tool, scale: 0.78).careHeroMatch(tool, in: heroSpace)
                    details(copy).frame(maxWidth: 460, alignment: .leading)
                }
            }
        }
        .padding(.horizontal, 44)
        .padding(.top, 52)
        .padding(.bottom, 32)
        .frame(maxWidth: .infinity, minHeight: size.height)
    }

    private var ink: Color { scheme == .dark ? .white : tool.theme.world.ink }
    private var softInk: Color { ink.opacity(scheme == .dark ? 0.74 : 0.76) }

    private func details(_ copy: CareCopy) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(copy.title)
                .font(.system(size: 40, weight: .light))
                .tracking(-0.6)
                .accessibilityAddTraits(.isHeader)
            Text(copy.subtitle)
                .font(.system(size: 16))
                .foregroundStyle(softInk)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 10)
            VStack(alignment: .leading, spacing: 18) {
                ForEach(copy.points, id: \.label) { point in
                    pointRow(point)
                }
            }
            .padding(.top, 30)
            CareActionButton(title: copy.action, world: tool.theme.world, action: press)
                .padding(.top, 34)
            if let note = copy.note {
                Label(note, systemImage: "info.circle")
                    .font(.system(size: 12))
                    .foregroundStyle(softInk)
                    .padding(.top, 14)
            }
        }
    }

    private func pointRow(_ point: CareCopy.Point) -> some View {
        HStack(alignment: .top, spacing: 14) {
            CareTile(symbol: point.symbol, world: tool.theme.world, size: 36)
            VStack(alignment: .leading, spacing: 3) {
                Text(point.label).font(.system(size: 15, weight: .semibold))
                Text(point.detail)
                    .font(.system(size: 13))
                    .foregroundStyle(softInk)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .combine)
    }

    private func compactLayout(_ copy: CareCopy, wide: Bool) -> some View {
        let layout = wide ? AnyLayout(HStackLayout(spacing: 30)) : AnyLayout(VStackLayout(spacing: 18))
        return layout {
            CareHero(tool: tool, scale: 0.56).careHeroMatch(tool, in: heroSpace)
            VStack(alignment: .leading, spacing: 0) {
                Text(copy.title)
                    .font(.system(size: 32, weight: .light))
                    .tracking(-0.4)
                    .accessibilityAddTraits(.isHeader)
                Text(copy.subtitle)
                    .font(.system(size: 14))
                    .foregroundStyle(softInk)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 6)
                CareActionButton(title: copy.action, world: tool.theme.world, action: press)
                    .padding(.top, 20)
                HStack(spacing: 16) {
                    ForEach(copy.points, id: \.label) { point in
                        HStack(spacing: 7) {
                            CareTile(symbol: point.symbol, world: tool.theme.world, size: 22)
                            Text(point.label).font(.system(size: 12, weight: .medium)).foregroundStyle(softInk)
                        }
                    }
                }
                .padding(.top, 22)
            }
            .frame(maxWidth: 520, alignment: .leading)
        }
    }

    private func press() {
        usedTools = CareUsage.marking(tool, in: usedTools)
        action()
    }
}

/// A rounded tile in the section gradient carrying a white symbol: the
/// bullet of every tool intro.
struct CareTile: View {
    let symbol: String
    let world: CareWorld
    var size: CGFloat = 36

    var body: some View {
        RoundedRectangle(cornerRadius: size * 0.28, style: .continuous)
            .fill(world.tileGradient)
            .overlay {
                RoundedRectangle(cornerRadius: size * 0.28, style: .continuous)
                    .fill(LinearGradient(colors: [.white.opacity(0.38), .white.opacity(0)], startPoint: .top, endPoint: .center))
            }
            .overlay {
                RoundedRectangle(cornerRadius: size * 0.28, style: .continuous)
                    .strokeBorder(.white.opacity(0.32), lineWidth: 0.75)
            }
            .overlay {
                Image(systemName: symbol)
                    .font(.system(size: size * 0.44, weight: .semibold))
                    .foregroundStyle(.white)
                    .shadow(color: world.deep.opacity(0.35), radius: 1, y: 1)
            }
            .frame(width: size, height: size)
            .shadow(color: world.deep.opacity(0.28), radius: 6, y: 3)
            .accessibilityHidden(true)
    }
}

/// The primary action on every tool screen: a white pill in dark rooms, the
/// section's own gradient in light ones.
struct CareActionButton: View {
    let title: String
    let world: CareWorld
    var systemImage: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let systemImage { Image(systemName: systemImage) }
                Text(title)
            }
        }
        .buttonStyle(CareActionStyle(world: world))
    }
}

struct CareActionStyle: ButtonStyle {
    let world: CareWorld

    func makeBody(configuration: Configuration) -> some View {
        CareActionFace(configuration: configuration, world: world)
    }
}

private struct CareActionFace: View {
    let configuration: ButtonStyleConfiguration
    let world: CareWorld
    @Environment(\.colorScheme) private var scheme
    @Environment(\.isEnabled) private var isEnabled
    @State private var hovering = false

    var body: some View {
        let dark = scheme == .dark
        configuration.label
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(labelColor(dark: dark))
            .padding(.horizontal, 30)
            .frame(minWidth: 150, minHeight: 46)
            .background { Capsule().fill(fill(dark: dark)) }
            .overlay { Capsule().strokeBorder(.white.opacity(dark ? 0 : 0.28), lineWidth: 1) }
            .shadow(color: world.deep.opacity(dark ? 0.5 : 0.28), radius: hovering ? 16 : 10, y: hovering ? 8 : 5)
            .brightness(configuration.isPressed ? -0.06 : (hovering ? 0.03 : 0))
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .contentShape(Capsule())
            .onHover { hovering = $0 }
            .animation(.easeOut(duration: 0.16), value: hovering)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }

    /// Disabled keeps a readable label on a quiet glass pill rather than
    /// fading the whole button into the room.
    private func labelColor(dark: Bool) -> Color {
        if !isEnabled { return dark ? .white.opacity(0.62) : world.ink.opacity(0.55) }
        return dark ? world.mid.mix(world.deep, 0.25) : .white
    }

    private func fill(dark: Bool) -> AnyShapeStyle {
        if !isEnabled { return AnyShapeStyle(dark ? Color.white.opacity(0.14) : world.mid.opacity(0.14)) }
        return dark
            ? AnyShapeStyle(LinearGradient(colors: [.white, .white.opacity(0.88)], startPoint: .top, endPoint: .bottom))
            : AnyShapeStyle(LinearGradient(colors: [world.mid.mix(.white, 0.12), world.mid.mix(world.deep, 0.3)],
                                           startPoint: .top, endPoint: .bottom))
    }
}

/// For tools that open straight onto a list: shows the intro until the tool
/// has been used once, keeping the list alive underneath so it loads early.
struct CareIntroGate<Content: View>: View {
    let tool: SidebarItem
    @ViewBuilder let content: Content
    @AppStorage(CareUsage.defaultsKey) private var usedTools = ""
    @AppStorage(NativeSkin.defaultsKey) private var nativeSkin = true
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        let showIntro = nativeSkin && !CareUsage.wasUsed(tool, in: usedTools)
        ZStack {
            content
                .opacity(showIntro ? 0 : 1)
                .allowsHitTesting(!showIntro)
                .accessibilityHidden(showIntro)
            if showIntro {
                CareIntro(tool: tool) {}
                    .transition(reduceMotion ? .opacity : .opacity.combined(with: .scale(scale: 1.02)))
            }
        }
        .animation(.easeOut(duration: 0.28), value: showIntro)
    }
}
