// Draws Sheen's app icon master (1024 x 1024, transparent corners) with SwiftUI.
// Usage: swift scripts/render-icon.swift assets/app_icon.png
import SwiftUI
import AppKit

func hex(_ value: UInt32, _ opacity: Double = 1) -> Color {
    Color(red: Double((value >> 16) & 255) / 255, green: Double((value >> 8) & 255) / 255,
          blue: Double(value & 255) / 255, opacity: opacity)
}

/// One glass pane: a thick slab with a darker side wall, a lit rim and a face gradient.
struct Pane: View {
    let top: Color
    let bottom: Color
    let edge: Color
    var clear = false
    let shape = RoundedRectangle(cornerRadius: 104, style: .continuous)

    var body: some View {
        ZStack {
            ForEach(0..<10, id: \.self) { index in
                shape.fill(edge.opacity(clear ? 0.05 : 1)).offset(x: CGFloat(10 - index) * 1.4, y: CGFloat(10 - index) * 2.2)
            }
            shape.fill(LinearGradient(colors: [top, bottom], startPoint: .topLeading, endPoint: .bottomTrailing))
            shape.fill(LinearGradient(colors: [.white.opacity(clear ? 0.30 : 0.36), .white.opacity(0)], startPoint: .top, endPoint: .center))
            shape.strokeBorder(LinearGradient(colors: [.white.opacity(0.95), .white.opacity(0.2), .white.opacity(0.06)],
                                              startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 5)
        }
        .frame(width: 430, height: 430)
    }
}

/// The sheen: two bands of light sliding across the front pane.
struct Sheen: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(colors: [.white.opacity(0), .white.opacity(0.92), .white.opacity(0.55), .white.opacity(0)],
                                     startPoint: .leading, endPoint: .trailing))
                .frame(width: 120, height: 900)
                .offset(x: -40)
            Rectangle()
                .fill(LinearGradient(colors: [.white.opacity(0), .white.opacity(0.8), .white.opacity(0)],
                                     startPoint: .leading, endPoint: .trailing))
                .frame(width: 34, height: 900)
                .offset(x: 70)
        }
        .rotationEffect(.degrees(32))
        .blendMode(.screen)
    }
}

struct Icon: View {
    let tile = RoundedRectangle(cornerRadius: 186, style: .continuous)

    var body: some View {
        ZStack {
            tile.fill(hex(0x000000, 0.45)).frame(width: 824, height: 824).blur(radius: 18).offset(y: 14)
            ZStack {
                LinearGradient(colors: [hex(0x221A6E), hex(0x0B0A2E)], startPoint: .top, endPoint: .bottom)
                RadialGradient(colors: [hex(0x37C8FF, 0.62), hex(0x37C8FF, 0)], center: UnitPoint(x: 0.22, y: 0.86), startRadius: 0, endRadius: 520)
                RadialGradient(colors: [hex(0x8B5CFF, 0.55), hex(0x8B5CFF, 0)], center: UnitPoint(x: 0.9, y: 0.08), startRadius: 0, endRadius: 460)
                Ellipse().fill(hex(0x000000, 0.45)).frame(width: 600, height: 90).blur(radius: 34).offset(y: 300)
                Pane(top: hex(0x5CF0BC), bottom: hex(0x0A9A7B), edge: hex(0x04402F))
                    .rotationEffect(.degrees(-20)).offset(x: -118, y: 36)
                Pane(top: hex(0xFF8FAB), bottom: hex(0xC71A5A), edge: hex(0x4E0A26))
                    .rotationEffect(.degrees(-5)).offset(x: -14, y: -12)
                ZStack {
                    Pane(top: hex(0x8F7DFF, 0.82), bottom: hex(0x22B5F5, 0.78), edge: hex(0x0B0A2E), clear: true)
                    Sheen()
                        .frame(width: 430, height: 430)
                        .mask(RoundedRectangle(cornerRadius: 104, style: .continuous).frame(width: 430, height: 430))
                    Circle().fill(.white.opacity(0.7)).frame(width: 70, height: 70).blur(radius: 22).offset(x: -150, y: -150)
                }
                .rotationEffect(.degrees(10)).offset(x: 104, y: -44)
                tile.strokeBorder(LinearGradient(colors: [.white.opacity(0.32), .white.opacity(0.04)], startPoint: .top, endPoint: .bottom), lineWidth: 3)
            }
            .frame(width: 824, height: 824)
            .clipShape(tile)
        }
        .frame(width: 1024, height: 1024)
    }
}

@MainActor func render() {
    let renderer = ImageRenderer(content: Icon())
    renderer.scale = 1
    guard let image = renderer.cgImage else { fatalError("render failed") }
    let rep = NSBitmapImageRep(cgImage: image)
    let data = rep.representation(using: .png, properties: [:])!
    try! data.write(to: URL(fileURLWithPath: CommandLine.arguments[1]))
    print("wrote \(CommandLine.arguments[1]) \(image.width)x\(image.height)")
}
MainActor.assumeIsolated { render() }
