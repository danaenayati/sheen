// Renders README images straight from Sheen's SwiftUI views.
// Run through scripts/render-showcase.sh.
import SwiftUI
import AppKit
import ImageIO
import UniformTypeIdentifiers

/// One frame: a tool's room at window size, with rounded corners and a soft shadow.
struct Frame<Content: View>: View {
    let tool: SidebarItem
    let scheme: ColorScheme
    let pointer: CarePointer
    let size: CGSize
    @ViewBuilder let content: Content

    var body: some View {
        ZStack {
            CareGround(theme: tool.theme)
            content
        }
        .frame(width: size.width, height: size.height)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).strokeBorder(.white.opacity(scheme == .dark ? 0.12 : 0.5), lineWidth: 1))
        .padding(36)
        .shadow(color: .black.opacity(0.32), radius: 24, y: 14)
        .environment(pointer)
        .environment(\.careTool, tool)
        .environment(\.careStaticRender, true)
        .environment(\.colorScheme, scheme)
    }
}

@MainActor
func image<V: View>(_ view: V, scale: CGFloat) -> CGImage {
    let renderer = ImageRenderer(content: view)
    renderer.scale = scale
    guard let image = renderer.cgImage else { fatalError("render failed") }
    return image
}

@MainActor
func save(_ image: CGImage, to url: URL) {
    let rep = NSBitmapImageRep(cgImage: image)
    try! rep.representation(using: .png, properties: [:])!.write(to: url)
    print("wrote \(url.lastPathComponent) \(image.width)x\(image.height)")
}

@main
struct Showcase {
    @MainActor static func main() {
        UserDefaults.standard.set("", forKey: CareUsage.defaultsKey)
        let out = URL(fileURLWithPath: CommandLine.arguments[1])
        let window = CGSize(width: 1100, height: 700)
        let rest = CarePointer()

        let stills: [(SidebarItem, ColorScheme, String)] = [
            (.smartScan, .dark, "smart-scan"), (.systemJunk, .light, "system-junk-light"),
            (.uninstaller, .dark, "uninstaller"), (.spaceLens, .dark, "space-map"),
            (.malwareRemoval, .light, "malware-light"), (.maintenance, .dark, "maintenance"),
        ]
        for (tool, scheme, name) in stills {
            let view = Frame(tool: tool, scheme: scheme, pointer: rest, size: window) { CareIntro(tool: tool) {} }
            save(image(view, scale: 1.6), to: out.appending(path: "\(name).png"))
        }

        let scanning = Frame(tool: .largeOldFiles, scheme: .dark, pointer: rest, size: window) {
            CareProgress(tool: .largeOldFiles, progress: 0.7, phase: "Checking access dates…")
        }
        save(image(scanning, scale: 1.6), to: out.appending(path: "scanning.png"))

        // The signature move: sweep the light around the hero, one frame at a time.
        let gif = out.appending(path: "light-follows-you.gif") as CFURL
        let frames = 44
        guard let destination = CGImageDestinationCreateWithURL(gif, UTType.gif.identifier as CFString, frames, nil) else { fatalError() }
        CGImageDestinationSetProperties(destination, [kCGImagePropertyGIFDictionary: [kCGImagePropertyGIFLoopCount: 0]] as CFDictionary)
        let moving = CarePointer()
        for index in 0..<frames {
            let t = Double(index) / Double(frames) * 2 * .pi
            moving.point = CGPoint(x: 0.85 * sin(t), y: 0.55 * sin(2 * t))
            let view = Frame(tool: .spaceLens, scheme: .dark, pointer: moving, size: CGSize(width: 900, height: 560)) {
                CareIntro(tool: .spaceLens) {}
            }
            CGImageDestinationAddImage(destination, image(view, scale: 0.8),
                                       [kCGImagePropertyGIFDictionary: [kCGImagePropertyGIFDelayTime: 0.06]] as CFDictionary)
        }
        CGImageDestinationFinalize(destination)
        print("wrote light-follows-you.gif (\(frames) frames)")
    }
}
