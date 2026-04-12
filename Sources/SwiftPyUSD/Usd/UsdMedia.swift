//
//  UsdMedia.swift
//  swiftpy-usd
//
//  Created by Tibor Felföldy on 2026-04-12.
//

import SwiftPy
import OpenUSD

@Scriptable(convertsToSnakeCase: false)
@MainActor
public class UsdMedia {
    static let SpatialAudio: object? = UsdMediaSpatialAudio.pyTypeObject
    static let Tokens: object? = UsdMediaTokens.pyTypeObject
}

@Scriptable("UsdMedia.Tokens", convertsToSnakeCase: false)
public class UsdMediaTokens: PythonConvertible {}

@Scriptable("UsdMedia.SpatialAudio", convertsToSnakeCase: false)
public class UsdMediaSpatialAudio: PythonConvertible {
    internal let base: pxr.UsdMediaSpatialAudio
    
    internal init(_ base: pxr.UsdMediaSpatialAudio) {
        self.base = base
    }

    public func CreateFilePathAttr() -> UsdAttribute? {
        UsdAttribute(base.CreateFilePathAttr(pxr.VtValue()))
    }
    
    public func CreateStartTimeAttr() -> UsdAttribute? {
        UsdAttribute(base.CreateStartTimeAttr(pxr.VtValue()))
    }
    
    public static func Define(stage: UsdStage, path: SdfPath) -> UsdMediaSpatialAudio? {
        let stagePointer = Overlay.TfWeakPtr(stage.stage)
        let audio = pxr.UsdMediaSpatialAudio.Define(stagePointer, path.base)
        return UsdMediaSpatialAudio(audio)
    }
}
