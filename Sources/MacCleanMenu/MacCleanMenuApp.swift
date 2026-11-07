import SwiftUI
import AppKit
import MacCleanKit

@main
struct MacCleanMenuApp: App {
    init() {
        AppLanguage.registerDefault(.system)
        // Single-instance enforcement. macOS does NOT auto-deduplicate
        // LSUIElement apps by bundle id the way it does for regular apps,
        // and we have two launch paths (SMAppService + NSWorkspace). Keep
        // the oldest copy; never `exit(0)` from every sibling — that took
        // the extra down when both copies started at once (issue #138).
        // Only enforce when we have a real bundle id (i.e. running from
        // the .app). Under `swift run` the bare executable has no bundle
        // id, and matching against other nil-bundle processes would make
        // the dev build exit immediately.
        if let myBundleID = Bundle.main.bundleIdentifier {
            let myPID = ProcessInfo.processInfo.processIdentifier
            let running = NSWorkspace.shared.runningApplications
            let me = running.first { $0.processIdentifier == myPID }
            let siblings = running.compactMap { app -> MenuBarInstance? in
                guard app.bundleIdentifier == myBundleID,
                      app.processIdentifier != myPID else { return nil }
                return MenuBarInstance(pid: app.processIdentifier, launchDate: app.launchDate)
            }
            // Keep-one, never both-exit. The old any-sibling check killed
            // every copy when SMAppService and NSWorkspace raced
            // (issue #138).
            if MenuBarInstancePolicy.shouldExitAsDuplicate(
                selfPID: myPID,
                selfLaunchDate: me?.launchDate,
                siblings: siblings
            ) {
                exit(0)
            }
        }
    }

    // Polling runs continuously from launch in MenuStatsModel (started by the
    // app delegate), NOT from the popover's onAppear (see MenuStatsModel for
    // why). The App just observes the model and renders it.
    @NSApplicationDelegateAdaptor(MenuAppDelegate.self) private var appDelegate
    @State private var model = MenuStatsModel.shared
    @AppStorage(AppLanguage.defaultsKey, store: SharedAppState.defaults) private var appLanguageRaw = AppLanguage.system.rawValue

    private var appLanguage: AppLanguage {
        AppLanguage(rawValue: appLanguageRaw) ?? .fallback
    }

    /// Only Sheen's mark sits in the menu bar; every figure lives in the panel.
    private static let labelIcon = SheenMark.image(size: 18)

    var body: some Scene {
        MenuBarExtra {
            MenuContentView(
                stats: model.stats,
                networkSpeed: model.networkSpeed,
                devices: model.devices,
                protection: model.protection,
                tips: model.tips,
                onDismissTip: { model.dismissTip(id: $0) }
            )
            .environment(\.locale, Locale(identifier: appLanguage.localeIdentifier))
            .id(appLanguage.rawValue)
        } label: {
            Image(nsImage: Self.labelIcon)
                .renderingMode(.template)
                .accessibilityLabel(MCConstants.appName)
        }
        .menuBarExtraStyle(.window)
    }
}

// MARK: - World

/// Sheen's Midnight Indigo room, plus the section colours the panel lends
/// to its metric tiles. Values come from DESIGN.md.
enum MenuWorld {
    static let deep = Color(menuHex: 0x0B0A2E)
    static let midIntoDeep = Color(menuHex: 0x201A66)
    static let mid = Color(menuHex: 0x2B2384)
    static let glow = Color(menuHex: 0x37C8FF)
    static let spark = Color(menuHex: 0x5BE3FF)
    static let paleTop = Color(menuHex: 0xE9EBFF)
    static let paleBottom = Color(menuHex: 0xCFEFFF)
    static let ink = Color(menuHex: 0x1A1660)
    static let pillLabel = Color(menuHex: 0x211B6B)

    /// A metric's colours: the gradient of the section whose tool it opens.
    struct Series {
        let top: Color
        let bottom: Color
        let symbol: String
    }

