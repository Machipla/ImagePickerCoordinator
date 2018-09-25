//
//  ViewController.swift
//  ImagePickerCoordinatorExample
//
//  Created by Mario Plaza on 25/9/18.
//  Copyright © 2018 Mario Plaza. All rights reserved.
//

import UIKit
import ImagePickerCoordinator

class ViewController: UIViewController {

    @IBOutlet weak var imageView:UIImageView!
    private var imagePickerCoordinator:ImagePickerCoordinator!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        imagePickerCoordinator = ImagePickerCoordinator(fromController: .specific(self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerCoordinator.delegate = self
        
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 5
        imageView.layer.borderColor = UIColor(red: 35/255, green: 125/255, blue: 255/255, alpha: 1).cgColor
    }

    @IBAction func changePictureTapped(){
        imagePickerCoordinator.start()
    }

}

extension ViewController: ImagePickerCoordinatorDelegate{
    func imagePickerCoordinator(_ coordinator: ImagePickerCoordinator, hasSelected image: UIImage) {
        imageView.image = image
    }
    
    func imagePickerCoordinator(_ coordinator: ImagePickerCoordinator, hasClearedSelectedImage image: UIImage) {
        imageView.image = nil
    }
}
