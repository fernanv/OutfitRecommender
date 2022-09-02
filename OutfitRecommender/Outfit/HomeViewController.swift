//
//  HomeController.swift
//  Armario
//
//  Created by Fernando Villalba  on 9/5/22.
//

import UIKit
import LocationPickerViewController

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, LocationPickerDelegate {
    
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var adviseLabel: UILabel!
    
    @IBOutlet weak var garmentsCollectionView: UICollectionView!
    
    var usuario: UserViewModel
    
    var selectedGarment: Garment?
    var selectedWeatherDay: DailyForecasts?
    let peticiones = WeatherRequests()
    let days = 5
    var weatherDays: [[DailyForecasts]] = []
    var location: LocationItem?
    var newLocation: Bool = false
    
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
    
    var outfit: [Garment]? = []
    
    private let refreshControl = UIRefreshControl()
    
    var outfitButton: UIButton = UIButton(frame: CGRect(x: 50,
                                                        y: 0,
                                                        width: 200,
                                                        height: 100))
    var usuarioLogueado = false
    
    var alert : UIAlertController {
        let garmentsAlert = UIAlertController(title: "Añade más prendas 👕 a tu Armario 😁",
                                              message: "Así podremos mostrarte un Outfit completo",
                                              preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel,
                                         handler: { (action: UIAlertAction!) in
        })
        
        garmentsAlert.addAction(cancelAction)
        
        return garmentsAlert
    }
    
    init(usuario: UserViewModel) {
        self.usuario = usuario
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
        Necesario para poder acceder al usuario sin que esté vacío y
        configurar así el botón que se muestra con las precondiciones
        para cargar un outfit
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.outfitButton.configuration = .filled()
        self.outfitButton.tintColor = .purple
        self.outfitButton.setTitleColor(.white,
                             for: .normal)
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.outfitButton.titleLabel?.font = .systemFont(ofSize: 18)
        }
        else {
            self.locationButton.isHidden = true
            self.outfitButton.titleLabel?.font = .systemFont(ofSize: 40)
        }
        self.outfitButton.layer.cornerRadius = 10
        self.outfitButton.titleLabel?.numberOfLines = 2
        self.outfitButton.titleLabel?.lineBreakMode = .byWordWrapping
        self.outfitButton.translatesAutoresizingMaskIntoConstraints = false
        
        if location == nil && !self.usuario.$estado.wrappedValue{
            
            self.usuarioLogueado = false
            self.adviseLabel.isHidden = true
            self.garmentsCollectionView.isHidden = true
            
            self.outfitButton.setTitle("Inicie sesión para\ncargar un conjunto", for: .normal)
            self.outfitButton.titleLabel?.textAlignment = .center
            self.outfitButton.addTarget(self,
                                     action: #selector(login),
                                     for: .touchUpInside)
        }
        else if location == nil && self.usuario.$estado.wrappedValue {

            self.usuarioLogueado = true
            self.adviseLabel.isHidden = true
            self.garmentsCollectionView.isHidden = true
            
            self.outfitButton.removeTarget(self,
                                     action: #selector(login),
                                     for: .touchUpInside)
            self.outfitButton.setTitle("Introduzca su ubicación\npara cargar un conjunto", for: .normal)
            self.outfitButton.titleLabel?.textAlignment = .center
            self.outfitButton.addTarget(self,
                                     action: #selector(selectLocation),
                                     for: .touchUpInside)
        }
        else if location != nil && !self.usuario.$estado.wrappedValue{

            self.usuarioLogueado = false
            self.adviseLabel.isHidden = true
            self.garmentsCollectionView.isHidden = true
            self.outfitButton.isHidden = false
            
            self.outfitButton.setTitle("Inicie sesión\npara cargar un conjunto", for: .normal)
            self.outfitButton.titleLabel?.textAlignment = .center
            self.outfitButton.addTarget(self,
                                     action: #selector(login),
                                     for: .touchUpInside)
        }
        else if location != nil && self.usuario.$estado.wrappedValue {
            
            self.usuarioLogueado = true
            self.adviseLabel.isHidden = false
            
            self.outfitButton.removeTarget(self, action: #selector(login), for: .touchUpInside)
            self.outfitButton.titleLabel?.numberOfLines = 1
            self.outfitButton.setTitle("Cargar Outfit",
                            for: .normal)
            self.outfitButton.addTarget(self,
                                     action: #selector(refreshGarments),
                                     for: .touchUpInside)
        }
        
        self.view.addSubview(self.outfitButton)
        
        let centerXConstraint = NSLayoutConstraint(item: self.outfitButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let centerYConstraint = NSLayoutConstraint(item: self.outfitButton, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        NSLayoutConstraint.activate([centerXConstraint, centerYConstraint])

    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.outfitButton.titleLabel?.font = .systemFont(ofSize: 18)
        }
        else {
            self.locationButton.isHidden = true
            self.outfitButton.titleLabel?.font = .systemFont(ofSize: 40)
        }
        
        self.garmentsCollectionView?.collectionViewLayout = MosaicLayout()
        self.garmentsCollectionView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.garmentsCollectionView?.alwaysBounceVertical = true
        self.garmentsCollectionView?.indicatorStyle = .white
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            self.garmentsCollectionView.refreshControl = refreshControl
        } else {
            self.garmentsCollectionView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self,
                                 action: #selector(refreshGarments),
                                 for: .valueChanged)
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Cargando un nuevo conjunto ...", attributes: [:])
        
        if location == nil {
           
            weatherCollectionView.isHidden = true
            self.adviseLabel.isHidden = true
            self.locationButton.isHidden = false
            
            self.locationButton.setTitle("Elegir ubicación 📍",
                            for: .normal)
            self.locationButton.setTitleColor(.magenta,
                                 for: .normal)
            self.locationButton.addTarget(self,
                                     action: #selector(selectLocation),
                                     for: .touchUpInside)
        }
        else{
            
            if self.usuarioLogueado {
                self.outfitButton.removeTarget(self, action: #selector(login), for: .touchUpInside)
                self.outfitButton.setTitle("Cargar Outfit",
                                for: .normal)
                self.outfitButton.addTarget(self,
                                         action: #selector(refreshGarments),
                                         for: .touchUpInside)
            }
            
            self.locationButton.setTitle("\(location?.name ?? "") 📍",
                            for: .normal)
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                self.locationButton.titleLabel?.font = .systemFont(ofSize: 25)
            }
            
            peticiones.location = location
            self.weatherCollectionView.isHidden = false
            //self.adviseLabel.isHidden = false
            
            self.weatherDays = []
            
            peticiones.cityRequest { resultCiudad in
                switch resultCiudad {
                    case let .success(responseCiudad):
                        
                        self.peticiones.weatherRequest(cityKey: responseCiudad.key) { resultTiempo in

                            switch resultTiempo {
                                case let .success(responseTiempo):
                                
                                
                                    self.weatherDays.append(responseTiempo.dailyForecast)
                                    self.weatherCollectionView.reloadData()
                                
                                    
                                case let .failure(errorTiempo):
                                    print(errorTiempo)

                                }
                        }
                        
                    case let .failure(errorCiudad):
                        print(errorCiudad)
                }
            }

            self.weatherCollectionView.reloadData()
            
        }
        
    }
    
    @objc
    func selectLocation(sender: Any?) {
        performSegue(withIdentifier: "LocationPickerSegue", sender: self)
    }
    
    @objc
    func login() {
        tabBarController?.selectedIndex = 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Show Location Picker via push segue.
        // LocationPicker in Storyboard.
        if segue.identifier == "LocationPickerSegue" {
            let locationPicker = segue.destination as! LocationPicker
            // User delegate
            locationPicker.delegate = self
            locationPicker.isAlternativeLocationEditable = true
        }
        else if (segue.identifier == "GarmentDetailFromOutfitSegue") {
            let vc = segue.destination as! GarmentDetailViewController
            vc.garment = selectedGarment
            vc.user = self.usuario
            vc.garmentTypes = self.sectionTitles
        }

    }
    
    @objc
    func refreshGarments(){
        self.outfitButton.isHidden = true
        self.adviseLabel.isHidden = false
        self.garmentsCollectionView.isHidden = false
        self.chooseGarments()
    }
    
    func chooseGarments(){
        self.refreshControl.isHidden = false
        if self.usuario.$estado.wrappedValue && usuario.user.garments!.count > 0 && self.location != nil {
            
            if self.selectedWeatherDay == nil || newLocation{
                self.selectedWeatherDay = self.weatherDays[0][0]
                newLocation = false
            }
            
            self.generateOutfit()
        }
        if usuario.user.garments!.count == 0 {
            self.present(alert,
                    animated: true,
                    completion: {self.refreshControl.isHidden = true
            })
        }
        self.garmentsCollectionView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func locationDidSelect(locationItem: LocationItem) {
        location = locationItem
        newLocation = true
        self.viewDidLoad()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.weatherCollectionView {
            return self.days
        }
        return outfit?.count ?? 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == self.weatherCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCollectionCell", for: indexPath) as! WeatherCollectionViewCell

            if !self.weatherDays.isEmpty {

                DispatchQueue.main.async {
                    
                    let icon = "\(self.weatherDays[0][indexPath.item].day.icon < 10 ? "0" : "")\(self.weatherDays[0][indexPath.item].day.icon)-s.png"
                    
                    cell.weatherImage.image = UIImage(named: icon)
                    
                    cell.weatherDay.text = self.weatherDays[0][indexPath.item].fecha
   
                }
            }
            
            if newLocation {
                cell.backgroundColor = nil
            }
        
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "outfitCollectionCell", for: indexPath)
            if outfit!.count > 0 {
                let imageView = UIImageView(image: self.outfit?[indexPath.item].image)
                imageView.frame = cell.frame
                cell.backgroundView = imageView
            }
            return cell
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.weatherCollectionView {
            
            let cell = collectionView.cellForItem(at: indexPath)

            let color = UIColor.init(red: 238.0/255.0, green: 211.0/255.0, blue: 242.0/255.0, alpha: 1.0)
            cell?.layer.cornerRadius = 20
            cell?.backgroundColor = color
            
            self.selectedWeatherDay = self.weatherDays[0][indexPath.item]
            
            if self.usuario.$estado.wrappedValue {
                self.refreshGarments()
            }
            
            let icon = "\(self.selectedWeatherDay!.day.icon < 10 ? "0" : "")\(self.selectedWeatherDay!.day.icon)-s.png"
            
            var popUpWindow: PopUpWindow!
            popUpWindow = PopUpWindow(title: "Día \(self.selectedWeatherDay?.fecha ?? "")",
                icon: icon,
                text: "Mínima: \(self.selectedWeatherDay!.temperature.min.value)º / Máxima: \(self.selectedWeatherDay!.temperature.max.value)º ", buttontext: "Cerrar")
                self.present(popUpWindow, animated: true, completion: nil)
        }
        else {
            if outfit != [] {
                self.selectedGarment = self.outfit![indexPath.item]
                self.performSegue(withIdentifier: "GarmentDetailFromOutfitSegue", sender: self)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == self.weatherCollectionView {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.backgroundColor = nil
        }
    }
    
    func generateOutfit() {
        
        self.outfit?.removeAll()
        
        // Si la temperatura es menor de 10º, se considera temperatura invernal
        if self.selectedWeatherDay?.temperature.min.value ?? 0 < 10 {
            // Si el usuario es una mujer
            if self.usuario.user.gender == "Mujer" {
                self.getWomenOutfit(type: 1)
            }
            // Si el usuario es un hombre
            else {
                self.getMenOutfit(type: 1)
            }
            
            if self.outfit?.count ?? 0 < 5 {
                self.present(alert,
                        animated: true,
                        completion: {self.refreshControl.isHidden = true
                })
            }
        }
        // Si la temperatura oscila entre 10º y 25º, se considera temperatura primaveral
        else if self.selectedWeatherDay?.temperature.min.value ?? 0 > 10 && self.selectedWeatherDay?.temperature.max.value ?? 0 < 25{
            // Si el usuario es una mujer
            if self.usuario.user.gender == "Mujer" {
                self.getWomenOutfit(type: 2)
            }
            // Si el usuario es un hombre
            else {
                self.getMenOutfit(type: 2)
            }
            
            if self.outfit?.count ?? 0 < 4 {
                self.present(alert,
                        animated: true,
                        completion: {self.refreshControl.isHidden = true
                })
            }
        }
        // Si la temperatura es mayor de 25º, se considera temperatura veraniega
        else if self.selectedWeatherDay?.temperature.max.value ?? 0 > 25 {
            // Si el usuario es una mujer
            if self.usuario.user.gender == "Mujer" {
                self.getWomenOutfit(type: 3)
            }
            // Si el usuario es un hombre
            else {
                self.getMenOutfit(type: 3)
            }
            
            if self.outfit?.count ?? 0 < 3 {
                self.present(alert,
                        animated: true,
                        completion: {self.refreshControl.isHidden = true
                })
            }
        }
    }
    
    func getMenOutfit(type: Int) {
        if type == 1 {
            let calzado = getGarmentsByType(types: ["Zapatillas"])
            if let calzado = calzado {
                self.outfit?.append(calzado)
            }
            
            let parte_inferior = getGarmentsByType(types: ["Pantalones"])
            if let parte_inferior = parte_inferior {
                self.outfit?.append(parte_inferior)
            }
            
            let camiseta = getGarmentsByType(types: ["Camisetas de manga larga", "Camisetas de manga corta", "Camisas de manga larga"])
            if let camiseta = camiseta {
                self.outfit?.append(camiseta)
            }
            
            let sudadera = getGarmentsByType(types: ["Sudaderas", "Jerseys", "Chaquetas"])
            if let sudadera = sudadera {
                self.outfit?.append(sudadera)
            }
            
            let abrigo = getGarmentsByType(types: ["Abrigos"])
            if let abrigo = abrigo {
                self.outfit?.append(abrigo)
            }
        }
        else if type == 2 {
            let calzado = getGarmentsByType(types: ["Zapatillas"])
            if let calzado = calzado {
                self.outfit?.append(calzado)
            }
            
            let parte_inferior = getGarmentsByType(types: ["Pantalones"])
            if let parte_inferior = parte_inferior {
                self.outfit?.append(parte_inferior)
            }
            
            let camiseta = getGarmentsByType(types: ["Camisetas de manga corta", "Camisas de manga larga"])
            if let camiseta = camiseta {
                self.outfit?.append(camiseta)
            }
            
            let sudadera = getGarmentsByType(types: ["Sudaderas", "Jerseys", "Chaquetas"])
            if let sudadera = sudadera {
                self.outfit?.append(sudadera)
            }
        }
        else {
            let calzado = getGarmentsByType(types: ["Zapatillas", "Chanclas y Sandalias"])
            if let calzado = calzado {
                self.outfit?.append(calzado)
            }
            
            let parte_inferior = getGarmentsByType(types: ["Bermudas"])
            if let parte_inferior = parte_inferior {
                self.outfit?.append(parte_inferior)
            }
            
            let camiseta = getGarmentsByType(types: ["Camisetas de manga corta", "Camisas de manga corta", "Camisas de manga larga"])
            if let camiseta = camiseta {
                self.outfit?.append(camiseta)
            }
        }
    }
    
    func getWomenOutfit(type: Int) {
        if type == 1 {
            let calzado = getGarmentsByType(types: ["Zapatillas"])
            if let calzado = calzado {
                self.outfit?.append(calzado)
            }
            
            let parte_inferior = getGarmentsByType(types: ["Pantalones"])
            if let parte_inferior = parte_inferior {
                self.outfit?.append(parte_inferior)
            }
            
            let camiseta = getGarmentsByType(types: ["Camisetas de manga larga", "Tops", "Camisetas de manga corta", "Camisas"])
            if let camiseta = camiseta {
                self.outfit?.append(camiseta)
            }
            
            let sudadera = getGarmentsByType(types: ["Sudaderas", "Jerseys", "Chaquetas"])
            if let sudadera = sudadera {
                self.outfit?.append(sudadera)
            }
            
            let abrigo = getGarmentsByType(types: ["Abrigos"])
            if let abrigo = abrigo {
                self.outfit?.append(abrigo)
            }
        }
        else if type == 2 {
            let calzado = getGarmentsByType(types: ["Zapatillas"])
            if let calzado = calzado {
                self.outfit?.append(calzado)
            }
            
            let parte_inferior = getGarmentsByType(types: ["Pantalones", "Faldas"])
            if let parte_inferior = parte_inferior {
                self.outfit?.append(parte_inferior)
            }
            
            let camiseta = getGarmentsByType(types: ["Camisetas de manga corta", "Tops", "Camisas", "Monos y Vestidos"])
            if let camiseta = camiseta {
                self.outfit?.append(camiseta)
            }
            
            let sudadera = getGarmentsByType(types: ["Sudaderas", "Jerseys", "Chaquetas"])
            if let sudadera = sudadera {
                self.outfit?.append(sudadera)
            }
        }
        else {
            let calzado = getGarmentsByType(types: ["Zapatillas", "Chanclas y Sandalias"])
            if let calzado = calzado {
                self.outfit?.append(calzado)
            }
            
            let parte_inferior = getGarmentsByType(types: ["Shorts", "Faldas"])
            if let parte_inferior = parte_inferior {
                self.outfit?.append(parte_inferior)
            }
            
            let camiseta = getGarmentsByType(types: ["Camisetas de manga corta", "Tops", "Monos y Vestidos"])
            if let camiseta = camiseta {
                self.outfit?.append(camiseta)
            }
        }
    }
    
    // MARK: - getGarmentsByType(type: String) : Obtiene todas las prendas de un tipo dado
    func getGarmentsByType(types: [String]) -> Garment?
    {

        var results : [Garment] = []
        
        for garment in self.usuario.user.garments! {
            for type in types {
                if (garment as! Garment).type == type {
                    results.append(garment as! Garment)
                }
            }
        }
        //print("Results type \(types) : \(results)")
        return results.randomElement() ?? nil
    }

}

extension LocationPicker {
    @objc open func locationDidSelect(locationItem: LocationItem) {
        pickCompletion?(locationItem)
        delegate?.locationDidSelect?(locationItem: locationItem)
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

