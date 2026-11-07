import SwiftUI

/// Each tool's hero: an original glass object, composed on a `GlassStage`.
/// Coordinates are points on the 300 x 300 stage, measured from its centre.
struct CareHero: View {
    let tool: SidebarItem
    var scale: CGFloat = 1

    var body: some View {
        let world = tool.theme.world
        GlassStage(world: world, scale: scale) {
            object(world)
        }
    }

    @ViewBuilder
    private func object(_ w: CareWorld) -> some View {
        switch tool {
        case .smartScan: SmartCareGlass(w: w)
        case .systemJunk: CanisterGlass(w: w)
        case .mailAttachments: EnvelopeGlass(w: w)
        case .trashBins: BinGlass(w: w)
        case .diskHogs: CratesGlass(w: w)
        case .projectJunk: ProjectFolderGlass(w: w)
        case .cleanHistory: RewindDialGlass(w: w)
        case .malwareRemoval: ShieldGlass(w: w)
        case .privacy: EyeGlass(w: w)
        case .browserExtensions: BrowserPieceGlass(w: w)
        case .wifiNetworks: SignalGlass(w: w)
        case .appPermissions: PadlockGlass(w: w)
        case .optimization: GaugeGlass(w: w)
        case .maintenance: GearGlass(w: w)
        case .uninstaller: LiftedAppGlass(w: w)
        case .unusedApps: SleepingAppGlass(w: w)
        case .extensions: PanelPlugGlass(w: w)
        case .updater: UpdateOrbGlass(w: w)
        case .spaceLens: SunburstGlass(w: w)
        case .largeOldFiles: PaperStackGlass(w: w)
        case .forgottenDownloads: DownloadsTrayGlass(w: w)
        case .duplicates: TwinCardsGlass(w: w)
        case .shredder: ShredderGlass(w: w)
        case .settings: GlassSymbol(name: "gearshape.fill", size: 180, tint: w.glass, thickness: 14)
        }
    }
}

/// A small glass coin carrying an engraved symbol, used as a badge.
private struct GlassBadge: View {
    let symbol: String
    let tint: GlassTint
    let ink: Color
    var size: CGFloat = 58

    var body: some View {
        ZStack {
            GlassSlab(shape: Circle(), tint: tint, thickness: 7)
                .frame(width: size, height: size)
            EngravedSymbol(name: symbol, size: size * 0.44, color: ink, weight: .bold)
        }
    }
}

/// A glass core with one orbit and the three sweeps Smart Scan runs riding
/// it: a junk canister, a malware shield and a privacy eye, each in the
/// colour of the section it comes from.
private struct SmartCareGlass: View {
    let w: CareWorld
    var body: some View {
        let cleanup = ModuleTheme.cleanup.world
        let protection = ModuleTheme.protection.world
        ZStack {
            ParallaxLayer(depth: -0.35) {
                Ellipse()
                    .stroke(LinearGradient(colors: [.white.opacity(0.5), w.spark.opacity(0.25)], startPoint: .leading, endPoint: .trailing), lineWidth: 3)
                    .frame(width: 286, height: 92)
                    .rotationEffect(.degrees(-14))
                    .offset(y: 14)
            }
            ParallaxLayer(depth: -0.3) {
                ZStack {
                    GlassSlab(shape: ShieldShape(), tint: protection.glass, thickness: 7)
                        .frame(width: 46, height: 54)
                    EngravedSymbol(name: "checkmark", size: 18, weight: .heavy).offset(y: -2)
                }
                .offset(x: 118, y: -26)
            }
            ParallaxLayer(depth: 0) {
                ZStack {
                    GlassSlab(shape: Circle(), tint: w.glass, thickness: 14)
                        .frame(width: 156, height: 156)
                    Circle()
                        .fill(RadialGradient(colors: [.white, w.spark.opacity(0.85), w.spark.opacity(0)], center: .center, startRadius: 2, endRadius: 46))
                        .frame(width: 92, height: 92)
                        .blendMode(.screen)
                    GlassSlab(shape: Circle(), tint: w.clearGlass, thickness: 4)
                        .frame(width: 64, height: 64)
                }
                .offset(y: -8)
            }
            ParallaxLayer(depth: 0.35) {
                Ellipse()
                    .trim(from: 0.02, to: 0.48)
                    .stroke(LinearGradient(colors: [w.spark.opacity(0.4), .white.opacity(0.85)], startPoint: .trailing, endPoint: .leading), lineWidth: 3)
                    .frame(width: 286, height: 92)
                    .rotationEffect(.degrees(-14))
                    .offset(y: 14)
            }
            ParallaxLayer(depth: 0.6) {
                ZStack {
                    GlassSlab(shape: RoundedRectangle(cornerRadius: 10, style: .continuous), tint: cleanup.glass, thickness: 7)
                        .frame(width: 42, height: 46).offset(y: 6)
                    GlassSlab(shape: Capsule(), tint: cleanup.pearl, thickness: 4)
                        .frame(width: 50, height: 13).offset(y: -20)
                }
                .offset(x: -122, y: 30)
            }
            ParallaxLayer(depth: 0.95) {
                ZStack {
                    GlassSlab(shape: LensShape(), tint: w.pearl, thickness: 6)
                        .frame(width: 62, height: 34)
                    Circle().fill(w.tileGradient).frame(width: 20, height: 20)
                    Circle().fill(w.deep).frame(width: 8, height: 8)
                }
                .offset(x: 46, y: 70)
            }
        }
    }
}