    static let cpu = Series(top: Color(menuHex: 0xFFC54D), bottom: Color(menuHex: 0xF0561A), symbol: "cpu")
    static let memory = Series(top: Color(menuHex: 0x62BCFF), bottom: Color(menuHex: 0x2F57F5), symbol: "memorychip")
    static let disk = Series(top: Color(menuHex: 0xCB8EFF), bottom: Color(menuHex: 0x7434E6), symbol: "internaldrive")
    static let battery = Series(top: Color(menuHex: 0x45E8B0), bottom: Color(menuHex: 0x0A9A7B), symbol: "battery.75")
    static let cleanup = Series(top: Color(menuHex: 0x45E8B0), bottom: Color(menuHex: 0x0A9A7B), symbol: "trash")
    static let home = Series(top: Color(menuHex: 0x7E6BFF), bottom: Color(menuHex: 0x22B5F5), symbol: "lightbulb")
    /// Attention: the Protection world's rose, for values past their threshold.
    static let alert = Series(top: Color(menuHex: 0xFF7B9C), bottom: Color(menuHex: 0xC71A5A), symbol: "exclamationmark")
}

extension Color {
    init(menuHex hex: UInt32) {
        self.init(red: Double((hex >> 16) & 255) / 255, green: Double((hex >> 8) & 255) / 255, blue: Double(hex & 255) / 255)
    }
}

// MARK: - Panel

struct MenuContentView: View {
    let stats: SystemStatsCollector.SystemStats?
    let networkSpeed: NetworkSpeedMonitor.NetworkSpeed?
    let devices: ConnectedDevices?
    let protection: SharedAppState.ProtectionStatus?
    let tips: [TipsEngine.Tip]
    let onDismissTip: (String) -> Void

    enum Tab: Hashable, CaseIterable { case health, tips, devices }

    @State private var tab: Tab

    init(stats: SystemStatsCollector.SystemStats?, networkSpeed: NetworkSpeedMonitor.NetworkSpeed?,
         devices: ConnectedDevices?, protection: SharedAppState.ProtectionStatus?,
         tips: [TipsEngine.Tip], onDismissTip: @escaping (String) -> Void, startTab: Tab = .health) {
        self.stats = stats
        self.networkSpeed = networkSpeed
        self.devices = devices
        self.protection = protection
        self.tips = tips
        self.onDismissTip = onDismissTip
        _tab = State(initialValue: startTab)
    }
    @Environment(\.colorScheme) private var scheme

