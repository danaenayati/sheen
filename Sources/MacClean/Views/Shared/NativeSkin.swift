import SwiftUI
import AppKit
import MacCleanKit

enum NativeSkin {
    static let defaultsKey = "nativeMacSkin"
    static var isEnabled: Bool { UserDefaults.standard.object(forKey: defaultsKey) as? Bool ?? true }
}

/// Every tool in reach, grouped by section. The sidebar takes on the colour
/// of the room you are in, so the window reads as one place.
struct CareSidebar: View {
    @Binding var selection: SidebarItem?
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let world = (selection ?? .smartScan).theme.world
        let ink: Color = scheme == .dark ? .white : world.ink
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 9) {
                Image(systemName: "sparkles")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(LinearGradient(colors: [Color(careHex: 0x9AE8FF), Color(careHex: 0x37C8FF)], startPoint: .top, endPoint: .bottom))
                Text("Sheen").font(.system(size: 17, weight: .semibold)).foregroundStyle(ink)
            }
            .padding(.horizontal, 20).padding(.top, 44).padding(.bottom, 14)
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 1) {
                        ForEach(SidebarSection.allCases) { section in
                            if section != .main {
                                Text(section.title)
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundStyle(ink.opacity(0.5))
                                    .padding(.horizontal, 10)
                                    .padding(.top, 12).padding(.bottom, 3)
                                    .accessibilityAddTraits(.isHeader)
                            }
                            ForEach(section.items) { item in
                                CareSidebarRow(item: item, ink: ink, selection: $selection).id(item)
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 12)
                }
                .scrollIndicators(.never)
                .onChange(of: selection) { _, item in
                    guard let item, item != .settings else { return }
                    withAnimation(.easeOut(duration: 0.3)) { proxy.scrollTo(item) }
                }
            }
            Divider().overlay(ink.opacity(0.08))
            CareSidebarRow(item: .settings, ink: ink, selection: $selection).padding(10)
        }
        .background {
            ZStack {
                CareVibrancy(dark: scheme == .dark)
                Rectangle().fill(scheme == .dark ? world.deep.opacity(0.5) : world.paleTop.opacity(0.42))
                    .animation(.easeOut(duration: 0.35), value: selection)
            }
            .ignoresSafeArea()
        }
    }
}

/// The real macOS sidebar material, so the window behind shows through.
private struct CareVibrancy: NSViewRepresentable {
    let dark: Bool

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = .sidebar
        view.blendingMode = .behindWindow
        view.state = .followsWindowActiveState
        return view
    }

    func updateNSView(_ view: NSVisualEffectView, context: Context) {
        view.appearance = NSAppearance(named: dark ? .vibrantDark : .vibrantLight)
    }
}

private struct CareSidebarRow: View {
    let item: SidebarItem
    let ink: Color
    @Binding var selection: SidebarItem?
    @State private var hovering = false

    var body: some View {
        let selected = selection == item
        Button { selection = item } label: {
            HStack(spacing: 10) {
                CareTile(symbol: item.careSymbol, world: item.theme.world, size: 24)
                Text(item.title)
                    .font(.system(size: 13, weight: selected ? .semibold : .regular))
                    .foregroundStyle(ink.opacity(selected ? 1 : 0.8))
                    .lineLimit(1)
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 8).padding(.vertical, 5)
            .background(ink.opacity(selected ? 0.13 : (hovering ? 0.06 : 0)), in: RoundedRectangle(cornerRadius: 9, style: .continuous))
            .contentShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
        }
        .buttonStyle(.plain)
        .onHover { hovering = $0 }
        .animation(.easeOut(duration: 0.15), value: hovering)
        .accessibilityAddTraits(selected ? [.isSelected] : [])
    }
}

extension SidebarItem {
    /// The filled symbol each tool shows on its sidebar tile.
    var careSymbol: String {
        switch self {
        case .smartScan: "sparkles"
        case .systemJunk: "bubbles.and.sparkles.fill"
        case .mailAttachments: "paperclip"
        case .trashBins: "trash.fill"
        case .diskHogs: "shippingbox.fill"
        case .projectJunk: "hammer.fill"
        case .cleanHistory: "clock.arrow.circlepath"
        case .malwareRemoval: "ladybug.fill"
        case .privacy: "hand.raised.fill"
        case .browserExtensions: "puzzlepiece.extension.fill"
        case .wifiNetworks: "wifi"
        case .appPermissions: "lock.fill"
        case .optimization: "gauge.with.dots.needle.67percent"
        case .maintenance: "wrench.and.screwdriver.fill"
        case .uninstaller: "xmark.app.fill"
        case .unusedApps: "moon.zzz.fill"
        case .extensions: "powerplug.fill"
        case .updater: "arrow.triangle.2.circlepath"
        case .spaceLens: "chart.pie.fill"
        case .largeOldFiles: "doc.fill"
        case .duplicates: "square.on.square.fill"
        case .shredder: "scissors"
        case .settings: "gearshape.fill"
        }
    }
}

extension Color {
    init(careHex: UInt32) {
        self.init(red: Double((careHex >> 16) & 255) / 255,
                  green: Double((careHex >> 8) & 255) / 255,
                  blue: Double(careHex & 255) / 255)
    }
}
