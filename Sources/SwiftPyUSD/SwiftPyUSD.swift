// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftPy
import Gf
import Sdf
import Usd
import UsdGeom
import UsdMedia
import UsdSkel
import UsdUtils

@MainActor
public func initialize() {
    PyBind.module("pxr") { pxr in }
    
    Gf.bindModule()
    Sdf.bindModule()
    Usd.bindModule()
    UsdGeom.bindModule()
    UsdMedia.bindModule()
    UsdSkel.bindModule()
    UsdUtils.bindModule()
}