private struct CanisterGlass: View {
    let w: CareWorld
    var body: some View {
        ZStack {
            ParallaxLayer(depth: -0.15) {
                ZStack {
                    GlassSlab(shape: RoundedRectangle(cornerRadius: 9, style: .continuous), tint: w.glass, thickness: 6)
                        .frame(width: 48, height: 48).rotationEffect(.degrees(18)).offset(x: -36, y: 76)
                    GlassSlab(shape: Circle(), tint: w.sparkGlass, thickness: 6)
                        .frame(width: 42, height: 42).offset(x: 34, y: 82)
                    GlassSlab(shape: Capsule(), tint: w.pearl, thickness: 5)
                        .frame(width: 66, height: 22).rotationEffect(.degrees(-24)).offset(x: 6, y: 38)
                }
            }
            GlassSlab(shape: RoundedRectangle(cornerRadius: 32, style: .continuous), tint: w.clearGlass, thickness: 12, depth: -0.3)
                .frame(width: 172, height: 192).offset(y: 24)
            GlassSlab(shape: Capsule(), tint: w.glass, thickness: 10, depth: 0.4)
                .frame(width: 194, height: 36).offset(y: -86)
            GlassSlab(shape: Capsule(), tint: w.pearl, thickness: 6, depth: 0.55)
                .frame(width: 62, height: 18).offset(y: -112)
        }
    }
}

private struct EnvelopeGlass: View {
    let w: CareWorld
    var body: some View {
        ZStack {
            GlassSlab(shape: RoundedRectangle(cornerRadius: 22, style: .continuous), tint: w.glass, thickness: 14, depth: -0.1)
                .frame(width: 238, height: 158).offset(y: 22)
            GlassSlab(shape: FlapShape(), tint: w.clearGlass, thickness: 4, depth: 0.15)
                .frame(width: 238, height: 94).offset(y: -10)
            GlassSymbol(name: "paperclip", size: 108, tint: w.pearl, weight: .bold, thickness: 7, depth: 0.8)
                .rotationEffect(.degrees(28)).offset(x: 88, y: -72)
        }
    }
}

private struct BinGlass: View {
    let w: CareWorld
    var body: some View {
        ZStack {
            GlassSlab(shape: TaperShape(taper: 0.12, radius: 20), tint: w.clearGlass, thickness: 12, depth: -0.2)
                .frame(width: 172, height: 188).offset(y: 36)
            ParallaxLayer(depth: -0.2) {
                HStack(spacing: 30) {
                    ForEach(0..<3, id: \.self) { _ in
                        GlassSlab(shape: Capsule(), tint: w.glass, thickness: 4)
                            .frame(width: 11, height: 116)
                    }
                }
                .offset(y: 40)
            }
            ParallaxLayer(depth: 0.5) {
                ZStack {
                    GlassSlab(shape: RoundedRectangle(cornerRadius: 13, style: .continuous), tint: w.glass, thickness: 10)
                        .frame(width: 204, height: 30)
                    GlassSlab(shape: Capsule(), tint: w.pearl, thickness: 6)
                        .frame(width: 58, height: 17).offset(y: -22)
                }
                .rotationEffect(.degrees(-14))
                .offset(x: -12, y: -84)
            }
        }
    }
}

