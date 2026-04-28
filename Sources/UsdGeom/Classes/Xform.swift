//
//  XForm.swift
//  swiftpy-usd
//
//  Created by Tibor Felföldy on 2026-04-28.
//

import pxr
import SwiftPy
import Usd
import Sdf

/// Concrete prim schema for a transform, which implements Xformable.
@Scriptable(convertsToSnakeCase: false)
@MainActor
public class Xform: ClassWrapper<pxr.UsdGeomXform> {
    /// Ensure an Xform prim is defined at the given path on the provided stage.
    public static func Define(stage: Usd.Stage, path: object) throws -> Xform {
        let path = try Path(path) ?? Path(path: .cast(path))
        let stagePtr = PxrOverlay.TfWeakPtr(stage.value)
        let xform = pxr.UsdGeomXform.Define(stagePtr, path.value)
        return Xform(value: xform)
    }
}
