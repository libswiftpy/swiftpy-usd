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
        if !Bool(prim) {
            throw .AssertionError("Failed to define prim at \(path)")
        }
        return Prim(value: prim)
    }

    /// Return the UsdPrim at path if exists.
    public func GetPrimAtPath(path: String) -> Prim? {
        let path = Sdf.Path(path: path)
        let prim = value.GetPrimAtPath(path.value)
        return Bool(prim) ? Prim(value: prim) : nil
    }

    /// Return the stage's "pseudo-root" prim, whose name is defined by Usd.
    public func GetPseudoRoot() -> Prim? {
        let prim = value.GetPseudoRoot()
        return Bool(prim) ? Prim(value: prim) : nil
    }

    /// Traverse the active, loaded, defined, non-abstract prims on this stage depth-first.
    public func Traverse() -> [Prim] {
        value.Traverse().map(Prim.init)
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
    
    // MARK: - Lifetime / file support

    /// Calls SdfLayer::Reload on all layers contributing to this stage, except session layers and sublayers of session layers.
    public func Reload() {
        value.Reload()
    }

    /// Indicates whether the specified file is supported by UsdStage.
    public static func IsSupportedFile(filePath: String) -> Bool {
        pxr.UsdStage.IsSupportedFile(std.string(filePath))
    }

    // MARK: - Layer serialization

    /// Save dirty session layers and sublayers of session layers contributing to this stage.
    public func SaveSessionLayers() {
        value.SaveSessionLayers()
    }

    // MARK: - Prim access / creation / mutation

    /// Return the stage's default prim, if one exists.
    public func GetDefaultPrim() -> Prim? {
        let prim = value.GetDefaultPrim()
        return Bool(prim) ? Prim(value: prim) : nil
    }

    /// Set the default prim layer metadata in this stage's root layer.
    public func SetDefaultPrim(_ prim: Prim) {
        value.SetDefaultPrim(prim.value)
    }

    /// Clear the default prim layer metadata in this stage's root layer.
    public func ClearDefaultPrim() {
        value.ClearDefaultPrim()
    }

    /// Return true if this stage's root layer has an authored opinion for the default prim layer metadata.
    public func HasDefaultPrim() -> Bool {
        value.HasDefaultPrim()
    }

    /// Return the UsdAttribute at path, if it exists.
    public func GetAttributeAtPath(path: String) -> Attribute? {
        let path = Sdf.Path(path: path)
        let attr = value.GetAttributeAtPath(path.value)
        return Bool(attr) ? Attribute(value: attr) : nil
    }

    /// Return the UsdRelationship at path, if it exists.
    public func GetRelationshipAtPath(path: String) -> Relationship? {
        let path = Sdf.Path(path: path)
        let rel = value.GetRelationshipAtPath(path.value)
        return Bool(rel) ? Relationship(value: rel) : nil
    }

    /// Traverse all prims on this stage depth-first.
    public func TraverseAll() -> [Prim] {
        value.TraverseAll().map(Prim.init)
    }

    /// Attempt to ensure a Prim at path exists on this stage as an over.
    public func OverridePrim(path: String) throws(PythonError) -> Prim {
        let path = Sdf.Path(path: path)
        let prim = value.OverridePrim(path.value)
        if !Bool(prim) {
            throw .AssertionError("Failed to override prim at \(path)")
        }
        return Prim(value: prim)
    }

    /// Author a class prim at the given root prim path.
    public func CreateClassPrim(path: String) throws(PythonError) -> Prim {
        let path = Sdf.Path(path: path)
        let prim = value.CreateClassPrim(path.value)
        if !Bool(prim) {
            throw .AssertionError("Failed to create class prim at \(path)")
        }
        return Prim(value: prim)
    }

    /// Remove all scene description for the given path and its subtree in the current EditTarget.
    public func RemovePrim(path: String) -> Bool {
        let path = Sdf.Path(path: path)
        return value.RemovePrim(path.value)
    }

    // MARK: - Working set management

    /// Load the prim at path, its ancestors, and all descendants.
    @discardableResult
    public func Load(path: String = "/") -> Prim? {
        let path = Sdf.Path(path: path)
        let prim = value.Load(path.value)
        return Bool(prim) ? Prim(value: prim) : nil
    }

    /// Unload the prim and its descendants at path.
    public func Unload(path: String = "/") {
        let path = Sdf.Path(path: path)
        value.Unload(path.value)
    }

    // MARK: - Layer / edit-target utilities

    /// Resolve the given identifier using this stage's resolver context and current edit target.
    public func ResolveIdentifierToEditTarget(identifier: String) -> String {
        String(value.ResolveIdentifierToEditTarget(std.string(identifier)))
    }

    /// Mute the layer identified by layerIdentifier.
    public func MuteLayer(layerIdentifier: String) {
        value.MuteLayer(std.string(layerIdentifier))
    }

    /// Unmute the layer identified by layerIdentifier.
    public func UnmuteLayer(layerIdentifier: String) {
        value.UnmuteLayer(std.string(layerIdentifier))
    }

    /// Return all muted layer identifiers on this stage.
    public func GetMutedLayers() -> [String] {
        value.GetMutedLayers().map { identifier in
            String(identifier)
        }
    }

    /// Return true if the layer identified by layerIdentifier is muted.
    public func IsLayerMuted(layerIdentifier: String) -> Bool {
        value.IsLayerMuted(std.string(layerIdentifier))
    }

    // MARK: - Export utilities

    /// Writes out the composite scene as a single flattened layer into filename.
    public func Export(filename: String, addSourceFileComment: Bool = true) -> Bool {
        value.Export(std.string(filename), addSourceFileComment, .init())
    }

    /// Writes the composite scene as a flattened Usd text representation.
    public func ExportToString(addSourceFileComment: Bool = true) -> String? {
        var result = std.string()
        guard value.ExportToString(&result, addSourceFileComment) else {
            return nil
        }
        return String(result)
    }

    // MARK: - Stage metadata

    /// Returns true if the metadata key has a meaningful value.
    public func HasMetadata(key: String) -> Bool {
        value.HasMetadata(TfToken(key))
    }

    /// Returns true if the metadata key has an authored value.
    public func HasAuthoredMetadata(key: String) -> Bool {
        value.HasAuthoredMetadata(TfToken(key))
    }

    /// Clear the value of stage metadata for key.
    public func ClearMetadata(key: String) -> Bool {
        value.ClearMetadata(TfToken(key))
    }

    /// Return true if there exists any authored or fallback opinion for key and keyPath.
    public func HasMetadataDictKey(key: String, keyPath: String) -> Bool {
        value.HasMetadataDictKey(TfToken(key), TfToken(keyPath))
    }

    /// Return true if there exists any authored opinion for key and keyPath.
    public func HasAuthoredMetadataDictKey(key: String, keyPath: String) -> Bool {
        value.HasAuthoredMetadataDictKey(TfToken(key), TfToken(keyPath))
    }

    /// Clear any authored dictionary metadata value identified by key and keyPath.
    public func ClearMetadataByDictKey(key: String, keyPath: String) -> Bool {
        value.ClearMetadataByDictKey(TfToken(key), TfToken(keyPath))
    }

    /// Writes schema-registry fallback prim types to stage metadata.
    public func WriteFallbackPrimTypes() {
        value.WriteFallbackPrimTypes()
    }

    // MARK: - TimeCode API

    /// Returns the stage's start timeCode.
    public func GetStartTimeCode() -> Double {
        value.GetStartTimeCode()
    }

    /// Returns the stage's end timeCode.
    public func GetEndTimeCode() -> Double {
        value.GetEndTimeCode()
    }

    /// Returns true if the stage has both start and end timeCodes authored.
    public func HasAuthoredTimeCodeRange() -> Bool {
        value.HasAuthoredTimeCodeRange()
    }

    /// Returns the stage's timeCodesPerSecond value.
    public func GetTimeCodesPerSecond() -> Double {
        value.GetTimeCodesPerSecond()
    }

    /// Returns the stage's framesPerSecond value.
    public func GetFramesPerSecond() -> Double {
        value.GetFramesPerSecond()
    }

    // MARK: - Color configuration

    /// Sets the name of the color management system.
    public func SetColorManagementSystem(_ cms: String) {
        value.SetColorManagementSystem(TfToken(cms))
    }

    /// Returns the name of the color management system.
    public func GetColorManagementSystem() -> String {
        String(value.GetColorManagementSystem().GetString())
    }

    // MARK: - Instancing

    /// Returns all native instancing prototype prims.
    public func GetPrototypes() -> [Prim] {
        value.GetPrototypes().map(Prim.init)
    }

    private static func deref(_ ptr: UsdStageRefPtr) throws(PythonError) -> Stage {
        guard let stage = PxrOverlay.DereferenceOrNil(ptr) else {
            throw .AssertionError("Failed to create stage")
        }
        return Stage(value: stage)
    }
}
