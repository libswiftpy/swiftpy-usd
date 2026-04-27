// The Swift Programming Language
// https://docs.swift.org/swift-book

import OpenUSD
import SwiftPy
import Sdf

public typealias pxr = pxrInternal_v0_25_8__pxrReserved__

@MainActor
public enum SwiftPyUSD {
    public static func initialize() {
        Sdf.bindModule()

        PyBind.module("pxr") { pxr in
            pxr.classes(
                Usd.self,
                UsdGeom.self,
                UsdSkel.self,
                UsdMedia.self,
                UsdUtils.self,
                Gf.self,
            )
        }
    }
}
