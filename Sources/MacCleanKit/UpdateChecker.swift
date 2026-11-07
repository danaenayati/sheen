import Foundation

/// Manual "Check for updates" against the GitHub Releases API.
///
/// Pure logic (semver compare, JSON parsing, Homebrew detection) is static
/// and unit-tested with fixtures; `check(...)` is the only networked entry
/// point and is never called at launch, only from the Settings button.
public enum UpdateChecker {
    public enum CheckResult: Equatable, Sendable {
        case upToDate
        case updateAvailable(version: String, url: URL)
        case failed(message: String)
    }

    /// Subset of the GitHub "latest release" payload we use.
    private struct LatestRelease: Decodable {
        let tag_name: String
        let html_url: String
    }

    /// Parse the latest-release JSON into (version without "v" prefix,
    /// release page URL). Returns nil for malformed payloads.
    public static func parseLatestRelease(_ data: Data) -> (version: String, url: URL)? {
        guard let release = try? JSONDecoder().decode(LatestRelease.self, from: data),
              let url = URL(string: release.html_url) else { return nil }
        var version = release.tag_name
        if version.hasPrefix("v") { version.removeFirst() }
        guard !version.isEmpty else { return nil }
        return (version, url)
    }

    /// Numeric component comparison: "1.10.0" is newer than "1.9.0".
    /// Missing components pad as 0; non-numeric components read as 0, so a
    /// garbage tag never reports itself as an update.
    public static func isNewer(_ candidate: String, than current: String) -> Bool {
        let lhs = candidate.split(separator: ".").map { Int($0) ?? 0 }
        let rhs = current.split(separator: ".").map { Int($0) ?? 0 }
        for i in 0..<max(lhs.count, rhs.count) {
            let l = i < lhs.count ? lhs[i] : 0
            let r = i < rhs.count ? rhs[i] : 0
            if l != r { return l > r }
        }
        return false
    }

    /// Select the version that can be compared with
    /// `CFBundleShortVersionString`. Sparkle's short version is the marketing
    /// version; `sparkle:version` is only a fallback when no short version is
    /// available anywhere in the appcast.
    public static func preferredAppcastVersion(
        shortVersion: String?,
        buildVersion: String?
    ) -> String? {
        shortVersion ?? buildVersion
    }

    /// Caskroom locations for Apple Silicon and Intel Homebrew prefixes.
    public static let defaultCaskroomPaths = [
        "/opt/homebrew/Caskroom/sheen",
        "/usr/local/Caskroom/sheen",
    ]

    /// True when the app was installed via the Homebrew cask. The Settings
    /// UI then shows `brew upgrade --cask sheen` instead of a DMG link,
    /// so brew's receipt and the installed app never drift.
    public static func isHomebrewInstall(
        caskroomPaths: [String] = defaultCaskroomPaths,
        fileManager: FileManager = .default
    ) -> Bool {
        caskroomPaths.contains { fileManager.fileExists(atPath: $0) }
    }

    /// Where to look for the latest version. Sheen's cask lives in its own
    /// tap (danaenayati/sheen), which Homebrew's public API does not index, and
    /// the tap is bumped together with each GitHub release, so every install
    /// checks the GitHub release. Homebrew installs still get the
    /// `brew upgrade` instruction instead of a download link.
    public static func updateSourceURL(isHomebrew: Bool) -> URL {
        MCConstants.latestReleaseAPI
    }

    /// Check for a newer version against the latest GitHub release and
    /// classify the result. Failures are returned as values, never thrown.
    public static func check(
        currentVersion: String = MCConstants.appVersion,
        session: URLSession = .shared,
        isHomebrew: Bool = isHomebrewInstall()
    ) async -> CheckResult {
        let sourceURL = updateSourceURL(isHomebrew: isHomebrew)
        var request = URLRequest(url: sourceURL, timeoutInterval: 10)
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        do {
            let (data, _) = try await session.data(for: request)
            guard let parsed = parseLatestRelease(data) else {
                return .failed(message: L10n.tr("GitHub 返回了无法识别的响应。", "Unexpected response from GitHub.", "Неожиданный ответ от GitHub."))
            }
            let version = parsed.version
            // Brew installs act via `brew upgrade`, not a download link; the
            // releases page is a sensible fallback URL.
            let url = isHomebrew ? MCConstants.releasesURL : parsed.url
            return isNewer(version, than: currentVersion)
                ? .updateAvailable(version: version, url: url)
                : .upToDate
        } catch {
            return .failed(message: error.localizedDescription)
        }
    }
}