private struct CratesGlass: View {
    let w: CareWorld
    var body: some View {
        ZStack {
            crate(w.glass, width: 214, ribs: 6, depth: -0.35).offset(y: 74)
            crate(w.sparkGlass, width: 182, ribs: 5, depth: 0.05).offset(y: 10)
            crate(w.clearGlass, width: 150, ribs: 4, depth: 0.45).offset(y: -54)
        }
    }

    private func crate(_ tint: GlassTint, width: CGFloat, ribs: Int, depth: CGFloat) -> some View {
        ParallaxLayer(depth: depth) {
            ZStack {
                GlassSlab(shape: RoundedRectangle(cornerRadius: 14, style: .continuous), tint: tint, thickness: 12)
                    .frame(width: width, height: 58)
                HStack(spacing: 16) {
                    ForEach(0..<ribs, id: \.self) { _ in
                        Capsule().fill(.white.opacity(0.34)).frame(width: 6, height: 30)
                    }
                }
            }
        }
    }
}

private struct ProjectFolderGlass: View {
    let w: CareWorld
    var body: some View {
        ZStack {
            ParallaxLayer(depth: -0.1) {
                ZStack {
                    GlassSlab(shape: FolderShape(), tint: w.glass, thickness: 14)
                        .frame(width: 240, height: 172)
                    EngravedSymbol(name: "chevron.left.forwardslash.chevron.right", size: 54, weight: .bold)
                        .offset(y: 16)
                }
                .offset(y: 22)
            }
            GlassSymbol(name: "hammer.fill", size: 96, tint: w.pearl, depth: 0.8)
                .rotationEffect(.degrees(-20)).offset(x: 86, y: -82)
        }
    }
}

private struct RewindDialGlass: View {
    let w: CareWorld
    var body: some View {
        ZStack {
            GlassSlab(shape: Circle(), tint: w.clearGlass, thickness: 14, depth: -0.3)
                .frame(width: 218, height: 218)
            ParallaxLayer(depth: 0) {
                ZStack {
                    GlassSlab(shape: Circle(), tint: w.glass, thickness: 8)
                        .frame(width: 160, height: 160)
                    ForEach(0..<12, id: \.self) { index in
                        Capsule()
                            .fill(.white.opacity(index.isMultiple(of: 3) ? 0.92 : 0.5))
                            .frame(width: 4, height: index.isMultiple(of: 3) ? 16 : 9)
                            .offset(y: -66)
                            .rotationEffect(.degrees(Double(index) * 30))
                    }
                }
            }
            ParallaxLayer(depth: 0.35) {
                ZStack {
                    GlassSlab(shape: Capsule(), tint: w.pearl, thickness: 5)
                        .frame(width: 10, height: 52).offset(y: -22).rotationEffect(.degrees(-62))
                    GlassSlab(shape: Capsule(), tint: w.pearl, thickness: 5)
                        .frame(width: 8, height: 70).offset(y: -31).rotationEffect(.degrees(38))
                    GlassSlab(shape: Circle(), tint: w.sparkGlass, thickness: 4)
                        .frame(width: 20, height: 20)
                }
            }
            ParallaxLayer(depth: 0.9) {
                GlassBadge(symbol: "arrow.uturn.backward", tint: w.sparkGlass, ink: .white, size: 66)
                    .offset(x: 84, y: 84)
            }
        }
    }
}

private struct ShieldGlass: View {
    let w: CareWorld
    var body: some View {
        ZStack {
            GlassSlab(shape: ShieldShape(), tint: w.glass, thickness: 16, depth: -0.2)
                .frame(width: 198, height: 230)
            GlassSlab(shape: ShieldShape(), tint: w.clearGlass, thickness: 6, depth: 0.15)
                .frame(width: 138, height: 162).offset(y: -4)
            GlassSymbol(name: "ladybug.fill", size: 68, tint: w.pearl, depth: 0.7)
                .offset(y: -6)
        }
    }
}