    private var ink: Color { scheme == .dark ? .white : MenuWorld.ink }
    private var softInk: Color { ink.opacity(scheme == .dark ? 0.72 : 0.74) }
    private var alertInk: Color { scheme == .dark ? MenuWorld.alert.top : MenuWorld.alert.bottom }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header
            FullWidthSegments(titles: [L10n.tr("状态", "Health", "Состояние"),
                                       tips.isEmpty ? L10n.tr("建议", "Tips", "Советы") : "\(L10n.tr("建议", "Tips", "Советы")) · \(tips.count)",
                                       L10n.tr("设备", "Devices", "Устройства")],
                              selection: Binding(get: { Tab.allCases.firstIndex(of: tab) ?? 0 },
                                                 set: { tab = Tab.allCases[$0] }))
                .frame(height: 24)
            // Every tab is laid out at once and only the chosen one shows, so the
            // panel keeps one height and the footer never jumps.
            ZStack(alignment: .top) {
                page(.health) { healthTab }
                page(.tips) { tipsTab }
                page(.devices) { devicesTab }
            }
            .frame(maxWidth: .infinity, minHeight: 232, alignment: .top)
            .animation(.easeOut(duration: 0.2), value: tab)
            footer
        }
        .padding(16)
        .frame(width: 340)
        // The menu bar window takes the panel's natural height; nothing may
        // squeeze the tabs under the footer.
        .fixedSize(horizontal: false, vertical: true)
        .foregroundStyle(ink)
        .background(ground)
    }

    private func page<Content: View>(_ page: Tab, @ViewBuilder content: () -> Content) -> some View {
        content()
            .frame(maxWidth: .infinity, alignment: .top)
            .opacity(tab == page ? 1 : 0)
            .allowsHitTesting(tab == page)
            .accessibilityHidden(tab != page)
    }

    // MARK: Ground

    @ViewBuilder private var ground: some View {
        if scheme == .dark {
            ZStack {
                LinearGradient(colors: [MenuWorld.deep, MenuWorld.midIntoDeep, MenuWorld.deep], startPoint: .topLeading, endPoint: .bottomTrailing)
                RadialGradient(colors: [MenuWorld.glow.opacity(0.42), MenuWorld.mid.opacity(0.16), .clear], center: UnitPoint(x: 0.2, y: 0.14), startRadius: 4, endRadius: 230)
                RadialGradient(colors: [MenuWorld.mid.opacity(0.55), .clear], center: UnitPoint(x: 0.95, y: 0.02), startRadius: 0, endRadius: 240)
                aurora(strength: 0.5)
            }
        } else {
            ZStack {
                LinearGradient(colors: [MenuWorld.paleTop, MenuWorld.paleBottom], startPoint: .topLeading, endPoint: .bottomTrailing)
                RadialGradient(colors: [MenuWorld.glow.opacity(0.38), .clear], center: UnitPoint(x: 0.2, y: 0.14), startRadius: 4, endRadius: 230)
                aurora(strength: 0.32)
            }
        }
    }

    /// The Midnight world's signature light: a long cyan band low across the room.
    private func aurora(strength: Double) -> some View {
        GeometryReader { geometry in
            Ellipse()
                .fill(RadialGradient(colors: [MenuWorld.spark.opacity(strength), MenuWorld.glow.opacity(strength * 0.4), .clear],
                                     center: .center, startRadius: 0, endRadius: geometry.size.width * 0.5))
                .frame(width: geometry.size.width * 1.2, height: 110)
                .rotationEffect(.degrees(-12))
                .position(x: geometry.size.width * 0.45, y: geometry.size.height - 50)
                .blur(radius: 26)
        }
    }

    // MARK: Header

    private var header: some View {
        HStack(spacing: 8) {
            Image(nsImage: NSApplication.shared.applicationIconImage)
                .resizable()
                .interpolation(.high)
                .frame(width: 20, height: 20)
                .accessibilityHidden(true)
            Text(MCConstants.appName)
                .font(.system(size: 15, weight: .semibold))
            Spacer()
            if let stats {
                Text(L10n.tr("已运行 \(formatUptime(stats.uptime))", "Up \(formatUptime(stats.uptime))", "Работает \(formatUptime(stats.uptime))"))
                    .font(.system(size: 12))
                    .monospacedDigit()
                    .foregroundStyle(softInk)
            }
        }
    }

    // MARK: Health

    @ViewBuilder private var healthTab: some View {
        if let s = stats {
            let diskUsed = s.diskTotal > 0 ? Double(s.diskTotal - s.diskFree) / Double(s.diskTotal) : 0
            VStack(alignment: .leading, spacing: 12) {
                // Grid rows take their tallest tile's height, so the four tiles line up
                // and the panel's natural height always holds them.
                Grid(horizontalSpacing: 10, verticalSpacing: 10) {
                    GridRow {
                        MetricTile(series: MenuWorld.cpu, label: "CPU",
                                   figure: percent(s.cpuUsage), fraction: s.cpuUsage,
                                   sub: L10n.tr("全部核心", "All cores", "Все ядра"),
                                   note: s.cpuUsage > 0.85 ? L10n.tr("繁忙", "Busy", "Нагрузка") : nil,
                                   opens: "optimization", opensName: L10n.tr("优化", "Optimization", "Оптимизация"))
                        MetricTile(series: MenuWorld.memory, label: L10n.tr("内存", "Memory", "Память"),
                                   figure: percent(s.memoryPressure), fraction: s.memoryPressure,
                                   sub: s.swapUsed > 0 ? HealthAlertStrings.swapLine(s.swapUsed) : L10n.tr("已用 \(FileSizeFormatter.format(s.memoryUsed))", "\(FileSizeFormatter.format(s.memoryUsed)) used", "Занято \(FileSizeFormatter.format(s.memoryUsed))"),
                                   note: s.memoryPressure > 0.85 ? L10n.tr("偏高", "High", "Высокая") : nil,
                                   opens: "optimization", opensName: L10n.tr("优化", "Optimization", "Оптимизация"))
                    }
                    GridRow {
                        MetricTile(series: MenuWorld.disk, label: L10n.tr("磁盘", "Disk", "Диск"),
                                   figure: FileSizeFormatter.format(s.diskFree), fraction: diskUsed,
                                   sub: L10n.tr("可用，共 \(FileSizeFormatter.format(s.diskTotal))", "free of \(FileSizeFormatter.format(s.diskTotal))", "свободно из \(FileSizeFormatter.format(s.diskTotal))"),
                                   note: diskUsed > 0.9 ? L10n.tr("空间不足", "Low space", "Мало места") : nil,
                                   shortNote: L10n.tr("不足", "Low", "Мало"),
                                   opens: "space-lens", opensName: L10n.tr("空间地图", "Space Map", "Карта диска"))
                        if let level = s.batteryLevel {
                            MetricTile(series: MenuWorld.battery, label: L10n.tr("电池", "Battery", "Аккумулятор"),
                                       figure: percent(level), fraction: level,
                                       sub: s.batteryIsCharging ? L10n.tr("充电中", "Charging", "Заряжается") : (level >= 0.99 ? L10n.tr("已充满", "Fully charged", "Заряжен") : L10n.tr("未在充电", "Not charging", "Не заряжается")),
                                       note: level < 0.2 && !s.batteryIsCharging ? L10n.tr("电量低", "Low", "Низкий") : nil)
                        } else {
                            MetricTile(series: MenuWorld.battery, label: L10n.tr("运行时间", "Uptime", "Время работы"),
                                       figure: formatUptime(s.uptime), fraction: nil,
                                       sub: L10n.tr("自上次重启", "Since last restart", "С перезагрузки"))
                        }
                    }
                }
                statusLine
            }
        } else {
            ProgressView()
                .controlSize(.small)
                .frame(maxWidth: .infinity, minHeight: 200)
        }
    }

    /// Network speed on the left, protection state on the right.
    private var statusLine: some View {
        HStack(spacing: 14) {
            if let net = networkSpeed {
                Label(net.formattedIn, systemImage: "arrow.down")
                Label(net.formattedOut, systemImage: "arrow.up")
            }
            Spacer(minLength: 6)
            if let p = protection {
                if p.threatsFound > 0 {
                    Button { TipAction.open(moduleID: "malware") } label: {
                        Label(L10n.tr("发现 \(p.threatsFound) 个威胁", "\(p.threatsFound) threat\(p.threatsFound == 1 ? "" : "s") found", "Угроз: \(p.threatsFound)"),
                              systemImage: "exclamationmark.shield.fill")
                            .foregroundStyle(alertInk)
                    }
                    .buttonStyle(.plain)
                } else {
                    Label(p.isStale ? L10n.tr("扫描已过期", "Scan is due", "Пора проверить") : L10n.tr("未发现威胁", "No threats found", "Угроз не найдено"),
                          systemImage: p.isStale ? "shield" : "checkmark.shield.fill")
                        .help(L10n.tr("上次扫描：\(relativeTime(p.lastScanDate))", "Last malware scan \(relativeTime(p.lastScanDate))", "Последняя проверка \(relativeTime(p.lastScanDate))"))
                }
            }
        }
        .font(.system(size: 12))
        .monospacedDigit()
        .foregroundStyle(softInk)
        .labelStyle(.titleAndIcon)
    }

    // MARK: Tips

    @ViewBuilder private var tipsTab: some View {
        if tips.isEmpty {
            emptyState(symbol: "checkmark", title: L10n.tr("一切正常", "Nothing needs attention", "Всё в порядке"),
                       detail: L10n.tr("Sheen 发现值得清理的内容时，建议会显示在这里。", "Tips show up here when Sheen spots something worth cleaning.", "Советы появятся, когда Sheen найдёт, что стоит очистить."))
        } else {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(tips.prefix(3)) { tip in tipRow(tip) }
            }
        }
    }

    private func tipRow(_ tip: TipsEngine.Tip) -> some View {
        HStack(alignment: .top, spacing: 10) {
            MenuTile(symbol: tip.symbol, series: tipSeries(tip), size: 26)
            VStack(alignment: .leading, spacing: 3) {
                Text(tip.title)
                    .font(.system(size: 13, weight: .semibold))
                    .fixedSize(horizontal: false, vertical: true)
                Text(tip.body)
                    .font(.system(size: 12))
                    .foregroundStyle(softInk)
                    .lineLimit(2)
                Button(tipCTA(tip)) { TipAction.open(moduleID: MenuTipRouting.moduleID(forTipID: tip.id)) }
                    .buttonStyle(MenuPillStyle(compact: true))
                    .padding(.top, 6)
            }
            Spacer(minLength: 0)
            Button { onDismissTip(tip.id) } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(softInk)
                    .frame(width: 20, height: 20)
                    .background(ink.opacity(0.08), in: Circle())
            }
            .buttonStyle(.plain)
            .help(L10n.tr("30 天内不再显示", "Dismiss for 30 days", "Скрыть на 30 дней"))
            .accessibilityLabel(L10n.tr("30 天内不再显示", "Dismiss for 30 days", "Скрыть на 30 дней"))
        }
        .padding(12)
        .background(MenuPanelFill())
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private func tipCTA(_ tip: TipsEngine.Tip) -> String {
        switch tip.id {
        case "trash_large": return L10n.tr("打开废纸篓", "Open Trash Bins", "Открыть Корзины")
        case "caches_large": return L10n.tr("打开系统垃圾", "Open System Junk", "Открыть системный мусор")
        default: return L10n.tr("打开 \(MCConstants.appName)", "Open \(MCConstants.appName)", "Открыть \(MCConstants.appName)")
        }
    }

    /// A tip's tile takes the colour of the section its action opens.
    private func tipSeries(_ tip: TipsEngine.Tip) -> MenuWorld.Series {
        switch MenuTipRouting.moduleID(forTipID: tip.id) {
        case "trash-bins", "system-junk": MenuWorld.cleanup
        default: MenuWorld.home
        }
    }

    // MARK: Devices

    @ViewBuilder private var devicesTab: some View {
        if let d = devices, d.hasAny {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(d.externalVolumes) { volume in
                    deviceRow(symbol: "externaldrive.fill", title: volume.name,
                              detail: L10n.tr("\(FileSizeFormatter.format(volume.freeBytes)) 可用", "\(FileSizeFormatter.format(volume.freeBytes)) free", "Свободно: \(FileSizeFormatter.format(volume.freeBytes))"))
                }
                if d.externalDisplays > 0 {
                    deviceRow(symbol: "display", title: L10n.tr("\(d.externalDisplays) 台外接显示器", "\(d.externalDisplays) external display\(d.externalDisplays == 1 ? "" : "s")", "Внешних дисплеев: \(d.externalDisplays)"), detail: nil)
                }
            }
            .padding(.vertical, 4)
            .background(MenuPanelFill())
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        } else {
            emptyState(symbol: "externaldrive.badge.questionmark", title: L10n.tr("没有外接设备", "No external devices", "Нет внешних устройств"),
                       detail: L10n.tr("连接的磁盘和显示器会显示在这里。", "Connected drives and displays show up here.", "Подключённые диски и дисплеи появятся здесь."))
        }
    }

    private func deviceRow(symbol: String, title: String, detail: String?) -> some View {
        HStack(spacing: 10) {
            MenuTile(symbol: symbol, series: MenuWorld.memory, size: 24)
            Text(title).font(.system(size: 13)).lineLimit(1)
            Spacer(minLength: 6)
            if let detail {
                Text(detail).font(.system(size: 12)).monospacedDigit().foregroundStyle(softInk)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .accessibilityElement(children: .combine)
    }

    private func emptyState(symbol: String, title: String, detail: String) -> some View {
        VStack(spacing: 10) {
            MenuTile(symbol: symbol, series: MenuWorld.home, size: 36)
            Text(title).font(.system(size: 15, weight: .semibold))
            Text(detail)
                .font(.system(size: 12))
                .foregroundStyle(softInk)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, minHeight: 200)
        .padding(.horizontal, 20)
    }

    // MARK: Footer

    private var footer: some View {
        HStack(spacing: 14) {
            Button { TipAction.open() } label: {
                Text(L10n.tr("打开 \(MCConstants.appName)", "Open \(MCConstants.appName)", "Открыть \(MCConstants.appName)"))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(MenuPillStyle())
            Button(L10n.tr("退出", "Quit", "Выйти")) {
                MenuBarKeepAlive.setUserQuit(true, defaults: SharedAppState.defaults)
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
            .font(.system(size: 13))
            .foregroundStyle(softInk)
            .help(L10n.tr("退出菜单栏监视器。可在 Sheen 设置中重新打开。", "Quit the menu bar monitor. Turn it back on in Sheen's Settings.", "Закрыть виджет. Включить снова можно в настройках Sheen."))
        }
    }

    // MARK: Formatting

    private func percent(_ value: Double) -> String { "\(Int((min(max(value, 0), 1) * 100).rounded()))%" }

    private func formatUptime(_ seconds: TimeInterval) -> String {
        let h = Int(seconds) / 3600, m = (Int(seconds) % 3600) / 60
        if h > 24 { return L10n.tr("\(h/24)天 \(h%24)小时", "\(h/24)d \(h%24)h", "\(h/24) \(L10n.russianPlural(h/24, one: "день", few: "дня", many: "дней")) \(h%24) \(L10n.russianPlural(h%24, one: "час", few: "часа", many: "часов"))") }
        return L10n.tr("\(h)小时 \(m)分", "\(h)h \(m)m", "\(h) \(L10n.russianPlural(h, one: "час", few: "часа", many: "часов")) \(m) \(L10n.russianPlural(m, one: "минута", few: "минуты", many: "минут"))")
    }

    private func relativeTime(_ date: Date) -> String {
        let i = Date().timeIntervalSince(date)
        if i < 60 { return L10n.tr("刚刚", "just now", "только что") }
        if i < 3600 { return L10n.tr("\(Int(i/60)) 分钟前", "\(Int(i/60)) min ago", "\(Int(i/60)) \(L10n.russianPlural(Int(i/60), one: "минуту", few: "минуты", many: "минут")) назад") }
        if i < 86400 { return L10n.tr("\(Int(i/3600)) 小时前", "\(Int(i/3600)) hr ago", "\(Int(i/3600)) \(L10n.russianPlural(Int(i/3600), one: "час", few: "часа", many: "часов")) назад") }
        return L10n.tr("\(Int(i/86400)) 天前", "\(Int(i/86400)) day\(Int(i/86400) == 1 ? "" : "s") ago", "\(Int(i/86400)) \(L10n.russianPlural(Int(i/86400), one: "день", few: "дня", many: "дней")) назад")
    }
}

// MARK: - Metric tile

/// One health figure in its section's colours. Clicking it opens the tool
/// that acts on it.
private struct MetricTile: View {
    let series: MenuWorld.Series
    let label: String
    let figure: String
    let fraction: Double?
    var sub: String?
    var note: String?
    var shortNote: String?
    var opens: String?
    var opensName: String?
    @Environment(\.colorScheme) private var scheme
    @State private var hovering = false

    var body: some View {
        if let opens {
            Button { TipAction.open(moduleID: opens) } label: { face }
                .buttonStyle(.plain)
                .onHover { hovering = $0 }
                .help(opensName.map { L10n.tr("打开\($0)", "Open \($0)", "Открыть: \($0)") } ?? "")
                .accessibilityHint(opensName.map { L10n.tr("打开\($0)", "Opens \($0)", "Открывает: \($0)") } ?? "")
        } else {
            face
        }
    }

    private var ink: Color { scheme == .dark ? .white : MenuWorld.ink }
    private var alertInk: Color { scheme == .dark ? MenuWorld.alert.top : MenuWorld.alert.bottom }

    private var face: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                MenuTile(symbol: series.symbol, series: series, size: 22)
                Text(label).font(.system(size: 13, weight: .medium)).lineLimit(1).fixedSize()
                Spacer(minLength: 0)
                if let note {
                    // A value past its threshold says so, in the Protection rose;
                    // the short form takes over when the long one won't fit.
                    ViewThatFits(in: .horizontal) {
                        Text(note)
                        Text(shortNote ?? note)
                    }
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(alertInk)
                    .lineLimit(1)
                }
            }
            Text(figure)
                .font(.system(size: 28, weight: .light))
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .contentTransition(.numericText())
                .animation(.easeOut(duration: 0.25), value: figure)
            if let fraction {
                MeterBar(fraction: fraction, series: note == nil ? series : MenuWorld.alert)
            }
            if let sub {
                Text(sub).font(.system(size: 11)).foregroundStyle(ink.opacity(0.72)).lineLimit(1).minimumScaleFactor(0.85)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(MenuPanelFill(lifted: hovering))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .animation(.easeOut(duration: 0.15), value: hovering)
        .accessibilityElement(children: .combine)
    }
}

/// A slim track with the metric's gradient filled to `fraction`.
private struct MeterBar: View {
    let fraction: Double
    let series: MenuWorld.Series
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule().fill(scheme == .dark ? Color.white.opacity(0.12) : MenuWorld.mid.opacity(0.12))
                Capsule()
                    .fill(LinearGradient(colors: [series.top, series.bottom], startPoint: .leading, endPoint: .trailing))
                    .frame(width: max(geometry.size.width * CGFloat(min(max(fraction, 0), 1)), 5))
                    .animation(.easeOut(duration: 0.35), value: fraction)
            }
        }
        .frame(height: 5)
        .accessibilityHidden(true)
    }
}

