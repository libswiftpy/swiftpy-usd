//
//  TimeCode.swift
//  swiftpy-usd
//
//  Created by Tibor Felföldy on 2026-04-28.
//

import pxr
import SwiftPy

/// Represent a time value, which may be either numeric, holding a double value, or a sentinel value TimeCode.Default()
@Scriptable(convertsToSnakeCase: false)
public class TimeCode: ClassWrapper<pxr.UsdTimeCode> {
    public init(_ time: Int? = nil) {
        if let time {
            super.init(value: UsdTimeCode(time))
        } else {
            super.init(value: .Default())
        }
    }
}
