//
//  Animation.swift
//  swiftpy-usd
//
//  Created by Tibor Felföldy on 2026-04-28.
//

import pxr
import SwiftPy
import Usd
import Sdf

/// Describes a skel animation, where joint animation is stored in a vectorized form.
@Scriptable(convertsToSnakeCase: false)
@MainActor
public class Animation: ClassWrapper<pxr.UsdSkelAnimation>, Sendable {
    /// Array of tokens identifying which blend shapes this animation's data applies to. The tokens for blendShapes correspond to the tokens set in the skel:blendShapes binding property of the UsdSkel.BindingAPI.
    public func CreateBlendShapesAttr(attributes: [String]) throws(PythonError) -> Usd.Attribute {
        let array = attributes.vtTokenArray()
        let attr = value.CreateBlendShapesAttr(VtValue(array))
        guard attr.IsValid() else {
            throw .AssertionError("Failed to create blendShapes attribute")
        }
        return Usd.Attribute(value: attr)
    }
    
    /// Creates an attribute for an array of weight values for each blend shape. Each weight value is associated with the corresponding blend shape identified within the blendShapes token array, and therefore must have the same length as blendShapes.
    public func CreateBlendShapeWeightsAttr() throws(PythonError) -> Usd.Attribute {
        let attr = value.CreateBlendShapeWeightsAttr(VtValue())
        guard attr.IsValid() else {
            throw .AssertionError("Failed to create blendShapeWeights attribute")
        }
        return Usd.Attribute(value: attr)
    }
    
    /// Return the complete scene path to this object on its Stage.
    public func GetPath() -> Sdf.Path {
        Sdf.Path(value.GetPath())
    }

    /// Ensure an Animation prim is defined at the given path on the provided stage.
    public static func Define(stage: Usd.Stage, path: object) throws -> Animation {
        let path = try Path(path) ?? Path(path: String.cast(path))
        let stagePtr = PxrOverlay.TfWeakPtr(stage.value)
        let anim = pxr.UsdSkelAnimation.Define(stagePtr, path.value)
        return Animation(value: anim)
    }
}
