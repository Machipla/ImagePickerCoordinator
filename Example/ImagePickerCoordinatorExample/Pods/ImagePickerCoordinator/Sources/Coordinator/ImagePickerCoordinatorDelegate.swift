//
//  ImagePickerCoordinatorDelegate.swift
//  PetSpotCoreUI
//
//  Created by Mario Chinchilla on 6/6/18.
//  Copyright © 2018 Machipla. All rights reserved.
//

import Foundation
import UIKit

public protocol ImagePickerCoordinatorDelegate: class{
    func imagePickerCoordinator(_ coordinator:ImagePickerCoordinator, hasSelected image:UIImage)
    func imagePickerCoordinator(_ coordinator:ImagePickerCoordinator, hasClearedSelectedImage image:UIImage)
    func imagePickerCoordinatorHasCancelled(_ coordinator:ImagePickerCoordinator)
}

public extension ImagePickerCoordinatorDelegate{
    func imagePickerCoordinator(_ coordinator:ImagePickerCoordinator, hasSelected image:UIImage){}
    func imagePickerCoordinator(_ coordinator:ImagePickerCoordinator, hasClearedSelectedImage image:UIImage){}
    func imagePickerCoordinatorHasCancelled(_ coordinator:ImagePickerCoordinator){}
}
