import Foundation
import CoreServices
import MacCleanKit

/// Lists what sits in ~/Downloads and has not been opened for a while: the
/// installers, archives and documents people download once and forget.
/// Each top-level entry (file or folder) is one item; folders count their
/// whole size. Nothing is preselected.
public struct ForgottenDownloadsModule: ScanModule {
    public let id = "forgotten_downloads"
    public var name: String { L10n.tr("被遗忘的下载", "Forgotten Downloads", "Забытые загрузки") }
    public let category = ModuleCategory.files
    // Your own files, not junk: never part of Smart Scan's total.
    public let includedInSmartScan = false

    private let idleThreshold: TimeInterval
    private let folder: URL

    public init(idleThreshold: TimeInterval = 30 * 24 * 3600, folder: URL = MCConstants.downloads) {
        self.idleThreshold = idleThreshold
        self.folder = folder
    }

    public func scan() async -> [ScanResult] {
        let keys: [URLResourceKey] = [.isDirectoryKey, .isSymbolicLinkKey, .isPackageKey, .addedToDirectoryDateKey,
                                      .creationDateKey, .contentModificationDateKey, .totalFileAllocatedSizeKey, .fileSizeKey]
        guard let entries = try? FileManager.default.contentsOfDirectory(
            at: folder, includingPropertiesForKeys: keys, options: [.skipsHiddenFiles]) else { return [] }

        var items: [FileItem] = []
        for url in entries where !Self.isInProgress(url) {
            guard let values = try? url.resourceValues(forKeys: Set(keys)), values.isSymbolicLink != true else { continue }
            let lastUsed = Self.lastUsedDate(url) ?? values.addedToDirectoryDate ?? values.creationDate
            guard Self.isForgotten(lastUsed: lastUsed, threshold: idleThreshold) else { continue }
            let isFolder = values.isDirectory == true
            let size = isFolder ? Self.folderSize(url) : UInt64(values.totalFileAllocatedSize ?? values.fileSize ?? 0)
            items.append(FileItem(url: url, name: url.lastPathComponent, size: size, allocatedSize: size,
                                  isDirectory: isFolder, isPackage: values.isPackage == true,
                                  creationDate: values.creationDate, modificationDate: values.contentModificationDate,
                                  lastAccessDate: lastUsed))
        }
        return Self.makeResults(items).filteringUncleanable()
    }

    /// Pure result builder: biggest first, never preselected. Shown under
    /// the Old Files category, whose wording and safety note fit exactly.
    internal static func makeResults(_ items: [FileItem]) -> [ScanResult] {
        guard !items.isEmpty else { return [] }
        return [ScanResult(category: .oldFiles, items: items.sorted { $0.size > $1.size }, autoSelect: false)]
    }

    /// An item is forgotten when it was last opened (or, never opened, last
    /// arrived) before the threshold. Unknown dates are never flagged.
    internal static func isForgotten(lastUsed: Date?, threshold: TimeInterval, now: Date = Date()) -> Bool {
        guard let lastUsed else { return false }
        return lastUsed < now.addingTimeInterval(-threshold)
    }

    /// Unfinished browser downloads belong to System Junk, not here.
    internal static func isInProgress(_ url: URL) -> Bool {
        ["download", "crdownload", "part", "partial", "opdownload"].contains(url.pathExtension.lowercased())
    }

    /// When macOS last saw the item opened (Spotlight's kMDItemLastUsedDate).
    private static func lastUsedDate(_ url: URL) -> Date? {
        guard let item = MDItemCreateWithURL(kCFAllocatorDefault, url as CFURL) else { return nil }
        return MDItemCopyAttribute(item, kMDItemLastUsedDate) as? Date
    }

    private static func folderSize(_ url: URL) -> UInt64 {
        guard let enumerator = FileManager.default.enumerator(
            at: url, includingPropertiesForKeys: [.totalFileAllocatedSizeKey, .isSymbolicLinkKey], options: []) else { return 0 }
        var total: UInt64 = 0
        for case let file as URL in enumerator {
            guard let values = try? file.resourceValues(forKeys: [.totalFileAllocatedSizeKey, .isSymbolicLinkKey]),
                  values.isSymbolicLink != true else { continue }
            total += UInt64(values.totalFileAllocatedSize ?? 0)
        }
        return total
    }
}
