//
//  Sdf.swift
//  swiftpy-usd
//
//  Created by Tibor Felföldy on 2026-04-27.
//

import SwiftPy
import pxr

@MainActor
public func bindModule() {
    PyBind.module("Sdf") { Sdf in
        Sdf.classes(
            AssetPath.self,
            Path.self,
            TimeCode.self,
            Variability.self,
            ValueTypeNames.self,
        )
        
        Sdf.VariabilityUniform = VariabilityUniform
        Sdf.VariabilityVarying = VariabilityVarying
    }
}
