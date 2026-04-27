//
//  Variability.swift
//  swiftpy-usd
//
//  Created by Tibor Felföldy on 2026-04-27.
//

import SwiftPy
import pxr

@MainActor
public let VariabilityUniform = Variability(value: pxr.SdfVariabilityUniform)
@MainActor
public let VariabilityVarying = Variability(value: pxr.SdfVariabilityVarying)

@Scriptable(convertsToSnakeCase: false)
public class Variability: ClassWrapper<pxr.SdfVariability> {}
