//
//  SpatialAudio.swift
//  swiftpy-usd
//
//  Created by Tibor Felföldy on 2026-04-28.
//

import Usd
import Sdf
import pxr
import SwiftPy

/// The SpatialAudio primitive defines basic properties for encoding playback of an audio file or stream within a Stage.
@Scriptable(convertsToSnakeCase: false)
public class SpatialAudio: ClassWrapper<pxr.UsdMediaSpatialAudio> {
    /// Create an attribute for the path to the audio file.
    public func CreateFilePathAttr() throws(PythonError) -> Usd.Attribute {
        let attribute = value.CreateFilePathAttr(pxr.VtValue())
        guard attribute.IsValid() else {
            throw .AssertionError("Failed to create filePath attribute.")
        }
        return Usd.Attribute(value: attribute)
    }

    /// Expressed in the timeCodesPerSecond of the containing stage, startTime specifies when the audio stream will start playing during animation playback.
    public func CreateStartTimeAttr() throws(PythonError) -> Usd.Attribute {
        let attribute = value.CreateStartTimeAttr(pxr.VtValue())
        guard attribute.IsValid() else {
            throw .AssertionError("Failed to create startTime attribute.")
        }
        return Usd.Attribute(value: attribute)
    }
    
    /// Attempt to ensure a Prim adhering to this schema at \p path
    /// is defined (according to UsdPrim::IsDefined()) on this stage.
    public static func Define(stage: Usd.Stage, path: Sdf.Path) throws(PythonError) -> SpatialAudio {
        let ptr = PxrOverlay.TfWeakPtr(stage.value)
        let audio = pxr.UsdMediaSpatialAudio.Define(ptr, path.value)
        return SpatialAudio(value: audio)
    }
}
