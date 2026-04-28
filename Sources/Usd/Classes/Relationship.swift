//
//  Relationship.swift
//  swiftpy-usd
//
//  Created by Tibor Felföldy on 2026-04-28.
//

import SwiftPy
import pxr
import Sdf

/// A Relationship creates dependencies between scenegraph objects by
/// allowing a prim to target other prims, attributes, or relationships.
@Scriptable(convertsToSnakeCase: false)
public class Relationship: ClassWrapper<pxr.UsdRelationship> {
    /// Make the authoring layer’s opinion of the targets list explicit, and set exactly to targets
    public func SetTargets(targets: [Sdf.Path]) -> Bool {
        var vector = pxr.SdfPathVector()
        for target in targets {
            vector.push_back(target.value)
        }
        return value.SetTargets(vector)
    }
}
