// The Swift Programming Language
// https://docs.swift.org/swift-book

import OpenUSD
import SwiftPy

public typealias pxr = pxrInternal_v0_25_8__pxrReserved__

@MainActor
public enum SwiftPyUSD {
    public static func initialize() {
        PyBind.module("pxr", [
            Usd.self,
            UsdGeom.self,
            UsdUtils.self,
            UsdSkel.self,
            Sdf.self,
            Gf.self,
        ])
    }
}