private struct EyeGlass: View {
    let w: CareWorld
    var body: some View {
        ZStack {
            GlassSlab(shape: LensShape(), tint: w.clearGlass, thickness: 12, depth: -0.3)
                .frame(width: 252, height: 132).offset(y: -10)
            ParallaxLayer(depth: 0.15) {
                ZStack {
                    GlassSlab(shape: Circle(), tint: w.glass, thickness: 8)
                        .frame(width: 106, height: 106)
                    Circle().fill(w.deep.mix(.black, 0.3)).frame(width: 42, height: 42)
                    Circle().fill(.white.opacity(0.9)).frame(width: 13, height: 13).offset(x: -12, y: -12)
                }
                .offset(y: -10)
            }
            GlassSymbol(name: "hand.raised.fill", size: 80, tint: w.pearl, depth: 0.9)
                .offset(x: 94, y: 74)
        }
    }
}

private struct BrowserPieceGlass: View {
    let w: CareWorld
    var body: some View {
        ZStack {
            ParallaxLayer(depth: -0.5) {
                ZStack {
                    GlassSlab(shape: Circle(), tint: w.clearGlass, thickness: 10)
                        .frame(width: 152, height: 152)
                    EngravedSymbol(name: "globe", size: 92, weight: .light)
                }
                .offset(x: -56, y: -44)
            }
            GlassSymbol(name: "puzzlepiece.extension.fill", size: 150, tint: w.glass, thickness: 12, depth: 0.4)
                .offset(x: 36, y: 36)
        }
    }
}

private struct SignalGlass: View {
    let w: CareWorld
    var body: some View {
        ZStack {
            GlassSlab(shape: ArcBand(start: 222, end: 318, thickness: 26), tint: w.clearGlass, thickness: 10, depth: -0.45)
                .frame(width: 268, height: 268)
            GlassSlab(shape: ArcBand(start: 222, end: 318, thickness: 26), tint: w.glass, thickness: 10, depth: 0)
                .frame(width: 188, height: 188)
            GlassSlab(shape: ArcBand(start: 222, end: 318, thickness: 26), tint: w.sparkGlass, thickness: 10, depth: 0.4)
                .frame(width: 108, height: 108)
            GlassSlab(shape: Circle(), tint: w.pearl, thickness: 8, depth: 0.7)
                .frame(width: 34, height: 34)
        }
        .offset(y: 64)
    }
}

private struct PadlockGlass: View {
    let w: CareWorld
    var body: some View {
        ZStack {
            ParallaxLayer(depth: -0.3) {
                ZStack {
                    GlassSlab(shape: ArcBand(start: 180, end: 360, thickness: 24), tint: w.clearGlass, thickness: 10)
                        .frame(width: 132, height: 132)
                    GlassSlab(shape: RoundedRectangle(cornerRadius: 4), tint: w.clearGlass, thickness: 10)
                        .frame(width: 24, height: 44).offset(x: -54, y: 20)
                    GlassSlab(shape: RoundedRectangle(cornerRadius: 4), tint: w.clearGlass, thickness: 10)
                        .frame(width: 24, height: 44).offset(x: 54, y: 20)
                }
                .offset(y: -42)
            }
            ParallaxLayer(depth: 0) {
                ZStack {
                    GlassSlab(shape: RoundedRectangle(cornerRadius: 30, style: .continuous), tint: w.glass, thickness: 14)
                        .frame(width: 188, height: 140)
                    Circle().fill(w.deep.opacity(0.55)).frame(width: 28, height: 28).offset(y: -8)
                    RoundedRectangle(cornerRadius: 5).fill(w.deep.opacity(0.55)).frame(width: 12, height: 34).offset(y: 14)
                }
                .offset(y: 50)
            }
            ParallaxLayer(depth: 0.95) {
                ZStack {
                    GlassBadge(symbol: "video.fill", tint: w.pearl, ink: w.mid, size: 52).offset(x: -116, y: -78)
                    GlassBadge(symbol: "mic.fill", tint: w.pearl, ink: w.mid, size: 52).offset(x: 118, y: -36)
                    GlassBadge(symbol: "location.fill", tint: w.sparkGlass, ink: .white, size: 48).offset(x: 112, y: 122)
                }
            }
        }
    }
}

