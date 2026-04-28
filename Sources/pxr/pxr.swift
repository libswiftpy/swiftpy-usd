//
//  pxr.swift
//  swiftpy-usd
//
//  Created by Tibor Felföldy on 2026-04-27.
//

import OpenUSD
import CxxStdlib

public typealias pxr = pxrInternal_v0_25_8__pxrReserved__

// MARK: - Sdf

public typealias SdfPath = pxr.SdfPath
public typealias SdfPathVector = pxr.SdfPathVector
public typealias SdfAssetPath = pxr.SdfAssetPath
public typealias SdfLayer = pxr.SdfLayer
public typealias SdfTimeCode = pxr.SdfTimeCode
public typealias SdfValueTypeName = pxr.SdfValueTypeName
public typealias SdfLayerOffset = pxr.SdfLayerOffset

public typealias SdfVariability = pxr.SdfVariability
public let SdfVariabilityUniform = pxr.SdfVariabilityUniform
public let SdfVariabilityVarying = pxr.SdfVariabilityVarying

public typealias GfVec3d = pxr.GfVec3d

// MARK: - Usd

public typealias UsdStage = pxr.UsdStage
public typealias UsdStageRefPtr = pxr.UsdStageRefPtr
public typealias UsdPrim = pxr.UsdPrim
public typealias UsdAttribute = pxr.UsdAttribute
public typealias UsdReferences = pxr.UsdReferences
public typealias UsdRelationship = pxr.UsdRelationship
public typealias UsdTimeCode = pxr.UsdTimeCode

// MARK: - UsdMedia

public typealias UsdMediaSpatialAudio = pxr.UsdMediaSpatialAudio

// MARK: - UsdSkel

public typealias UsdSkelAnimation = pxr.UsdSkelAnimation
public typealias UsdSkelBindingAPI = pxr.UsdSkelBindingAPI

// MARK: - UsdGeom

public typealias UsdGeomXform = pxr.UsdGeomXform
public typealias UsdGeomXformable = pxr.UsdGeomXformable
public typealias UsdGeomXformOp = pxr.UsdGeomXformOp
public typealias UsdGeomSphere = pxr.UsdGeomSphere

public let UsdGeomSetStageMetersPerUnit = pxr.UsdGeomSetStageMetersPerUnit
public let UsdGeomSetStageUpAxis = pxr.UsdGeomSetStageUpAxis

// MARK: - UsdUtils

public let UsdUtilsCreateNewARKitUsdzPackage = pxr.UsdUtilsCreateNewARKitUsdzPackage

public typealias TfToken = pxr.TfToken

public typealias VtValue = pxr.VtValue

public extension [String] {
    func vtStringArray() -> pxr.VtStringArray {
        var array = pxr.VtStringArray()
        for element in self {
            array.push_back(std.string(element))
        }
        return array
    }
    
    func vtTokenArray() -> pxr.VtTokenArray {
        var array = pxr.VtTokenArray()
        for element in self {
            array.push_back(pxr.TfToken(element))
        }
        return array
    }
}

public extension [Float] {
    func vtArray() -> pxr.VtFloatArray {
        var array = pxr.VtFloatArray()
        for element in self {
            array.push_back(element)
        }
        return array
    }
}

public typealias PxrOverlay = OpenUSD.Overlay

open class ClassWrapper<Object> {
    public var value: Object

    public init(value: Object) {
        self.value = value
    }
}
