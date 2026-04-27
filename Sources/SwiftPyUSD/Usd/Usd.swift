//
//  Usd.swift
//  openusd
//
//  Created by Tibor Felföldy on 2025-10-31.
//

import SwiftPy
import OpenUSD
import Sdf

@MainActor
@Scriptable(convertsToSnakeCase: false)
public class Usd {
    static let Stage: object? = py.tpobject(UsdStage.pyType)
    static let Prim: object? = py.tpobject(UsdPrim.pyType)
    static let References: object? = py.tpobject(UsdReferences.pyType)
    static let Relationship: object? = py.tpobject(UsdRelationship.pyType)
}

@Scriptable("Usd.Stage", convertsToSnakeCase: false)
public class UsdStage {
    internal let stage: pxr.UsdStage
    internal var weakPtr: pxr.UsdStageWeakPtr {
        Overlay.TfWeakPtr(stage)
    }
    
    internal init(_ stage: pxr.UsdStageRefPtr) throws {
        guard let stage = Overlay.DereferenceOrNil(stage) else {
            throw PythonError.AssertionError("Failed to create stage")
        }
        self.stage = stage
    }
    
    func DefinePrim(path: String, typeName: String = "") -> UsdPrim? {
        let path = pxr.SdfPath(path)
        let typeName = pxr.TfToken(typeName)
        let prim = stage.DefinePrim(path, typeName)
        return UsdPrim(prim)
    }
    
    func GetPrimAtPath(path: String) -> UsdPrim? {
        let path = pxr.SdfPath(path)
        let prim = stage.GetPrimAtPath(path)
        return UsdPrim(prim)
    }

    /// Traverse the active, loaded, defined, non-abstract prims on this stage depth-first.
    func Traverse() -> [UsdPrim] {
        stage.Traverse().compactMap(UsdPrim.init)
    }

    func ExportToString() -> String? {
        stage.ExportToString()
    }
    
    /// Calls SdfLayer.Save on all dirty layers contributing to this stage except session layers and sublayers of session layers.
    func Save() {
        stage.Save()
    }

    /// Returns the stage’s start timeCode.
    func GetStartTimeCode() -> Double {
        stage.GetStartTimeCode()
    }
    
    /// Sets the stage’s start timeCode.
    func SetStartTimeCode(timeCode: Double) {
        stage.SetStartTimeCode(timeCode)
    }
    
    /// Sets the stage's end timeCode.
    func SetEndTimeCode(timeCode: Double) {
        stage.SetEndTimeCode(timeCode)
    }
    
    /// Sets the stage's framesPerSecond value.
    func SetFramesPerSecond(fps: Double) {
        stage.SetFramesPerSecond(fps)
    }
    
    /// Sets the stage's timeCodesPerSecond value.
    func SetTimeCodesPerSecond(timeCodesPerSecond: Double) {
        stage.SetTimeCodesPerSecond(timeCodesPerSecond)
    }

    static func CreateNew(name: String) throws -> UsdStage? {
        try UsdStage(pxr.UsdStage.CreateNew(std.string(name)))
    }

    static func CreateInMemory() throws -> UsdStage? {
        try UsdStage(pxr.UsdStage.CreateInMemory())
    }
    
    static func Open(name: String) throws -> UsdStage? {
        try UsdStage(pxr.UsdStage.Open(std.string(name)))
    }
}

extension UsdStage: CustomStringConvertible {
    public var description: String {
        ExportToString() ?? ""
    }
}

@Scriptable("Usd.Prim", convertsToSnakeCase: false)
@MainActor
public class UsdPrim: ObjectWrapper<pxr.UsdPrim>, Sendable {
    /// Author ‘active’ metadata for this prim at the current EditTarget.
    public func SetActive(_ value: Bool) -> Bool {
        base.SetActive(value)
    }
    
    /// Return the complete scene path to this object on its Stage.
    public func GetPath() -> Sdf.Path {
        Sdf.Path(base.GetPath())
    }

    public func GetPropertyNames() -> [String] {
        base.GetPropertyNames(Overlay.DefaultPropertyPredicateFunc)
            .map { token in
                String(token.GetString())
            }
    }

