//
//  ViewController.swift
//  Armario
//  REF: https://stackoverflow.com/questions/40154238/collectionview-with-the-horizontal-scroll-with-mulitple-section
//  Created by Fernando Villalba  on 4/4/22.
//

import UIKit
import CoreData

let sectionTitlesMen = [
    "Abrigos",
    "Camisetas de manga larga",
    "Camisetas de manga corta",
    "Chaquetas",
    "Pantalones",
    "Jerseys",
    "Camisas de manga larga",
    "Camisas de manga corta",
    "Sudaderas",
    "Zapatillas",
    "Bermudas",
    "Chanclas y Sandalias",
]

let sectionTitlesWomen = [
    "Abrigos",
    "Camisetas de manga larga",
    "Camisetas de manga corta",
    "Chaquetas",
    "Tops",
    "Camisas",
    "Pantalones",
    "Monos y Vestidos",
    "Jerseys",
    "Sudaderas",
    "Zapatillas",
    "Shorts",
    "Faldas",
    "Chanclas y Sandalias",
]

let colors = [
    "Negro",
    "Azul",
    "Marrón",
    "Gris",
    "Verde",
    "Naranja",
    "Rosa",
    "Morado",
    "Rojo",
    "Blanco",
    "Amarillo",
    "Multicolor",
]

class GarmentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CollectionViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var usuario: UserViewModel!
    
    var managedContext: NSManagedObjectContext! {
        get
        {
            return usuario.coreDataStack.context
        }
    }
    
    var sectionToUpdate: IndexSet?
    
    var sectionTitles : [String] {
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

    
    var selectedGarment: Garment?
    
    let button = UIButton(frame: CGRect(x: 50,
                                        y: 0,
                                        width: 200,
                                        height: 60))
    
    /*init(usuario: UserViewModel) {
        self.usuario = usuario
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
    
    // MARK: UIViewController methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        if !self.usuario.$estado.wrappedValue{
            
            tableView.isHidden = true
            
            navigationController?.setNavigationBarHidden(true, animated: false)
            
            button.setTitle("Iniciar sesión",
                            for: .normal)
            button.setTitleColor(.magenta,
                                 for: .normal)
            button.addTarget(self, action: #selector(login),
                            for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(button)
            
            // Ref: https://stackoverflow.com/questions/51218604/how-to-make-the-button-centre-aligned-in-all-ios-devices-programmatically-in-swi
            let centerXConstraint = NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
                let centerYConstraint = NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0.0)
                NSLayoutConstraint.activate([centerXConstraint, centerYConstraint])
        }
        else{

            button.removeFromSuperview()

            navigationController?.setNavigationBarHidden(false, animated: false)

            tableView.isHidden = false
            tableView.reloadData()
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usuario.getUserByEmail(email: self.usuario.email)
        
        navigationController?.navigationBar.barTintColor = UIColor(cgColor: CGColor(red: 159/255.0, green: 129/255.0, blue: 159/255.0, alpha: 1.0))
        // Register the custom header view.
        tableView.register(GarmentsCustomHeaderSection.self,
            forHeaderFooterViewReuseIdentifier: "garmentsSectionHeader")
        
        if self.usuario.$estado.wrappedValue {
            button.removeFromSuperview()
            
            tableView.isHidden = false
            tableView.reloadData()
        }
        else {
            tableView.isHidden = true
        }

    }
    
    @objc
    func login() {
        tabBarController?.selectedIndex = 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "GarmentDetailSegue") {
            let vc = segue.destination as! GarmentDetailViewController
            vc.garment = selectedGarment
            vc.user = self.usuario
            vc.garmentTypes = self.sectionTitles
        }
        else if (segue.identifier == "AddGarmentSegue") {
            if let vc = segue.destination as? AddGarmentViewController {
                vc.usuario = self.usuario
            }
        }
    }
    
    // MARK: UITableViewDataSource methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView,
            viewForHeaderInSection section: Int) -> UIView? {

       let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                   "garmentsSectionHeader") as! GarmentsCustomHeaderSection
       view.title.text = sectionTitles[section]

       return view
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "garmentsTableCell", for: indexPath) as! GarmentsTableViewCell

        cell.sectionHeader = sectionTitles[indexPath.section]
        cell.cellDelegate = self
        cell.coreDataStack = self.usuario.coreDataStack
        cell.usuario = self.usuario
        cell.collectionView.reloadData()

        return cell
    }

    // MARK: UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    // MARK: CollectionViewCellDelegate methods
    
    func collectionView(collectionviewcell: GarmentsCollectionViewCell?, index: Int, didTappedInTableViewCell: GarmentsTableViewCell) {
        let indiceSeccion = sectionTitles.firstIndex(of: didTappedInTableViewCell.sectionHeader ?? "") ?? 0
        
        self.sectionToUpdate = IndexSet(integer: indiceSeccion)
        
        self.selectedGarment = didTappedInTableViewCell.sectionGarments[index]
        self.performSegue(withIdentifier: "GarmentDetailSegue", sender: self)
    }
    
}
