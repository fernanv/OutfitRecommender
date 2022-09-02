//
//  Perfil.swift
//  Armario
//
//  Created by Fernando Villalba  on 9/5/22.
//

import SwiftUI


struct Profile: View {
    
    // Atributos compartidos por otras vistas
    @Binding var login: Bool
    @Binding var perfil: Bool

    @ObservedObject var usuario : UserViewModel
    
    // Atributos privados de la vista
    @State private var mostrarPedidos = false
    @State private var menu = false

    private let colorBoton1 = Color.init(hex: "7A28CB")
    private let colorBoton2 = Color.init(hex: "FC60A8")
    
    var body: some View {
            
        ZStack{
            
            Color.init(CGColor.init(red: 240.0 / 255, green: 255.0 / 255, blue: 230.0 / 255, alpha: 1.0)).ignoresSafeArea(.all, edges: .top)
            
            // CONTENIDO
            VStack{
                
                Group{
                    EspacioGrande()
                }
                
                Group{
                    Text("Bienvenido/a")
                        .padding(.vertical, 10.0)
                    Text("\(self.usuario.nombre)")
                        .font(.title2)
                        .fontWeight(.bold)
                    EspacioGrande()
                }
                .font(.custom("Roboto-MediumItalic", size: 20))
                .foregroundColor(Color.init(hex: "7A28CB"))
    
                Group{
                    EspacioMedio()
                    
                    /* BOTÓN CERRAR SESIÓN */
                    Button(action: {
                        self.cerrarSesion()
                        }, label: {
                        Text("Cerrar sesión")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(self.colorBoton2)
                            .cornerRadius(15.0)
                    })
                    .padding(.vertical, 30.0)
                    .padding(.horizontal, 100.0)
                    
                    Spacer()
                    
                    /* BOTÓN CERRAR SESIÓN */
                    Button(action: {
                        print(self.usuario.user.name!)
                        self.eliminarCuenta()
                        }, label: {
                        Text("Eliminar mi cuenta")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(Color.init(hex: "494368"))
                            .cornerRadius(15.0)
                    })
                    .padding(.vertical, 30.0)
                    .padding(.horizontal, 100.0)
                }
                
                Group{
                    EspacioPeque()
                }
                
            } // FIN CONTENIDO
            
            if self.usuario.cargando{
                VistaCargando().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
        }

    }
    
    func cerrarSesion(){
        self.login = true
        self.usuario.cerrarSesion()
    }
    
    func eliminarCuenta(){
        self.login = true
        self.usuario.eliminarCuenta()
    }

    struct Profile_Previews: PreviewProvider {
        static var usuario = UserViewModel(coreDataStack: CoreDataStack())
        static var previews: some View {
            Group {
                Profile(login: Binding.constant(true), perfil: Binding.constant(false), usuario: self.usuario)
            }
        }
    }
    
}


