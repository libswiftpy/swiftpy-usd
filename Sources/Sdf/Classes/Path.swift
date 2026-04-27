//
//  Path.swift
//  swiftpy-usd
//
//  Created by Tibor Felföldy on 2026-04-27.
//

import SwiftPy
import pxr
import CxxStdlib

@Scriptable(convertsToSnakeCase: false)
public final class Path: ClassWrapper<pxr.SdfPath> {
    internal override init(value: pxr.SdfPath) {
        super.init(value: value)
    }

    public init(path: String) {
        super.init(value: pxr.SdfPath(std.string(path)))
    }

    /// Return the string representation of this path.
    public func GetAsString() -> String {
        String(value.GetAsString())
    }
}

extension Path: @MainActor CustomStringConvertible {
    public convenience init(_ value: pxr.SdfPath) {
        self.init(value: value)
    }

    public var description: String { GetAsString() }
}

@Scriptable(convertsToSnakeCase: false)
public final class AssetPath: ClassWrapper<pxr.SdfAssetPath> {
    internal override init(value: pxr.SdfAssetPath) {
        super.init(value: value)
    }

    public init(path: String) {
        super.init(value: pxr.SdfAssetPath(std.string(path)))
    }
}

extension AssetPath {
    public convenience init(_ value: pxr.SdfAssetPath) {
        self.init(value: value)
    }
}
