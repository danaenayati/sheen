import SwiftUI

/// The colors one glass piece is cut from: a face gradient and the darker
/// edge its thickness shows on the side away from the light.
struct GlassTint {
    let top: Color
    let bottom: Color
    let edge: Color
    var isClear = false

    static func clear(edge: Color, hue: Color) -> GlassTint {
        GlassTint(top: Color.white.mix(hue, 0.12).opacity(0.42), bottom: hue.opacity(0.10), edge: edge, isClear: true)
    }

    var face: LinearGradient {
        LinearGradient(colors: [top, bottom], startPoint: .top, endPoint: .bottom)
    }

    /// Side wall colour, `index` 0 at the back.
    func side(_ index: Int, of count: Int) -> Color {
        let t = Double(index) / Double(max(count - 1, 1))
        if isClear { return .white.opacity(0.05 + 0.09 * t) }
        return bottom.mix(edge, 0.62 - 0.32 * t)
    }
}

/// The light every glass piece answers. At rest it sits top-left; the pointer
/// pulls it across the object.
struct CareLight {
    let pointer: CGPoint

    @MainActor init(_ pointer: CarePointer?) { self.pointer = pointer?.point ?? .zero }

    var source: CGPoint {
        CGPoint(x: min(max(-0.5 + pointer.x * 1.1, -1), 1), y: min(max(-0.65 + pointer.y * 1.1, -1), 1))
    }

    var specular: UnitPoint { UnitPoint(x: 0.5 + source.x * 0.36, y: 0.5 + source.y * 0.36) }
    var rimStart: UnitPoint { UnitPoint(x: 0.5 + source.x * 0.5, y: 0.5 + source.y * 0.5) }
    var rimEnd: UnitPoint { UnitPoint(x: 0.5 - source.x * 0.5, y: 0.5 - source.y * 0.5) }

    /// Thickness direction: away from the light.
    func extrusion(_ length: CGFloat) -> CGSize {
        let magnitude = max(hypot(source.x, source.y), 0.35)
        return CGSize(width: -source.x / magnitude * length, height: -source.y / magnitude * length)
    }

    /// Bevel highlight direction: toward the light.
    func bevel(_ length: CGFloat) -> CGSize {
        let away = extrusion(length)
        return CGSize(width: -away.width, height: -away.height)
    }

    /// Front pieces (depth 1) travel with the pointer, back pieces (-1) against it.
    func parallax(_ depth: CGFloat) -> CGSize {
        CGSize(width: pointer.x * depth * 11, height: pointer.y * depth * 8)
    }

    var tiltAngle: Angle { .degrees(8 * min(hypot(pointer.x, pointer.y), 1)) }
    var tiltAxis: (x: CGFloat, y: CGFloat, z: CGFloat) { (x: -pointer.y, y: pointer.x, z: 0) }
}

private let sideLayers = 7
private let clearLayers = 14

/// A glass solid in any shape: side walls, a shaded face, a specular bloom
/// that follows the light, an inner edge shadow and a rim light.
struct GlassSlab<S: Shape>: View {
    let shape: S
    let tint: GlassTint
    var thickness: CGFloat = 12
    var depth: CGFloat = 0
    @Environment(CarePointer.self) private var pointer: CarePointer?

    var body: some View {
        let light = CareLight(pointer)
        let wall = light.extrusion(thickness)
        ZStack {
            if tint.isClear {
                // Clear glass: merge the wall into one silhouette before it
                // turns translucent, so it reads as a single edge, not copies.
                ZStack {
                    ForEach(0..<clearLayers, id: \.self) { index in
                        let reach = CGFloat(clearLayers - index) / CGFloat(clearLayers)
                        shape.fill(Color.white).offset(x: wall.width * reach, y: wall.height * reach)
                    }
                }
                .compositingGroup()
                .opacity(0.13)
                shape.stroke(.white.opacity(0.3), lineWidth: 1).offset(wall)
            } else {
                ForEach(0..<sideLayers, id: \.self) { index in
                    let reach = CGFloat(sideLayers - index) / CGFloat(sideLayers)
                    shape.fill(tint.side(index, of: sideLayers))
                        .offset(x: wall.width * reach, y: wall.height * reach)
                }
            }
            shape.fill(tint.face)
            shape.fill(LinearGradient(colors: [.white.opacity(tint.isClear ? 0.16 : 0.34), .white.opacity(0)],
                                      startPoint: .top, endPoint: .center))
            shape.fill(EllipticalGradient(colors: [.white.opacity(tint.isClear ? 0.55 : 0.75), .white.opacity(0.1), .clear],
                                          center: light.specular, startRadiusFraction: 0, endRadiusFraction: 0.5))
            shape.stroke(tint.isClear ? Color.white.opacity(0.3) : tint.edge.opacity(0.35), lineWidth: tint.isClear ? 5 : 7)
                .blur(radius: tint.isClear ? 3 : 5)
                .clipShape(shape)
            shape.stroke(LinearGradient(colors: [.white.opacity(0.95), .white.opacity(0.22), .white.opacity(0.08)],
                                        startPoint: light.rimStart, endPoint: light.rimEnd), lineWidth: tint.isClear ? 2 : 1.6)
        }
        .offset(light.parallax(depth))
    }
}

