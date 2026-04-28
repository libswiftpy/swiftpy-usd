//
//  UsdUtils.swift
//  swiftpy-usd
//
//  Created by Tibor Felföldy on 2026-04-28.
//

import SwiftPy
import Sdf
import CxxStdlib
import pxr

public func CreateNewUsdzPackage(
    assetPath: AssetPath,
    usdzFilePath: String,
    firstLayerName: String
) -> Bool {
    pxr.UsdUtilsCreateNewARKitUsdzPackage(
        assetPath.value,
        std.string(usdzFilePath),
        std.string(firstLayerName)
    )
}

@MainActor
public func bindModule() {
    PyBind.module("pxr.UsdUtils") { UsdUtils in
        UsdUtils.def(
            "CreateNewARKitUsdzPackage(asset_path: str, usdz_file_path: str, layer_name: str = 'Root') -> bool",
            docstring: "Packages all of the dependencies of the given asset."
        ) { argc, argv in
            PyBind.function(argc, argv) { (
                assetPath: PyAPI.Reference,
                usdzFilePath: String,
                layerName: String
            ) in
                let assetPath = try Sdf.AssetPath(assetPath) ?? Sdf.AssetPath(path: String.cast(assetPath))
                
                return CreateNewUsdzPackage(
                    assetPath: assetPath,
                    usdzFilePath: usdzFilePath,
                    firstLayerName: layerName
                )
            }
        }
    }
}
