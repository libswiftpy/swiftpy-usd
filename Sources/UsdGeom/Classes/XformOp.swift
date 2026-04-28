//
//  XformOp.swift
//  swiftpy-usd
//
//  Created by Tibor Felföldy on 2026-04-28.
//

import SwiftPy
import pxr
import Gf
import Usd

/// Schema wrapper for Usd.Attribute for authoring and computing transformation operations, as consumed by Xformable schema.
@Scriptable(convertsToSnakeCase: false)
public class XformOp: ClassWrapper<pxr.UsdGeomXformOp> {
    /// Set the attribute value of the XformOp at time,
    public func Set(vec3d: Gf.Vec3d, time: Int? = nil) -> Bool {
        let timeCode = Usd.TimeCode(time)
        return value.Set(vec3d.value, timeCode.value)
    }
}