private struct GaugeGlass: View {
    let w: CareWorld
    @Environment(CarePointer.self) private var pointer: CarePointer?
    var body: some View {
        let sweep = -18 + (pointer?.point.x ?? 0) * 52
        ZStack {
            GlassSlab(shape: ArcBand(start: 150, end: 390, thickness: 36), tint: w.clearGlass, thickness: 12, depth: -0.3)
                .frame(width: 246, height: 246)
            GlassSlab(shape: ArcBand(start: 150, end: 292, thickness: 36), tint: w.glass, thickness: 12, depth: -0.05)
                .frame(width: 246, height: 246)
            ParallaxLayer(depth: 0.4) {
                ZStack {
                    GlassSlab(shape: Capsule(), tint: w.pearl, thickness: 6)
                        .frame(width: 13, height: 100).offset(y: -44)
                        .rotationEffect(.degrees(sweep))
                    GlassSlab(shape: Circle(), tint: w.sparkGlass, thickness: 8)
                        .frame(width: 48, height: 48)
                }
            }
        }
        .offset(y: 16)
    }
}

private struct GearGlass: View {
    let w: CareWorld
    @Environment(CarePointer.self) private var pointer: CarePointer?
    var body: some View {
        let turn = (pointer?.point.x ?? 0) * 24
        ZStack {
            ParallaxLayer(depth: -0.2) {
                ZStack {
                    GlassSlab(shape: GearShape(teeth: 10), tint: w.glass, thickness: 14)
                        .frame(width: 204, height: 204)
                    GlassSlab(shape: Circle(), tint: w.clearGlass, thickness: 6)
                        .frame(width: 70, height: 70)
                }
                .rotationEffect(.degrees(turn))
                .offset(x: -22, y: -22)
            }
            ParallaxLayer(depth: 0.7) {
                ZStack {
                    GlassSlab(shape: Capsule(), tint: w.pearl, thickness: 8)
                        .frame(width: 30, height: 134).offset(y: 52)
                    GlassSlab(shape: ArcBand(start: 300, end: 600, thickness: 22), tint: w.pearl, thickness: 8)
                        .frame(width: 76, height: 76).offset(y: -30)
                }
                .rotationEffect(.degrees(-42))
                .offset(x: 62, y: 46)
            }
        }
    }
}

private struct LiftedAppGlass: View {
    let w: CareWorld
    var body: some View {
        ZStack {
            GlassSlab(shape: RoundedRectangle(cornerRadius: 10, style: .continuous), tint: w.clearGlass, thickness: 6, depth: -0.3)
                .frame(width: 214, height: 24).offset(y: 30)
            ParallaxLayer(depth: 0.3) {
                ZStack {
                    GlassSlab(shape: RoundedRectangle(cornerRadius: 36, style: .continuous), tint: w.glass, thickness: 14)
                        .frame(width: 140, height: 140)
                    EngravedSymbol(name: "square.grid.2x2.fill", size: 50)
                }
                .rotationEffect(.degrees(-8))
                .offset(x: -6, y: -48)
            }
            GlassSlab(shape: TaperShape(taper: 0.06, radius: 18), tint: w.clearGlass, thickness: 12, depth: 0)
                .frame(width: 214, height: 104).offset(y: 86)
            ParallaxLayer(depth: 0.9) {
                GlassBadge(symbol: "minus", tint: w.sparkGlass, ink: .white, size: 56)
                    .offset(x: 70, y: -110)
            }
        }
    }
}

private struct SleepingAppGlass: View {
    let w: CareWorld
    var body: some View {
        ZStack {
            ParallaxLayer(depth: -0.1) {
                ZStack {
                    GlassSlab(shape: RoundedRectangle(cornerRadius: 42, style: .continuous), tint: w.glass, thickness: 14)
                        .frame(width: 172, height: 172)
                    EngravedSymbol(name: "square.grid.2x2.fill", size: 58)
                }
                .offset(x: -10, y: 18)
            }
            GlassSymbol(name: "moon.zzz.fill", size: 94, tint: w.pearl, depth: 0.8)
                .offset(x: 82, y: -84)
            ParallaxLayer(depth: 1) {
                ZStack {
                    Circle().fill(.white.opacity(0.55)).frame(width: 9, height: 9).offset(x: -112, y: -62)
                    Circle().fill(.white.opacity(0.4)).frame(width: 6, height: 6).offset(x: -92, y: -96)
                    Circle().fill(.white.opacity(0.5)).frame(width: 7, height: 7).offset(x: 104, y: 92)
                }
            }
        }
    }
}

