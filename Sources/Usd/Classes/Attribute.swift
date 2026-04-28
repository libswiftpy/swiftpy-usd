//
//  Attribute.swift
//  swiftpy-usd
//
//  Created by Tibor Felföldy on 2026-04-28.
//

import SwiftPy
import pxr
import Sdf

/// Scenegraph object for authoring and retrieving numeric, string, and array valued data, sampled over time, or animated by a spline
@Scriptable(convertsToSnakeCase: false)
@MainActor
public class Attribute: ClassWrapper<pxr.UsdAttribute>, Sendable {
    /// Return the 'scene description' value type name for this attribute.
    public func GetTypeName() -> Sdf.ValueTypeName {
        Sdf.ValueTypeName(value: value.GetTypeName())
    }

    /// Set the value of this attribute in the current UsdEditTarget to value at time, which defaults to default.
    public func Set(attrValue: object, time: Int? = nil) -> Bool {
        let timeCode = Usd.TimeCode(time)
        
        let vtValue: pxr.VtValue? = {
            switch value.GetTypeName() {
            case .Asset:
                if let path = Sdf.AssetPath(attrValue) {
                    return pxr.VtValue(path.value)
                }

                if let str = String(attrValue) {
                    return pxr.VtValue(pxr.SdfAssetPath(str))
                }
                
            case .TimeCode:
                if let timeCode = Sdf.TimeCode(attrValue) {
                    return pxr.VtValue(timeCode.value)
                }

                if attrValue.canCast(to: .float) {
                    return pxr.VtValue(pxr.SdfTimeCode(py.castfloat(attrValue)))
                }
                
            case .Token:
                if let str = String(attrValue) {
                    return pxr.VtValue(pxr.TfToken(str))
                }
                
            case .FloatArray:
                if let array = [Float](attrValue) {
                    return pxr.VtValue(array.vtArray())
                }

            case .StringArray:
                if let array = [String](attrValue) {
                    return pxr.VtValue(array.vtStringArray())
                }
                
            default: break
            }

            return nil
        }()

        if let vtValue, value.Set(vtValue, timeCode.value) {
            return true
        }

        return false
    }
}
