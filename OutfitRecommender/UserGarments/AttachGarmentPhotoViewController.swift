//
//  AttachPhotoViewController.swift
//  Armario
//
//  Created by Fernando Villalba  on 19/4/22.
//

import UIKit

class AttachGarmentPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
    var garment : Garment?
  
    lazy var imagePicker : UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        self.addChild(picker)
        return picker
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imagePicker.view)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imagePicker.view.frame = view.bounds
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let garment = garment {

            garment.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        }
        
       self.navigationController?.popViewController(animated: true)
    }
}

