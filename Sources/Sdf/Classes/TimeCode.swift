//
//  TimeCode.swift
//  swiftpy-usd
//
//  Created by Tibor Felföldy on 2026-04-27.
//

import pxr
import SwiftPy

@Scriptable(convertsToSnakeCase: false)
public class TimeCode: ClassWrapper<pxr.SdfTimeCode> {
    public init(value: Double) {
        super.init(value: pxr.SdfTimeCode(value))
    }
}
