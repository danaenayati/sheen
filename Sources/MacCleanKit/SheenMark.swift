import AppKit

/// Sheen's mark: the app icon's fanned glass panes reduced to two, drawn as a
/// one-colour template so macOS can tint it (menu bar, tiles). The back pane
/// is an outline; the front pane is solid with the sheen cut through it.
public enum SheenMark {
    /// Pass as a tile symbol name to draw the mark instead of an SF Symbol.
    public static let symbolName = "sheen.mark"

    /// The mark at `size` points, as a template image.
    public static func image(size: CGFloat = 18) -> NSImage {
        let image = NSImage(size: NSSize(width: size, height: size), flipped: true) { rect in
            let unit = rect.width / 18
            func pane(_ x: CGFloat, _ y: CGFloat, _ degrees: CGFloat, side points: CGFloat) -> NSBezierPath {
                let side = points * unit
                let path = NSBezierPath(roundedRect: NSRect(x: -side / 2, y: -side / 2, width: side, height: side),
                                        xRadius: 2.6 * unit, yRadius: 2.6 * unit)
                var transform = AffineTransform()
                transform.translate(x: x * unit, y: y * unit)
                transform.rotate(byDegrees: degrees)
                path.transform(using: transform)
                return path
            }
            NSColor.black.set()
            guard let context = NSGraphicsContext.current else { return true }
            // Back pane: an outline, tilted the other way.
            let back = pane(7.0, 7.6, -14, side: 9.2)
            back.lineWidth = 1.5 * unit
            back.stroke()
            // Front pane: solid, with a clear gap around it so the two panes read apart at 18pt.
            let front = pane(10.8, 10.2, 8, side: 9.6)
            context.saveGraphicsState()
            context.compositingOperation = .destinationOut
            front.lineWidth = 3 * unit
            front.stroke()
            context.restoreGraphicsState()
            front.fill()
            // The sheen: a short glint in the front pane's upper-left, stopping
            // short of both edges so the pane stays one solid piece.
            context.saveGraphicsState()
            context.compositingOperation = .destinationOut
            let glint = NSBezierPath()
            glint.move(to: NSPoint(x: -2.9 * unit, y: 0.2 * unit))
            glint.line(to: NSPoint(x: 0.2 * unit, y: -2.9 * unit))
            glint.lineWidth = 1.5 * unit
            glint.lineCapStyle = .round
            var transform = AffineTransform()
            transform.translate(x: 10.8 * unit, y: 10.2 * unit)
            transform.rotate(byDegrees: 8)
            glint.transform(using: transform)
            glint.stroke()
            context.restoreGraphicsState()
            return true
        }
        image.isTemplate = true
        image.accessibilityDescription = "Sheen"
        return image
    }
}
