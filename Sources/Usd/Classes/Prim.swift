//
//  Prim.swift
//  swiftpy-usd
//
//  Created by Tibor Felföldy on 2026-04-28.
//

import SwiftPy
import pxr
import Sdf

/// Prim is the sole persistent scenegraph object on a Stage.
@Scriptable(convertsToSnakeCase: false)
@MainActor
public class Prim: ClassWrapper<pxr.UsdPrim>, Sendable {
    /// Author ‘active’ metadata for this prim at the current EditTarget.
    public func SetActive(_ active: Bool) -> Bool {
        value.SetActive(active)
    }

    /// Return the complete scene path to this object on its Stage.
    public func GetPath() -> Sdf.Path {
        Sdf.Path(value.GetPath())
    }

    /// Return all of this prim's property names (attributes and relationships), including all builtin properties.
    public func GetPropertyNames() -> [String] {
        value.GetPropertyNames(PxrOverlay.DefaultPropertyPredicateFunc)
            .map { token in
                String(token.GetString())
            }
    }

    /// Author scene description for the attribute named attrName at the current EditTarget if none already exists.  Return an attribute if scene description was successfully authored. Note that the supplied typeName and  custom arguments are only used in one specific case.
    public func CreateAttribute(attrName: String, typeName: Sdf.ValueTypeName, custom: Bool = true, variability: Sdf.Variability? = nil) throws(PythonError) -> Attribute {
        let variability = variability ?? Sdf.VariabilityVarying
        let attribute = value.CreateAttribute(TfToken(attrName), typeName.value, custom, variability.value)
        if !attribute.IsValid() {
            throw .AssertionError("Failed to create attribute: \(attrName)")
        }
        return Attribute(value: attribute)
    }

    /// Return an Attribute with the name if exists.
    public func GetAttribute(name: String) -> Attribute? {
        let attr = value.GetAttribute(TfToken(name))
        return attr.IsValid() ? Attribute(value: attr) : nil
    }
    
    /// Return a References object that allows one to add, remove, or mutate references at the currently set UsdEditTarget.
    public func GetReferences() -> References {
        References(value: value.GetReferences())
    }
    
    /// Author scene description for the relationship at the current EditTarget if none already exists.  Return a relationship if scene description was successfully authored.
    public func CreateRelationship(name: String, custom: Bool = true) throws(PythonError) -> Relationship {
        let rel = value.CreateRelationship(TfToken(name), custom)
        guard rel.IsValid() else {
            throw .AssertionError("Failed to create relationship: \(name)")
        }
        return Relationship(value: rel)
    }
}
