//
//  UsdSkel.swift
//  openusd
//
//  Created by Tibor Felföldy on 2026-03-20.
//

import SwiftPy
import OpenUSD

@Scriptable(convertsToSnakeCase: false)
@MainActor
public class UsdSkel {
    static let Animation: object? = UsdSkelAnimation.pyType.object
    static let BindingAPI: object? = UsdSkelBindingAPI.pyType.object
}

@Scriptable("UsdSkel.Animation", convertsToSnakeCase: false)
public class UsdSkelAnimation {
    internal var base: pxr.UsdSkelAnimation
    
    internal init(base: pxr.UsdSkelAnimation) {
        self.base = base
    }
    
    func CreateBlendShapesAttr(attributes: [String]) -> UsdAttribute? {
        let array = attributes.vtArray()
        let attrib = base.CreateBlendShapesAttr(pxr.VtValue(array))
        return UsdAttribute(attrib)
    }
    
    func CreateBlendShapeWeightsAttr() -> UsdAttribute? {
        UsdAttribute(base.CreateBlendShapeWeightsAttr(pxr.VtValue()))
    }

    func GetPath() -> SdfPath {
        SdfPath(base: base.GetPath())
    }
    
    static func Define(stage: UsdStage, path: SdfPath) -> UsdSkelAnimation {
        let stageRef = Overlay.TfWeakPtr(stage.stage)
        return UsdSkelAnimation(base: pxr.UsdSkelAnimation.Define(stageRef, path.base))
    }
}

/// Provides API for authoring and extracting all the skinning-related data that lives in the “geometry hierarchy” of prims and models that want to be skeletally deformed.
@Scriptable("UsdSkel.BindingAPI", convertsToSnakeCase: false)
class UsdSkelBindingAPI {
    internal let base: pxr.UsdSkelBindingAPI
    
    internal init(base: pxr.UsdSkelBindingAPI) {
        self.base = base
    }

    /// Creates an animation source to be bound to Skeleton primitives at or beneath the location at which this property is defined.
    func CreateAnimationSourceRel() -> UsdRelationship {
        UsdRelationship(base: base.CreateAnimationSourceRel())
    }
    
    /// Applies this single-apply API schema to the given prim.
    static func Apply(prim: UsdPrim) -> UsdSkelBindingAPI {
        UsdSkelBindingAPI(base: pxr.UsdSkelBindingAPI.Apply(prim.base))
    }
}
