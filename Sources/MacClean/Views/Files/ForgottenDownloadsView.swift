import SwiftUI
import MacCleanKit

/// Downloads you haven't opened in 30 days: same scan, review and clean ritual
/// as Large & Old Files.
struct ForgottenDownloadsView: View {
    @Environment(AppState.self) private var appState
    @State private var results: [ScanResult] = []
    @State private var selectedItems: Set<URL> = []
    @State private var isScanning = false
    @State private var scanProgress: Double = 0
    @State private var scanPhase = ""
    @State private var scanComplete = false
    @State private var completion: CleanSummary?
    @State private var cleaning: CleaningEngine.Progress?
    @State private var cleanTask: Task<Void, Never>?

    var body: some View {
        ModuleContainerView(
            title: L10n.tr("被遗忘的下载", "Forgotten Downloads", "Забытые загрузки"),
            subtitle: L10n.tr("下载文件夹中 30 天未打开的内容", "Things in Downloads you haven't opened in 30 days", "Загрузки, которые не открывались 30 дней"),
            theme: .files,
            emptyMessage: L10n.tr("没有被遗忘的下载", "No forgotten downloads", "Забытых загрузок нет"),
            results: results,
            selectedItems: $selectedItems,
            isScanning: isScanning,
            scanProgress: scanProgress,
            scanPhase: scanPhase,
            scanComplete: scanComplete,
            completion: completion,
            cleaning: cleaning,
            onScan: scan,
            onClean: clean,
            onCancelClean: { cleanTask?.cancel() },
            onReset: reset
        )
        .onAppear {
            if let e = appState.scanResultsStore.entry(for: .forgottenDownloads) {
                results = e.results
                selectedItems = e.selection
                scanComplete = e.scanComplete
            }
        }
        .onDisappear {
            appState.scanResultsStore.save(
                results: results,
                selection: selectedItems,
                scanComplete: scanComplete,
                for: .forgottenDownloads
            )
        }
    }

    private func scan() {
        isScanning = true
        scanComplete = false
        scanProgress = 0
        results = []
        selectedItems = []
        Task {
            let scanStart = Date()

            scanPhase = L10n.tr("正在读取下载文件夹...", "Reading your Downloads folder...", "Чтение папки «Загрузки»...")
            scanProgress = 0.2
            try? await Task.sleep(for: .milliseconds(500))

            scanPhase = L10n.tr("正在检查上次打开时间...", "Checking when each item was last opened...", "Проверка, когда файлы открывались...")
            scanProgress = 0.45

            let module = ForgottenDownloadsModule()
            async let scanTask = module.scan()

            try? await Task.sleep(for: .milliseconds(400))
            scanPhase = L10n.tr("正在计算大小...", "Measuring sizes...", "Подсчёт размеров...")
            scanProgress = 0.7

            results = await scanTask

            scanPhase = L10n.tr("正在整理结果...", "Grouping results...", "Группировка результатов...")
            scanProgress = 0.9

            let elapsed = Date().timeIntervalSince(scanStart)
            if elapsed < 2.0 {
                try? await Task.sleep(for: .milliseconds(Int((2.0 - elapsed) * 1000)))
            }
            scanProgress = 1.0

            isScanning = false
            scanComplete = true
        }
    }

    private func clean() {
        let preCleanSelectedCount = selectedItems.count
        cleaning = CleaningEngine.Progress(
            totalItems: preCleanSelectedCount,
            processedItems: 0, removedSoFar: 0, freedBytesSoFar: 0
        )
        cleanTask = Task {
            let result = await CleanActions.executeUserClean(
                results: results,
                selectedItems: selectedItems,
                engine: appState.cleaningEngine,
                onProgress: { progress in
                    Task { @MainActor in cleaning = progress }
                }
            )
            cleaning = nil
            completion = CleanSummary(
                selectedCount: preCleanSelectedCount,
                removedCount: result.removedCount,
                freedBytes: result.freedBytes,
                errorMessages: result.errors.map(\.error)
            )
        }
    }

    private func reset() {
        results = []; selectedItems = []; completion = nil; cleaning = nil; cleanTask = nil; scanComplete = false
    }
}
