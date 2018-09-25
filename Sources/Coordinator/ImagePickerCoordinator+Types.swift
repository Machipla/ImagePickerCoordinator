//
//  ImagePickerCoordinator+Types.swift
//  PetSpotCoreUI
//
//  Created by Mario Chinchilla on 6/6/18.
//  Copyright © 2018 Machipla. All rights reserved.
//

import Foundation
import UIKit

public extension ImagePickerCoordinator{
    public struct Sources: OptionSet {
        public let rawValue: Int
        public var imagePickerControllerSourceTypeRawValue: Int { return self.rawValue >> 1 }
        
        public init(rawValue: Int) { self.rawValue = rawValue }
        public init(sourceType: UIImagePickerControllerSourceType) { self.init(rawValue: 1 << sourceType.rawValue) }
        
        public static let photoLibrary                       = ImagePickerCoordinator.Sources(sourceType: .photoLibrary)
        public static let camera                             = ImagePickerCoordinator.Sources(sourceType: .camera)
        public static let savedPhotosAlbum                   = ImagePickerCoordinator.Sources(sourceType: .savedPhotosAlbum)
        public static let none:ImagePickerCoordinator.Sources = []
        public static let all:ImagePickerCoordinator.Sources = [camera, photoLibrary, savedPhotosAlbum]
    }
    
    public enum UserSelection{
        case none
        case clearedImage
        case selectedImage(UIImage)
    }
    
    public enum FromControllerProvider{
        case topMost
        case specific(UIViewController)
        case byHandler(() -> UIViewController)
        
        public var providedController:UIViewController{
            switch self {
            case .topMost:                  return UIApplication.shared.topMostViewController!
            case .specific(let controller): return controller
            case .byHandler(let handler):   return handler()
            }
        }
    }
}
