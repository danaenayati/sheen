import SwiftUI

private struct CareHeroNamespaceKey: EnvironmentKey {
    static let defaultValue: Namespace.ID? = nil
}

extension EnvironmentValues {
    /// Lets a tool's hero glide from its intro into the progress ring.
    var careHeroNamespace: Namespace.ID? {
        get { self[CareHeroNamespaceKey.self] }
        set { self[CareHeroNamespaceKey.self] = newValue }
    }
}

extension View {
    @ViewBuilder
    func careHeroMatch(_ tool: SidebarItem, in namespace: Namespace.ID?) -> some View {
        if let namespace {
            matchedGeometryEffect(id: "care-hero-" + CareUsage.key(tool), in: namespace)
        } else {
            self
        }
    }
}

/// Scanning or cleaning in the tool's own room: its glass object held inside
/// a progress ring cut from the section gradient.
struct CareProgress: View {
    let tool: SidebarItem
    let progress: Double
    let phase: String
    var detail: String?
    @Environment(\.colorScheme) private var scheme
    @Environment(\.careHeroNamespace) private var heroSpace

    var body: some View {
        let world = tool.theme.world
        let ink: Color = scheme == .dark ? .white : world.ink
        VStack(spacing: 0) {
            Spacer(minLength: 24)
            ZStack {
                Circle()
                    .stroke(scheme == .dark ? Color.white.opacity(0.1) : world.mid.opacity(0.12), lineWidth: 10)
                Circle()
                    .trim(from: 0, to: max(min(progress, 1), 0.015))
                    .stroke(AngularGradient(colors: [world.tileBottom, world.tileTop, world.spark], center: .center,
                                            startAngle: .degrees(0), endAngle: .degrees(360 * max(progress, 0.05))),
                            style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .shadow(color: world.glow.opacity(scheme == .dark ? 0.55 : 0.3), radius: 10)
                    .animation(.easeOut(duration: 0.35), value: progress)
                CareHero(tool: tool, scale: 0.6)
                    .careHeroMatch(tool, in: heroSpace)
            }
            .frame(width: 270, height: 270)
            Text("\(Int((min(max(progress, 0), 1) * 100).rounded()))%")
                .font(.system(size: 34, weight: .light))
                .monospacedDigit()
                .contentTransition(.numericText())
                .animation(.easeOut(duration: 0.25), value: Int(progress * 100))
                .padding(.top, 26)
            Text(phase)
                .font(.system(size: 14))
                .foregroundStyle(ink.opacity(0.74))
                .lineLimit(1)
                .truncationMode(.middle)
                .frame(maxWidth: 420)
                .padding(.top, 6)
            if let detail {
                Text(detail)
                    .font(.system(size: 12))
                    .monospacedDigit()
                    .foregroundStyle(ink.opacity(0.62))
                    .padding(.top, 4)
            }
            Spacer(minLength: 24)
        }
        .foregroundStyle(ink)
        .frame(maxWidth: .infinity)
    }
}

/// The glass coin that heads every end state (done, nothing found, blocked).
struct CareResultMark: View {
    let symbol: String
    let world: CareWorld
    var tint: GlassTint?

    var body: some View {
        ZStack {
            GlassSlab(shape: Circle(), tint: tint ?? world.glass, thickness: 10)
                .frame(width: 96, height: 96)
            EngravedSymbol(name: symbol, size: 40, weight: .bold)
        }
        .frame(width: 112, height: 112)
        .drawingGroup()
        .accessibilityHidden(true)
    }
}

extension View {
    /// The room's pill under Glass Care, the original super-ellipse otherwise.
    @ViewBuilder
    func careOrSuperEllipse(_ care: Bool, world: CareWorld, gradient: LinearGradient, size: CGSize) -> some View {
        if care {
            buttonStyle(CareActionStyle(world: world))
        } else {
            buttonStyle(SuperEllipseButtonStyle(gradient: gradient, size: size))
        }
    }
}

/// The surface behind every list and results panel: the system material,
/// tinted with the room it sits in so the room carries through the list.
struct CarePanelFill: View {
    @AppStorage(NativeSkin.defaultsKey) private var nativeSkin = true
    @Environment(\.careTool) private var careTool
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        ZStack {
            Rectangle().fill(.ultraThinMaterial)
            if nativeSkin, let careTool {
                let world = careTool.theme.world
                Rectangle().fill(scheme == .dark ? world.deep.opacity(0.55) : world.paleTop.opacity(0.55))
            }
        }
    }
}

private struct CareTitleFont: ViewModifier {
    let fallback: Font
    @AppStorage(NativeSkin.defaultsKey) private var nativeSkin = true

    func body(content: Content) -> some View {
        if nativeSkin {
            content.font(.system(size: 28, weight: .light)).tracking(-0.3)
        } else {
            content.font(fallback)
        }
    }
}

extension View {
    /// A tool's screen title: the intro's light voice under Glass Care.
    func careTitleFont(_ fallback: Font) -> some View { modifier(CareTitleFont(fallback: fallback)) }
}

/// Heads a finished scan or clean: the tool's own object at rest, with a
/// glass coin carrying the outcome.
struct CareOutcomeHero: View {
    let tool: SidebarItem
    let symbol: String

    var body: some View {
        let world = tool.theme.world
        ZStack(alignment: .bottomTrailing) {
            CareHero(tool: tool, scale: 0.5)
            ZStack {
                GlassSlab(shape: Circle(), tint: world.pearl, thickness: 6)
                    .frame(width: 52, height: 52)
                EngravedSymbol(name: symbol, size: 22, color: world.mid, weight: .bold)
            }
            .frame(width: 60, height: 60)
            .drawingGroup()
            .offset(x: -14, y: -14)
        }
        .accessibilityHidden(true)
    }
}
