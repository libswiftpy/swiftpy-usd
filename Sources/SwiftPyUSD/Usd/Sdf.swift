//
//  Sdf.swift
//  openusd
//
//  Created by Tibor Felföldy on 2025-10-31.
//

import SwiftPy
import OpenUSD

@MainActor
@Scriptable(convertsToSnakeCase: false)
final class Sdf: PythonBindable {
    static let Path: object? = py.tpobject(SdfPath.pyType)
    static let AssetPath: object? = py.tpobject(SdfAssetPath.pyType)
    static let Layer: object? = py.tpobject(SdfLayer.pyType)
    static let TimeCode: object? = SdfTimeCode.pyTypeObject
}

@Scriptable("Sdf.TimeCode", convertsToSnakeCase: false)
public class SdfTimeCode: PythonConvertible {
    internal let base: pxr.SdfTimeCode
    
    internal init(_ base: pxr.SdfTimeCode) {
        self.base = base
    }
    
    convenience init(value: Double) {
        self.init(pxr.SdfTimeCode(value))
    }
}

@Scriptable("Sdf.AssetPath", convertsToSnakeCase: false)
final class SdfAssetPath {
    internal let base: pxr.SdfAssetPath
    
    init(path: String) {
        self.base = pxr.SdfAssetPath(std.string(path))
    }
}

@Scriptable("Sdf.Path", convertsToSnakeCase: false)
public final class SdfPath {
    internal let base: pxr.SdfPath

    internal init(base: pxr.SdfPath) {
        self.base = base
    }

    init(path: String) {
        self.base = pxr.SdfPath(std.string(path))
    }

    /// Return the string representation of this path.
    public func GetAsString() -> String {
        String(base.GetAsString())
    }
}

extension SdfPath: CustomStringConvertible {
    public var description: String {
        GetAsString()
    }
}

@Scriptable("Sdf.Layer", convertsToSnakeCase: false)
public class SdfLayer {
    internal let layer: pxr.SdfLayerHandle

    var realPath: String {
        let layerRef = Overlay.Dereference(layer)
        return String(layerRef.GetRealPath())
    }
    
    internal init(layer: pxr.SdfLayerHandle) {
        self.layer = layer
    }

    func Save() {
        let layerRef = Overlay.Dereference(layer)
        layerRef.Save()
    }
}