/// The app's list-panel recipe: system material with the room laid over it.
private struct MenuPanelFill: View {
    var lifted = false
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        ZStack {
            Rectangle().fill(.ultraThinMaterial)
            Rectangle().fill(scheme == .dark ? MenuWorld.deep.opacity(0.55) : MenuWorld.paleTop.opacity(0.55))
            if lifted {
                Rectangle().fill(scheme == .dark ? Color.white.opacity(0.11) : MenuWorld.mid.opacity(0.08))
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(scheme == .dark ? Color.white.opacity(0.07) : Color.white.opacity(0.75), lineWidth: 0.75)
        }
    }
}

/// The bullet tile from the app: a rounded square in a section gradient with
/// a white glyph (an SF Symbol, or Sheen's own mark).
struct MenuTile: View {
    let symbol: String
    let series: MenuWorld.Series
    var size: CGFloat = 22

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: size * 0.28, style: .continuous)
        shape
            .fill(LinearGradient(colors: [series.top, series.bottom], startPoint: .topLeading, endPoint: .bottomTrailing))
            .overlay { shape.fill(LinearGradient(colors: [.white.opacity(0.38), .white.opacity(0)], startPoint: .top, endPoint: .center)) }
            .overlay { shape.strokeBorder(.white.opacity(0.32), lineWidth: 0.75) }
            .overlay {
                Image(systemName: symbol)
                    .font(.system(size: size * 0.44, weight: .semibold))
                    .foregroundStyle(.white)
                    .shadow(color: MenuWorld.deep.opacity(0.35), radius: 1, y: 1)
            }
            .frame(width: size, height: size)
            .shadow(color: MenuWorld.deep.opacity(0.28), radius: 4, y: 2)
            .accessibilityHidden(true)
    }
}

