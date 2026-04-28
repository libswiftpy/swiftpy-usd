//
//  UsdGeom.swift
//  swiftpy-usd
//
//  Created by Tibor Felföldy on 2026-04-28.
//

import SwiftPy
import Usd
import pxr

/// Author stage's metersPerUnit. Returns True if metersPerUnit was successfully set.
public func SetStageMetersPerUnit(stage: Stage, metersPerUnit: Double) -> Bool {
    let stagePtr = PxrOverlay.TfWeakPtr(stage.value)
    return pxr.UsdGeomSetStageMetersPerUnit(stagePtr, metersPerUnit)
}

/// Set stage's upAxis to axis, which must be one of Tokens.y or Tokens.z. Returns true if upAxis was successfully set.
public func SetStageUpAxis(stage: Stage, token: String) -> Bool {
    let stagePtr = PxrOverlay.TfWeakPtr(stage.value)
    return pxr.UsdGeomSetStageUpAxis(stagePtr, TfToken(token))
}

@MainActor
public func bindModule() {
    PyBind.module("pxr.UsdGeom") { UsdGeom in
        UsdGeom.classes(
            Sphere.self,
            Tokens.self,
            Xform.self,
            Xformable.self,
            XformOp.self,
        )

        UsdGeom.def(
            "SetStageMetersPerUnit(stage: pxr.Usd.Stage, metersPerUnit: float) -> bool",
            docstring: "Author stage's metersPerUnit. Returns True if metersPerUnit was successfully set."
        ) { argc, argv in
            PyBind.function(argc, argv, SetStageMetersPerUnit)
        }

        UsdGeom.def(
            "SetStageUpAxis(stage: pxr.Usd.Stage, token: str) -> bool",
            docstring: "Set stage's upAxis to axis, which must be one of Tokens.y or Tokens.z. Returns true if upAxis was successfully set."
        ) { argc, argv in
            PyBind.function(argc, argv, SetStageUpAxis)
        }
    }
}
