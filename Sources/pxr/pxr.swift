//
//  pxr.swift
//  swiftpy-usd
//
//  Created by Tibor Felföldy on 2026-04-27.
//

import OpenUSD
import CxxStdlib

public typealias pxr = pxrInternal_v0_25_8__pxrReserved__
public typealias SdfPath = pxr.SdfPath
public typealias SdfAssetPath = pxr.SdfAssetPath
public typealias SdfLayer = pxr.SdfLayer
public typealias SdfTimeCode = pxr.SdfTimeCode
public typealias SdfValueTypeName = pxr.SdfValueTypeName

public typealias SdfVariability = pxr.SdfVariability
public let SdfVariabilityUniform = pxr.SdfVariabilityUniform
public let SdfVariabilityVarying = pxr.SdfVariabilityVarying

public typealias GfVec3d = pxr.GfVec3d

// MARK: - UsdUtils

public let UsdUtilsCreateNewARKitUsdzPackage = pxr.UsdUtilsCreateNewARKitUsdzPackage

open class ClassWrapper<Object> {
    public var value: Object

    public init(value: Object) {
        self.value = value
    }
}
