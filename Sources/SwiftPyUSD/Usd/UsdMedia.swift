//
//  UsdMedia.swift
//  swiftpy-usd
//
//  Created by Tibor Felföldy on 2026-04-12.
//

import SwiftPy
import OpenUSD
import Sdf
import Usd

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

    public func CreateFilePathAttr() -> Usd.Attribute? {
        Usd.Attribute(value: base.CreateFilePathAttr(pxr.VtValue()))
    }
    
    public func CreateStartTimeAttr() -> Usd.Attribute? {
        Usd.Attribute(value: base.CreateStartTimeAttr(pxr.VtValue()))
    }
    
    public static func Define(stage: Usd.Stage, path: Sdf.Path) -> UsdMediaSpatialAudio? {
        let stagePointer = Overlay.TfWeakPtr(stage.value)
        let audio = pxr.UsdMediaSpatialAudio.Define(stagePointer, path.value)
        return UsdMediaSpatialAudio(audio)
    }
}