    public func CreateAttribute(name: String, typeName: Sdf.ValueTypeName, custom: Bool = true, variability: Sdf.Variability? = nil) -> UsdAttribute? {
        let variability = variability ?? Sdf.VariabilityVarying
        let attribute = base.CreateAttribute(pxr.TfToken(name), typeName.value, custom, variability.value)
        return UsdAttribute(attribute)
    }
    
    public func GetAttribute(name: String) -> UsdAttribute? {
        UsdAttribute(base.GetAttribute(pxr.TfToken(name)))
    }

    public func GetReferences() -> UsdReferences {
        UsdReferences(base: base.GetReferences())
    }
    
    public func CreateRelationship(name: String, custom: Bool = true) -> UsdRelationship? {
        let relationship = base.CreateRelationship(pxr.TfToken(name), custom)
        return UsdRelationship(relationship)
    }
}

@Scriptable("Usd.Attribute", convertsToSnakeCase: false)
@MainActor
public class UsdAttribute: ObjectWrapper<pxr.UsdAttribute>, Sendable {
    func Get() throws -> object? {
        throw PythonError.NotImplementedError("UsdAttribute.Get is not implemented")
    }

    func GetTypeName() -> Sdf.ValueTypeName {
        Sdf.ValueTypeName(value: base.GetTypeName())
    }

    func Set(value: object, timecode: Int? = nil) -> Bool {
        let timecode = if let timecode {
            pxr.UsdTimeCode(timecode)
        } else {
            pxr.UsdTimeCode.Default()
        }

        let vtValue: pxr.VtValue? = {
            switch base.GetTypeName() {
            case .Asset:
                if let path = Sdf.AssetPath(value) {
                    return pxr.VtValue(path.value)
                }

                if let str = String(value) {
                    return pxr.VtValue(pxr.SdfAssetPath(str))
                }
                
            case .TimeCode:
                if let timeCode = Sdf.TimeCode(value) {
                    return pxr.VtValue(timeCode.value)
                }

                if value.canCast(to: .float) {
                    return pxr.VtValue(pxr.SdfTimeCode(py.castfloat(value)))
                }
                
            case .Token:
                if let str = String(value) {
                    return pxr.VtValue(pxr.TfToken(str))
                }
                
            case .FloatArray:
                if let array = [Float](value) {
                    return pxr.VtValue(array.vtArray())
                }

            case .StringArray:
                if let array = [String](value) {
                    return pxr.VtValue(array.vtStringArray())
                }
                
            default: break
            }

            return nil
        }()
        
        if let vtValue, base.Set(vtValue, timecode) {
            return true
        }
        
        return false
    }
}

@Scriptable("Usd.References", convertsToSnakeCase: false)
public class UsdReferences {
    internal var base: pxr.UsdReferences
    
    internal init(base: pxr.UsdReferences) {
        self.base = base
    }

    func AddReference(identifier: String, primPath: Sdf.Path) -> Bool {
        base.AddReference(std.string(identifier), primPath.value, pxr.SdfLayerOffset(0, 1))
    }
}

/// A UsdRelationship creates dependencies between scenegraph objects by allowing a prim to target other prims, attributes, or relationships.
@Scriptable("Usd.Relationship", convertsToSnakeCase: false)
public class UsdRelationship: ObjectWrapper<pxr.UsdRelationship> {
    /// Make the authoring layer’s opinion of the targets list explicit, and set exactly to targets
    func SetTargets(targets: [Sdf.Path]) -> Bool {
        var vector = pxr.SdfPathVector()
        for target in targets {
            vector.push_back(target.value)
        }
        return base.SetTargets(vector)
    }
}

public protocol UsdObject {
    func IsValid() -> Bool
}

extension pxr.UsdAttribute: UsdObject {}
extension pxr.UsdPrim: UsdObject {}
extension pxr.UsdRelationship: UsdObject {}

public class ObjectWrapper<T: UsdObject> {
    let base: T

    init?(_ base: T) {
        guard base.IsValid() else {
            return nil
        }
        self.base = base
    }
}