/// An SF Symbol cut as a glass solid, for silhouettes too intricate to draw
/// as a shape (a puzzle piece, a wrench, a paperclip).
struct GlassSymbol: View {
    let name: String
    let size: CGFloat
    let tint: GlassTint
    var weight: Font.Weight = .semibold
    var thickness: CGFloat = 9
    var depth: CGFloat = 0
    @Environment(CarePointer.self) private var pointer: CarePointer?

    var body: some View {
        let light = CareLight(pointer)
        let wall = light.extrusion(thickness)
        let lip = light.bevel(1.4)
        ZStack {
            ForEach(0..<sideLayers, id: \.self) { index in
                let reach = CGFloat(sideLayers - index) / CGFloat(sideLayers)
                glyph.foregroundStyle(tint.side(index, of: sideLayers))
                    .offset(x: wall.width * reach, y: wall.height * reach)
            }
            glyph.foregroundStyle(.white.opacity(0.9)).offset(lip)
            glyph.foregroundStyle(tint.face)
            EllipticalGradient(colors: [.white.opacity(0.7), .white.opacity(0.1), .clear],
                               center: light.specular, startRadiusFraction: 0, endRadiusFraction: 0.55)
                .mask(glyph)
        }
        .offset(light.parallax(depth))
    }

    private var glyph: some View {
        Image(systemName: name).font(.system(size: size, weight: weight))
    }
}

/// A symbol pressed into a glass face: lit on the edge toward the light,
/// shadowed on the far edge.
struct EngravedSymbol: View {
    let name: String
    let size: CGFloat
    var color: Color = .white
    var weight: Font.Weight = .semibold
    var depth: CGFloat = 0
    @Environment(CarePointer.self) private var pointer: CarePointer?

    var body: some View {
        let light = CareLight(pointer)
        let lip = light.bevel(1.2)
        let glyph = Image(systemName: name).font(.system(size: size, weight: weight))
        ZStack {
            glyph.foregroundStyle(.black.opacity(0.28)).offset(x: lip.width, y: lip.height)
            glyph.foregroundStyle(LinearGradient(colors: [color, color.opacity(0.72)], startPoint: .top, endPoint: .bottom))
        }
        .offset(light.parallax(depth))
    }
}

/// Moves a group of pieces together by their shared depth.
struct ParallaxLayer<Content: View>: View {
    let depth: CGFloat
    @ViewBuilder let content: Content
    @Environment(CarePointer.self) private var pointer: CarePointer?

    var body: some View {
        content.offset(CareLight(pointer).parallax(depth))
    }
}

/// The 300 x 300 point stage every hero object is composed on. It casts the
/// floor shadow, tilts the whole object toward the pointer and renders it in
/// one Metal pass.
struct GlassStage<Content: View>: View {
    let world: CareWorld
    var scale: CGFloat = 1
    @ViewBuilder let content: Content
    @Environment(CarePointer.self) private var pointer: CarePointer?
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        let light = CareLight(pointer)
        ZStack {
            Ellipse()
                .fill(scheme == .dark ? world.deep.opacity(0.85) : world.mid.opacity(0.32))
                .frame(width: 210, height: 30)
                .blur(radius: 16)
                .offset(x: -light.source.x * 18, y: 132)
            content
                .frame(width: 300, height: 300)
                .rotation3DEffect(light.tiltAngle, axis: light.tiltAxis, perspective: 0.55)
        }
        .frame(width: 320, height: 330)
        .drawingGroup()
        .scaleEffect(scale)
        .frame(width: 320 * scale, height: 330 * scale)
        .accessibilityHidden(true)
    }
}

// MARK: - Shapes the objects are cut from

struct ShieldShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width, h = rect.height, x = rect.minX, y = rect.minY
        path.move(to: CGPoint(x: x + w * 0.5, y: y))
        path.addCurve(to: CGPoint(x: x + w, y: y + h * 0.16),
                      control1: CGPoint(x: x + w * 0.68, y: y + h * 0.1), control2: CGPoint(x: x + w * 0.86, y: y + h * 0.14))
        path.addCurve(to: CGPoint(x: x + w * 0.5, y: y + h),
                      control1: CGPoint(x: x + w * 1.02, y: y + h * 0.62), control2: CGPoint(x: x + w * 0.74, y: y + h * 0.88))
        path.addCurve(to: CGPoint(x: x, y: y + h * 0.16),
                      control1: CGPoint(x: x + w * 0.26, y: y + h * 0.88), control2: CGPoint(x: x - w * 0.02, y: y + h * 0.62))
        path.addCurve(to: CGPoint(x: x + w * 0.5, y: y),
                      control1: CGPoint(x: x + w * 0.14, y: y + h * 0.14), control2: CGPoint(x: x + w * 0.32, y: y + h * 0.1))
        path.closeSubpath()
        return path
    }
}

