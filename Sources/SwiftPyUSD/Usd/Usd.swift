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

    func GetRootLayer() -> SdfLayer {
        SdfLayer(layer: stage.GetRootLayer())
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
public class UsdPrim: ObjectWrapper<pxr.UsdPrim> {
    /// Author ‘active’ metadata for this prim at the current EditTarget.
    public func SetActive(_ value: Bool) -> Bool {
        base.SetActive(value)
    }
    
    /// Return the complete scene path to this object on its Stage.
    public func GetPath() -> SdfPath {
        SdfPath(base: base.GetPath())
    }

    public func GetPropertyNames() -> [String] {
        base.GetPropertyNames(Overlay.DefaultPropertyPredicateFunc)
            .map { token in
                String(token.GetString())
            }
    }

    public func GetAttribute(name: String) -> UsdAttribute? {
        UsdAttribute(base.GetAttribute(pxr.TfToken(name)))
    }

    public func GetReferences() -> UsdReferences {
        UsdReferences(base: base.GetReferences())
    }
}

@Scriptable("Usd.Attribute", convertsToSnakeCase: false)
@MainActor
public class UsdAttribute: ObjectWrapper<pxr.UsdAttribute>, Sendable {
    func Get() throws -> object? {
        throw PythonError.NotImplementedError("UsdAttribute.Get is not implemented")
    }

    func GetTypeName() {
        base.GetTypeName()
    }
    
    func Set(value: object, timecode: Int? = nil) -> Bool {
        let timecode = if let timecode {
            pxr.UsdTimeCode(timecode)
        } else {
            pxr.UsdTimeCode.Default()
        }

        if let array = [Float](value) {
            return base.Set(pxr.VtValue(array.vtArray()), timecode)
        }

        if let assetPath = SdfAssetPath(value) {
            return base.Set(pxr.VtValue(assetPath.base), timecode)
        }

        if let tc = SdfTimeCode(value) {
            return base.Set(pxr.VtValue(tc.base), timecode)
        }
        
        // TODO: Detect base type
        if let str = String(value) {
            return base.Set(pxr.VtValue(pxr.TfToken(str)), timecode)
        }

        // TODO: Detect base type
        if let int = Int(value) {
            return base.Set(pxr.VtValue(pxr.SdfTimeCode(Double(int))), timecode)
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
