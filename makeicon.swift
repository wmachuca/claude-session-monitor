import AppKit

let S = 1024
let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: S, pixelsHigh: S,
    bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
    colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!

NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)

let full = NSRect(x: 0, y: 0, width: S, height: S)

// fondo squircle con degradado oscuro
let bg = NSBezierPath(roundedRect: full, xRadius: CGFloat(S) * 0.22, yRadius: CGFloat(S) * 0.22)
bg.addClip()
let grad = NSGradient(colors: [
    NSColor(calibratedRed: 0.16, green: 0.17, blue: 0.20, alpha: 1),
    NSColor(calibratedRed: 0.06, green: 0.06, blue: 0.08, alpha: 1),
])!
grad.draw(in: full, angle: -90)

// tres barras tipo "monitor de contexto": verde, amarillo, rojo
func bar(centerY: CGFloat, fill: CGFloat, color: NSColor) {
    let x: CGFloat = 235, w: CGFloat = 555, h: CGFloat = 120, r: CGFloat = h / 2
    // punto de color a la izquierda (identidad de sesión)
    let dotD: CGFloat = 70
    color.setFill()
    NSBezierPath(ovalIn: NSRect(x: 165, y: centerY - dotD/2, width: dotD, height: dotD)).fill()
    // pista
    NSColor.white.withAlphaComponent(0.12).setFill()
    NSBezierPath(roundedRect: NSRect(x: x, y: centerY - h/2, width: w, height: h), xRadius: r, yRadius: r).fill()
    // relleno
    color.setFill()
    NSBezierPath(roundedRect: NSRect(x: x, y: centerY - h/2, width: max(h, w * fill), height: h), xRadius: r, yRadius: r).fill()
}

bar(centerY: 715, fill: 0.55, color: NSColor.systemGreen)
bar(centerY: 512, fill: 0.78, color: NSColor.systemYellow)
bar(centerY: 309, fill: 0.95, color: NSColor.systemRed)

NSGraphicsContext.restoreGraphicsState()

let png = rep.representation(using: .png, properties: [:])!
try! png.write(to: URL(fileURLWithPath: "/tmp/cs-icon.png"))
print("icono escrito en /tmp/cs-icon.png")
