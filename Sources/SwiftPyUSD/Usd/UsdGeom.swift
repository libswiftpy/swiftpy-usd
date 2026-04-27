//
//  UsdGeom.swift
//  openusd
//
//  Created by Tibor Felföldy on 2025-11-01.
//

import SwiftPy
import OpenUSD
import Gf

@MainActor
@Scriptable(convertsToSnakeCase: false)
final class UsdGeom {
    static let Xform: object? = UsdGeomXform.pyTypeObject
    static let Sphere: object? = UsdGeomSphere.pyTypeObject
    static let Tokens: object? = UsdGeomTokens.pyTypeObject
    static let Xformable: object? = UsdGeomXformable.pyTypeObject

    /// Author stage's metersPerUnit. Returns True if metersPerUnit was successfully set.
    static func SetStageMetersPerUnit(stage: UsdStage, metersPerUnit: Double) -> Bool {
        return pxr.UsdGeomSetStageMetersPerUnit(stage.weakPtr, metersPerUnit)
    }

    /// Set stage's upAxis to axis, which must be one of UsdGeom.Tokens.y or UsdGeom.Tokens.z. Returns true if upAxis was successfully set.
    static func SetStageUpAxis(stage: UsdStage, token: String) -> Bool {
        pxr.UsdGeomSetStageUpAxis(stage.weakPtr, pxr.TfToken(token))
    }
}

@Scriptable("UsdGeom.Tokens")
class UsdGeomTokens: PythonConvertible {
    static let y = String(pxr.TfToken.UsdGeomTokens.y.GetString())
    static let z = String(pxr.TfToken.UsdGeomTokens.z.GetString())
}

@Scriptable("UsdGeom.Xform", convertsToSnakeCase: false)
final class UsdGeomXform: PythonConvertible {
    internal let base: pxr.UsdGeomXform

    internal init(base: pxr.UsdGeomXform) {
        self.base = base
    }

    static func Define(stage: UsdStage, path: String) -> UsdGeomXform {
        let base = pxr.UsdGeomXform.Define(stage.weakPtr, pxr.SdfPath(path))
        return UsdGeomXform(base: base)
    }
}

@Scriptable("UsdGeom.Xformable", convertsToSnakeCase: false)
final class UsdGeomXformable: PythonConvertible {
    internal let base: pxr.UsdGeomXformable
    
    init(prim: UsdPrim) {
        base = pxr.UsdGeomXformable(prim.base)
    }
    
    func GetTranslateOp() -> UsdGeomXformOp? {
        let op = base.GetTranslateOp(pxr.TfToken())
        guard op.IsDefined() else { return nil }
        return UsdGeomXformOp(base: op)
    }
    
    /// Add a translate operation to the local stack represented by this xformable.
    func AddTranslateOp() -> UsdGeomXformOp? {
        let op = base.AddTranslateOp(pxr.UsdGeomXformOp.Precision.PrecisionDouble, pxr.TfToken())
        guard op.IsDefined() else {  return nil }
        return UsdGeomXformOp(base: op)
    }
}

@Scriptable("UsdGeom.XformOp", convertsToSnakeCase: false)
final class UsdGeomXformOp: PythonConvertible {
    internal let base: pxr.UsdGeomXformOp

    internal init(base: pxr.UsdGeomXformOp) {
        self.base = base
    }
    
    func Set(value: Gf.Vec3d) -> Bool {
        base.Set(value.value, pxr.UsdTimeCode.Default())
    }
}

@Scriptable("UsdGeom.Sphere", convertsToSnakeCase: false)
final class UsdGeomSphere: PythonConvertible {
    internal let base: pxr.UsdGeomSphere

    internal init(base: pxr.UsdGeomSphere) {
        self.base = base
    }

    static func Define(stage: UsdStage, path: String) -> UsdGeomSphere {
        let base = pxr.UsdGeomSphere.Define(stage.weakPtr, pxr.SdfPath(path))
        return UsdGeomSphere(base: base)
    }
}
