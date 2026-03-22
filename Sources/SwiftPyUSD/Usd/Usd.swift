//
//  Usd.swift
//  openusd
//
//  Created by Tibor Felföldy on 2025-10-31.
//

import SwiftPy
import OpenUSD

@MainActor
@Scriptable(convertsToSnakeCase: false)
public class Usd {
    static let Stage: object? = UsdStage.pyType.object
    static let Prim: object? = UsdPrim.pyType.object
    static let References: object? = UsdReferences.pyType.object
    static let Relationship: object? = UsdRelationship.pyType.object
}

@Scriptable("Usd.Stage", convertsToSnakeCase: false)
public class UsdStage {
    internal let stage: pxr.UsdStage
    internal var weakPtr: pxr.UsdStageWeakPtr {
        Overlay.TfWeakPtr(stage)
    }
    
    internal init(_ stage: pxr.UsdStageRefPtr) {
        self.stage = Overlay.Dereference(stage)
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

    func ExportToString() -> String? {
        stage.ExportToString()
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

    func GetRootLayer() -> SdfLayer {
        SdfLayer(layer: stage.GetRootLayer())
    }
    
    static func CreateNew(name: String) -> UsdStage? {
        UsdStage(pxr.UsdStage.CreateNew(std.string(name)))
    }

    static func CreateInMemory() -> UsdStage? {
        UsdStage(pxr.UsdStage.CreateInMemory())
    }
    
    static func Open(name: String) -> UsdStage? {
        UsdStage(pxr.UsdStage.Open(std.string(name)))
    }
}

extension UsdStage: CustomStringConvertible {
    public var description: String {
        ExportToString() ?? ""
    }
}

@Scriptable("Usd.Prim", convertsToSnakeCase: false)
public class UsdPrim: ObjectWrapper<pxr.UsdPrim> {
    func GetPropertyNames() -> [String] {
        base.GetPropertyNames(Overlay.DefaultPropertyPredicateFunc)
            .map { token in
                String(token.GetString())
            }
    }

    func GetAttribute(name: String) -> UsdAttribute? {
        UsdAttribute(base.GetAttribute(pxr.TfToken(name)))
    }

    func GetReferences() -> UsdReferences {
        UsdReferences(base: base.GetReferences())
    }
}

@Scriptable("Usd.Attribute", convertsToSnakeCase: false)
public class UsdAttribute: ObjectWrapper<pxr.UsdAttribute> {
    func Get() throws -> object? {
        throw PythonError.NotImplementedError("UsdAttribute.Get is not implemented")
    }

    func Set(values: [Float], timecode: Int) -> Bool {
        base.Set(pxr.VtValue(values.vtArray()), pxr.UsdTimeCode(timecode))
    }
}

@Scriptable("Usd.References", convertsToSnakeCase: false)
public class UsdReferences {
    internal var base: pxr.UsdReferences
    
    internal init(base: pxr.UsdReferences) {
        self.base = base
    }

    func AddReference(identifier: String, primPath: SdfPath) -> Bool {
        base.AddReference(std.string(identifier), primPath.base, pxr.SdfLayerOffset(0, 1))
    }
}

/// A UsdRelationship creates dependencies between scenegraph objects by allowing a prim to target other prims, attributes, or relationships.
@Scriptable("Usd.Relationship", convertsToSnakeCase: false)
public class UsdRelationship {
    internal var base: pxr.UsdRelationship

    internal init(base: pxr.UsdRelationship) {
        self.base = base
    }

    /// Make the authoring layer’s opinion of the targets list explicit, and set exactly to targets
    func SetTargets(targets: [SdfPath]) -> Bool {
        var vector = pxr.SdfPathVector()
        for target in targets {
            vector.push_back(target.base)
        }
        return base.SetTargets(vector)
    }
}

public protocol UsdObject {
    func IsValid() -> Bool
}

extension pxr.UsdAttribute: UsdObject {}
extension pxr.UsdPrim: UsdObject {}

public class ObjectWrapper<T: UsdObject> {
    let base: T

    init?(_ base: T) {
        guard base.IsValid() else {
            return nil
        }
        self.base = base
    }
}
