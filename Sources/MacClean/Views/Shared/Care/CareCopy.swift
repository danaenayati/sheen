import Foundation

/// What each tool's intro says. Every line is taken from what the tool's code
/// actually does; nothing here may promise more than the module delivers.
struct CareCopy {
    struct Point {
        let symbol: String
        let label: String
        let detail: String
    }

    let title: String
    let subtitle: String
    let points: [Point]
    let action: String
    /// A requirement or caution worth knowing before the first press.
    var note: String?

    // swiftlint:disable:next function_body_length cyclomatic_complexity
    static func of(_ tool: SidebarItem) -> CareCopy {
        switch tool {
        case .smartScan:
            CareCopy(title: "Smart Scan",
                     subtitle: "One scan across cleanup, protection and privacy. Nothing goes until you choose.",
                     points: [Point(symbol: "trash", label: "Junk and leftovers", detail: "System junk, mail attachments and every Trash bin."),
                              Point(symbol: "shield.lefthalf.filled", label: "Malware check", detail: "Startup items, extensions and apps against known threats."),
                              Point(symbol: "hand.raised.fill", label: "Privacy traces", detail: "Browser caches and history, and recent-items lists.")],
                     action: "Scan",
                     note: "Full Disk Access lets the scan reach Mail and browser data.")
        case .systemJunk:
            CareCopy(title: "System Junk",
                     subtitle: "Caches, logs and leftovers your Mac piles up, sorted by how safe they are to remove.",
                     points: [Point(symbol: "internaldrive", label: "20 kinds of junk", detail: "Caches, logs, language files, old updates, broken downloads and more."),
                              Point(symbol: "checkmark.shield", label: "A safety rating on each", detail: "Recreated automatically, safe to remove, or review first."),
                              Point(symbol: "arrow.uturn.backward", label: "Undo from Clean History", detail: "Removed files go to the Trash and can be put back.")],
                     action: "Scan")
        case .mailAttachments:
            CareCopy(title: "Mail Attachments",
                     subtitle: "Attachment files from Mail, Outlook and Spark that are taking up space.",
                     points: [Point(symbol: "envelope", label: "Mail, Outlook and Spark", detail: "Saved downloads and cached attachments."),
                              Point(symbol: "text.bubble", label: "Your messages stay", detail: "Only the attachment files are listed."),
                              Point(symbol: "icloud.and.arrow.down", label: "Back when you need them", detail: "IMAP and Exchange accounts can download them again.")],
                     action: "Scan",
                     note: "Needs Full Disk Access to read Mail.")
        case .trashBins:
            CareCopy(title: "Trash Bins",
                     subtitle: "Every Trash on this Mac in one place, including the ones on external drives.",
                     points: [Point(symbol: "trash", label: "Your Trash", detail: "Everything waiting to be emptied."),
                              Point(symbol: "externaldrive", label: "Every connected drive", detail: "The hidden Trash folders on other volumes."),
                              Point(symbol: "exclamationmark.triangle", label: "Emptying is permanent", detail: "You confirm first, because it cannot be undone.")],
                     action: "Scan",
                     note: "Needs Full Disk Access to look inside the Trash.")
        case .diskHogs:
            CareCopy(title: "Disk Hogs",
                     subtitle: "Space taken by Docker and Xcode simulators. Only the tools found on this Mac are shown.",
                     points: [Point(symbol: "shippingbox", label: "Docker", detail: "Images, containers and build cache you can prune."),
                              Point(symbol: "iphone", label: "Xcode simulators", detail: "Unavailable devices and older runtimes."),
                              Point(symbol: "hand.raised", label: "Nothing chosen for you", detail: "Pruning is permanent, so every item is your pick.")],
                     action: "Show Disk Hogs")
        case .projectJunk:
            CareCopy(title: "Project Junk",
                     subtitle: "Folders your code projects can rebuild any time, found in a folder you choose.",
                     points: [Point(symbol: "folder", label: "You pick the folder", detail: "For example ~/Code. System folders are refused."),
                              Point(symbol: "hammer", label: "Rebuildable folders", detail: "node_modules, venvs, target, build, Pods and more."),
                              Point(symbol: "arrow.uturn.backward", label: "To the Trash, not gone", detail: "Nothing is preselected, and Clean History can undo it.")],
                     action: "Choose Folder")
        case .cleanHistory:
            CareCopy(title: "Clean History",
                     subtitle: "Put a whole clean back with one click.",
                     points: [Point(symbol: "clock.arrow.circlepath", label: "The last 30 days", detail: "Up to 20 cleans are remembered."),
                              Point(symbol: "arrow.uturn.backward", label: "Back where it was", detail: "Each item returns to its original folder."),
                              Point(symbol: "lock.shield", label: "Never overwrites", detail: "Emptied items, or ones with a new file in their place, are skipped.")],
                     action: "Show History")
        case .malwareRemoval:
            CareCopy(title: "Malware Removal",
                     subtitle: "Checks the places Mac malware hides against known threats.",
                     points: [Point(symbol: "power", label: "Startup items", detail: "Launch agents and daemons that run on their own."),
                              Point(symbol: "puzzlepiece.extension", label: "Extensions and apps", detail: "Chrome and Safari extensions, and apps in Applications."),
                              Point(symbol: "checkmark.seal", label: "Known signatures", detail: "Apple XProtect, Safari's blocklist and known family names.")],
                     action: "Scan",
                     note: "Anything you remove goes to the Trash.")
        case .privacy:
            CareCopy(title: "Privacy",
                     subtitle: "Browsing traces and recent-items lists that show what you have been doing.",
                     points: [Point(symbol: "safari", label: "Safari, Chrome and Firefox", detail: "Browser caches, plus Safari history."),
                              Point(symbol: "list.bullet.rectangle", label: "Recent items", detail: "The recent files and servers lists macOS keeps."),
                              Point(symbol: "person.badge.key", label: "You stay signed in", detail: "Cookies and logged-in sessions are kept.")],
                     action: "Scan",
                     note: "Needs Full Disk Access to read browser data.")
        case .browserExtensions:
            CareCopy(title: "Browser Extensions",
                     subtitle: "Every extension across your browsers, with likely adware listed first.",
                     points: [Point(symbol: "globe", label: "Six browsers", detail: "Chrome, Brave, Edge, Arc, Firefox and Safari."),
                              Point(symbol: "exclamationmark.shield", label: "Suspicious first", detail: "Names that match known adware families are flagged."),
                              Point(symbol: "trash", label: "Careful removal", detail: "Only while the browser is closed, and into the Trash.")],
                     action: "Show Extensions")
        case .wifiNetworks:
            CareCopy(title: "Saved Wi-Fi",
                     subtitle: "Networks your Mac remembers and will join on its own.",
                     points: [Point(symbol: "wifi", label: "Every saved network", detail: "Listed for each Wi-Fi device."),
                              Point(symbol: "location.slash", label: "A smaller trail", detail: "Forget the networks you no longer use."),
                              Point(symbol: "lock", label: "Your confirmation", detail: "Forgetting asks for your administrator password.")],
                     action: "Show Networks")
        case .appPermissions:
            CareCopy(title: "Permissions",
                     subtitle: "Which apps can use your camera, microphone, screen and files.",
                     points: [Point(symbol: "video", label: "Camera and microphone", detail: "Plus screen recording and automation."),
                              Point(symbol: "folder.badge.person.crop", label: "Full Disk Access", detail: "The apps allowed to read everything."),
                              Point(symbol: "gearshape", label: "Changed in System Settings", detail: "This list is read-only. Buttons take you there.")],
                     action: "Show Permissions",
                     note: "Needs Full Disk Access to list every app.")
        case .optimization:
            CareCopy(title: "Optimization",
                     subtitle: "What is using your Mac right now, and what starts with it.",
                     points: [Point(symbol: "cpu", label: "Resource hogs", detail: "The apps using the most CPU and memory, with Force Quit."),
                              Point(symbol: "power", label: "Startup items", detail: "Login items and launch agents you can turn off."),
                              Point(symbol: "doc.badge.gearshape", label: "File associations", detail: "Which app opens which file, with backups.")],
                     action: "Show Activity")
        case .maintenance:
            CareCopy(title: "Maintenance",
                     subtitle: "Ten routine tasks that keep macOS running smoothly.",
                     points: [Point(symbol: "play.circle", label: "Safe tasks in one click", detail: "Run Safe Tasks works through the routine set in order."),
                              Point(symbol: "exclamationmark.triangle", label: "Advanced tasks explained", detail: "Side effects are shown before anything runs."),
                              Point(symbol: "lock", label: "Password when needed", detail: "Some tasks ask for administrator access.")],
                     action: "Show Tasks")
        case .uninstaller:
            CareCopy(title: "Uninstaller",
                     subtitle: "Remove apps completely, along with the files they leave behind.",
                     points: [Point(symbol: "app.badge", label: "Every installed app", detail: "Search, or show only unused or third-party apps."),
                              Point(symbol: "folder.badge.minus", label: "Leftovers included", detail: "Caches, preferences, containers and launch agents."),
                              Point(symbol: "arrow.counterclockwise", label: "Reset instead of remove", detail: "Clear an app's data and keep the app.")],
                     action: "Show Apps")
        case .unusedApps:
            CareCopy(title: "Unused Apps",
                     subtitle: "Apps you have not opened in months, biggest first.",
                     points: [Point(symbol: "calendar", label: "3, 6 or 12 months", detail: "Based on when macOS last saw each app in use."),
                              Point(symbol: "internaldrive", label: "Sorted by space", detail: "Including each app's support files."),
                              Point(symbol: "arrow.right.circle", label: "One step to remove", detail: "Hands the app to the Uninstaller.")],
                     action: "Show Unused Apps")
        case .extensions:
            CareCopy(title: "Extensions",
                     subtitle: "Add-ons installed into macOS and Safari.",
                     points: [Point(symbol: "gearshape.2", label: "Preference panes", detail: "Third-party panes in System Settings."),
                              Point(symbol: "powerplug", label: "Internet plug-ins", detail: "Old browser plug-ins still on disk."),
                              Point(symbol: "safari", label: "Safari extensions", detail: "Listed here, managed in Safari Settings.")],
                     action: "Show Extensions")
        case .updater:
            CareCopy(title: "Updater",
                     subtitle: "Find newer versions of the apps you already have.",
                     points: [Point(symbol: "dot.radiowaves.left.and.right", label: "Each app's update feed", detail: "For apps that publish one."),
                              Point(symbol: "arrow.up.circle", label: "Current and new version", detail: "Side by side, before you update."),
                              Point(symbol: "bag", label: "App Store apps too", detail: "Opens the App Store's Updates page.")],
                     action: "Check for Updates")
        case .spaceLens:
            CareCopy(title: "Space Map",
                     subtitle: "See what fills your home folder, as a map you can explore.",
                     points: [Point(symbol: "square.grid.3x3.fill", label: "A map of your folders", detail: "The 50 biggest items, sized by the space they take."),
                              Point(symbol: "paintpalette", label: "Colored by type", detail: "Documents, photos, video, apps, archives and more."),
                              Point(symbol: "cursorarrow.click.2", label: "Click to go deeper", detail: "Open any folder, then go back with Up or Home.")],
                     action: "Scan")
        case .largeOldFiles:
            CareCopy(title: "Large & Old Files",
                     subtitle: "Big files you may have forgotten about.",
                     points: [Point(symbol: "arrow.up.doc", label: "50 MB and up", detail: "Found across your home and Downloads folders."),
                              Point(symbol: "clock", label: "Untouched for six months", detail: "Old files are listed separately."),
                              Point(symbol: "hand.raised", label: "You choose", detail: "Nothing is preselected, and removals go to the Trash.")],
                     action: "Scan")
        case .duplicates:
            CareCopy(title: "Duplicates",
                     subtitle: "Identical files in your home folder, matched by content rather than name.",
                     points: [Point(symbol: "number", label: "Exact matches only", detail: "Compared with SHA-256, so look-alikes are left alone."),
                              Point(symbol: "star", label: "Originals are kept", detail: "One file in each group is never offered for removal."),
                              Point(symbol: "square.on.square", label: "Remove or consolidate", detail: "Trash the copies, or turn them into space-free clones.")],
                     action: "Scan",
                     note: "Can take several minutes on a large home folder.")
        case .shredder:
            CareCopy(title: "Shredder",
                     subtitle: "Get rid of files for good, as gently or as thoroughly as you need.",
                     points: [Point(symbol: "trash", label: "Move to Trash", detail: "The gentle default."),
                              Point(symbol: "xmark.bin", label: "Permanent delete", detail: "Skips the Trash entirely."),
                              Point(symbol: "eraser", label: "Secure erase", detail: "Overwrites with zeros first. Best effort on SSDs.")],
                     action: "Select Files")
        case .settings:
            CareCopy(title: "Settings", subtitle: "", points: [], action: "")
        }
    }
}