private struct PanelPlugGlass: View {
    let w: CareWorld
    var body: some View {
        ZStack {
            ParallaxLayer(depth: -0.3) {
                ZStack {
                    GlassSlab(shape: RoundedRectangle(cornerRadius: 26, style: .continuous), tint: w.clearGlass, thickness: 12)
                        .frame(width: 204, height: 156)
                    VStack(alignment: .leading, spacing: 18) {
                        ForEach([110.0, 84.0, 124.0], id: \.self) { width in
                            HStack(spacing: 12) {
                                Capsule().fill(w.tileGradient).frame(width: 34, height: 18)
                                Capsule().fill(.white.opacity(0.42)).frame(width: width * 0.8, height: 8)
                            }
                        }
                    }
                }
                .offset(x: -22, y: -24)
            }
            GlassSymbol(name: "powerplug.fill", size: 112, tint: w.pearl, depth: 0.7)
                .rotationEffect(.degrees(-30)).offset(x: 70, y: 74)
        }
    }
}

private struct UpdateOrbGlass: View {
    let w: CareWorld
    var body: some View {
        ZStack {
            GlassSlab(shape: ArcBand(start: 200, end: 320, thickness: 15), tint: w.sparkGlass, thickness: 6, depth: 0.3)
                .frame(width: 266, height: 266)
            GlassSlab(shape: ArcBand(start: 20, end: 140, thickness: 15), tint: w.clearGlass, thickness: 6, depth: 0.3)
                .frame(width: 266, height: 266)
            GlassSlab(shape: Circle(), tint: w.glass, thickness: 14, depth: -0.2)
                .frame(width: 196, height: 196)
            GlassSymbol(name: "arrow.up", size: 104, tint: w.pearl, weight: .heavy, depth: 0.6)
        }
    }
}

private struct SunburstGlass: View {
    let w: CareWorld
    @Environment(CarePointer.self) private var pointer: CarePointer?
    var body: some View {
        let turn = (pointer?.point.x ?? 0) * 14
        ZStack {
            ring(size: 272, band: 30, depth: -0.55, turn: -turn, segments: [(-88, -34, w.clearGlass), (-30, 38, w.glass), (42, 118, w.clearGlass),
                                                                            (122, 150, w.sparkGlass), (154, 238, w.glass)])
            ring(size: 198, band: 32, depth: 0, turn: turn * 0.5, segments: [(-88, 8, w.sparkGlass), (12, 108, w.glass),
                                                                           (112, 198, w.pearl), (202, 268, w.glass)])
            ring(size: 124, band: 34, depth: 0.5, turn: turn, segments: [(-88, 58, w.glass), (62, 168, w.sparkGlass), (172, 268, w.clearGlass)])
            ParallaxLayer(depth: 0.85) {
                GlassBadge(symbol: "house.fill", tint: w.pearl, ink: w.mid, size: 52)
            }
        }
    }

    private func ring(size: CGFloat, band: CGFloat, depth: CGFloat, turn: Double,
                      segments: [(Double, Double, GlassTint)]) -> some View {
        ParallaxLayer(depth: depth) {
            ZStack {
                ForEach(segments.indices, id: \.self) { index in
                    let segment = segments[index]
                    GlassSlab(shape: ArcBand(start: segment.0, end: segment.1, thickness: band), tint: segment.2, thickness: 8)
                        .frame(width: size, height: size)
                }
            }
            .rotationEffect(.degrees(turn))
        }
    }
}

private struct PaperStackGlass: View {
    let w: CareWorld
    var body: some View {
        ZStack {
            sheet(w.clearGlass, depth: -0.5).rotationEffect(.degrees(-12)).offset(x: -50, y: 4)
            sheet(w.sparkGlass, depth: -0.15).rotationEffect(.degrees(9)).offset(x: 48, y: -6)
            ParallaxLayer(depth: 0.3) {
                ZStack {
                    GlassSlab(shape: SheetShape(), tint: w.glass, thickness: 12)
                        .frame(width: 172, height: 222)
                    GlassSlab(shape: SheetFoldShape(), tint: w.pearl, thickness: 3)
                        .frame(width: 172, height: 222)
                    VStack(alignment: .leading, spacing: 14) {
                        ForEach([104.0, 78.0, 112.0, 64.0], id: \.self) { width in
                            Capsule().fill(.white.opacity(0.5)).frame(width: width, height: 8)
                        }
                    }
                    .offset(x: -10, y: 22)
                }
                .offset(y: 16)
            }
            ParallaxLayer(depth: 0.95) {
                GlassBadge(symbol: "clock.fill", tint: w.pearl, ink: w.mid, size: 66)
                    .offset(x: 70, y: 104)
            }
        }
    }

