//
//  Usuario.swift
//  Armario
//
//  Created by Fernando Villalba  on 11/5/22.
//

import SwiftUI
import CryptoKit
import CoreData

final class UserViewModel : ObservableObject, Identifiable {
    
    let coreDataStack = CoreDataStack()
    var user : User
    
    internal var id: String = "-1"
    //@Published var email: String = ""
    @Published var emailRegistro: String = ""
    @Published var claveRegistro: String = ""
    @Published var claveRepetida: String = ""
    @Published var clave: String = "" // Contraseña
    @Published var nombre: String = ""
    @Published var genero: String = ""
    @Published var estaRegistrado: Bool = false
    @Published var nuevaClave: Bool = false
    @Published var cargando: Bool = false
    
    // Alertas de Error
    @Published var alerta = false
    @Published var mensajeAlerta = ""
    
    // Estado del usuario
    @AppStorage("estado") var estado = false
    @AppStorage("email") var email: String = ""
    
    init(){
        
        let userEntity = NSEntityDescription.entity(forEntityName: "User",
                                                    in: self.coreDataStack.context)!
        
        self.user = User(entity: userEntity, insertInto: self.coreDataStack.context)
        
        self.user.garments = []
        self.user.name = ""
        self.user.email = ""
        self.user.password = ""
        self.user.gender = ""
        self.user.age = 0
    }

