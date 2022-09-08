//
//  AddGarmentViewController.swift
//  Armario
//
//  Created by Fernando Villalba  on 19/4/22.
//

import UIKit
import CoreData
import DropDown

class AddGarmentViewController : UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var usuario: UserViewModel!
    
    var managedContext: NSManagedObjectContext! {
        get
        {
            return usuario.coreDataStack.context
        }
    }
    
    var garment: Garment?
    
    var garmentTypes: [String] {
        get
        {
            if usuario.user.gender == "Hombre" {
                return sectionTitlesMen
            }
            else {
                return sectionTitlesWomen
            }
        }
    }
    
    @IBOutlet var attachPhotoButton : UIButton!
    @IBOutlet weak var garmentName : UITextField!
    @IBOutlet weak var garmentTypeLabel: UILabel!
    @IBOutlet weak var garmentColorLabel: UILabel!
    @IBOutlet weak var garmentTypeView: UIView!
    @IBOutlet weak var garmentColorView: UIView!
    @IBOutlet var attachedPhoto : UIImageView!
    
    let dropDownTypes = DropDown()
    let dropDownColors = DropDown()
    
    /*init(usuario: UserViewModel) {
        self.usuario = usuario
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
    
    override func viewDidLoad() {
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.purple]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        dropDownTypes.anchorView = garmentTypeView
        dropDownColors.anchorView = garmentColorView // UIView or UIButton

        // For set direction .top, .bottom or .any(for automatic)
        dropDownColors.direction = .bottom
        dropDownColors.dataSource = colors
        
        dropDownTypes.direction = .bottom
        dropDownTypes.dataSource = self.garmentTypes

        // select item from dropdown
        dropDownTypes.selectionAction = { [] (index: Int, item: String) in
           print("Selected item: \(item) at index: \(index)")
            self.garmentTypeLabel.text = item
        }
        
        // select item from dropdown
        dropDownColors.selectionAction = { [] (index: Int, item: String) in
           print("Selected item: \(item) at index: \(index)")
            self.garmentColorLabel.text = item
        }
        
        self.garment = NSEntityDescription.insertNewObject(forEntityName: "Garment", into: managedContext) as? Garment
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if let image = self.garment?.image {
            attachedPhoto.image = image
            view.endEditing(true)
        }
        else {
            garmentName.becomeFirstResponder()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
      if segue.identifier == "AttachPhotoSegue" {
        if let nextViewController = segue.destination as? AttachGarmentPhotoViewController {
            nextViewController.garment = self.garment
        }
      }
    }
    
    // MARK: - showTypes
    @IBAction func showTypes (_ sender:Any) {
        dropDownTypes.show()
    }
    
    // MARK: - showColors
    @IBAction func showColors (_ sender:Any) {
        dropDownColors.show()
    }

    // MARK: - addGarment
    @IBAction func createGarment(_ sender:AnyObject)
    {
        
        let alert = UIAlertController(title: "Añadir nueva prenda",
                                      message: "¿Está todo correcto?",
                                      preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: { (action: UIAlertAction!) in
        })
        
        let createAction = UIAlertAction(title: "Create",
                                         style: .default,
                                       handler: { (action: UIAlertAction!) in
                                            self.newGarment()
        })
        
        alert.addAction(cancelAction)
        alert.addAction(createAction)
        
        present(alert,
                animated: true,
                completion: nil)
        
    }
    
    private func newGarment(){

        let alert = UIAlertController(title: "Añadir nueva prenda",
                                      message: "¿Está todo correcto?",
                                      preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel,
                                         handler: { (action: UIAlertAction!) in
        })
        alert.addAction(cancelAction)
        
        if self.garmentName.text != "" {
            self.garment!.name = self.garmentName.text
        }
        else {
            alert.message = "Debe introducir el nombre de la prenda"
        }
        
        if self.garmentTypeLabel.text != "Tipo de la prenda" {
            self.garment!.type = self.garmentTypeLabel.text
        }
        else {
            alert.message = "Debe introducir el tipo de la prenda"
        }
        
        if self.garmentColorLabel.text != "Color de la prenda" {
            self.garment!.color = self.garmentColorLabel.text
        }
        else {
            alert.message = "Debe introducir el color de la prenda"
        }
        
        let targetSize = CGSize(width: 120, height: 100)
        
        if self.attachedPhoto.image != nil {
            self.garment!.image = attachedPhoto.image?.scalePreservingAspectRatio(targetSize: targetSize)
        }
        else {
            alert.message = "Debe introducir una imagen para la prenda"
        }
        
        if self.garmentName.text == "" || self.garmentTypeLabel.text == "Tipo de la prenda" || self.garmentColorLabel.text == "Color de la prenda" || self.attachedPhoto.image == nil {
                present(alert,
                        animated: true,
                        completion: nil)
        }
        else {
            alert.dismiss(animated: true, completion: nil)
        }
        
        self.garment!.user = self.usuario.user
        
        self.usuario.user.addToGarments(garment!)
  
        self.usuario.coreDataStack.saveContext()

        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - createItem
    @IBAction func cancel (_ sender:Any) {
        navigationController?.popViewController(animated: true)
    }
}

