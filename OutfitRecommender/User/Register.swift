//
//  Registro.swift
//  Armario
//
//  Created by Fernando Villalba  on 9/5/22.
//

import SwiftUI

enum Gender: String, CaseIterable, Identifiable {
    case hombre = "Hombre"
    case mujer = "Mujer"
    
    var id: String { self.rawValue }
}

struct Register: View {

    // Atributos compartidos por otras vistas
    @ObservedObject var usuario : UserViewModel
    
    // Atributos privados de la vista
    @Environment(\.presentationMode) private var presentation
    
    @State private var selection: Gender = Gender.hombre
    private let colorBoton = Color.init(hex: "FC60A8")
    
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
                    
                    Text("Registro")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.init(hex: "7A28CB"))
                        .padding(.vertical, 20.0)
                    
                    // Campo EMAIL
                    CustomTextField(imagen: "person", placeHolder: "Email", txt: self.$usuario.emailRegistro, pass: false)
                    
                    // Campo CONTRASEÑA
                    CustomTextField(imagen: "lock", placeHolder: "Contraseña", txt: self.$usuario.claveRegistro, pass: true)
                    
                    // Campo REPETIR CONTRASEÑA
                    CustomTextField(imagen: "lock", placeHolder: "Repetir contraseña", txt: self.$usuario.claveRepetida, pass: true)
                   
                    // Campo NOMBRE
                    CustomTextField(imagen: "person", placeHolder: "Nombre", txt: self.$usuario.nombre, pass: false)
                    
                    Spacer()
                    
                    // Campo GÉNERO
                    Picker("Select one option", selection: $selection) {
                        ForEach(Gender.allCases, id: \.self) {
                            Text("\($0.rawValue)")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .background(Color.init(hex: "7A28CB"))
                    .padding(.horizontal, 50)
                    
                    Spacer()
                }
                
                /* BOTÓN DE REGISTRO */
                Button(action: {
                    self.usuario.genero = self.selection.rawValue
                    self.usuario.Registrarse()
                    if self.usuario.estaRegistrado {
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
                if self.usuario.mensajeAlerta == "Se ha realizado el registro con éxito"{
                    self.usuario.emailRegistro = ""
                    self.usuario.claveRegistro = ""
                    self.usuario.claveRepetida = ""
                    self.usuario.nombre = ""
                }
            }))
        })
    }
    
    struct Register_Previews: PreviewProvider {
        static var usuario = UserViewModel()
        static var previews: some View {
            Register(usuario: self.usuario)
        }
    }
     
}

