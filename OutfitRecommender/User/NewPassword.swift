//
//  NuevaClave.swift
//  Armario
//
//  Created by Fernando Villalba  on 1/6/22.
//

import SwiftUI

struct NewPassword: View {

    // Atributos compartidos por otras vistas
    @ObservedObject var usuario : UserViewModel
    
    // Atributos privados de la vista
    @Environment(\.presentationMode) private var presentation
    
    private let colorFormulario = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    private let colorBoton = Color.init(hex: "FC60A8")
    private let colorFondo = Color(red: 107/255.0, green: 103/255.0, blue: 103/255.0, opacity: 0.0)
    
    var body: some View {
            
        ZStack{
            
            Color.init(CGColor.init(red: 240.0 / 255, green: 255.0 / 255, blue: 230.0 / 255, alpha: 1.0)).ignoresSafeArea(.all, edges: .top)
            
            // CONTENIDO
            VStack{
                
                if UIDevice.current.userInterfaceIdiom == .phone {
                    Button(action: {self.presentation
                            .wrappedValue
                            .dismiss()
                        self.usuario.email = ""
                        self.usuario.clave = ""
                        self.usuario.claveRepetida = ""
                    },
                           label: {
                                Image(systemName: "arrowshape.turn.up.backward.circle").resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                    })
                    .foregroundColor(colorBoton)
                    .padding(.trailing, 300.0)
                    .padding(.top, 30.0)
                }
                else {
                    Button(action: {self.presentation
                            .wrappedValue
                            .dismiss()
                        self.usuario.email = ""
                        self.usuario.clave = ""
                        self.usuario.claveRepetida = ""
                    },
                           label: {
                                Image(systemName: "arrowshape.turn.up.backward.circle").resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60)
                    })
                    .foregroundColor(colorBoton)
                    .padding(.trailing, 650.0)
                    .padding(.top, 30.0)
                }
                
                Spacer()
                    
                VStack(spacing: 20){
                    
                    Text("Cambiar Contraseña")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.init(hex: "7A28CB"))
                        .padding(.vertical, 20.0)
                    
                    Spacer()
                    
                    // Campo EMAIL
                    CustomTextField(imagen: "person", placeHolder: "Email", txt: self.$usuario.email, pass: false)
                    
                    // Campo CONTRASEÑA
                    CustomTextField(imagen: "lock", placeHolder: "Nueva contraseña", txt: self.$usuario.clave, pass: true)
                    
                    // Campo REPETIR CONTRASEÑA
                    CustomTextField(imagen: "lock", placeHolder: "Repetir contraseña", txt: self.$usuario.claveRepetida, pass: true)
                   
                    Spacer()
                }
                
                /* BOTÓN DE REGISTRO */
                Button(action: {
                    self.usuario.cambiarClave()
                    if self.usuario.nuevaClave{
                        self.usuario.nuevaClave.toggle()
                        self.presentation
                                .wrappedValue
                                .dismiss()
                    }
                    
                    }, label: {
                    Text("Continuar")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(self.colorBoton)
                        .cornerRadius(15.0)
                })
                .frame(alignment: .trailing)
                .padding(.vertical)
                .padding(.horizontal, 100.0)
                
                EspacioMedio()

            } // FIN CONTENIDO
            
            if self.usuario.cargando{
                VistaCargando().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
        }
        .navigationBarHidden(true)
        .alert(isPresented: self.$usuario.alerta, content: {
            Alert(title: Text("Notificación"), message: Text(self.usuario.mensajeAlerta), dismissButton: .destructive(Text("OK"), action: {
                // si se ha enviado el email de verificación se cierra la vista de Registro
                if self.usuario.mensajeAlerta == "Se ha modificado correctamente su contraseña"{
                    self.usuario.email = ""
                    self.usuario.clave = ""
                    self.usuario.claveRepetida = ""
                }
            }))
        })
    }
    
    struct NewPassword_Previews: PreviewProvider {
        static var usuario = UserViewModel()
        static var previews: some View {
            NewPassword(usuario: self.usuario)
        }
    }
     
}

