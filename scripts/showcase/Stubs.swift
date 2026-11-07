// Minimal stand-ins for the app types Sheen's Care views reference, so the
// real view files compile on their own for offscreen rendering.
import SwiftUI

enum SidebarItem: String, CaseIterable, Hashable {
    case smartScan, systemJunk, mailAttachments, trashBins, diskHogs, projectJunk, cleanHistory
    case malwareRemoval, privacy, browserExtensions, wifiNetworks, appPermissions
    case optimization, maintenance, uninstaller, unusedApps, extensions, updater
    case spaceLens, largeOldFiles, duplicates, shredder, forgottenDownloads, settings

    var theme: ModuleTheme {
        switch self {
        case .smartScan: .smartScan
        case .systemJunk, .mailAttachments, .trashBins, .projectJunk, .diskHogs, .cleanHistory: .cleanup
        case .malwareRemoval, .privacy, .browserExtensions, .wifiNetworks, .appPermissions: .protection
        case .optimization, .maintenance: .performance
        case .uninstaller, .unusedApps, .extensions, .updater: .applications
        case .spaceLens, .largeOldFiles, .duplicates, .shredder, .forgottenDownloads: .files
        case .settings: .settings
        }
    }
}

enum ModuleTheme { case smartScan, cleanup, protection, performance, applications, files, settings }

enum NativeSkin { static let defaultsKey = "nativeMacSkin" }

extension Color {
    init(careHex: UInt32) {
        self.init(red: Double((careHex >> 16) & 255) / 255, green: Double((careHex >> 8) & 255) / 255,
                  blue: Double(careHex & 255) / 255)
    }
}

struct SuperEllipseButtonStyle: ButtonStyle {
    init(gradient: LinearGradient, size: CGSize) {}
    func makeBody(configuration: Configuration) -> some View { configuration.label }
}
