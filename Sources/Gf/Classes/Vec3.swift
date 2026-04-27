//
//  Vec3.swift
//  swiftpy-usd
//
//  Created by Tibor Felföldy on 2026-04-27.
//

import pxr
import SwiftPy

@Scriptable(convertsToSnakeCase: false)
public class Vec3d: ClassWrapper<pxr.GfVec3d> {
    public init(x: Double, y: Double, z: Double) {
        super.init(value: GfVec3d(x, y, z))
    }
}
