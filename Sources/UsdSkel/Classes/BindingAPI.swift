//
//  BindingAPI.swift
//  swiftpy-usd
//
//  Created by Tibor Felföldy on 2026-04-28.
//

import SwiftPy
import pxr
import Usd

/// Provides API for authoring and extracting all the skinning-related data that lives in the “geometry hierarchy” of prims and models that want to be skeletally deformed.
@Scriptable(convertsToSnakeCase: false)
public class BindingAPI: ClassWrapper<pxr.UsdSkelBindingAPI> {
    /// Creates an animation source to be bound to Skeleton primitives at or beneath the location at which this property is defined.
    public func CreateAnimationSourceRel() throws(PythonError) -> Usd.Relationship {
        let rel = value.CreateAnimationSourceRel()
        guard Bool(rel) else {
            throw .AssertionError("Failed to create animation source relationship")
        }
        return Usd.Relationship(value: rel)
    }

    /// Applies this single-apply API schema to the given prim.
    public static func Apply(prim: Usd.Prim) -> BindingAPI {
        BindingAPI(value: pxr.UsdSkelBindingAPI.Apply(prim.value))
    }
}
