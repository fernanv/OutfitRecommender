//
//  Login.swift
//  Armario
//
//  Created by Fernando Villalba  on 9/5/22.
//

/*
En esta vista se muestra el formulario típico de inicio de sesión para un usuario, si el usuario no recuerda sus claves o no está registrado dispone de los enlaces para llevar a cabo dichas acciones.
*/

import SwiftUI

struct Login: View {
   
    // Atributos compartidos por otras vistas
    @Binding var login: Bool
    @Binding var perfil: Bool
    
    @ObservedObject var usuario : UserViewModel
    
    // Atributos privados de la vista
    @State private var falloAutenticacion: Bool = false
    @State private var exitoAutenticacion: Bool = false
    
    @State private var isShowingDetailView = false
    
    private let colorBoton = Color.init(hex: "FC60A8")
    @AppStorage("estado") var estado = false

    var body: some View{
          
        if estado{
            Profile(login: self.$login, perfil: self.$perfil, usuario: self.usuario)
        }
        
        else{
        NavigationView {
            ZStack{
                Color.init(CGColor.init(red: 240.0 / 255, green: 255.0 / 255, blue: 230.0 / 255, alpha: 1.0)).ignoresSafeArea(.all, edges: .top)  // F0FFE6
                // CONTENIDO
                VStack{
                    
                    VStack(spacing: 20){
                        Spacer()
                        Text("Inicio de Sesión")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.init(hex: "7A28CB"))
                            .padding(.vertical, 20.0)
                        EspacioMedio()
                        // Campo EMAIL
                        CustomTextField(imagen: "person", placeHolder: "Email", txt: self.$usuario.email, pass: false)
                        // Campo CONTRASEÑA
                        CustomTextField(imagen: "lock", placeHolder: "Contraseña", txt: self.$usuario.clave, pass: true)
                    }
                    
                    Spacer()
                    
                    /* BOTÓN INICIO DE SESIÓN */
                    Button(action: {
                        self.usuario.Identificarse()
                        print(self.usuario.nombre)
                        print(self.usuario.user.password!)
                        }, label: {
                        Text("Iniciar sesión")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220, height: 60)
                            .background(self.colorBoton)
                            .cornerRadius(15.0)
                    })
                    .padding(.vertical, 50.0)
                    .padding(.horizontal, 100.0)

                    /* BOTÓN RECUPERACIÓN CLAVES */
                    NavigationLink(destination: NewPassword(usuario: usuario)){
                        Text("¿Has olvidado tu contraseña?")
                            .font(.headline)
                            .foregroundColor(Color.init(hex: "FC60A8"))
                    }
                    .padding(.leading, 55.0)
                    .frame(width: 350, height: 100, alignment: .leading)

                    /* BOTÓN REGISTRO */
                    NavigationLink(destination: Register(usuario: usuario)){
                        
                            Text("¿Aún no tienes cuenta? Regístrate")
                                .font(.headline)
                                .foregroundColor(Color.init(hex: "7A28CB"))
                        }
                        .padding(.bottom, 30.0)
                        .padding(.leading, 10.0)
                        .listRowBackground(Color.black)
                        .frame(width: 300, height: 20, alignment: .leading)
                    
                    EspacioGrande()
                    
                } // FIN CONTENIDO
                
                if self.usuario.cargando{
                    VistaCargando().frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
                
            }
            .navigationBarHidden(true)
        }
            .navigationViewStyle(StackNavigationViewStyle())
            .fullScreenCover(isPresented: self.$usuario.estaRegistrado){
                Register(usuario: self.usuario)
            }
            .alert(isPresented: self.$usuario.alerta, content: {
                Alert(title: Text("Notificación"), message: Text(self.usuario.mensajeAlerta), dismissButton: .destructive(Text("OK")))
            })
        }
        
    }

    struct Login_Previews: PreviewProvider {
        static var usuario = UserViewModel(coreDataStack: CoreDataStack())
        static var previews: some View {
            Group {
                Login(login: Binding.constant(true), perfil: Binding.constant(false), usuario: usuario)
                    .previewDevice("iPad (9th generation)")

            }
        }
    }
}

struct CustomTextField: View{
    
    var imagen: String
    var placeHolder: String
    @Binding var txt: String
    var pass: Bool
    
    var body: some View{
        
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)){
            
            Image(systemName: self.imagen)
                .font(.system(size: 24))
                .foregroundColor(Color.white)
                .frame(width: 60, height: 60)
                .background(Color.init(hex: "494368"))
                .clipShape(Circle())
            
            if !self.pass{
                TextField(self.placeHolder, text: self.$txt)
                    .padding(.horizontal)
                    .padding(.leading,65)
                    .frame(height: 60)
                    .foregroundColor(.white)
                    .background(Color.init(hex: "494368").opacity(0.4))
                    .clipShape(Capsule())
            }
            else{
                SecureField(self.placeHolder, text: self.$txt)
                    .padding(.horizontal)
                    .padding(.leading,65)
                    .frame(height: 60)
                    .foregroundColor(.white)
                    .background(Color.init(hex: "494368").opacity(0.4))
                    .clipShape(Capsule())
            }
        }
        .padding(.horizontal, 30)
    }
}

struct VistaCargando: View {
 
  @State private var currentIndex: Int = 5

  func decrementIndex() {
    self.currentIndex -= 1
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50), execute: {
      self.decrementIndex()
    })
  }

  var body: some View {
    GeometryReader { (geometry: GeometryProxy) in
      ForEach(0..<12) { index in
        Group {
          Rectangle()
            .cornerRadius(geometry.size.width / 5)
            .frame(width: geometry.size.width / 8, height: geometry.size.height / 3)
            .offset(y: geometry.size.width / 2.25)
            .rotationEffect(.degrees(Double(-360 * index / 12)))
            .opacity(self.setOpacity(for: index))
        }.frame(width: geometry.size.width, height: geometry.size.height)
      }
    }
    .aspectRatio(1, contentMode: .fit)
    .onAppear {
      self.decrementIndex()
    }
  }

  func setOpacity(for index: Int) -> Double {
    let opacityOffset = Double((index + self.currentIndex - 1) % 11 ) / 12 * 0.9
    return 0.1 + opacityOffset
  }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
