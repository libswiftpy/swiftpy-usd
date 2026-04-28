//
//  Sphere.swift
//  swiftpy-usd
//
//  Created by Tibor Felföldy on 2026-04-28.
//

import SwiftPy
import pxr
import Usd
import Sdf

@Scriptable(convertsToSnakeCase: false)
@MainActor
public class Sphere: ClassWrapper<pxr.UsdGeomSphere> {
    /// Ensure a Sphere prim is defined at the given path on the provided stage.
    public static func Define(stage: Usd.Stage, path: object) throws -> Sphere {
        let stagePtr = PxrOverlay.TfWeakPtr(stage.value)
        let path = try Path(path) ?? Path(path: .cast(path))
        let sphere = pxr.UsdGeomSphere.Define(stagePtr, path.value)
        return Sphere(value: sphere)
    }
}