    func Identificarse(){
        // Comprobación de errores en los inputs
        if self.email == "" || self.clave == ""{
            self.mensajeAlerta = "Por favor, rellene los campos"
            self.alerta.toggle()
            return
        }
        
        if !isValidEmail(self.email) {
            self.mensajeAlerta = "El formato del email introducido no es correcto"
            self.alerta.toggle()
            return
        }
        
        withAnimation{
            self.cargando = true
        }
        
        //Encryptamos la contraseña
        let inputData = Data(self.clave.utf8)
        let hashed = SHA256.hash(data: inputData).description
 
        self.getUserByEmail(email: self.email)
        
        if self.user.name == "" {
            withAnimation{
                 self.cargando = false
             }
            self.mensajeAlerta = "El email introducido no está registrado"
            self.alerta.toggle()
            return
        }
        
        if self.user.password == hashed {
             
            withAnimation{
                 self.cargando = false
             }

            self.nombre = self.user.name!
            self.genero = self.user.gender!
            self.email = self.user.email!
            self.clave = self.user.password!
            self.id = self.user.objectID.description
            
             // Cambiamos el estado del usuario a true
             withAnimation{
                 self.estado = true
             }
        }
        
        else {
            withAnimation{
                 self.cargando = false
             }
            self.mensajeAlerta = "La contraseña introducida no es correcta"
            self.alerta.toggle()
            return
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        
        // REF: https://emailregex.com
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
    
    func cambiarClave() {
        
        if self.email == "" || self.clave == "" || self.claveRepetida == ""{
            self.mensajeAlerta = "Por favor, rellene los campos"
            self.alerta.toggle()
            return
        }
        
        if self.clave != self.claveRepetida{
            self.mensajeAlerta = "La contraseña no coincide con la de arriba"
            self.alerta.toggle()
            return
        }
        
        if !isValidEmail(self.email) {
            self.mensajeAlerta = "El formato del email introducido no es correcto"
            self.alerta.toggle()
            return
        }
        
        withAnimation{
            self.cargando = true
        }

        //Encryptamos la contraseña
        let inputData = Data(self.clave.utf8)
        let hashed = SHA256.hash(data: inputData).description
        
        self.getUserByEmail(email: self.email)
        
        if self.user.name == "" {
            withAnimation{
                 self.cargando = false
             }
            self.mensajeAlerta = "El email introducido no está registrado"
            self.alerta.toggle()
            return
        }
        
        /*if self.user.password == hashed {
            self.mensajeAlerta = "La nueva contraseña debe ser diferente a la actual"
            self.alerta.toggle()
            return
        }*/
        
        self.user.password = hashed
        self.coreDataStack.saveContext()
        
        self.mensajeAlerta = "Se ha modificado correctamente su contraseña"
        self.alerta.toggle()
        
        self.nuevaClave = true
        
        withAnimation{
             self.cargando = false
         }
    }
    
    // MARK: - getUserByEmail(email: String) : Obtiene un usuario según su email
    func getUserByEmail(email: String)
    {

        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        var results: [User] = []
        
        let userEntity = NSEntityDescription.entity(forEntityName: "User",
                                                    in: self.coreDataStack.context)!
        
        let user = User(entity: userEntity, insertInto: self.coreDataStack.context)
        user.garments = []
        user.name = ""
        user.email = ""
        user.password = ""
        user.gender = ""
        user.age = 0
        
        do
        {
            results = try self.coreDataStack.context.fetch(fetchRequest)
            self.user = results.first ?? user
            
            self.nombre = self.user.name!
            self.genero = self.user.gender!
            self.email = self.user.email!
            self.clave = self.user.password!
            self.id = self.user.objectID.description
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    func Registrarse(){

        // Comprobación de errores en los inputs
        if self.emailRegistro == "" || self.claveRegistro == "" || self.claveRepetida == "" || self.nombre == "" || self.genero == ""{
            self.mensajeAlerta = "Por favor, rellene los campos"
            self.alerta.toggle()
            return
        }

        if self.claveRegistro != self.claveRepetida{
            self.mensajeAlerta = "La contraseña no coincide con la de arriba"
            self.alerta.toggle()
            return
        }
        
        if !isValidEmail(self.emailRegistro) {
            self.mensajeAlerta = "El formato del email introducido no es correcto"
            self.alerta.toggle()
            return
        }
  
        withAnimation{
            self.cargando = true
        }

        //Encryptamos la contraseña
        let inputData = Data(self.claveRegistro.utf8)
        let hashed = SHA256.hash(data: inputData).description

        self.user.name = self.nombre
        self.user.gender = self.genero
        self.user.password = hashed
        self.user.email = self.emailRegistro
        self.user.age = 20
        self.id = self.user.objectID.description
        
        self.coreDataStack.saveContext()
        
        withAnimation{
            self.cargando = false
        }
        
        self.mensajeAlerta = "Se ha realizado el registro con éxito"
        self.alerta.toggle()
        self.estaRegistrado.toggle()
    
    }
    
    func cerrarSesion(){

        withAnimation{
            self.cargando = true
        }
        
        withAnimation{
            self.estado = false
        }
        
        // Limpiando los datos
        self.id = ""
        self.email = ""
        self.clave = ""
        self.emailRegistro = ""
        self.claveRegistro = ""
        self.claveRepetida = ""
        self.nombre = ""
        self.genero = ""
        
        withAnimation{
            self.cargando = false
        }
    }
    
    func eliminarCuenta(){
        
        let alerta = UIAlertController(title: "Eliminar cuenta", message: "Se eliminarán todos sus datos definitivamente", preferredStyle: .alert)
        
        let seguir = UIAlertAction(title: "Eliminar", style: .default) { _ in
            
            withAnimation{
                self.cargando = true
            }
            
            // Eliminar usuario
            
            self.coreDataStack.context.delete(self.user)
            
            self.coreDataStack.saveContext()
            
            withAnimation{
                self.estado = false
            }
            
            // Limpiando los datos
            self.id = ""
            self.email = ""
            self.clave = ""
            self.emailRegistro = ""
            self.claveRegistro = ""
            self.claveRepetida = ""
            self.nombre = ""
            self.genero = ""
            
            withAnimation{
                self.cargando = false
            }
        }
        
        withAnimation{
            self.cargando = false
        }
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        
        alerta.addAction(cancelar)
        alerta.addAction(seguir)
        
        // Presentación
        UIApplication.shared.keyWindow?.rootViewController?.present(alerta, animated: true)
    }
    
    func recoverData() {
        
    }
    
}

// REF: https://stackoverflow.com/questions/68387187/how-to-use-uiwindowscene-windows-on-ios-15
extension UIApplication {
    
    var keyWindow: UIWindow? {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
    
}
