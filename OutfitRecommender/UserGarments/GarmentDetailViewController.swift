//
//  ClothesDetailView.swift
//  Armario
//
//  Created by Fernando Villalba  on 5/4/22.
//

import UIKit
import CoreData
import DropDown

class GarmentDetailViewController: UIViewController {
    
    var user: UserViewModel
    
    var managedContext: NSManagedObjectContext! {
        get
        {
            return user.coreDataStack.context
        }
    }
    
    var garment: Garment!
    var garmentTypes: [String]!
    
    @IBOutlet weak var garmentNameLabel: UILabel!
    @IBOutlet weak var garmentTypeLabel: UILabel!
    @IBOutlet weak var garmentColorLabel: UILabel!
    @IBOutlet weak var garmentTypeView: UIView!
    @IBOutlet weak var garmentColorView: UIView!
    @IBOutlet weak var garmentImage: UIImageView!

    let dropDownTypes = DropDown()
    let dropDownColors = DropDown()
    
    init(user: UserViewModel) {
        self.user = user
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Se desenvuelven los valores correspondientes a la prenda pasados a través del ítem correspondiete del CollectionView y se asignan a los elementos de la interfaz
        if let name = garment.name, let type = garment.type, let color = garment.color, let image = garment.image {
            self.garmentNameLabel.text = name
            self.garmentTypeLabel.text = type
            self.garmentColorLabel.text = color
            self.garmentImage.image = image
        }
        
        dropDownTypes.anchorView = garmentTypeView
        dropDownColors.anchorView = garmentColorView // UIView or UIButton

        // For set direction .top, .bottom or .any(for automatic)
        dropDownColors.direction = .top
        dropDownColors.dataSource = colors
        
        dropDownTypes.direction = .top
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

    }
    
    @IBAction func deleteGarment(_ sender: AnyObject)
    {
        let alert = UIAlertController(title: "¿Realmente quieres eliminar esta prenda?",
                                      message: "Esta acción no se puede deshacer",
                                      preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: { (action: UIAlertAction!) in
        })
        
        let deleteAction = UIAlertAction(title: "Delete",
                                       style: .destructive,
                                       handler: { (action: UIAlertAction!) in
    
                                        self.deleteItem()
        })
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert,
                animated: true,
                completion: nil)
    }
    
    // MARK: - showTypes
    @IBAction func showTypes (_ sender:Any) {
        dropDownTypes.show()
    }
    
    // MARK: - showColors
    @IBAction func showColors (_ sender:Any) {
        dropDownColors.show()
    }
    
    // MARK: - deleteItem
    private func deleteItem() {
        managedContext.delete(garment)
        user.coreDataStack.saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editGarment(_ sender:Any)
    {
        let alert = UIAlertController(title: "Editar prenda",
                                      message: "¿Está todo correcto?",
                                      preferredStyle: UIAlertController.Style.alert)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: { (action: UIAlertAction!) in
        })
        
        let editAction = UIAlertAction(title: "Edit",
                                       style: .destructive,
                                       handler: { (action: UIAlertAction!) in
    
                                        self.changeGarmentData()
        })
        
        alert.addAction(cancelAction)
        alert.addAction(editAction)
        
        present(alert,
                animated: true,
                completion: nil)
    }
    
    private func changeGarmentData(){

        garment.name = self.garmentNameLabel.text
        garment.type = self.garmentTypeLabel.text
        garment.color = self.garmentColorLabel.text
        garment.image = self.garmentImage.image
 
        user.coreDataStack.saveContext()
        
        navigationController?.popViewController(animated: true)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "DeleteItemSegue") {
            let vc = segue.destination as! HomeViewController
            vc.usuario = self.user
        }
    }
}
