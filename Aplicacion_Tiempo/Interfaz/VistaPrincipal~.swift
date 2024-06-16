//
//  VistaPrincipal.swift
//  Aplicacion_Tiempo
//
//  Created by Gabriel Gandara on 21/4/24.
//

import SwiftUI

struct VistaTiempo: View {
    // Variables de control de interfaz
    @State var modoPresentacion = false
    
    // Variables de control de la modal
    @State var modalAñadirCiudad = false
    @State var modalAltura = PresentationDetent.medium
    
    // Ciudades guardadas
    @AppStorage @ObservedObject var misCiudades: listaCiudades = listaCiudades()
    @State var eliminarCiudad = false
    
    var body: some View {
        
        VStack {
            HStack {
                Button(action: {
                    eliminarCiudad = !eliminarCiudad
                }, label: {
                    if(eliminarCiudad) {
                        Image(systemName: "return").foregroundStyle((modoPresentacion ? temaDark.colorLetra :
                                                                        temaLight.colorLetra))
                    } else {
                        Image(systemName: "trash.fill").foregroundStyle((modoPresentacion ? temaDark.colorLetra :
                                                                            temaLight.colorLetra))
                    }
                })
                
                Button(action: {
                    modoPresentacion = !modoPresentacion
                }, label: {
                    if(modoPresentacion) {
                        Image(systemName: "sun.max.fill").foregroundStyle((modoPresentacion ? temaDark.colorLetra :
                                                                            temaLight.colorLetra))
                    } else {
                        Image(systemName: "moon.stars").foregroundStyle((modoPresentacion ? temaDark.colorLetra :
                                                                            temaLight.colorLetra))
                    }
                })
            }.border((modoPresentacion ? temaDark.colorBordes :
                        temaLight.colorBordes))
            
            /*
             Comprueba de que la lista de ciudades este vacia
             para mostrar el mensaje de abajo
             */
            
            if misCiudades.listaCiudades.isEmpty {
                vistaVacia(añadirCiudad: $modalAñadirCiudad)
            } else {
                vistaConDatos(mostrarModal: $modalAñadirCiudad, listaCiudades: misCiudades)
            }
            
            /*
             Cuando la condicion de mostrar esta modal
             cambie muestra la modal de abajo
             */
            
            if modalAñadirCiudad {
                VStack{
                    
                }.sheet(isPresented: $modalAñadirCiudad, content: {
                    vistaSeleccionarCiudad(
                        mostrarModal: $modalAñadirCiudad,
                        listaGuardados: misCiudades).presentationDetents([.fraction(0.3)])
                })
            }
            
        }.frame(maxWidth: .infinity,
                maxHeight:.infinity)
        .background((modoPresentacion ? temaDark.colorFondo :
                        temaLight.colorFondo))
    }
}

struct vistaSeleccionarCiudad: View {
    
    @Binding var mostrarModal: Bool
    @State var listaGuardados: listaCiudades
    
    var listaProvincias: [String] = devolverProvincias()
    @State var provinciaEscogida: String = ""
    
    @State var mostrarSegundoSelector: Bool = false
    
    @State var listaCiudades: [String] = []
    @State var ciudadEscogida: String = ""
    @State var errorEnProvincia = false
    @State var errorEnCiudad = false
    
    
    var body: some View {
        
        VStack {
            HStack {
                
                Picker("pickerMunicipios", selection: $provinciaEscogida) {
                    
                    Text("Escoger un Municipio")
                    
                    ForEach(listaProvincias, id: \.self) {
                        provincia in
                        Text(provincia).tag(provincia)
                        
                    }
                }.onChange(of: provinciaEscogida) {
                    if(!provinciaEscogida.isEmpty) {
                        errorEnProvincia = false
                        mostrarSegundoSelector = true
                        listaCiudades = devolverCiudades(provincia: provinciaEscogida)
                    } else {
                        errorEnProvincia = true
                    }
                }.pickerStyle(.menu)
                
                
                if(mostrarSegundoSelector) {
                    Picker("pickerCiudades", selection: $ciudadEscogida) {
                        Text("Escoger una Ciudad")
                        ForEach(listaCiudades, id: \.self) { ciudad in
                            Text(ciudad).tag(ciudad)
                        }
                    }
                }
            }
            
            if(errorEnProvincia) {
                Text("No hay provincia seleccionada")
            }
            if(errorEnCiudad) {
                Text("No hay ciudad seleccionada")
            }
            
            Button {
                if(provinciaEscogida.isEmpty) {
                    errorEnProvincia = true
                } else {
                    errorEnProvincia = false
                    if(ciudadEscogida.isEmpty) {
                        errorEnCiudad = true
                    }
                }
                
                if(!ciudadEscogida.isEmpty && !provinciaEscogida.isEmpty) {
                    errorEnCiudad = false
                    listaGuardados.añadirCiudad(nombreCiudad: ciudadEscogida, nombreProvincia: provinciaEscogida)
                    self.mostrarModal.toggle()
                }
            } label: {
                Text("Guardar")
            }
            
        }.frame(maxWidth: .infinity, maxHeight:.infinity).background(Color.green)
    }
}


struct vistaVacia: View {
    @Binding var añadirCiudad: Bool
    var body: some View {
        Text("No hay ciudades seleccionadas")
        Text("Pulse aqui para añadir una:")
        
        Button(action: {
            añadirCiudad = !añadirCiudad
        }, label: {
            Text("+")
        })
    }
}


struct vistaConDatos: View {
    @Binding var mostrarModal: Bool
    @State var listaCiudades: listaCiudades
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView{
                List {
                    ForEach(listaCiudades.listaCiudades, id: \.self) {
                        ciudad in
                        HStack {
                            Button(action: {
                                
                            }, label: {
                                HStack {
                                    Image(systemName: "x.circle")
                                }
                            })
                            
                            NavigationLink(ciudad.ciudad + " / " + ciudad.provincia, destination: {
                                VistaCiudad(ciudadEscogida: ciudad)
                            })
                        }
                    }
                }
            }.frame(width: geometry.size.width * 0.90, height:geometry.size.height * 0.95)
        }.frame(alignment: .center)
        
        
        Button(action: {
            mostrarModal = !mostrarModal
        }, label: {
            Text("+")
        })
        
        
        if mostrarModal {
            
            VStack{
                
            }.sheet(isPresented: $mostrarModal) {
                vistaSeleccionarCiudad(mostrarModal: $mostrarModal, listaGuardados: listaCiudades).presentationDetents([.fraction(0.3)])
            }
        }
    }
}


#Preview {
    VistaTiempo()
}
