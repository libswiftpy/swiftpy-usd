//
//  XFormable.swift
//  swiftpy-usd
//
//  Created by Tibor Felföldy on 2026-04-28.
//

import SwiftPy
import pxr
import Usd

/// Base class for all transformable prims, which allows arbitrary sequences of component affine transformations to be encoded.
@Scriptable(convertsToSnakeCase: false)
public class Xformable: ClassWrapper<pxr.UsdGeomXformable> {
    /// Construct an Xformable on a prim. Equivalent to Xformable.Get(prim.GetStage(), prim.GetPath())
    public init(prim: Usd.Prim) {
        super.init(value: pxr.UsdGeomXformable(prim.value))
    }

    /// Get a translate operation from the local stack represented by this xformable.
    public func GetTranslateOp() -> XformOp? {
        let op = value.GetTranslateOp(pxr.TfToken())
        guard op.IsDefined() else { return nil }
        return XformOp(value: op)
    }

    /// Add a translate operation to the local stack represented by this xformable.
    public func AddTranslateOp() throws(PythonError) -> XformOp {
        let op = value.AddTranslateOp(pxr.UsdGeomXformOp.Precision.PrecisionDouble, pxr.TfToken())
        guard op.IsDefined() else {
            throw .AssertionError("Failed to Add translateOp to the prim.")
        }
        return XformOp(value: op)
    }
}
