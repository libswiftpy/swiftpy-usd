//
//  Usd.swift
//  swiftpy-usd
//
//  Created by Tibor Felföldy on 2026-04-28.
//

import SwiftPy
import pxr
import Sdf

@MainActor
public func bindModule() {
    PyBind.module("pxr.Usd") { Usd in
        Usd.classes(
            Stage.self,
            Prim.self,
            Attribute.self,
            References.self,
            Relationship.self,
        )
    }
}
