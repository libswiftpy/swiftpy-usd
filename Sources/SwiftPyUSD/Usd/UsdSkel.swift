//
//  UsdSkel.swift
//  openusd
//
//  Created by Tibor Felföldy on 2026-03-20.
//

import SwiftPy
import OpenUSD
import Sdf
import Usd

@Scriptable(convertsToSnakeCase: false)
@MainActor
public class UsdSkel {
    static let Animation: object? = UsdSkelAnimation.pyTypeObject
    static let BindingAPI: object? = UsdSkelBindingAPI.pyTypeObject
}

@Scriptable("UsdSkel.Animation", convertsToSnakeCase: false)
public class UsdSkelAnimation: PythonConvertible {
    internal var base: pxr.UsdSkelAnimation
    
    internal init(base: pxr.UsdSkelAnimation) {
        self.base = base
    }
    
    func CreateBlendShapesAttr(attributes: [String]) -> Usd.Attribute? {
        let array = attributes.vtTokenArray()
        let attrib = base.CreateBlendShapesAttr(pxr.VtValue(array))
        return Usd.Attribute(value: attrib)
    }
    
    func CreateBlendShapeWeightsAttr() -> Usd.Attribute? {
        Usd.Attribute(value: base.CreateBlendShapeWeightsAttr(pxr.VtValue()))
    }

    func GetPath() -> Sdf.Path {
        Sdf.Path(base.GetPath())
    }

    static func Define(stage: Usd.Stage, path: Sdf.Path) -> UsdSkelAnimation {
        let stageRef = Overlay.TfWeakPtr(stage.value)
        return UsdSkelAnimation(base: pxr.UsdSkelAnimation.Define(stageRef, path.value))
    }
}

/// Provides API for authoring and extracting all the skinning-related data that lives in the “geometry hierarchy” of prims and models that want to be skeletally deformed.
@Scriptable("UsdSkel.BindingAPI", convertsToSnakeCase: false)
class UsdSkelBindingAPI: PythonConvertible {
    internal let base: pxr.UsdSkelBindingAPI
    
    internal init(base: pxr.UsdSkelBindingAPI) {
        self.base = base
    }

    /// Creates an animation source to be bound to Skeleton primitives at or beneath the location at which this property is defined.
    func CreateAnimationSourceRel() throws(PythonError) -> Usd.Relationship? {
        let rel = base.CreateAnimationSourceRel()
        guard rel.IsValid() else {
            throw .AssertionError("Failed to create animation source relationship")
        }
        return Usd.Relationship(value: rel)
    }
    
    /// Applies this single-apply API schema to the given prim.
    static func Apply(prim: Usd.Prim) -> UsdSkelBindingAPI {
        UsdSkelBindingAPI(base: pxr.UsdSkelBindingAPI.Apply(prim.value))
    }
}
