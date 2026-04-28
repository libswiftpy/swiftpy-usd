//
//  Stage.swift
//  swiftpy-usd
//
//  Created by Tibor Felföldy on 2026-04-28.
//

import SwiftPy
import pxr
import CxxStdlib
import Sdf

/// The outermost container for scene description, which owns and presents composed prims as a scenegraph, following the composition recipe recursively described in its associated "root layer".
@Scriptable(convertsToSnakeCase: false)
@MainActor
public class Stage: ClassWrapper<pxr.UsdStage>, Sendable {
    /// Attempt to ensure a Prim at path is defined on this stage.
    public func DefinePrim(path: String, typeName: String = "") throws(PythonError) -> Prim {
        let path = Sdf.Path(path: path)
        let typeName = TfToken(typeName)
        let prim = value.DefinePrim(path.value, typeName)
        if !prim.IsDefined() {
            throw .AssertionError("Failed to define prim at \(path)")
        }
        return Prim(value: prim)
    }

    /// Return the UsdPrim at path if exists.
    public func GetPrimAtPath(path: String) -> Prim? {
        let path = Sdf.Path(path: path)
        let prim = value.GetPrimAtPath(path.value)
        return prim.IsValid() ? Prim(value: prim) : nil
    }

    /// Traverse the active, loaded, defined, non-abstract prims on this stage depth-first.
    public func Traverse() -> [Prim] {
        value.Traverse().map(Prim.init)
    }

    /// Writes the composite scene as a flattened Usd text representation.
    public func ExportToString() -> String? {
        value.ExportToString()
    }

    /// Functions for saving changes to layers that contribute opinions to this stage.
    public func Save() {
        value.Save()
    }

    /// Sets the stage’s start timeCode.
    public func SetStartTimeCode(timeCode: Double) {
        value.SetStartTimeCode(timeCode)
    }

    /// Sets the stage's end timeCode.
    public func SetEndTimeCode(timeCode: Double) {
        value.SetEndTimeCode(timeCode)
    }

    /// Sets the stage's framesPerSecond value.
    public func SetFramesPerSecond(fps: Double) {
        value.SetFramesPerSecond(fps)
    }
    
    /// Sets the stage's timeCodesPerSecond value.
    public func SetTimeCodesPerSecond(timeCodesPerSecond: Double) {
        value.SetTimeCodesPerSecond(timeCodesPerSecond)
    }
    
    /// Creates a new stage only in memory, analogous to creating an anonymous SdfLayer.
    public static func CreateInMemory() throws -> Stage {
        try deref(pxr.UsdStage.CreateInMemory())
    }

    /// Create a new stage with root layer identifier, destroying potentially existing files with that identifier; it is considered an error if an existing, open layer is present with this identifier.
    public static func CreateNew(identifier: String) throws -> Stage {
        try deref(pxr.UsdStage.CreateNew(std.string(identifier)))
    }

    /// Attempt to find a matching existing stage in a cache if UsdStageCacheContext objects exist on the stack. Failing that, create a new stage and recursively compose prims defined within and referenced by the layer at filePath, which must already exist.
    public static func Open(filePath: String) throws -> Stage {
        try deref(pxr.UsdStage.Open(std.string(filePath)))
    }

    private static func deref(_ ptr: UsdStageRefPtr) throws(PythonError) -> Stage {
        guard let stage = PxrOverlay.DereferenceOrNil(ptr) else {
            throw .AssertionError("Failed to create stage")
        }
        return Stage(value: stage)
    }
}
