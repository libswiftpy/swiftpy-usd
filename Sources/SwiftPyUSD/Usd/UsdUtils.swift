//
//  UsdUtils.swift
//  openusd
//
//  Created by Tibor Felföldy on 2025-10-31.
//

import SwiftPy
import OpenUSD
import Sdf

@Scriptable(convertsToSnakeCase: false)
final class UsdUtils {
    static func CreateNewARKitUsdzPackage(assetPath: String, outputPath: String, layerName: String = "Root") -> Bool {
        let assetPath = AssetPath(path: assetPath)
        return pxr.UsdUtilsCreateNewARKitUsdzPackage(assetPath.value, std.string(outputPath), std.string(layerName))
    }
}
