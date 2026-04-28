//
//  References.swift
//  swiftpy-usd
//
//  Created by Tibor Felföldy on 2026-04-28.
//

import SwiftPy
import pxr
import Sdf
import CxxStdlib

/// References are the primary operator for 'encapsulated aggregation' of scene description.
@Scriptable(convertsToSnakeCase: false)
public class References: ClassWrapper<pxr.UsdReferences> {
    /// Adds a reference to the reference listOp at the current EditTarget.
    public func AddReference(identifier: String, primPath: Sdf.Path) -> Bool {
        value.AddReference(std.string(identifier), primPath.value, pxr.SdfLayerOffset(0, 1))
    }
}
