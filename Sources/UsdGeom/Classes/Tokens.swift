//
//  Tokens.swift
//  swiftpy-usd
//
//  Created by Tibor Felföldy on 2026-04-28.
//

import SwiftPy
import pxr

@Scriptable(convertsToSnakeCase: false)
public class Tokens {
    static var x: String {
        String(pxr.TfToken.UsdGeomTokens.x.GetString())
    }
    static var y: String {
        String(TfToken.UsdGeomTokens.y.GetString())
    }
    static var z: String {
        String(TfToken.UsdGeomTokens.z.GetString())
    }
}
