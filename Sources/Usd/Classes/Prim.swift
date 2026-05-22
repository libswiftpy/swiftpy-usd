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

    /// Return true if this prim is active, meaning neither it nor any of its ancestors have active=false.
    public func IsActive() -> Bool {
        value.IsActive()
    }

    /// Return true if this prim is active, and either it is loadable and it is loaded, or its nearest loadable ancestor is loaded, or it has no loadable ancestor.
    public func IsLoaded() -> Bool {
        value.IsLoaded()
    }

    /// Return true if this prim and all its ancestors have defining specifiers.
    public func IsDefined() -> Bool {
        value.IsDefined()
    }

    /// Return true if this prim or any of its ancestors is a class.
    public func IsAbstract() -> Bool {
        value.IsAbstract()
    }

    /// Return true if this prim has been marked as instanceable.
    public func IsInstanceable() -> Bool {
        value.IsInstanceable()
    }

    /// Return true if this prim is a model based on its kind metadata.
    public func IsModel() -> Bool {
        value.IsModel()
    }

    /// Return true if this prim is a model group based on its kind metadata.  If this prim is a group, it is also necessarily a model.
    public func IsGroup() -> Bool {
        value.IsGroup()
    }

    /// Return the complete scene path to this object on its Stage.
    public func GetPath() -> Sdf.Path {
        Sdf.Path(value.GetPath())
    }

    /// Return the full name of this object, i.e. the last component of its Sdf.Path in namespace.
    public func GetName() -> String {
        String(value.GetName().GetString())
    }

    /// Return this prim's composed type name.
    public func GetTypeName() -> String {
        String(value.GetTypeName().GetString())
    }

    /// Return all of this prim's property names (attributes and relationships), including all builtin properties.
    public func GetPropertyNames() -> [String] {
        value.GetPropertyNames(PxrOverlay.DefaultPropertyPredicateFunc)
            .map { token in
                String(token.GetString())
            }
    }

    /// Return all this prim’s children.
    public func GetAllChildren() -> [Prim] {
        value.GetAllChildren().map(Prim.init)
    }

    /// Author scene description for the attribute named attrName at the current EditTarget if none already exists.  Return an attribute if scene description was successfully authored. Note that the supplied typeName and  custom arguments are only used in one specific case.
    public func CreateAttribute(attrName: String, typeName: Sdf.ValueTypeName, custom: Bool = true, variability: Sdf.Variability? = nil) throws(PythonError) -> Attribute {
        let variability = variability ?? Sdf.VariabilityVarying
        let attribute = value.CreateAttribute(TfToken(attrName), typeName.value, custom, variability.value)
        if !Bool(attribute) {
            throw .AssertionError("Failed to create attribute: \(attrName)")
        }
        return Attribute(value: attribute)
    }

    /// Return an Attribute with the name if exists.
    public func GetAttribute(name: String) -> Attribute? {
        let attr = value.GetAttribute(TfToken(name))
        return Bool(attr) ? Attribute(value: attr) : nil
    }
    
    /// Return a References object that allows one to add, remove, or mutate references at the currently set UsdEditTarget.
    public func GetReferences() -> References {
        References(value: value.GetReferences())
    }
    
    /// Author scene description for the relationship at the current EditTarget if none already exists.  Return a relationship if scene description was successfully authored.
    public func CreateRelationship(name: String, custom: Bool = true) throws(PythonError) -> Relationship {
        let rel = value.CreateRelationship(TfToken(name), custom)
        guard Bool(rel) else {
            throw .AssertionError("Failed to create relationship: \(name)")
        }
        return Relationship(value: rel)
    }
    
    // MARK: - Type metadata

    /// Author this Prim's typeName at the current EditTarget.
    public func SetTypeName(_ typeName: String) -> Bool {
        value.SetTypeName(TfToken(typeName))
    }

    /// Clear the opinion for this Prim's typeName at the current EditTarget.
    public func ClearTypeName() -> Bool {
        value.ClearTypeName()
    }

    /// Return true if a typeName has been authored.
    public func HasAuthoredTypeName() -> Bool {
        value.HasAuthoredTypeName()
    }

    // MARK: - Active metadata

    /// Remove the authored ‘active’ opinion at the current EditTarget.
    public func ClearActive() -> Bool {
        value.ClearActive()
    }

    /// Return true if this prim has an authored opinion for ‘active’.
    public func HasAuthoredActive() -> Bool {
        value.HasAuthoredActive()
    }

    // MARK: - Kind / definition queries

    /// Return true if this prim is a component model based on its kind metadata.
    public func IsComponent() -> Bool {
        value.IsComponent()
    }

    /// Return true if this prim is a subcomponent based on its kind metadata.
    public func IsSubComponent() -> Bool {
        value.IsSubComponent()
    }

    /// Return true if this prim has the specifier SdfSpecifierClass.
    public func HasClassSpecifier() -> Bool {
        value.HasClassSpecifier()
    }

    /// Return true if this prim has the specifier SdfSpecifierDef or SdfSpecifierClass.
    public func HasDefiningSpecifier() -> Bool {
        value.HasDefiningSpecifier()
    }

    /// Retrieve the authored kind for this prim.
    public func GetKind() -> String? {
        var kind = TfToken()
        guard value.GetKind(&kind) else {
            return nil
        }
        return String(kind.GetString())
    }

    /// Author a kind for this prim at the current UsdEditTarget.
    public func SetKind(_ kind: String) -> Bool {
        value.SetKind(TfToken(kind))
    }

    // MARK: - Applied schemas

    /// Return the names of API schemas applied to this prim.
    public func GetAppliedSchemas() -> [String] {
        value.GetAppliedSchemas().map { token in
            String(token.GetString())
        }
    }

    /// Add an applied API schema name token to the apiSchemas metadata.
    public func AddAppliedSchema(_ appliedSchemaName: String) -> Bool {
        value.AddAppliedSchema(TfToken(appliedSchemaName))
    }

    /// Remove an applied API schema name token from the apiSchemas metadata.
    public func RemoveAppliedSchema(_ appliedSchemaName: String) -> Bool {
        value.RemoveAppliedSchema(TfToken(appliedSchemaName))
    }

    /// Return true if this prim has the applied API schema identified by name.
    public func HasAPI(_ schemaIdentifier: String) -> Bool {
        value.HasAPI(TfToken(schemaIdentifier))
    }

    /// Apply an API schema identified by name.
    public func ApplyAPI(_ schemaIdentifier: String) -> Bool {
        value.ApplyAPI(TfToken(schemaIdentifier))
    }

    /// Remove an API schema identified by name.
    public func RemoveAPI(_ schemaIdentifier: String) -> Bool {
        value.RemoveAPI(TfToken(schemaIdentifier))
    }

    // MARK: - Properties

    /// Return authored property names only.
    public func GetAuthoredPropertyNames() -> [String] {
        value.GetAuthoredPropertyNames(PxrOverlay.DefaultPropertyPredicateFunc)
            .map { token in
                String(token.GetString())
            }
    }

    /// Return the strongest propertyOrder metadata value authored on this prim.
    public func GetPropertyOrder() -> [String] {
        value.GetPropertyOrder().map { token in
            String(token.GetString())
        }
    }

    /// Remove the opinion for propertyOrder metadata on this prim.
    public func ClearPropertyOrder() {
        value.ClearPropertyOrder()
    }

    /// Remove scene description for the property with the given name in the current EditTarget.
    public func RemoveProperty(_ propName: String) -> Bool {
        value.RemoveProperty(TfToken(propName))
    }

    /// Return true if this prim has a property with the given name.
    public func HasProperty(_ propName: String) -> Bool {
        value.HasProperty(TfToken(propName))
    }

    // MARK: - Attributes

    /// Return this prim's attributes, including builtin attributes.
    public func GetAttributes() -> [Attribute] {
        value.GetAttributes().map { attr in
            Attribute(value: attr)
        }
    }

    /// Return this prim's authored attributes.
    public func GetAuthoredAttributes() -> [Attribute] {
        value.GetAuthoredAttributes().map { attr in
            Attribute(value: attr)
        }
    }

    /// Return true if this prim has an attribute with the given name.
    public func HasAttribute(_ attrName: String) -> Bool {
        value.HasAttribute(TfToken(attrName))
    }

    // MARK: - Relationships

    /// Return a Relationship with the name if it exists.
    public func GetRelationship(name: String) -> Relationship? {
        let rel = value.GetRelationship(TfToken(name))
        return Bool(rel) ? Relationship(value: rel) : nil
    }

    /// Return this prim's relationships, including builtin relationships.
    public func GetRelationships() -> [Relationship] {
        value.GetRelationships().map { rel in
            Relationship(value: rel)
        }
    }

    /// Return this prim's authored relationships.
    public func GetAuthoredRelationships() -> [Relationship] {
        value.GetAuthoredRelationships().map { rel in
            Relationship(value: rel)
        }
    }

    /// Return true if this prim has a relationship with the given name.
    public func HasRelationship(_ relName: String) -> Bool {
        value.HasRelationship(TfToken(relName))
    }

    // MARK: - Children

    /// Return this prim’s default-filtered children: active, loaded, defined, non-abstract.
    public func GetChildren() -> [Prim] {
        value.GetChildren().map(Prim.init)
    }

    /// Return this prim's direct child with the given name, if it exists.
    public func GetChild(_ name: String) -> Prim? {
        let child = value.GetChild(TfToken(name))
        return Bool(child) ? Prim(value: child) : nil
    }

    /// Return the names of this prim's default-filtered children.
    public func GetChildrenNames() -> [String] {
        value.GetChildrenNames().map { token in
            String(token.GetString())
        }
    }

    /// Return the names of all child prims.
    public func GetAllChildrenNames() -> [String] {
        value.GetAllChildrenNames().map { token in
            String(token.GetString())
        }
    }

    /// Return the strongest opinion for child reorder metadata.
    public func GetChildrenReorder() -> [String] {
        value.GetChildrenReorder().map { token in
            String(token.GetString())
        }
    }

    /// Remove the opinion for children reorder metadata.
    public func ClearChildrenReorder() {
        value.ClearChildrenReorder()
    }

    // MARK: - Parent / sibling / stage-relative lookup

    /// Return this prim's parent prim, or nil if this is the pseudoroot.
    public func GetParent() -> Prim? {
        let parent = value.GetParent()
        return Bool(parent) ? Prim(value: parent) : nil
    }

    /// Return this prim's next default-filtered sibling, if it has one.
    public func GetNextSibling() -> Prim? {
        let sibling = value.GetNextSibling()
        return Bool(sibling) ? Prim(value: sibling) : nil
    }

    /// Return true if the prim is the pseudo-root.
    public func IsPseudoRoot() -> Bool {
        value.IsPseudoRoot()
    }

    /// Returns the prim at path on the same stage as this prim.
    public func GetPrimAtPath(_ path: Sdf.Path) -> Prim? {
        let prim = value.GetPrimAtPath(path.value)
        return Bool(prim) ? Prim(value: prim) : nil
    }

    /// Returns the attribute at path on the same stage as this prim.
    public func GetAttributeAtPath(_ path: Sdf.Path) -> Attribute? {
        let attr = value.GetAttributeAtPath(path.value)
        return Bool(attr) ? Attribute(value: attr) : nil
    }

    /// Returns the relationship at path on the same stage as this prim.
    public func GetRelationshipAtPath(_ path: Sdf.Path) -> Relationship? {
        let rel = value.GetRelationshipAtPath(path.value)
        return Bool(rel) ? Relationship(value: rel) : nil
    }

    // MARK: - Payload / reference / inherits / specializes presence

    /// Return true if this prim has any authored payloads.
    public func HasAuthoredPayloads() -> Bool {
        value.HasAuthoredPayloads()
    }

    /// Return true if this prim has any authored references.
    public func HasAuthoredReferences() -> Bool {
        value.HasAuthoredReferences()
    }

    /// Return true if this prim has any authored inherits.
    public func HasAuthoredInherits() -> Bool {
        value.HasAuthoredInherits()
    }

    /// Return true if this prim has any authored specializes.
    public func HasAuthoredSpecializes() -> Bool {
        value.HasAuthoredSpecializes()
    }

    // MARK: - Load / unload

    /// Load this prim, all its ancestors, and by default all descendants.
    public func Load() {
        value.Load()
    }

    /// Unload this prim and all descendants.
    public func Unload() {
        value.Unload()
    }

    // MARK: - Instancing

    /// Author ‘instanceable’ metadata for this prim.
    public func SetInstanceable(_ instanceable: Bool) -> Bool {
        value.SetInstanceable(instanceable)
    }

    /// Clear authored ‘instanceable’ metadata.
    public func ClearInstanceable() -> Bool {
        value.ClearInstanceable()
    }

    /// Return true if this prim has an authored opinion for ‘instanceable’.
    public func HasAuthoredInstanceable() -> Bool {
        value.HasAuthoredInstanceable()
    }

    /// Return true if this prim is an instance of a prototype.
    public func IsInstance() -> Bool {
        value.IsInstance()
    }

    /// Return true if this prim is an instance proxy.
    public func IsInstanceProxy() -> Bool {
        value.IsInstanceProxy()
    }

    /// Return true if this prim is an instancing prototype prim.
    public func IsPrototype() -> Bool {
        value.IsPrototype()
    }

    /// Return true if this prim is a prototype prim or descendant of a prototype prim.
    public func IsInPrototype() -> Bool {
        value.IsInPrototype()
    }

    /// If this prim is an instance, return the corresponding prototype prim.
    public func GetPrototype() -> Prim? {
        let prototype = value.GetPrototype()
        return Bool(prototype) ? Prim(value: prototype) : nil
    }

    /// If this prim is an instance proxy, return the corresponding prim in the prototype.
    public func GetPrimInPrototype() -> Prim? {
        let prim = value.GetPrimInPrototype()
        return Bool(prim) ? Prim(value: prim) : nil
    }

    /// If this prim is a prototype prim, return all prims that are instances of it.
    public func GetInstances() -> [Prim] {
        value.GetInstances().map(Prim.init)
    }
}
