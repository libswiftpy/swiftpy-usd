//
//  ValueTypeNames.swift
//  swiftpy-usd
//
//  Created by Tibor Felföldy on 2026-04-27.
//

import pxr
import SwiftPy

@Scriptable(convertsToSnakeCase: false)
public class ValueTypeName: ClassWrapper<pxr.SdfValueTypeName> {}

extension ValueTypeName: @MainActor CustomStringConvertible {
    public var description: String {
        String(describing: value)
    }
}

@Scriptable(convertsToSnakeCase: false)
@MainActor
public class ValueTypeNames {
    // TODO: Fix `public` static property binding.
    static let Asset = ValueTypeName(value: .Asset)
    static let TimeCode = ValueTypeName(value: .TimeCode)
    static let StringArray = ValueTypeName(value: .StringArray)
    static let Token = ValueTypeName(value: .Token)
}