    private func sheet(_ tint: GlassTint, depth: CGFloat) -> some View {
        ParallaxLayer(depth: depth) {
            ZStack {
                GlassSlab(shape: SheetShape(), tint: tint, thickness: 8)
                GlassSlab(shape: SheetFoldShape(), tint: w.pearl, thickness: 2)
            }
            .frame(width: 150, height: 196)
        }
    }
}

/// A download arrow over an open glass tray where forgotten files pile up.
private struct DownloadsTrayGlass: View {
    let w: CareWorld
    var body: some View {
        ZStack {
            GlassSlab(shape: RoundedRectangle(cornerRadius: 10, style: .continuous), tint: w.clearGlass, thickness: 6, depth: -0.4)
                .frame(width: 222, height: 26).offset(y: 30)
            ParallaxLayer(depth: -0.15) {
                ZStack {
                    GlassSlab(shape: SheetShape(), tint: w.sparkGlass, thickness: 6)
                        .frame(width: 96, height: 124).rotationEffect(.degrees(-12)).offset(x: -48, y: 36)
                    GlassSlab(shape: SheetShape(), tint: w.glass, thickness: 6)
                        .frame(width: 96, height: 124).rotationEffect(.degrees(9)).offset(x: 40, y: 30)
                }
            }
            GlassSlab(shape: TaperShape(taper: 0.07, radius: 20), tint: w.clearGlass, thickness: 12, depth: 0)
                .frame(width: 238, height: 98).offset(y: 92)
            GlassSymbol(name: "arrow.down", size: 98, tint: w.pearl, weight: .heavy, depth: 0.7)
                .offset(y: -92)
            ParallaxLayer(depth: 0.95) {
                GlassBadge(symbol: "hourglass", tint: w.sparkGlass, ink: .white, size: 56)
                    .offset(x: 104, y: 112)
            }
        }
    }
}

private struct TwinCardsGlass: View {
    let w: CareWorld
    var body: some View {
        ZStack {
            card(w.glass, depth: -0.3).rotationEffect(.degrees(-10)).offset(x: -42, y: -8)
            card(w.clearGlass, depth: 0.3).rotationEffect(.degrees(8)).offset(x: 44, y: 18)
            ParallaxLayer(depth: 0.95) {
                GlassBadge(symbol: "equal", tint: w.sparkGlass, ink: .white, size: 58)
                    .offset(x: 96, y: -96)
            }
        }
    }

    private func card(_ tint: GlassTint, depth: CGFloat) -> some View {
        ParallaxLayer(depth: depth) {
            ZStack {
                GlassSlab(shape: RoundedRectangle(cornerRadius: 26, style: .continuous), tint: tint, thickness: 10)
                    .frame(width: 152, height: 184)
                EngravedSymbol(name: "photo", size: 58, weight: .medium)
            }
        }
    }
}

private struct ShredderGlass: View {
    let w: CareWorld
    private let strips: [CGFloat] = [70, 88, 62, 94, 74, 82]
    var body: some View {
        ZStack {
            ParallaxLayer(depth: 0.5) {
                HStack(spacing: 9) {
                    ForEach(strips.indices, id: \.self) { index in
                        GlassSlab(shape: Capsule(), tint: index.isMultiple(of: 2) ? w.pearl : w.sparkGlass, thickness: 4)
                            .frame(width: 15, height: strips[index])
                    }
                }
                .offset(y: 104)
            }
            GlassSlab(shape: SheetShape(), tint: w.clearGlass, thickness: 8, depth: -0.3)
                .frame(width: 142, height: 152).offset(y: -72)
            ParallaxLayer(depth: 0) {
                ZStack {
                    GlassSlab(shape: RoundedRectangle(cornerRadius: 24, style: .continuous), tint: w.glass, thickness: 14)
                        .frame(width: 234, height: 94)
                    Capsule().fill(w.deep.opacity(0.6)).frame(width: 164, height: 10).offset(y: -26)
                    EngravedSymbol(name: "scissors", size: 30, weight: .bold).offset(y: 12)
                }
                .offset(y: 30)
            }
        }
    }
}
