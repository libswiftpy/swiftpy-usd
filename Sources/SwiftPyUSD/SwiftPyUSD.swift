// The Swift Programming Language
// https://docs.swift.org/swift-book

import OpenUSD
import SwiftPy

public typealias pxr = pxrInternal_v0_25_8__pxrReserved__

@MainActor
public enum SwiftPyUSD {
    public static func initialize() {
        PyBind.module("pxr") { pxr in
            pxr.classes(
                Usd.self,
                UsdGeom.self,
                UsdSkel.self,
                UsdMedia.self,
                UsdUtils.self,
                Sdf.self,
                Gf.self,
            )
        }
    }
}
