//
//  Gf.swift
//  swiftpy-usd
//
//  Created by Tibor Felföldy on 2026-04-27.
//

import SwiftPy

@MainActor
public func bindModule() {
    PyBind.module("pxr.Gf") { Gf in
        Gf.classes(
            Vec3d.self,
        )
    }
}