/// The panel's single action: a white pill in the dark room, the Midnight
/// gradient with a white label in the light one.
private struct MenuPillStyle: ButtonStyle {
    /// The small version used on tip actions.
    var compact = false

    func makeBody(configuration: Configuration) -> some View {
        MenuPillFace(configuration: configuration, compact: compact)
    }
}

private struct MenuPillFace: View {
    let configuration: ButtonStyleConfiguration
    let compact: Bool
    @Environment(\.colorScheme) private var scheme
    @State private var hovering = false

    var body: some View {
        let dark = scheme == .dark
        configuration.label
            .font(.system(size: compact ? 12 : 14, weight: .semibold))
            .foregroundStyle(dark ? MenuWorld.pillLabel : .white)
            .frame(height: compact ? 24 : 36)
            .padding(.horizontal, compact ? 12 : 18)
            .background {
                Capsule().fill(dark
                               ? AnyShapeStyle(LinearGradient(colors: [.white, .white.opacity(0.88)], startPoint: .top, endPoint: .bottom))
                               : AnyShapeStyle(LinearGradient(colors: [MenuWorld.mid, MenuWorld.midIntoDeep], startPoint: .top, endPoint: .bottom)))
            }
            .shadow(color: MenuWorld.deep.opacity(dark ? 0.5 : 0.25), radius: hovering ? 10 : 6, y: hovering ? 5 : 3)
            .brightness(configuration.isPressed ? -0.06 : (hovering ? 0.03 : 0))
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .contentShape(Capsule())
            .onHover { hovering = $0 }
            .animation(.easeOut(duration: 0.16), value: hovering)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

/// A segmented control that spans its full width with equal segments
/// (SwiftUI's segmented picker sizes to its labels on macOS).
private struct FullWidthSegments: NSViewRepresentable {
    let titles: [String]
    @Binding var selection: Int

    func makeNSView(context: Context) -> NSSegmentedControl {
        let control = NSSegmentedControl(labels: titles, trackingMode: .selectOne,
                                         target: context.coordinator, action: #selector(Coordinator.changed(_:)))
        control.segmentDistribution = .fillEqually
        control.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return control
    }

    func updateNSView(_ control: NSSegmentedControl, context: Context) {
        context.coordinator.selection = $selection
        for (index, title) in titles.enumerated() where control.label(forSegment: index) != title {
            control.setLabel(title, forSegment: index)
        }
        control.selectedSegment = selection
    }

    func makeCoordinator() -> Coordinator { Coordinator(selection: $selection) }

    @MainActor final class Coordinator: NSObject {
        var selection: Binding<Int>
        init(selection: Binding<Int>) { self.selection = selection }
        @objc func changed(_ sender: NSSegmentedControl) { selection.wrappedValue = sender.selectedSegment }
    }
}
