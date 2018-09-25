//
//  String+Localized.swift
//  Pods
//
//  Created by Mario Chinchilla on 22/6/17.
//
//

import Foundation

internal extension String{
    func localized() -> String{
        return NSLocalizedString(self, tableName: nil, bundle: ModuleBundles.resourcesBundle, value: "", comment: "")
    }
}
