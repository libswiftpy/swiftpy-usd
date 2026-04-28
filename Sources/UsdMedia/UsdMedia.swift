//
//  UsdMedia.swift
//  swiftpy-usd
//
//  Created by Tibor Felföldy on 2026-04-28.
//

import SwiftPy

@MainActor
public func bindModule() {
    PyBind.module("pxr.UsdMedia") { UsdMedia in
        UsdMedia.classes(
            SpatialAudio.self,
        )
    }
}
