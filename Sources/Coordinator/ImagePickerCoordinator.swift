//
//  ImagePickerCoordinator.swift
//  PetSpotCoreUI
//
//  Created by Mario Chinchilla on 6/6/18.
//  Copyright © 2018 Machipla. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import CropViewController
import ImagePicker

public final class ImagePickerCoordinator: NSObject{
    
    /// Returns the selected image on the picker coordinator, either if it was selected or not by the user
    public var selectedImage:UIImage?
    /// Returns the image selected explicitly by the user.
    public var userSelectedImage:UIImage?{
        guard case .selectedImage(let image) = lastUserSelection else { return nil }
        return image
    }
    /// Last user selection made by the user
    public private(set) var lastUserSelection:UserSelection = .none
    
    public var canClearSelectedImageIfAny:Bool = true
    public var cropStyle:CropViewCroppingStyle? = .default
    public weak var delegate:ImagePickerCoordinatorDelegate?
    
    public weak var fromController:UIViewController!
    public private(set) weak var navigationController:UINavigationController?
    public private(set) weak var sourceSelectorController:UIAlertController?
    public private(set) weak var albumPickerController:UIImagePickerController?
    public private(set) weak var cameraController:ImagePickerController?
    public private(set) weak var cropController:CropViewController?
    public private(set) var currentSource:UIImagePickerControllerSourceType?
    
    public var availableSources:Sources = .all
    
    /// Contains all the possible sources specified by 'availableSources' var and the device capabilities.
    public var deviceFilteredSources:Sources{
        var sources:Sources = .none
        let sourceTypes:[UIImagePickerControllerSourceType] = [.photoLibrary, .camera, .savedPhotosAlbum]
        sourceTypes.forEach{
            let singleSource = ImagePickerCoordinator.Sources(sourceType: $0)
            if availableSources.contains(singleSource), UIImagePickerController.isSourceTypeAvailable($0){
                sources.insert(singleSource)
            }
        }
        
        return sources
    }
    
    public init(fromController:FromControllerProvider = .topMost){
        self.fromController = fromController.providedController
    }
    
    public func start(){
        let sourceSelectorController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if deviceFilteredSources.contains(.camera){
            let title = "COORDINATOR_SELECT_CAMERA".localized()
            let cameraAction = UIAlertAction(title: title, style: .default, handler: { _ in self.launchCamera() })
            sourceSelectorController.addAction(cameraAction)
        }
        
        if deviceFilteredSources.contains(.photoLibrary){
            let title = "COORDINATOR_SELECT_PHOTO_LIBRARY".localized()
            let photoLibraryAction = UIAlertAction(title: title, style: .default, handler: { _ in self.launchPhotoLibrary() })
            sourceSelectorController.addAction(photoLibraryAction)
        }
        
        if deviceFilteredSources.contains(.savedPhotosAlbum){
            let title = "COORDINATOR_SELECT_SAVED_PHOTOS".localized()
            let savedPhotosAlbumAction = UIAlertAction(title: title, style: .default, handler: { _ in self.launchPhotosAlbum() })
            sourceSelectorController.addAction(savedPhotosAlbumAction)
        }
        
        if let _ = selectedImage, canClearSelectedImageIfAny{
            let title = "COORDINATOR_SELECT_CLEAR_PHOTO".localized()
            let clearSelectedImageAction = UIAlertAction(title: title, style: .destructive, handler: { _ in self.clearSelectedImage() })
            sourceSelectorController.addAction(clearSelectedImageAction)
        }
        
        let cancelAction = UIAlertAction(title: "COORDINATOR_SELECT_CANCEL".localized(), style: .cancel, handler: nil)
        sourceSelectorController.addAction(cancelAction)
       
        fromController.present(sourceSelectorController, animated: true, completion: nil)
        self.sourceSelectorController = sourceSelectorController
    }
}

private extension ImagePickerCoordinator{
    func launchCamera(){
        currentSource = .camera
        
        let cameraController = ImagePickerController()
        cameraController.imageLimit = 1
        cameraController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: cameraController)
        
        fromController.present(navigationController, animated: true, completion: nil)
        self.navigationController = navigationController
        self.cameraController = cameraController
    }

    func launchPhotoLibrary(){
        currentSource = .photoLibrary
        
        let albumPickerController = UIImagePickerController()
        albumPickerController.delegate = self
        albumPickerController.sourceType = .photoLibrary
        albumPickerController.mediaTypes = [kUTTypeImage as String]
        
        fromController.present(albumPickerController, animated: true, completion: nil)
        self.navigationController = albumPickerController
        self.albumPickerController = albumPickerController
    }
    
    func launchPhotosAlbum(){
        currentSource = .savedPhotosAlbum
     
        let albumPickerController = UIImagePickerController()
        albumPickerController.delegate = self
        albumPickerController.sourceType = .savedPhotosAlbum
        albumPickerController.mediaTypes = [kUTTypeImage as String]
        
        fromController.present(albumPickerController, animated: true, completion: nil)
        self.navigationController = albumPickerController
        self.albumPickerController = albumPickerController
    }
    
    func clearSelectedImage(){
        guard let clearedImage = selectedImage else { return }
        
        selectedImage = nil
        finishFromClearingImage(clearedImage)
    }
    
    func launchCropControllerIfNecessary(for image:UIImage){
        guard let cropStyle = cropStyle else {
            finishWithSelectedImage(image)
            return
        }
            
        let cropController = CropViewController(croppingStyle: cropStyle, image: image)
        cropController.delegate = self
        
        navigationController?.pushViewController(cropController, animated: true)
        self.cropController = cropController
    }
    
    func finishFromClearingImage(_ clearedImage:UIImage){
        currentSource = nil
        lastUserSelection = .clearedImage
        delegate?.imagePickerCoordinator(self, hasClearedSelectedImage: clearedImage)
    }
    
    func finishFromCancelling(){
        currentSource = nil
        delegate?.imagePickerCoordinatorHasCancelled(self)
    }
    
    func finishWithSelectedImage(_ image:UIImage){
        currentSource = nil
        selectedImage = image
        lastUserSelection = .selectedImage(image)
        delegate?.imagePickerCoordinator(self, hasSelected: image)
    }
}

extension ImagePickerCoordinator: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        launchCropControllerIfNecessary(for: selectedImage)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { self.finishFromCancelling() }
    }
}

extension ImagePickerCoordinator: ImagePickerDelegate{
    public func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        guard let selectedImage = images.first else { return }
        launchCropControllerIfNecessary(for: selectedImage)
    }
    
    public func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        guard let selectedImage = images.first else { return }
        launchCropControllerIfNecessary(for: selectedImage)
    }
    
    public func cancelButtonDidPress(_ imagePicker: ImagePickerController){
        imagePicker.dismiss(animated: true) { self.finishFromCancelling() }
    }
}

extension ImagePickerCoordinator: CropViewControllerDelegate{
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int){
        cropViewController.dismiss(animated: true) { self.finishWithSelectedImage(image) }
    }
   
    public func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool){
        navigationController?.popViewController(animated: true)
    }
}