/// Wider at the top than the bottom, with rounded corners: a bin, a cup.
struct TaperShape: Shape {
    var taper: CGFloat = 0.12
    var radius: CGFloat = 18
    func path(in rect: CGRect) -> Path {
        let inset = rect.width * taper
        let points = [CGPoint(x: rect.minX, y: rect.minY), CGPoint(x: rect.maxX, y: rect.minY),
                      CGPoint(x: rect.maxX - inset, y: rect.maxY), CGPoint(x: rect.minX + inset, y: rect.maxY)]
        return Path.rounded(points, radius: radius)
    }
}

/// A folder with its tab on the top-left.
struct FolderShape: Shape {
    func path(in rect: CGRect) -> Path {
        let tabWidth = rect.width * 0.4, tabHeight = rect.height * 0.14
        let points = [CGPoint(x: rect.minX, y: rect.minY), CGPoint(x: rect.minX + tabWidth, y: rect.minY),
                      CGPoint(x: rect.minX + tabWidth + tabHeight, y: rect.minY + tabHeight),
                      CGPoint(x: rect.maxX, y: rect.minY + tabHeight), CGPoint(x: rect.maxX, y: rect.maxY),
                      CGPoint(x: rect.minX, y: rect.maxY)]
        return Path.rounded(points, radius: 16)
    }
}

/// A sheet of paper with its top-right corner folded.
struct SheetShape: Shape {
    func path(in rect: CGRect) -> Path {
        let fold = rect.width * 0.24
        let points = [CGPoint(x: rect.minX, y: rect.minY), CGPoint(x: rect.maxX - fold, y: rect.minY),
                      CGPoint(x: rect.maxX, y: rect.minY + fold), CGPoint(x: rect.maxX, y: rect.maxY),
                      CGPoint(x: rect.minX, y: rect.maxY)]
        return Path.rounded(points, radius: 14)
    }
}

/// The folded corner of `SheetShape`, drawn as its own piece.
struct SheetFoldShape: Shape {
    func path(in rect: CGRect) -> Path {
        let fold = rect.width * 0.24
        let points = [CGPoint(x: rect.maxX - fold, y: rect.minY), CGPoint(x: rect.maxX, y: rect.minY + fold),
                      CGPoint(x: rect.maxX - fold, y: rect.minY + fold)]
        return Path.rounded(points, radius: 4)
    }
}

/// An envelope's closed flap: a V from the top corners to the middle.
struct FlapShape: Shape {
    func path(in rect: CGRect) -> Path {
        let points = [CGPoint(x: rect.minX, y: rect.minY), CGPoint(x: rect.maxX, y: rect.minY),
                      CGPoint(x: rect.midX, y: rect.maxY)]
        return Path.rounded(points, radius: 12)
    }
}

/// A pointed oval, the outline of an eye.
struct LensShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.midY), control: CGPoint(x: rect.midX, y: rect.minY - rect.height * 0.5))
        path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.midY), control: CGPoint(x: rect.midX, y: rect.maxY + rect.height * 0.5))
        path.closeSubpath()
        return path
    }
}

/// A thick arc: part of a ring between two angles (0 degrees points right,
/// angles run clockwise).
struct ArcBand: Shape {
    var start: Double
    var end: Double
    var thickness: CGFloat
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outer = min(rect.width, rect.height) / 2
        let inner = max(outer - thickness, 0)
        var path = Path()
        path.addArc(center: center, radius: outer, startAngle: .degrees(start), endAngle: .degrees(end), clockwise: false)
        path.addArc(center: center, radius: inner, startAngle: .degrees(end), endAngle: .degrees(start), clockwise: true)
        path.closeSubpath()
        return path
    }
}

extension Path {
    /// A closed polygon with every corner rounded by `radius`.
    static func rounded(_ points: [CGPoint], radius: CGFloat) -> Path {
        var path = Path()
        guard points.count > 2 else { return path }
        let count = points.count
        let start = CGPoint(x: (points[0].x + points[count - 1].x) / 2, y: (points[0].y + points[count - 1].y) / 2)
        path.move(to: start)
        for index in 0..<count {
            let corner = points[index]
            let next = points[(index + 1) % count]
            path.addArc(tangent1End: corner, tangent2End: next, radius: radius)
        }
        path.closeSubpath()
        return path
    }
}

/// A cog with `teeth` rounded teeth.
struct GearShape: Shape {
    var teeth: Int
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let outer = min(rect.width, rect.height) / 2
        let inner = outer * 0.8
        let step = 2 * Double.pi / Double(teeth)
        func point(_ angle: Double, _ radius: CGFloat) -> CGPoint {
            CGPoint(x: center.x + radius * CGFloat(cos(angle)), y: center.y + radius * CGFloat(sin(angle)))
        }
        var points: [CGPoint] = []
        for index in 0..<teeth {
            let middle = Double(index) * step
            points.append(point(middle - step * 0.3, inner))
            points.append(point(middle - step * 0.17, outer))
            points.append(point(middle + step * 0.17, outer))
            points.append(point(middle + step * 0.3, inner))
        }
        return Path.rounded(points, radius: 4)
    }
}
