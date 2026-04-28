// The Swift Programming Language
// https://docs.swift.org/swift-book

import OpenUSD
import SwiftPy
import Gf
import Sdf
import Usd
import UsdUtils

public typealias pxr = pxrInternal_v0_25_8__pxrReserved__

@MainActor
public enum SwiftPyUSD {
    public static func initialize() {
        Gf.bindModule()
        Sdf.bindModule()
        Usd.bindModule()
        UsdUtils.bindModule()

        PyBind.module("pxr") { pxr in
            pxr.classes(
                UsdGeom.self,
                UsdSkel.self,
                UsdMedia.self,
            )
        }
    }
}
